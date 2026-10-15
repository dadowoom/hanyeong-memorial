import { describe, expect, it } from "vitest";
import { checkHealth, createHealthChecker } from "./_core/health";

describe("checkHealth", () => {
  it("DB 설정이 없으면 503 not_configured", async () => {
    const result = await checkHealth({ getDb: async () => null });
    expect(result).toEqual({
      status: 503,
      body: { ok: false, db: "not_configured" },
    });
  });

  it("DB 가 응답하면 200 ok", async () => {
    const result = await checkHealth({
      getDb: async () => ({ execute: async () => [] }),
    });
    expect(result).toEqual({ status: 200, body: { ok: true, db: "ok" } });
  });

  it("DB 질의가 실패하면 503 error (오류 내용은 숨김)", async () => {
    const result = await checkHealth({
      getDb: async () => ({
        execute: async () => {
          throw new Error("password=secret");
        },
      }),
    });
    expect(result).toEqual({ status: 503, body: { ok: false, db: "error" } });
  });

  it("DB 가 멈춰 있으면 시간 초과로 503", async () => {
    const result = await checkHealth({
      getDb: async () => ({ execute: () => new Promise(() => {}) }),
      timeoutMs: 20,
    });
    expect(result).toEqual({ status: 503, body: { ok: false, db: "error" } });
  });
});

describe("createHealthChecker", () => {
  it("앞 질의가 멈춰 있으면 새 질의를 보내지 않고 503", async () => {
    let calls = 0;
    let finish!: () => void;
    const check = createHealthChecker({
      getDb: async () => ({
        execute: () => {
          calls += 1;
          return new Promise<void>(resolve => (finish = resolve));
        },
      }),
      timeoutMs: 20,
    });
    expect(await check()).toEqual({
      status: 503,
      body: { ok: false, db: "error" },
    });
    expect(await check()).toEqual({
      status: 503,
      body: { ok: false, db: "error" },
    });
    expect(calls).toBe(1);
    finish();
    await new Promise(resolve => setTimeout(resolve, 0));
    expect((await check()).status).toBe(503); // 새 질의도 멈춤 → 시간 초과
    expect(calls).toBe(2);
  });

  it("정상이면 매번 200", async () => {
    const check = createHealthChecker({
      getDb: async () => ({ execute: async () => [] }),
    });
    expect((await check()).status).toBe(200);
    expect((await check()).status).toBe(200);
  });
});
