# 사무실 서버에서 돌리기 (시험용)

운영(https://hanyeong.dadowoomtest.co.kr, pm2) 배포 방식은 그대로다. 이 폴더는 사무실 서버(office-server)의 `site` 도구용이다. **시험값만** 쓴다(운영 `.env`·운영 DB 사본·실제 사진 금지).

1. 서버: `sudo site new hanyeong-memorial mysql git@github.com:dadowoom/hanyeong-memorial.git --health /` → 보여 주는 배포 열쇠 1줄을 GitHub 저장소 Settings → Deploy keys 에 붙인다(쓰기 권한 X). 여기서 멈춘다(준비 중).
2. 서버: 앱 시작 **전에** 시험 설정 넣기 — `sudo nano /srv/sites/hanyeong-memorial/.env` 에 아래 3줄 추가(값은 시험용):
   `JWT_SECRET=<openssl rand -hex 32 결과>` / `VITE_APP_ID=office-test` / `PUBLIC_SITE_URL=http://hanyeong-memorial.office.dadowoomtest.co.kr`
   (OAuth·카카오·Forge 열쇠는 비워 둔다. 이 저장소에는 `.env.example` 이 없어 site 도구가 칸을 자동으로 못 만든다.)
3. 서버: `sudo site up hanyeong-memorial` (이미지 빌드 = `pnpm install --frozen-lockfile` → `pnpm run build`, Node 22, 실행 사용자 10001)
4. 시험 DB 표 만들기: `sudo docker compose -f /srv/sites/hanyeong-memorial/compose.yaml run --rm app node_modules/.bin/drizzle-kit migrate`
5. 확인: `site status hanyeong-memorial` → 관문 응답 200 (건강 검사 주소가 따로 없어 첫 화면 `/` 로 본다). `.env` 를 나중에 고치면 `sudo site up hanyeong-memorial` 로 다시 만들어야 반영된다(`restart` 로는 안 됨).
