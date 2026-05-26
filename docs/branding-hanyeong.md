# 한영교회 브랜딩 정리

## 발견한 소망교회 고유 지점

- `client/index.html`: 문서 제목, description, Open Graph/Twitter 메타, OG 이미지 URL.
- `client/src/components/Navbar.tsx`, `client/src/components/Footer.tsx`: 서비스명, 교회명, 주요 메뉴, 푸터 주소/저작권.
- `client/src/pages/Home.tsx`, `client/src/pages/Login.tsx`, `client/src/pages/MemorialCreate.tsx`: 홈 히어로 문구, 서비스 단계명, 회원가입 CTA, 추모관 생성 기본 교회명.
- `client/src/pages/SomangHill.tsx`: 소망동산 전용 메뉴/사진/외부 링크/방문 안내.
- `client/src/pages/MemorialPublicDetail.tsx`, `MemorialArchivePage.tsx`, `MemorialFamilyPage.tsx`: 비공개 추모관 접근 토큰 저장 키와 서비스 라벨.
- `client/src/data/*`, 데모 페이지, 섹션 컴포넌트: 소망교회 샘플 인물/연혁/문구.
- `server/routers.ts`, `drizzle/schema.ts`, `drizzle/*.sql`: 추모관 생성 기본 교회명과 샘플 seed 데이터.
- `server/db.ts`, `server/storage.ts`: 가족관/비공개 추모관 해시 salt, 프로덕션 업로드 경로.
- `client/public/og-somang-v1.*`: 소망교회용 공유 이미지.

## 현재 브랜드 설정 지점

- 공통 설정: `shared/church.ts`
  - `churchName`
  - `serviceName`
  - `serviceTitle`
  - `serviceTagline`
  - `description`, `shortDescription`
  - `domain`, `ogImage`
  - 업로드 디렉터리명과 저장 키 prefix/salt
- 클라이언트 화면 설정: `client/src/config/church.ts`
  - 주요 라우트
  - 네비게이션/푸터 링크
  - 홈 서비스/가치/절차 문구
  - 추모관 접근 토큰 저장 키
  - 추모관 생성 draft 저장 키
- 정적 HTML 메타: `client/index.html`
  - Vite 정적 HTML이라 런타임 TS 설정을 직접 import하지 못하므로, 운영 도메인 확정 시 `shared/church.ts`와 함께 값이 맞는지 확인합니다.
- OG 이미지: `client/public/og-hanyeong-v1.svg`, `client/public/og-hanyeong-v1.png`

## 변경 원칙

- 차분한 화이트톤, 단순한 선, 세리프 타이틀 감성은 유지했습니다.
- 추모관 생성, 검색, 공개/비공개, 가족관 비밀번호, 사진첩, 영상, 책장, 연표, 하늘로 보내는 편지 기능은 유지했습니다.
- `.env`, `.project-config.json`, 실제 비밀번호, 서버 접속 정보는 추가하지 않았습니다.
