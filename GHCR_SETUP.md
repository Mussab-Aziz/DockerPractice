# 🐳 GitHub Container Registry (GHCR) Publishing Setup

## ✅ Completed Steps

Your project is now configured to automatically publish to GitHub Container Registry!

### What Just Happened:
1. ✅ All Docker and CI/CD files committed to GitHub
2. ✅ Version tag `v1.0.0` created and pushed
3. ✅ Automated deployment workflow triggered

---

## 📋 Required Manual Setup (One-Time Only)

### Step 1: Create GitHub Personal Access Token (PAT)

1. Go to: **GitHub.com → Settings → Developer settings → Personal access tokens → Tokens (classic)**
2. Click **"Generate new token (classic)"**
3. Fill in details:
   - **Note**: `GHCR_TOKEN`
   - **Expiration**: 90 days (or your preference)
4. Select these scopes:
   - ✅ `write:packages` - Push/publish packages
   - ✅ `read:packages` - Read/pull packages
   - ✅ `delete:packages` - Delete packages (optional)
5. Click **"Generate token"** at bottom
6. **Copy the token immediately** (you won't see it again!)

### Step 2: Add Token to Repository Secrets

1. Go to: **GitHub.com → Your Repo (DockerPractice) → Settings → Secrets and variables → Actions**
2. Click **"New repository secret"**
3. Fill in:
   - **Name**: `GHCR_TOKEN`
   - **Secret**: Paste your token from Step 1
4. Click **"Add secret"**

---

## 🚀 Publishing Your Project

### Automatic Publishing (Recommended)

Every time you want to publish a new version:

```powershell
# 1. Make your changes and commit
git add .
git commit -m "your changes"
git push origin main

# 2. Create a version tag
git tag -a v1.0.1 -m "Release v1.0.1 - Description here"

# 3. Push the tag (this triggers automated publishing)
git push origin v1.0.1
```

The workflow will automatically:
- Build Docker image
- Push to `ghcr.io/mussab-aziz/dockerpractice:v1.0.1`
- Push to `ghcr.io/mussab-aziz/dockerpractice:latest`
- Create GitHub Release

### Manual Publishing (If needed)

```powershell
# Authenticate with Docker
docker login ghcr.io -u your-username -p YOUR_GHCR_TOKEN

# Build the image
docker build -t ghcr.io/mussab-aziz/dockerpractice:v1.0.1 --target production .

# Push to GHCR
docker push ghcr.io/mussab-aziz/dockerpractice:v1.0.1
```

---

## 📊 Monitor Deployment

1. **GitHub Actions Dashboard**:
   - Go to: `GitHub.com → Your Repo → Actions`
   - Look for: "Deploy to Production" workflow
   - Check status: Building → Pushed → Released

2. **View Published Images**:
   - Go to: `GitHub.com → Your Repo → Packages`
   - You'll see your Docker images listed

---

## 🔍 Verify Image in GHCR

Once the workflow completes (takes ~5-10 minutes):

```powershell
# Log in to GHCR (if needed)
docker login ghcr.io

# Pull the image
docker pull ghcr.io/mussab-aziz/dockerpractice:latest

# Run it
docker run -p 3000:3000 ghcr.io/mussab-aziz/dockerpractice:latest

# View all your images
docker image ls | findstr ghcr
```

---

## 📝 Next Releases

For each new release, follow this pattern:

```powershell
# Example for version 1.0.1
git tag -a v1.0.1 -m "Release v1.0.1 - Bug fixes"
git push origin v1.0.1

# Example for version 1.1.0
git tag -a v1.1.0 -m "Release v1.1.0 - New features"
git push origin v1.1.0
```

---

## 🎯 Current Status

| Item | Status | Details |
|------|--------|---------|
| Docker Setup | ✅ Complete | Dockerfile configured with multi-stage build |
| CI/CD Pipelines | ✅ Complete | GitHub Actions workflows ready |
| GHCR Workflow | ✅ Complete | Deploy to Production workflow active |
| Code Committed | ✅ Complete | All files pushed to main branch |
| Version Tagged | ✅ Complete | v1.0.0 tag pushed to trigger first build |
| PAT Setup | ⏳ Required | Create token in GitHub (one-time setup) |
| Image Publishing | ⏳ Pending | Will complete once PAT is added to secrets |

---

## 🐛 Troubleshooting

### Workflow Failed?
- Check GitHub Actions logs: **Actions tab → Deploy to Production**
- Common issues:
  - `GHCR_TOKEN` not set in repository secrets
  - Token doesn't have `write:packages` scope
  - Dockerfile has syntax errors

### Image Pull Failed?
```powershell
# Verify login
docker logout ghcr.io
docker login ghcr.io -u your-username -p YOUR_GHCR_TOKEN

# Try pulling again
docker pull ghcr.io/mussab-aziz/dockerpractice:latest
```

### Port Already in Use?
```powershell
docker run -p 8000:3000 ghcr.io/mussab-aziz/dockerpractice:latest
# Access at: http://localhost:8000
```

---

## 📚 Quick Commands Reference

```powershell
# Create and publish a new release
git tag -a vX.Y.Z -m "Release vX.Y.Z - Description"
git push origin vX.Y.Z

# Check all tags
git tag -l

# Delete a tag (if needed)
git tag -d v1.0.0
git push origin --delete v1.0.0

# View commit history
git log --oneline -10

# Docker commands
docker images                           # List all images
docker image ls ghcr.io                 # List GHCR images
docker pull ghcr.io/mussab-aziz/dockerpractice:latest
docker run -p 3000:3000 ghcr.io/mussab-aziz/dockerpractice:latest
docker rmi ghcr.io/mussab-aziz/dockerpractice:latest  # Remove image
```

---

## ✅ Setup Checklist

- [ ] GitHub Personal Access Token created
- [ ] Token added to repository secrets as `GHCR_TOKEN`
- [ ] Version tag v1.0.0 pushed to GitHub
- [ ] Check GitHub Actions "Deploy to Production" workflow
- [ ] Workflow completes successfully (green checkmark)
- [ ] Image appears in GitHub Packages
- [ ] `docker pull ghcr.io/mussab-aziz/dockerpractice:latest` works
- [ ] Container runs: `docker run -p 3000:3000 [image-name]`

---

**Everything is automated!** 🎉

Once you complete the one-time PAT setup, just push version tags to publish automatically!
