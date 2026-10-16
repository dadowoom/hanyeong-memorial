# 사무실 서버에서 돌리기 (시험용)

운영(https://hanyeong.dadowoomtest.co.kr, pm2) 배포 방식은 그대로다. 이 폴더는 사무실 서버(office-server)의 `site` 도구용이다. **시험값만** 쓴다(운영 `.env`·운영 DB 사본·실제 사진 금지).

1. 서버: `sudo site new hanyeong-memorial mysql git@github.com:dadowoom/hanyeong-memorial.git` (건강 검사 = `/api/health`, DB 까지 확인) → 보여 주는 배포 열쇠 1줄을 GitHub 저장소 Settings → Deploy keys 에 붙인다(쓰기 권한 X). 여기서 멈춘다(준비 중).
2. 서버: 앱 시작 **전에** 시험 설정 넣기 — `sudo nano /srv/sites/hanyeong-memorial/.env.app` 끝에 아래 2줄을 **직접 추가**(시험값):
   `VITE_APP_ID=office-test` / `PUBLIC_SITE_URL=http://hanyeong-memorial.office.dadowoomtest.co.kr`
   (`JWT_SECRET` 은 첫 `site up` 때 도구가 `.env.example` 칸을 가져오며 무작위로 채운다. 나머지 칸은 주석으로 들어오니 비워 둔다 — OAuth·카카오·Forge 열쇠 X.)
3. 서버: `sudo site up hanyeong-memorial` (이미지 빌드 = `pnpm install --frozen-lockfile` → `pnpm run build`, Node 22 bookworm-slim, 실행 사용자 10001)
4. 시험 DB 표 만들기 — **주의: 이 저장소의 마이그레이션 0004·0006·0009·0011·0014·0015·0019 에는 실제 추모 내용(실명·글·사진 주소)이 시드로 들어 있다.** 사무실 서버에 넣을지는 H4 전에 사장님이 정한다(넣지 않으려면 표만 만드는 별도 방법 필요): `sudo docker compose -f /srv/sites/hanyeong-memorial/compose.yaml run --rm app node_modules/.bin/drizzle-kit migrate`
5. 확인: `site status hanyeong-memorial` → 관문 응답 200 (`/api/health` = 서버+DB). `.env.app` 을 나중에 고치면 `sudo site up hanyeong-memorial` 로 다시 만들어야 반영된다(`restart` 로는 안 됨).
