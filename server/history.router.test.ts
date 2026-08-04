import { beforeEach, describe, expect, it, vi } from "vitest";
import type { TrpcContext } from "./_core/context";

vi.mock("./history", () => ({
  createHistoryDecade: vi.fn(),
  createHistoryItem: vi.fn(),
  deleteHistoryDecade: vi.fn(),
  deleteHistoryItem: vi.fn(),
  getAllHistory: vi.fn(),
  getPublicHistory: vi.fn(),
  reorderHistoryDecades: vi.fn(),
  reorderHistoryItems: vi.fn(),
  updateHistoryDecade: vi.fn(),
  updateHistoryItem: vi.fn(),
}));

import * as historyDb from "./history";
import { historyRouter } from "./routers/history";

const mockedHistoryDb = vi.mocked(historyDb);

function createContext(role?: "admin" | "user"): TrpcContext {
  return {
    user: role
      ? ({
          id: 1,
          openId: "history-user",
          email: "history@example.com",
          name: "History User",
          loginMethod: "local",
          role,
          createdAt: new Date(),
          updatedAt: new Date(),
          lastSignedIn: new Date(),
        } as TrpcContext["user"])
      : null,
    req: {} as TrpcContext["req"],
    res: {} as TrpcContext["res"],
  };
}

describe("history router", () => {
  beforeEach(() => {
    vi.resetAllMocks();
  });

  it("allows public history lookup without signing in", async () => {
    mockedHistoryDb.getPublicHistory.mockResolvedValue({
      decades: [],
      items: [],
    });
    const caller = historyRouter.createCaller(createContext());

    await expect(caller.public()).resolves.toEqual({ decades: [], items: [] });
  });

  it("blocks history management for non-admin users", async () => {
    const caller = historyRouter.createCaller(createContext("user"));

    await expect(caller.adminList()).rejects.toMatchObject({
      code: "FORBIDDEN",
    });
    expect(mockedHistoryDb.getAllHistory).not.toHaveBeenCalled();
  });

  it("validates decade ranges before admin writes", async () => {
    const caller = historyRouter.createCaller(createContext("admin"));

    await expect(
      caller.createDecade({
        title: "2000년대",
        startYear: 2010,
        endYear: 2000,
        isVisible: true,
      })
    ).rejects.toMatchObject({ code: "BAD_REQUEST" });
    expect(mockedHistoryDb.createHistoryDecade).not.toHaveBeenCalled();
  });
});
