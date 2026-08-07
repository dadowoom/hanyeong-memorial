import { describe, expect, it } from "vitest";
import {
  groupHistoryItemsByYear,
  sortHistoryDecades,
  sortHistoryItems,
} from "../shared/history";

describe("history ordering", () => {
  it("orders decades by manual order and newest start year", () => {
    const result = sortHistoryDecades([
      { id: 1, startYear: 1990, sortOrder: 2 },
      { id: 2, startYear: 2020, sortOrder: 1 },
      { id: 3, startYear: 2010, sortOrder: 1 },
    ]);
    expect(result.map(item => item.id)).toEqual([2, 3, 1]);
  });

  it("groups years and months in chronological order", () => {
    const items = [
      { id: 1, year: 2024, month: 12, sortOrder: 1 },
      { id: 2, year: 2025, month: 3, sortOrder: 1 },
      { id: 3, year: 2025, month: 1, sortOrder: 2 },
    ];

    expect(sortHistoryItems(items).map(item => item.id)).toEqual([1, 3, 2]);
    expect(
      groupHistoryItemsByYear(items).map(group => ({
        year: group.year,
        ids: group.items.map(item => item.id),
      }))
    ).toEqual([
      { year: 2024, ids: [1] },
      { year: 2025, ids: [3, 2] },
    ]);
  });
});
