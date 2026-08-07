export type HistoryDecadeLike = {
  id: number;
  startYear: number;
  sortOrder: number;
};

export type HistoryItemLike = {
  id: number;
  year: number;
  month: number;
  sortOrder: number;
};

export function sortHistoryDecades<T extends HistoryDecadeLike>(decades: T[]) {
  return [...decades].sort(
    (a, b) =>
      a.sortOrder - b.sortOrder || b.startYear - a.startYear || a.id - b.id
  );
}

export function sortHistoryItems<T extends HistoryItemLike>(items: T[]) {
  return [...items].sort(
    (a, b) =>
      a.year - b.year ||
      a.month - b.month ||
      a.sortOrder - b.sortOrder ||
      a.id - b.id
  );
}

export function groupHistoryItemsByYear<T extends HistoryItemLike>(items: T[]) {
  const groups = new Map<number, T[]>();
  for (const item of sortHistoryItems(items)) {
    groups.set(item.year, [...(groups.get(item.year) ?? []), item]);
  }
  return Array.from(groups, ([year, yearItems]) => ({
    year,
    items: yearItems,
  }));
}
