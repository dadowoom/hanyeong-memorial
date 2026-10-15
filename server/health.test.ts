import { describe, expect, it } from "vitest";
import { checkHealth } from "./_core/health";

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
