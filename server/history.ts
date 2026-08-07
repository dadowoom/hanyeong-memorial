import { and, asc, desc, eq, inArray } from "drizzle-orm";
import {
  historyDecades,
  historyItems,
  type InsertHistoryDecade,
  type InsertHistoryItem,
} from "../drizzle/schema";
import { getDb } from "./db";

async function requireDb() {
  const db = await getDb();
  if (!db) throw new Error("Database is not available");
  return db;
}

function compactUpdate<T extends Record<string, unknown>>(data: T) {
  return Object.fromEntries(
    Object.entries(data).filter(([, value]) => value !== undefined)
  ) as Partial<T>;
}

function nextSortOrder(rows: Array<{ sortOrder: number }>) {
  return Math.max(0, ...rows.map(row => row.sortOrder || 0)) + 1;
}

export async function getPublicHistory() {
  const db = await getDb();
  if (!db) return { decades: [], items: [] };

  const decades = await db
    .select()
    .from(historyDecades)
    .where(eq(historyDecades.isVisible, true))
    .orderBy(
      asc(historyDecades.sortOrder),
      desc(historyDecades.startYear),
      asc(historyDecades.id)
    );

  if (decades.length === 0) return { decades, items: [] };

  const items = await db
    .select()
    .from(historyItems)
    .where(
      and(
        eq(historyItems.isVisible, true),
        inArray(
          historyItems.decadeId,
          decades.map(decade => decade.id)
        )
      )
    )
    .orderBy(
      asc(historyItems.year),
      asc(historyItems.month),
      asc(historyItems.sortOrder),
      asc(historyItems.id)
    );

  return { decades, items };
}

export async function getAllHistory() {
  const db = await requireDb();
  const [decades, items] = await Promise.all([
    db
      .select()
      .from(historyDecades)
      .orderBy(
        asc(historyDecades.sortOrder),
        desc(historyDecades.startYear),
        asc(historyDecades.id)
      ),
    db
      .select()
      .from(historyItems)
      .orderBy(
        asc(historyItems.year),
        asc(historyItems.month),
        asc(historyItems.sortOrder),
        asc(historyItems.id)
      ),
  ]);
  return { decades, items };
}

export async function createHistoryDecade(data: InsertHistoryDecade) {
  const db = await requireDb();
  const existing = await db
    .select({ sortOrder: historyDecades.sortOrder })
    .from(historyDecades);

  await db.insert(historyDecades).values({
    ...data,
    sortOrder: data.sortOrder ?? nextSortOrder(existing),
  });
}

export async function updateHistoryDecade(
  id: number,
  data: Partial<InsertHistoryDecade>
) {
  const db = await requireDb();
  const update = compactUpdate(data);
  if (Object.keys(update).length === 0) return;
  await db.update(historyDecades).set(update).where(eq(historyDecades.id, id));
}

export async function deleteHistoryDecade(id: number) {
  const db = await requireDb();
  await db.transaction(async tx => {
    await tx.delete(historyItems).where(eq(historyItems.decadeId, id));
    await tx.delete(historyDecades).where(eq(historyDecades.id, id));
  });
}

export async function reorderHistoryDecades(ids: number[]) {
  const db = await requireDb();
  await db.transaction(async tx => {
    for (let index = 0; index < ids.length; index += 1) {
      await tx
        .update(historyDecades)
        .set({ sortOrder: index + 1 })
        .where(eq(historyDecades.id, ids[index]));
    }
  });
}

export async function createHistoryItem(data: InsertHistoryItem) {
  const db = await requireDb();
  const [decade] = await db
    .select({
      startYear: historyDecades.startYear,
      endYear: historyDecades.endYear,
    })
    .from(historyDecades)
    .where(eq(historyDecades.id, data.decadeId))
    .limit(1);
  if (!decade) throw new Error("선택한 연대를 찾을 수 없습니다.");
  if (data.year < decade.startYear || data.year > decade.endYear) {
    throw new Error("연대의 연도 범위 안에서 입력해주세요.");
  }

  const existing = await db
    .select({ sortOrder: historyItems.sortOrder })
    .from(historyItems)
    .where(eq(historyItems.decadeId, data.decadeId));

  await db.insert(historyItems).values({
    ...data,
    sortOrder: data.sortOrder ?? nextSortOrder(existing),
  });
}

export async function updateHistoryItem(
  id: number,
  data: Partial<InsertHistoryItem>
) {
  const db = await requireDb();
  const update = compactUpdate(data);
  if (Object.keys(update).length === 0) return;

  if (data.decadeId !== undefined && data.year !== undefined) {
    const [decade] = await db
      .select({
        startYear: historyDecades.startYear,
        endYear: historyDecades.endYear,
      })
      .from(historyDecades)
      .where(eq(historyDecades.id, data.decadeId))
      .limit(1);
    if (!decade) throw new Error("선택한 연대를 찾을 수 없습니다.");
    if (data.year < decade.startYear || data.year > decade.endYear) {
      throw new Error("연대의 연도 범위 안에서 입력해주세요.");
    }
  }

  await db.update(historyItems).set(update).where(eq(historyItems.id, id));
}

export async function deleteHistoryItem(id: number) {
  const db = await requireDb();
  await db.delete(historyItems).where(eq(historyItems.id, id));
}

export async function reorderHistoryItems(decadeId: number, ids: number[]) {
  const db = await requireDb();
  await db.transaction(async tx => {
    for (let index = 0; index < ids.length; index += 1) {
      await tx
        .update(historyItems)
        .set({ sortOrder: index + 1 })
        .where(
          and(
            eq(historyItems.id, ids[index]),
            eq(historyItems.decadeId, decadeId)
          )
        );
    }
  });
}
