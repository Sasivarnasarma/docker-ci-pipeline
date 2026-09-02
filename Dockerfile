# syntax=docker/dockerfile:1

FROM node:24-bookworm-slim AS dependencies

WORKDIR /app

RUN corepack enable

COPY package.json pnpm-lock.yaml ./

RUN --mount=type=cache,target=/root/.local/share/pnpm/store \
    pnpm install --frozen-lockfile --prod

FROM node:24-bookworm-slim AS runtime

ENV NODE_ENV=production

WORKDIR /app

RUN corepack enable

COPY --from=dependencies --chown=node:node /app/node_modules ./node_modules
COPY --chown=node:node package.json server.js ./

USER node

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "fetch('http://127.0.0.1:3000/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"

CMD ["node", "server.js"]