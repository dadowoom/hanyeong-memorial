# 사무실 서버에서 돌리기 (시험용)

운영(https://hanyeong.dadowoomtest.co.kr, pm2) 배포 방식은 그대로다. 이 폴더는 사무실 서버(office-server)의 `site` 도구용이다.

1. 서버: `sudo site new hanyeong-memorial mysql git@github.com:dadowoom/hanyeong-memorial.git --health /` → 보여 주는 배포 열쇠 1줄을 GitHub 저장소 Settings → Deploy keys 에 붙인다(쓰기 권한 X).
2. 서버: `sudo site up hanyeong-memorial` (이미지 빌드 = `pnpm install --frozen-lockfile` → `pnpm run build`, Node 22, 실행 사용자 10001)
3. 시험 DB 표 만들기: `cd /srv/sites/hanyeong-memorial && sudo docker compose run --rm app node_modules/.bin/drizzle-kit migrate`
4. `.env` 에는 **시험값만**(JWT_SECRET 은 무작위, OAuth·카카오·Forge 열쇠는 비워 둠). 운영 `.env`·운영 DB 사본·실제 사진 금지.
5. 확인: `site status hanyeong-memorial` → 관문 응답 200 (건강 검사 주소가 따로 없어 첫 화면 `/` 로 본다)
