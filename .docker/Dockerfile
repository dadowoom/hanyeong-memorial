# 사무실 서버(office-server) 시험 실행용 이미지 — 운영(pm2) 배포 방식은 바꾸지 않는다.
# 빌드: 서버의 site 도구가 `docker compose build` 로 만든다(context = 저장소 루트, 파일 = .docker/Dockerfile).
# 검사 순서는 docs/OPERATIONS.md 와 같다: pnpm install --frozen-lockfile → pnpm build
ARG NODE_VERSION=22

# ---------- 1단계: 빌드 ----------
FROM node:${NODE_VERSION}-alpine AS build
WORKDIR /app
ENV CI=true
RUN corepack enable
# lock 파일·패치만 먼저 복사(의존성 층 캐시)
COPY package.json pnpm-lock.yaml ./
COPY patches ./patches
RUN pnpm install --frozen-lockfile
COPY . .
# 이 저장소에는 build:prod 가 없다 → build 가 운영과 같은 명령
RUN pnpm run build

# ---------- 2단계: 실행 ----------
FROM node:${NODE_VERSION}-alpine AS run
WORKDIR /app
ENV NODE_ENV=production \
    PORT=3000 \
    UPLOAD_DIR=/data/uploads
# 실행 중에도 dist/index.js 가 vite·vite 플러그인(개발 의존성)을 불러오므로 node_modules 를 통째로 쓴다.
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
# 시험 DB 표 만들기용(drizzle-kit migrate): docker compose run --rm app node_modules/.bin/drizzle-kit migrate
COPY --from=build /app/drizzle ./drizzle
COPY --from=build /app/drizzle.config.ts ./drizzle.config.ts
# 저장소를 root·umask 027 로 받으면 파일이 640 이라 실행 사용자(10001)가 못 읽는다 → 읽기 권한을 넓혀 둔다(쓰기는 안 줌)
RUN chmod -R a+rX /app/package.json /app/dist /app/drizzle /app/drizzle.config.ts  && mkdir -p /data/uploads && chown 10001:10001 /data/uploads
USER 10001:10001
EXPOSE 3000
CMD ["node", "dist/index.js"]
