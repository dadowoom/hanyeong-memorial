export const churchConfig = {
  churchName: "한영교회",
  brandName: "역사관",
  serviceName: "신앙기념관",
  serviceTitle: "한영교회 역사관",
  serviceSubtitle: "한영교회",
  serviceTagline: "한영교회 온라인 역사관",
  description:
    "한영교회 역사관은 1961년부터 이어온 교회의 역사와 성도들의 삶과 신앙을 함께 기록하여 다음 세대에 전합니다.",
  shortDescription:
    "1961년부터 이어온 한영교회의 믿음의 역사와 성도들의 신앙 유산을 만나는 온라인 역사관입니다.",
  domain: "http://115.68.224.123:3060",
  ogImage: "/og-hanyeong-history-v2.jpg",
  contact: {
    address: "한영교회",
    serviceLabel: "온라인 역사관",
  },
  uploadDirectoryName: "hanyeong-memorial",
  storage: {
    localStoragePrefix: "hanyeong",
    familyRoomPasswordSalt: "hanyeong-family",
    memorialAccessPasswordSalt: "hanyeong-memorial-access",
    memorialAccessTokenSalt: "hanyeong-memorial-token",
  },
} as const;

export const DEFAULT_CHURCH_NAME = churchConfig.churchName;
