# 🚀 Quick Reference - CI/CD & Docker Commands

## ⚡ Fastest Start

```bash
# Windows
.\start.bat

# Linux/macOS
chmod +x start.sh
./start.sh
```

Choose option 1 to start development.

---

## 🐳 Docker Essentials

### Development (with hot reload)
```bash
docker-compose up
```

### Production
```bash
docker build -t app:latest --target production .
docker run -p 3000:3000 --env-file .env.local app:latest
```

### View logs
```bash
docker-compose logs -f
```

### Stop everything
```bash
docker-compose down
```

---

## 📦 Make Commands (if Make is installed)

```bash
make help              # Show all commands
make docker-up        # Start dev environment
make build-docker     # Build production image
make run-docker       # Run production image
make clean            # Remove containers/images
make scan-vuln        # Scan for vulnerabilities
```

---

## 📝 Environment Variables

### Create `.env.local`:
```bash
cp .env.example .env.local
# Edit with your API key
```

### Content:
```
OPENAI_API_KEY=your_key_here
NODE_ENV=development
NEXT_TELEMETRY_DISABLED=1
```

---

## 🔄 GitHub Actions Pipelines

### Automatic on Push
- Every push to `main`/`develop` runs CI (lint, build, Docker push)
- View at: GitHub → Actions tab

### Manual Deployment
```bash
# Create and push version tag
git tag -a v1.0.0 -m "Release 1.0.0"
git push origin v1.0.0
```

This automatically:
- Builds Docker image
- Pushes to GitHub Container Registry
- Creates GitHub Release

---

## 🌐 Access Points

| Service | URL | Environment |
|---------|-----|-------------|
| App | http://localhost:3000 | Development |
| App | http://localhost:3001 | Production (optional) |

---

## 📊 File Reference

| File | Purpose |
|------|---------|
| `Dockerfile` | Multi-stage Docker build |
| `docker-compose.yml` | Local development setup |
| `.dockerignore` | Build optimization |
| `.github/workflows/cicd.yml` | CI pipeline |
| `.github/workflows/deploy.yml` | Deployment pipeline |
| `Makefile` | Command shortcuts |
| `.env.local` | Local configuration |
| `.env.example` | Configuration template |

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Docker not found | Install Docker Desktop |
| Port 3000 in use | Use `docker run -p 8000:3000` |
| npm ci fails | Ensure `package-lock.json` exists |
| .env not loaded | Create `.env.local` in root |
| Workflows not running | Commit to main/develop branch |

---

## 📚 Full Documentation

For detailed information, see:
- **Local Development**: `DOCKER_CICD_GUIDE.md`
- **Setup Summary**: `SETUP_COMPLETE.md`
- **GitHub Actions**: `.github/workflows/*.yml`

---

## ✅ Quick Checklist

- [ ] Docker Desktop installed and running
- [ ] `.env.local` created with API key
- [ ] `docker-compose up` works
- [ ] App loads at http://localhost:3000
- [ ] Ready to push to GitHub

---

**Everything is ready!** 🎉

Run `docker-compose up` to get started immediately.
