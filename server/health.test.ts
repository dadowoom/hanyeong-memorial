import net from "net";
import { afterEach, describe, expect, it } from "vitest";
import {
  createHealthChecker,
  DbNotConfiguredError,
  mysqlProbe,
} from "./_core/health";

describe("createHealthChecker", () => {
  it("DB 가 응답하면 200 ok", async () => {
    const check = createHealthChecker({ probe: async () => {} });
    expect(await check()).toEqual({
      status: 200,
      body: { ok: true, db: "ok" },
    });
  });

  it("DB 설정이 없으면 503 not_configured", async () => {
    const check = createHealthChecker({
      probe: async () => {
        throw new DbNotConfiguredError();
      },
    });
    expect(await check()).toEqual({
      status: 503,
      body: { ok: false, db: "not_configured" },
    });
  });

  it("DB 검사가 실패하면 503 error (오류 내용은 숨김)", async () => {
    const check = createHealthChecker({
      probe: async () => {
        throw new Error("password=secret");
      },
    });
    expect(await check()).toEqual({
      status: 503,
      body: { ok: false, db: "error" },
    });
  });

  it("겹친 요청은 검사 하나를 함께 기다린다(정상이면 둘 다 200)", async () => {
    let calls = 0;
    const check = createHealthChecker({
      probe: async () => {
        calls += 1;
        await new Promise(resolve => setTimeout(resolve, 20));
      },
    });
    const [a, b] = await Promise.all([check(), check()]);
    expect(a.status).toBe(200);
    expect(b.status).toBe(200);
    expect(calls).toBe(1);
    expect((await check()).status).toBe(200);
    expect(calls).toBe(2);
  });

  it("실패 뒤에도 다음 검사는 새로 한다(잠김이 남지 않음)", async () => {
    let fail = true;
    const check = createHealthChecker({
      probe: async () => {
        if (fail) throw new Error("down");
      },
    });
    expect((await check()).status).toBe(503);
    fail = false;
    expect((await check()).status).toBe(200);
  });
});

describe("mysqlProbe", () => {
  const saved = process.env.DATABASE_URL;
  let server: net.Server | undefined;
  afterEach(() => {
    if (saved === undefined) delete process.env.DATABASE_URL;
    else process.env.DATABASE_URL = saved;
    server?.close();
    server = undefined;
  });

  it("DATABASE_URL 이 없으면 DbNotConfiguredError", async () => {
    delete process.env.DATABASE_URL;
    await expect(mysqlProbe(200)).rejects.toBeInstanceOf(DbNotConfiguredError);
  });

  it("DB 가 연결만 받고 아무 응답도 안 해도 제한 시간 안에 끝난다", async () => {
    server = net.createServer(() => {
      /* 연결을 받고 아무것도 보내지 않음(멈춘 DB 흉내) */
    });
    await new Promise<void>(resolve =>
      server!.listen(0, "127.0.0.1", () => resolve())
    );
    const port = (server.address() as net.AddressInfo).port;
    process.env.DATABASE_URL = `mysql://u:p@127.0.0.1:${port}/db`;
    const started = Date.now();
    await expect(mysqlProbe(200)).rejects.toBeTruthy();
    expect(Date.now() - started).toBeLessThan(1500);
  });
});
