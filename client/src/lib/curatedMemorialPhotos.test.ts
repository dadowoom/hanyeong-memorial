import { describe, expect, it } from "vitest";
import { resolveCuratedMemorialPhoto } from "./curatedMemorialPhotos";

describe("resolveCuratedMemorialPhoto", () => {
  it("replaces the legacy Lee Hanyeong illustrations with curated photos", () => {
    expect(
      resolveCuratedMemorialPhoto(
        "lee-hanyeong",
        "/memorial-assets/lee-hanyeong/chapel-prayer.svg"
      )
    ).toBe("/memorial-assets/lee-hanyeong/prayer-1979.webp");

    expect(
      resolveCuratedMemorialPhoto(
        "lee-hanyeong",
        "http://115.68.224.123:3060/memorial-assets/lee-hanyeong/portrait.png"
      )
    ).toBe("/memorial-assets/lee-hanyeong/portrait-2026.webp");
  });

  it("leaves photos for other memorials unchanged", () => {
    const photoUrl = "/memorial-assets/lee-hanyeong/chapel-prayer.svg";

    expect(resolveCuratedMemorialPhoto("bae-jeonga-kwonsa", photoUrl)).toBe(
      photoUrl
    );
  });

  it("leaves newly uploaded Lee Hanyeong photos unchanged", () => {
    const photoUrl = "/uploads/gallery/custom-photo.webp";

    expect(resolveCuratedMemorialPhoto("lee-hanyeong", photoUrl)).toBe(
      photoUrl
    );
  });
});
