import { beforeEach, describe, expect, it, vi } from "vitest";
import type { TrpcContext } from "./_core/context";

vi.mock("./db", () => ({
  canReadMemorial: vi.fn(),
  createMemorialBook: vi.fn(),
  createMemorialBookPage: vi.fn(),
  createMemorialGalleryPhoto: vi.fn(),
  createMemorialVideo: vi.fn(),
  deleteMemorialBook: vi.fn(),
  deleteMemorialBookPage: vi.fn(),
  deleteMemorialGalleryPhoto: vi.fn(),
  deleteMemorialVideo: vi.fn(),
  getMemorialAccessByBookId: vi.fn(),
  getMemorialAccessById: vi.fn(),
  getMemorialBookById: vi.fn(),
  listMemorialBookPages: vi.fn(),
  listMemorialBooks: vi.fn(),
  listMemorialGalleryPhotos: vi.fn(),
  listMemorialVideos: vi.fn(),
  setRepresentativeMemorialPhoto: vi.fn(),
  updateMemorialBook: vi.fn(),
  updateMemorialBookPage: vi.fn(),
  updateMemorialGalleryPhoto: vi.fn(),
  updateMemorialVideo: vi.fn(),
}));

import { galleryRouter } from "./routers/gallery";
import { bookRouter } from "./routers/book";
import { videoRouter } from "./routers/video";
import * as db from "./db";

const mockedDb = vi.mocked(db);

function createContext(role?: "admin" | "user"): TrpcContext {
  return {
    user: role
      ? ({
          id: 1,
          openId: "sample-user",
          email: "sample@example.com",
          name: "Sample User",
          loginMethod: "manus",
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

describe("memorial asset access control", () => {
  beforeEach(() => {
    vi.resetAllMocks();
  });

  it("blocks private gallery access without a valid token", async () => {
    mockedDb.getMemorialAccessById.mockResolvedValue({
      id: 10,
      slug: "private-hall",
      visibility: "private",
      accessPasswordHash: "hashed",
    });
    mockedDb.canReadMemorial.mockReturnValue(false);

    const caller = galleryRouter.createCaller(createContext());

    await expect(
      caller.listByMemorial({ memorialId: 10 })
    ).rejects.toMatchObject({
      code: "FORBIDDEN",
      message: "비공개 기념관입니다.",
    });
    expect(mockedDb.listMemorialGalleryPhotos).not.toHaveBeenCalled();
  });

  it("blocks private book lookup by book id without a valid token", async () => {
    mockedDb.getMemorialAccessByBookId.mockResolvedValue({
      id: 10,
      slug: "private-hall",
      visibility: "private",
      accessPasswordHash: "hashed",
    });
    mockedDb.canReadMemorial.mockReturnValue(false);

    const caller = bookRouter.createCaller(createContext());

    await expect(caller.getById({ id: 22 })).rejects.toMatchObject({
      code: "FORBIDDEN",
      message: "비공개 기념관입니다.",
    });
    expect(mockedDb.getMemorialBookById).not.toHaveBeenCalled();
  });

  it("lets admin read hidden videos without memorial access checks", async () => {
    mockedDb.listMemorialVideos.mockResolvedValue([
      {
        id: 1,
        memorialId: 10,
        title: "hidden",
        description: null,
        youtubeVideoId: "abcdefghijk",
        isVisible: 0,
        sortOrder: 0,
      },
    ]);

    const caller = videoRouter.createCaller(createContext("admin"));
    const result = await caller.listByMemorial({ memorialId: 10 });

    expect(result).toHaveLength(1);
    expect(result[0]?.isVisible).toBe(0);
    expect(mockedDb.getMemorialAccessById).not.toHaveBeenCalled();
    expect(mockedDb.canReadMemorial).not.toHaveBeenCalled();
  });
});
