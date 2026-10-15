import type { Express } from "express";
import { sql } from "drizzle-orm";
import { getDb } from "../db";

type HealthDb = {
  execute: (query: ReturnType<typeof sql>) => Promise<unknown>;
};
type HealthDeps = { getDb: () => Promise<HealthDb | null>; timeoutMs?: number };

export type HealthResult = {
  status: 200 | 503;
  body: { ok: boolean; db: "ok" | "not_configured" | "error" };
};

function withTimeout<T>(promise: Promise<T>, ms: number): Promise<T> {
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => reject(new Error("timeout")), ms);
    promise.then(
      value => {
        clearTimeout(timer);
        resolve(value);
      },
      error => {
        clearTimeout(timer);
        reject(error);
      }
    );
  });
}

/**
 * 서버와 DB 가 응답하는지 확인한다(사무실 서버·컨테이너 건강 검사용).
 * 오류 내용은 밖으로 내보내지 않는다.
 */
export async function checkHealth(
  deps: HealthDeps = { getDb: getDb as HealthDeps["getDb"] }
): Promise<HealthResult> {
  const db = await deps.getDb();
  if (!db) return { status: 503, body: { ok: false, db: "not_configured" } };
  try {
    await withTimeout(db.execute(sql`select 1`), deps.timeoutMs ?? 3000);
    return { status: 200, body: { ok: true, db: "ok" } };
  } catch {
    return { status: 503, body: { ok: false, db: "error" } };
  }
}

/**
 * 같은 시각에 DB 질의는 하나만 보낸다. 앞 질의가 아직 안 끝났으면(DB 가 멈춘 경우 등)
 * 새 질의를 보내지 않고 바로 503 을 돌려줘, 건강 검사가 연결 풀을 쌓아 막지 않게 한다.
 */
export function createHealthChecker(deps?: HealthDeps) {
  let busy = false;
  const loadDb = deps?.getDb ?? (getDb as HealthDeps["getDb"]);
  return async (): Promise<HealthResult> => {
    if (busy) return { status: 503, body: { ok: false, db: "error" } };
    busy = true;
    let db: HealthDb | null;
    try {
      db = await loadDb();
    } catch {
      busy = false;
      return { status: 503, body: { ok: false, db: "error" } };
    }
    if (!db) {
      busy = false;
      return { status: 503, body: { ok: false, db: "not_configured" } };
    }
    let query: Promise<unknown>;
    try {
      query = Promise.resolve(db.execute(sql`select 1`));
    } catch {
      busy = false;
      return { status: 503, body: { ok: false, db: "error" } };
    }
    // 질의가 실제로 끝날 때(성공·실패·늦은 응답 모두) 비로소 다음 질의를 허용
    query.then(
      () => {
        busy = false;
      },
      () => {
        busy = false;
      }
    );
    return checkHealth({
      getDb: async () => ({ execute: () => query }),
      timeoutMs: deps?.timeoutMs,
    });
  };
}

export function registerHealthRoute(app: Express, deps?: HealthDeps) {
  const check = createHealthChecker(deps);
  app.get("/api/health", async (_req, res) => {
    const result = await check();
    res
      .status(result.status)
      .set("Cache-Control", "no-store")
      .json(result.body);
  });
}
