import type { Express } from "express";
import mysql from "mysql2";

export type HealthResult = {
  status: 200 | 503;
  body: { ok: boolean; db: "ok" | "not_configured" | "error" };
};

/** DB 를 한 번 찔러 본다. 제한 시간 안에 반드시 끝나야 하고(성공=resolve, 실패=reject), 쓴 연결은 스스로 정리한다. */
export type HealthProbe = (timeoutMs: number) => Promise<void>;

export class DbNotConfiguredError extends Error {}

/**
 * 건강 검사 전용 MySQL 연결을 매번 새로 열고, 끝나면(성공·실패·시간 초과 모두) 바로 끊는다.
 * 연결 객체를 접속 시작과 동시에 잡아 두므로 접속·인증·질의 어느 단계에서 멈춰도
 * 제한 시간이 되면 소켓까지 강제로 닫는다. 앱의 연결 풀은 쓰지 않는다.
 */
export const mysqlProbe: HealthProbe = timeoutMs => {
  const url = process.env.DATABASE_URL;
  if (!url) return Promise.reject(new DbNotConfiguredError());
  return new Promise<void>((resolve, reject) => {
    const conn = mysql.createConnection({
      uri: url,
      connectTimeout: timeoutMs,
    });
    let settled = false;
    const close = () => {
      try {
        conn.destroy();
      } catch {
        /* 이미 닫힘 */
      }
      // destroy() 는 쓰기 쪽만 닫을 수 있어 실제 소켓도 강제로 닫는다
      const stream = (conn as unknown as { stream?: { destroy?: () => void } })
        .stream;
      stream?.destroy?.();
    };
    const finish = (error?: unknown) => {
      if (settled) return;
      settled = true;
      clearTimeout(timer);
      close();
      if (error) reject(error);
      else resolve();
    };
    const timer = setTimeout(() => finish(new Error("timeout")), timeoutMs);
    conn.on("error", error => finish(error));
    conn.query({ sql: "SELECT 1", timeout: timeoutMs }, error =>
      finish(error ?? undefined)
    );
  });
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
