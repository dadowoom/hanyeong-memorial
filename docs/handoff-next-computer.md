# 한영교회 신앙기념관 작업 인수인계 지시문

아래 내용을 새 컴퓨터의 Codex/개발자에게 그대로 전달하면 된다.

---

GitHub 저장소 `dadowoom/hanyeong-memorial` 기준으로 작업한다.

이 프로젝트는 소망교회 디지털 추모관(`dadowoom/somang-memorial`)을 복제해 만든 한영교회 전용 프로젝트다. 소망교회 원본 저장소는 절대 수정하지 말고, `dadowoom/hanyeong-memorial`만 독립적으로 작업한다.

## 현재 상태

- 운영 URL: `http://115.68.224.123:3060/`
- PM2 프로세스명: `hanyeong-memorial`
- 서버 작업 경로: `/var/www/hanyeong-memorial`
- 브랜치: `main`
- 현재 브랜딩: 한영교회 신앙기념관
- 메인 컬러: `#0b1c30`
- 기념관 사진은 컬러로 표시
- 추모관 전환/추모관 화면은 추후 별도 확장 예정
- 기념관 목록은 공개 인물 36명, 12명씩 3페이지로 정리됨
- 김한영 원로장로, 이한영 권사 샘플 데이터가 들어 있음
- 이한영 권사 대표사진은 새 한국인 권사 프로필 사진으로 교체됨
- 기념관 내부 사진첩/책장/영상 커버/대표사진은 전부 컬러
- 카톡 공유 버튼이 기념관 상세와 아카이브 화면에 있음
- 공유 미리보기 OG는 인물 사진과 `OOO 직분님의 신앙기념관입니다.` 문구를 사용

## 새 컴퓨터에서 시작하기

```bash
git clone https://github.com/dadowoom/hanyeong-memorial.git
cd hanyeong-memorial
pnpm install --frozen-lockfile
pnpm check
pnpm test
pnpm build
```

로컬 실행이 필요하면 프로젝트의 기존 실행 방식을 확인해 사용한다. 보통은 서버 환경 변수와 DB 연결이 필요하므로 `.env`는 별도 안전 채널로 전달받아 로컬에만 둔다.

## 절대 커밋하지 말 것

- `.env`
- `.project-config.json`
- 서버 접속 정보
- DB 접속 정보
- 비밀번호, 토큰, 인증키
- 개인 로컬 설정 파일

민감 정보가 필요하면 저장소에 넣지 말고 별도 보안 채널로 받아 로컬 환경 변수에만 설정한다.

## 배포 흐름

서버 접속 정보는 별도 안전 채널로 받아 사용한다. 비밀번호는 문서나 커밋에 남기지 않는다.

서버에서 배포할 때는 보통 아래 흐름을 사용한다.

```bash
cd /var/www/hanyeong-memorial
git fetch origin main
git reset --hard origin/main
pnpm install --frozen-lockfile
pnpm build
pm2 restart hanyeong-memorial --update-env
curl -sS -o /dev/null -w "STATUS:%{http_code}\n" http://127.0.0.1:3060/
```

검증 URL:

```bash
curl -sS -o /dev/null -w "GARDEN:%{http_code}\n" http://127.0.0.1:3060/memorial-garden
curl -sS -o /dev/null -w "LEE:%{http_code}\n" http://127.0.0.1:3060/memorial/lee-hanyeong/archive
curl -sS -o /dev/null -w "KIM:%{http_code}\n" http://127.0.0.1:3060/memorial/kim-hanyeong/archive
```

## 주요 파일

- 브랜드 설정: `client/src/config/church.ts`, `shared/church.ts`
- 메인/히어로/프로세스: `client/src/pages/Home.tsx`
- 신앙기념관 목록: `client/src/pages/MemorialGarden.tsx`
- 기념관 기본 상세: `client/src/pages/MemorialPublicDetail.tsx`
- 기념관 자세히 보기/사진첩/책장/영상/편지: `client/src/pages/MemorialArchivePage.tsx`
- 사진첩: `client/src/components/memorial/MemorialGallerySection.tsx`
- 책장/연표: `client/src/components/memorial/MemorialBookSection.tsx`
- 영상: `client/src/components/memorial/MemorialVideoSection.tsx`
- 공유 미리보기 OG: `server/_core/openGraph.ts`
- 이한영 권사 사진: `client/public/memorial-assets/lee-hanyeong/portrait.png`
- 한국인 가상 인물 사진: `client/public/memorial-assets/hanyeong-faces/`

## 현재 기획 규칙

- “기억의 동산” 대신 “신앙 기념관” 사용
- 히어로 타이틀은 `한영교회` / `신앙기념관` 두 줄
- “마음 남기기”는 “신앙기념관 만들기”로 변경
- 기념관 단계/CTA 문구는 신앙의 유산을 남기는 방향으로 작성
- 하늘로 보내는 편지는 추모관/아카이브 성격 화면에 유지
- 신앙기념관 목록에는 인물 카드가 보여야 함
- 카드 사진/이름/직분이 잘 보여야 함
- 신앙기념관 사진은 컬러
- 추모관을 별도 화면으로 확장할 경우에만 흑백 톤 적용
- 공개 인물 목록은 한 페이지당 12명

## 확인할 것

작업 후 반드시 실행:

```bash
pnpm install --frozen-lockfile
pnpm check
pnpm test
pnpm build
```

테스트에서 `OAUTH_SERVER_URL is not configured` 로그가 보일 수 있으나 현재 테스트는 통과하는 상태다. Vite 빌드의 chunk size warning도 현재 알려진 경고다.

## 다음 작업자가 받을 프롬프트

```text
GitHub 저장소 dadowoom/hanyeong-memorial 기준으로 작업해줘.

소망교회 원본 dadowoom/somang-memorial은 절대 건드리지 말고, 한영교회 프로젝트만 작업한다.

현재 사이트는 한영교회 신앙기념관으로 브랜딩되어 있고, 운영 URL은 http://115.68.224.123:3060/ 이다.

작업 전 main 최신본을 pull 하고, pnpm install --frozen-lockfile, pnpm check, pnpm test, pnpm build로 상태를 확인해라.

민감 정보(.env, 서버/DB 비밀번호, 토큰)는 절대 커밋하지 말고, 필요한 경우 별도 안전 채널로 받아 로컬/서버 환경 변수에서만 사용해라.

기획 기준:
- 신앙기념관 사진은 전부 컬러
- 추모관 전환/추모관 전용 화면을 만들 경우에만 흑백 사용
- 신앙기념관 목록은 인물 카드형, 한 페이지당 12명
- 기념관 공유 미리보기는 해당 인물 사진과 "OOO 직분님의 신앙기념관입니다." 문구가 나와야 함
- 기능은 유지: 회원가입 후 기념관 생성, 검색, 공개/비공개, 가족관 비밀번호, 사진첩, 영상, 책장, 연표, 하늘로 보내는 편지

작업 후 커밋하고 GitHub main에 push한 뒤 서버 /var/www/hanyeong-memorial에서 git fetch/reset, pnpm install, pnpm build, pm2 restart hanyeong-memorial --update-env로 배포해라.
```
