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

export function registerHealthRoute(app: Express, deps?: HealthDeps) {
  app.get("/api/health", async (_req, res) => {
    const result = await checkHealth(deps);
    res
      .status(result.status)
      .set("Cache-Control", "no-store")
      .json(result.body);
  });
}
