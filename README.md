# 🐳 Docker CI Pipeline

<p align="center">
  <strong>A lightweight, production-ready Express.js container setup engineered with multi-stage builds, non-root security, and native health checks.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Node.js-24_Bookworm_Slim-339933?style=for-the-badge&logo=node.js&logoColor=white" alt="Node.js" />
  <img src="https://img.shields.io/badge/Express-v5.2.1-000000?style=for-the-badge&logo=express&logoColor=white" alt="Express" />
  <img src="https://img.shields.io/badge/Docker-Multi--Stage-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker" />
  <img src="https://img.shields.io/badge/pnpm-Corepack-F69220?style=for-the-badge&logo=pnpm&logoColor=white" alt="pnpm" />
  <img src="https://img.shields.io/badge/License-ISC-blue?style=for-the-badge" alt="License" />
</p>

---

## ✨ Highlights

- ⚡ **Multi-Stage Build**: Keeps the final image footprint minimal by isolating dependencies and build caches from the runtime container.
- 🔒 **Secure by Default**: Runs under the unprivileged `node` user (UID 1000) rather than `root`.
- 🩺 **Built-In Healthcheck**: Periodic health probes via native Node.js `fetch` without requiring external utilities like `curl` or `wget`.
- 📦 **Fast Dependency Caching**: Leverages BuildKit cache mounts (`--mount=type=cache`) with `pnpm` for blazing fast rebuilds.
- 🚀 **Modern Runtime**: Powered by Node 24 and Express 5.

---

## 🏗️ Architecture

```mermaid
flowchart LR
    subgraph BuildStage["Stage 1: Dependencies (node:24-bookworm-slim)"]
        A[package.json + pnpm-lock.yaml] --> B[pnpm install --prod]
        B --> C[node_modules]
    end

    subgraph RuntimeStage["Stage 2: Runtime (node:24-bookworm-slim)"]
        C -. copy .-> D[/app/node_modules]
        E[server.js] --> F[Expose :3000]
        D --> G[USER node]
        F --> G
        G --> H([Healthcheck: /health])
        G --> I([Container Ready])
    end
```

---

## 🚀 Quick Start

### 1. Local Development

Ensure you have [Node.js 24+](https://nodejs.org/) and `pnpm` installed.

```bash
# Enable pnpm via Corepack
corepack enable

# Install production dependencies
pnpm install

# Start server
pnpm start
```

The service will run on `http://localhost:3000`.

---

### 2. Run with Docker

Build and start the containerized service:

```bash
# Build the Docker image
docker build -t docker-ci-pipeline .

# Run container in detached mode
docker run -d --name ci-service -p 3000:3000 docker-ci-pipeline
```

Verify container status and health:

```bash
docker ps --filter "name=ci-service"
```

Stop and remove the container:

```bash
docker stop ci-service && docker rm ci-service
```

---

## 📡 API Endpoints

| Method | Endpoint | Description | Sample Response |
| :--- | :--- | :--- | :--- |
| `GET` | `/` | Service info and runtime metadata | `{"message":"Hello from Docker!","dev":"Sasivarnasarma","runtime":"v24.x"}` |
| `GET` | `/health` | Liveness & readiness probe | `200 OK ("ok")` |

---

## ⚙️ Configuration

Environment variables can be configured directly or passed into Docker via `-e`:

| Variable | Default | Description |
| :--- | :---: | :--- |
| `PORT` | `3000` | Port on which the Express server listens |
| `NODE_ENV` | `production` | Environment mode (set automatically in Dockerfile) |

---

## 📂 Project Structure

```text
docker-ci-pipeline/
├── .dockerignore      # Excludes node_modules, git, and local artifacts
├── .gitignore         # Ignores logs, env files, and dependencies
├── Dockerfile         # Multi-stage container definition with healthcheck
├── package.json       # Application dependencies and start script
├── pnpm-lock.yaml     # Deterministic lockfile for reproducible builds
├── server.js          # Express web server with health & status routes
└── README.md          # Project documentation
```

---

## 👨‍💻 Author

**Sasivarnasarma**
- GitHub: [@Sasivarnasarma](https://github.com/Sasivarnasarma)
- Repository: [docker-ci-pipeline](https://github.com/Sasivarnasarma/docker-ci-pipeline)

---

<p align="center">
  <sub>Built with care for robust containerized delivery.</sub>
</p>
