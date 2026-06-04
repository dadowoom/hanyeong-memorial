import { z } from "zod";
import { TRPCError } from "@trpc/server";
import {
  canReadMemorial,
  createMemorialVideo,
  deleteMemorialVideo,
  getMemorialAccessById,
  listMemorialVideos,
  updateMemorialVideo,
} from "../db";
import { adminProcedure, publicProcedure, router } from "../_core/trpc";

export const videoRouter = router({
  listByMemorial: publicProcedure
    .input(
      z.object({
        memorialId: z.number(),
        accessToken: z.string().trim().max(128).optional(),
      })
    )
    .query(async ({ ctx, input }) => {
      if (ctx.user?.role !== "admin") {
        const memorial = await getMemorialAccessById(input.memorialId);
        if (!memorial) {
          throw new TRPCError({
            code: "NOT_FOUND",
            message: "기념관을 찾을 수 없습니다.",
          });
        }

        if (!canReadMemorial(memorial, input.accessToken)) {
          throw new TRPCError({
            code: "FORBIDDEN",
            message: "비공개 기념관입니다.",
          });
        }
      }

      const videos = await listMemorialVideos(input.memorialId);
      if (ctx.user?.role === "admin") return videos;
      return videos.filter(video => video.isVisible !== 0);
    }),

  create: adminProcedure
    .input(
      z.object({
        memorialId: z.number(),
        title: z.string().trim().min(1).max(300),
        description: z.string().trim().max(2000).optional(),
        youtubeVideoId: z.string().trim().min(1).max(50),
        isVisible: z.boolean().optional(),
        sortOrder: z.number().optional(),
      })
    )
    .mutation(async ({ input }) => {
      await createMemorialVideo({
        memorialId: input.memorialId,
        title: input.title,
        description: input.description || null,
        youtubeVideoId: input.youtubeVideoId,
        isVisible: input.isVisible === false ? 0 : 1,
        sortOrder: input.sortOrder ?? 0,
      });
      return { success: true };
    }),

  update: adminProcedure
    .input(
      z.object({
        id: z.number(),
        title: z.string().trim().min(1).max(300).optional(),
        description: z.string().trim().max(2000).nullable().optional(),
        youtubeVideoId: z.string().trim().max(50).optional(),
        isVisible: z.boolean().optional(),
        sortOrder: z.number().optional(),
      })
    )
    .mutation(async ({ input }) => {
      const { id, isVisible, ...rest } = input;
      await updateMemorialVideo(id, {
        ...rest,
        ...(isVisible === undefined ? {} : { isVisible: isVisible ? 1 : 0 }),
      });
      return { success: true };
    }),

  delete: adminProcedure
    .input(z.object({ id: z.number() }))
    .mutation(async ({ input }) => {
      await deleteMemorialVideo(input.id);
      return { success: true };
    }),
});
