import { z } from "zod";
import { adminProcedure, publicProcedure, router } from "../_core/trpc";
import {
  createHistoryDecade,
  createHistoryItem,
  deleteHistoryDecade,
  deleteHistoryItem,
  getAllHistory,
  getPublicHistory,
  reorderHistoryDecades,
  reorderHistoryItems,
  updateHistoryDecade,
  updateHistoryItem,
} from "../history";

const idSchema = z.number().int().positive();
const yearSchema = z.number().int().min(1800).max(2200);
const monthSchema = z.number().int().min(1).max(12);
const sortOrderSchema = z.number().int().min(0).max(9999).optional();

const decadeFields = z
  .object({
    title: z.string().trim().min(1).max(64),
    startYear: yearSchema,
    endYear: yearSchema,
    sortOrder: sortOrderSchema,
    isVisible: z.boolean(),
  })
  .refine(value => value.startYear <= value.endYear, {
    path: ["endYear"],
    message: "종료 연도는 시작 연도보다 작을 수 없습니다.",
  });

const itemFields = z.object({
  decadeId: idSchema,
  year: yearSchema,
  month: monthSchema,
  content: z.string().trim().min(1).max(10000),
  sortOrder: sortOrderSchema,
  isVisible: z.boolean(),
});

export const historyRouter = router({
  public: publicProcedure.query(() => getPublicHistory()),
  adminList: adminProcedure.query(() => getAllHistory()),
  createDecade: adminProcedure
    .input(decadeFields)
    .mutation(({ input }) => createHistoryDecade(input)),
  updateDecade: adminProcedure
    .input(decadeFields.safeExtend({ id: idSchema }))
    .mutation(({ input }) => {
      const { id, ...data } = input;
      return updateHistoryDecade(id, data);
    }),
  deleteDecade: adminProcedure
    .input(z.object({ id: idSchema }))
    .mutation(({ input }) => deleteHistoryDecade(input.id)),
  reorderDecades: adminProcedure
    .input(z.object({ ids: z.array(idSchema).min(1) }))
    .mutation(({ input }) => reorderHistoryDecades(input.ids)),
  createItem: adminProcedure
    .input(itemFields)
    .mutation(({ input }) => createHistoryItem(input)),
  updateItem: adminProcedure
    .input(itemFields.extend({ id: idSchema }))
    .mutation(({ input }) => {
      const { id, ...data } = input;
      return updateHistoryItem(id, data);
    }),
  deleteItem: adminProcedure
    .input(z.object({ id: idSchema }))
    .mutation(({ input }) => deleteHistoryItem(input.id)),
  reorderItems: adminProcedure
    .input(z.object({ decadeId: idSchema, ids: z.array(idSchema).min(1) }))
    .mutation(({ input }) => reorderHistoryItems(input.decadeId, input.ids)),
});
