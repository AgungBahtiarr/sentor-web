FROM oven/bun:latest as builder
WORKDIR /usr/src/app

COPY package.json bun.lock* ./
RUN bun install --frozen-lockfile
COPY . .
RUN bun --bun run build

FROM oven/bun:latest as production
WORKDIR /app

COPY --from=builder /usr/src/app/package.json /usr/src/app/bun.lock* ./
RUN bun install --production

COPY --from=builder /usr/src/app/build ./

EXPOSE 3000
CMD [ "bun", "./index.js" ]
