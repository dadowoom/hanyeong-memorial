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
  { label: "추모관", href: routes.memorialSearch },
  { label: "하늘로 보내는 편지", href: routes.letters },
  { label: "서비스", href: routes.services },
] as const;

export const serviceLinks = [
  { label: "추모관", href: routes.memorialSearch, type: "route" },
  { label: "추모관 만들기", href: routes.memorialCreate, type: "route" },
  { label: "서비스", href: routes.services, type: "hash" },
] as const;

export const homeCopy = {
  services: [
    {
      number: "01",
      title: "추모관 만들기",
      desc: "고인의 생애와 신앙의 기록을 사진, 글, 연혁으로 정리합니다.",
    },
    {
      number: "02",
      title: "기억 전하기",
      desc: "등록된 내용을 바탕으로 품위 있는 부고장과 공유 링크를 준비합니다.",
    },
    {
      number: "03",
      title: "마음 남기기",
      desc: "교회 공동체가 방문록과 편지로 기억의 마음을 남길 수 있습니다.",
    },
  ],
  steps: [
    "회원가입 후 바로 시작합니다.",
    "고인 기본 정보와 사진, 생애 기록을 입력합니다.",
    "추모관을 생성하고 링크를 가족과 공동체에 공유합니다.",
  ],
  values: [
    {
      number: "01",
      title: "가족에게는 위로",
      desc: "고인의 사진과 이야기, 추모의 글을 통해 사랑하는 이를 다시 만나고, 슬픔을 믿음 안에서 위로로 품습니다.",
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
