import { beforeEach, describe, expect, it, vi } from "vitest";
import type { TrpcContext } from "./_core/context";

vi.mock("./db", () => ({
  listManagedLetters: vi.fn(),
  listManagedMemorials: vi.fn(),
  listManagedUsers: vi.fn(),
  updateManagedLetterStatus: vi.fn(),
  updateManagedMemorialVisibility: vi.fn(),
  updateManagedUser: vi.fn(),
}));

import * as adminDb from "./db";
import { adminRouter } from "./routers/admin";

const mockedAdminDb = vi.mocked(adminDb);

function createContext(role: "admin" | "user"): TrpcContext {
  return {
    user: {
      id: 1,
      openId: "admin-user",
      email: "admin@example.com",
      name: "Admin User",
      passwordHash: null,
      phone: null,
      loginMethod: "local",
      role,
      approvalStatus: "approved",
      approvedAt: new Date(),
      createdAt: new Date(),
      updatedAt: new Date(),
      lastSignedIn: new Date(),
    },
    req: {} as TrpcContext["req"],
    res: {} as TrpcContext["res"],
  };
}

describe("admin router", () => {
  beforeEach(() => {
    vi.resetAllMocks();
  });

  it("blocks every management area for a regular user", async () => {
    const caller = adminRouter.createCaller(createContext("user"));

    await expect(caller.users.list()).rejects.toMatchObject({
      code: "FORBIDDEN",
    });
    await expect(caller.memorials.list()).rejects.toMatchObject({
      code: "FORBIDDEN",
    });
    await expect(caller.letters.list()).rejects.toMatchObject({
      code: "FORBIDDEN",
    });
    expect(mockedAdminDb.listManagedUsers).not.toHaveBeenCalled();
    expect(mockedAdminDb.listManagedMemorials).not.toHaveBeenCalled();
    expect(mockedAdminDb.listManagedLetters).not.toHaveBeenCalled();
  });

  it("allows an administrator to list management data", async () => {
    mockedAdminDb.listManagedUsers.mockResolvedValue([]);
    mockedAdminDb.listManagedMemorials.mockResolvedValue([]);
    mockedAdminDb.listManagedLetters.mockResolvedValue([]);
    const caller = adminRouter.createCaller(createContext("admin"));

    await expect(caller.users.list()).resolves.toEqual([]);
    await expect(caller.memorials.list()).resolves.toEqual([]);
    await expect(caller.letters.list()).resolves.toEqual([]);
  });

  it("validates memorial visibility changes before writing", async () => {
    const caller = adminRouter.createCaller(createContext("admin"));

    await expect(
      caller.memorials.updateVisibility({
        id: 1,
        visibility: "invalid" as "private",
      })
    ).rejects.toMatchObject({ code: "BAD_REQUEST" });
    expect(
      mockedAdminDb.updateManagedMemorialVisibility
    ).not.toHaveBeenCalled();
  });
});
