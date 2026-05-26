import { churchConfig } from "@shared/church";

export { churchConfig };

export const routes = {
  home: "/",
  memorialGarden: "/memorial-garden",
  memorialSearch: "/memorial/search",
  memorialCreate: "/memorial/create",
  letters: "/letters",
  services: "/#services",
} as const;

export const navItems = [
  { label: "신앙 기념관", href: routes.memorialGarden },
  { label: "기념관 찾기", href: routes.memorialSearch },
  { label: "하늘로 보내는 편지", href: routes.letters },
  { label: "서비스", href: routes.services },
] as const;

export const serviceLinks = [
  { label: "기념관 자세히 보기", href: routes.memorialSearch, type: "route" },
  { label: "기념관 만들기", href: routes.memorialCreate, type: "route" },
  { label: "서비스", href: routes.services, type: "hash" },
] as const;

export const homeCopy = {
  services: [
    {
      number: "01",
      title: "기념관 만들기",
      desc: "성도의 생애와 신앙의 기록을 사진, 글, 연혁으로 정리합니다.",
    },
    {
      number: "02",
      title: "기념관 공유하기",
      desc: "등록된 내용을 바탕으로 가족과 교회 공동체가 함께 볼 수 있는 링크를 준비합니다.",
    },
    {
      number: "03",
      title: "마음 남기기",
      desc: "교회 공동체가 방문록과 편지로 기억의 마음을 남길 수 있습니다.",
    },
  ],
  steps: [
    "회원가입 후 기념관 만들기를 시작합니다.",
    "성도의 기본 정보와 사진, 생애 기록을 입력합니다.",
    "기념관을 생성하고 링크를 가족과 공동체에 공유합니다.",
    "소천 이후에는 별도의 추모관 전환하기 흐름으로 추모관을 열 수 있습니다.",
  ],
  values: [
    {
      number: "01",
      title: "가족에게는 위로",
      desc: "성도의 사진과 이야기, 신앙의 글을 통해 사랑하는 이를 다시 만나고, 삶의 기록을 믿음 안에서 위로로 품습니다.",
    },
    {
      number: "02",
      title: "교회에는 기억",
      desc: "한 사람의 예배와 봉사, 기도와 헌신은 한영교회가 걸어온 믿음의 길 위에 남겨진 귀한 흔적입니다.",
    },
    {
      number: "03",
      title: "다음 세대에는 신앙의 유산",
      desc: "자녀와 손주들이 부모와 조부모의 삶의 고백을 만나고, 말로 다 전하지 못한 신앙의 이야기를 이어받습니다.",
    },
  ],
} as const;

export const getMemorialAccessStorageKey = (slug: string) =>
  `${churchConfig.storage.localStoragePrefix}.memorialAccess.${slug}`;

export const memorialCreateDraftKey = `${churchConfig.storage.localStoragePrefix}.memorialCreateDraft`;
