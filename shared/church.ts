export const churchConfig = {
  churchName: "한영교회",
  serviceName: "한영 신앙기념관",
  serviceTitle: "한영교회 신앙기념관",
  serviceSubtitle: "한영교회 신앙기념관",
  serviceTagline: "한영교회 온라인 신앙 기념 서비스",
  description:
    "한영교회 신앙기념관은 성도들의 삶과 믿음과 사랑을 가족과 교회의 기억 속에 아름답게 보존합니다.",
  shortDescription:
    "가족에게는 위로, 교회에는 기억, 다음 세대에는 신앙의 유산을 남기는 한영교회 온라인 신앙 기념 서비스입니다.",
  domain: "http://115.68.224.123:3060",
  ogImage: "/og-hanyeong-v1.png",
  contact: {
    address: "한영교회",
    serviceLabel: "온라인 신앙 기념 서비스",
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
