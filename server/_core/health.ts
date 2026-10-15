import type { Express } from "express";
import mysql from "mysql2/promise";

export type HealthResult = {
  status: 200 | 503;
  body: { ok: boolean; db: "ok" | "not_configured" | "error" };
};

/** DB 를 한 번 찔러 본다. 제한 시간 안에 반드시 끝나야 하고(성공=resolve, 실패=reject), 쓴 연결은 스스로 정리한다. */
export type HealthProbe = (timeoutMs: number) => Promise<void>;

export class DbNotConfiguredError extends Error {}

/**
 * 건강 검사 전용 MySQL 연결을 매번 새로 열고, 끝나면(성공·실패·시간 초과 모두) 바로 끊는다.
 * 앱의 연결 풀을 쓰지 않으므로 DB 가 멈춰도 풀에 질의가 쌓이지 않는다.
 */
export const mysqlProbe: HealthProbe = async timeoutMs => {
  const url = process.env.DATABASE_URL;
  if (!url) throw new DbNotConfiguredError();
  let conn: mysql.Connection | undefined;
  let timer: ReturnType<typeof setTimeout> | undefined;
  const work = (async () => {
    conn = await mysql.createConnection({
      uri: url,
      connectTimeout: timeoutMs,
    });
    await conn.query({ sql: "SELECT 1", timeout: timeoutMs });
  })();
  // 시간 초과 뒤에 늦게 열린 연결도 닫는다
  work.then(
    () => conn?.destroy(),
    () => conn?.destroy()
  );
  try {
    await Promise.race([
      work,
      new Promise<never>((_, reject) => {
        timer = setTimeout(() => reject(new Error("timeout")), timeoutMs);
      }),
    ]);
  } finally {
    if (timer) clearTimeout(timer);
    conn?.destroy();
  }
};

/**
 * 같은 시각에 DB 검사는 하나만 한다. 검사 중에 들어온 요청은 그 결과를 함께 기다린다
 * (정상인데 겹쳤다고 503 이 되지 않게). 검사는 제한 시간 안에 반드시 끝나므로 잠김이 남지 않는다.
 * 오류 내용은 밖으로 내보내지 않는다.
 */
export function createHealthChecker(opts?: {
  probe?: HealthProbe;
  timeoutMs?: number;
}) {
  const probe = opts?.probe ?? mysqlProbe;
  const timeoutMs = opts?.timeoutMs ?? 3000;
  let current: Promise<HealthResult> | null = null;

  const run = async (): Promise<HealthResult> => {
    try {
      await probe(timeoutMs);
      return { status: 200, body: { ok: true, db: "ok" } };
    } catch (error) {
      if (error instanceof DbNotConfiguredError) {
        return { status: 503, body: { ok: false, db: "not_configured" } };
      }
      return { status: 503, body: { ok: false, db: "error" } };
    }
  };

  return (): Promise<HealthResult> => {
    if (!current) {
      current = run().finally(() => {
        current = null;
      });
    }
    return current;
  };
}

export function registerHealthRoute(
  app: Express,
  opts?: Parameters<typeof createHealthChecker>[0]
) {
  const check = createHealthChecker(opts);
  app.get("/api/health", async (_req, res) => {
    const result = await check();
    res
      .status(result.status)
      .set("Cache-Control", "no-store")
      .json(result.body);
  });
}
