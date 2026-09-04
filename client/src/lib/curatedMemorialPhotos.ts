const LEE_HANYEONG_PHOTO_OVERRIDES: Record<string, string> = {
  "/memorial-assets/lee-hanyeong/portrait.png":
    "/memorial-assets/lee-hanyeong/portrait-2026.webp",
  "/memorial-assets/lee-hanyeong/portrait.svg":
    "/memorial-assets/lee-hanyeong/portrait-2026.webp",
  "/memorial-assets/lee-hanyeong/chapel-prayer.svg":
    "/memorial-assets/lee-hanyeong/prayer-1979.webp",
  "/memorial-assets/lee-hanyeong/bible-flowers.svg":
    "/memorial-assets/lee-hanyeong/bible-prayer-1988.webp",
  "/memorial-assets/lee-hanyeong/family-table.svg":
    "/memorial-assets/lee-hanyeong/family-table-1998.webp",
  "/memorial-assets/lee-hanyeong/choir-service.svg":
    "/memorial-assets/lee-hanyeong/choir-service-2007.webp",
  "/memorial-assets/lee-hanyeong/garden-path.svg":
    "/memorial-assets/lee-hanyeong/church-garden-2026.webp",
};

function getPathname(photoUrl: string) {
  try {
    return new URL(photoUrl, "https://memorial.local").pathname;
  } catch {
    return photoUrl.split(/[?#]/, 1)[0];
  }
}

export function resolveCuratedMemorialPhoto(
  memorialSlug: string | undefined,
  photoUrl: string
) {
  if (memorialSlug !== "lee-hanyeong") return photoUrl;

  return LEE_HANYEONG_PHOTO_OVERRIDES[getPathname(photoUrl)] ?? photoUrl;
}
