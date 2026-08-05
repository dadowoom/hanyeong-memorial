import { TRPCError } from "@trpc/server";
import { z } from "zod";
import {
  listManagedLetters,
  listManagedMemorials,
  listManagedUsers,
  updateManagedLetterStatus,
  updateManagedMemorialVisibility,
  updateManagedUser,
} from "../db";
import { adminProcedure, router } from "../_core/trpc";

const roleSchema = z.enum(["user", "admin"]);
const approvalStatusSchema = z.enum(["pending", "approved", "rejected"]);
const visibilitySchema = z.enum(["public", "link", "private"]);
const letterStatusSchema = z.enum(["published", "hidden"]);

function toAdminError(error: unknown, fallback: string) {
  if (error instanceof TRPCError) return error;
  return new TRPCError({
    code: "BAD_REQUEST",
    message: error instanceof Error ? error.message : fallback,
  });
}

export const adminRouter = router({
  users: router({
    list: adminProcedure.query(() => listManagedUsers()),
    update: adminProcedure
      .input(
        z.object({
          id: z.number().int().positive(),
          role: roleSchema,
          approvalStatus: approvalStatusSchema,
        })
      )
      .mutation(async ({ ctx, input }) => {
        try {
          const user = await updateManagedUser({
            actorId: ctx.user.id,
            targetId: input.id,
            role: input.role,
            approvalStatus: input.approvalStatus,
          });

          if (!user) {
            throw new TRPCError({
              code: "NOT_FOUND",
              message: "회원을 찾을 수 없습니다.",
            });
          }

          return user;
        } catch (error) {
          throw toAdminError(error, "회원 정보를 변경하지 못했습니다.");
        }
      }),
  }),
  memorials: router({
    list: adminProcedure.query(() => listManagedMemorials()),
    updateVisibility: adminProcedure
      .input(
        z.object({
          id: z.number().int().positive(),
          visibility: visibilitySchema,
        })
      )
      .mutation(async ({ input }) => {
        try {
          const memorial = await updateManagedMemorialVisibility(input);
          if (!memorial) {
            throw new TRPCError({
              code: "NOT_FOUND",
              message: "신앙기념관을 찾을 수 없습니다.",
            });
          }
          return memorial;
        } catch (error) {
          throw toAdminError(error, "공개 상태를 변경하지 못했습니다.");
        }
      }),
  }),
  letters: router({
    list: adminProcedure.query(() => listManagedLetters()),
    updateStatus: adminProcedure
      .input(
        z.object({
          id: z.number().int().positive(),
          status: letterStatusSchema,
        })
      )
      .mutation(async ({ input }) => {
        try {
          const letter = await updateManagedLetterStatus(input);
          if (!letter) {
            throw new TRPCError({
              code: "NOT_FOUND",
              message: "편지를 찾을 수 없습니다.",
            });
          }
          return letter;
        } catch (error) {
          throw toAdminError(error, "편지 공개 상태를 변경하지 못했습니다.");
        }
      }),
  }),
});
