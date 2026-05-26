export const TEXT_SIZE_OPTIONS = ["auto", "small", "normal", "large"] as const;

export type TextDisplaySize = (typeof TEXT_SIZE_OPTIONS)[number];

export function normalizeTextDisplaySize(
  value: string | null | undefined
): TextDisplaySize {
  return TEXT_SIZE_OPTIONS.includes(value as TextDisplaySize)
    ? (value as TextDisplaySize)
    : "auto";
}

export function getNarrativeFontSize(
  value: string,
  size: TextDisplaySize,
  scale = 1
): string {
  if (size === "small") return clampTextSize(1, 1.6, 1.35, scale);
  if (size === "normal") return clampTextSize(1.12, 1.9, 1.65, scale);
  if (size === "large") return clampTextSize(1.3, 2.3, 2, scale);

  const length = value.replace(/\s/g, "").length;
  if (length <= 14) return clampTextSize(1.3, 2.5, 2.1, scale);
  if (length <= 28) return clampTextSize(1.16, 2, 1.7, scale);
  return clampTextSize(1, 1.6, 1.35, scale);
}

function clampTextSize(
  minRem: number,
  vw: number,
  maxRem: number,
  scale: number
): string {
  return `clamp(${formatNumber(minRem * scale)}rem, ${formatNumber(
    vw * scale
  )}vw, ${formatNumber(maxRem * scale)}rem)`;
}

function formatNumber(value: number): string {
  return Number(value.toFixed(2)).toString();
}
