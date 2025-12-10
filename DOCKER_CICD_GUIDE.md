# CI/CD and Docker Setup Guide

## Overview

This project uses GitHub Actions for CI/CD pipelines and Docker for containerization. The setup includes:

- **Automated Testing & Linting**: Runs on every push and pull request
- **Docker Image Building**: Builds and pushes to GitHub Container Registry
- **Security Scanning**: Vulnerability scanning with Trivy
- **Production Deployment**: Triggered on version tags

## Prerequisites

- Docker Desktop installed ([Download](https://www.docker.com/products/docker-desktop))
- GitHub account with write access to the repository
- Node.js 18+ (for local development)

## Local Development

### Using Docker Compose

Run the development server in a container:

```bash
docker-compose up
```

The application will be available at `http://localhost:3000`

Features:
- Hot reload enabled
- Volume mounted for live code changes
- Auto-restart on failure

### Using npm locally

```bash
npm install
npm run dev
```

## Docker Commands

### Build the production image

```bash
docker build -t ai-quiz-generator:latest --target production .
```

### Build the development image

```bash
docker build -t ai-quiz-generator:dev --target development .
```

### Run the production image

```bash
docker run -p 3000:3000 ai-quiz-generator:latest
```

### Run the development image with hot reload

```bash
docker run -it -p 3000:3000 -v $(pwd):/app ai-quiz-generator:dev
```

### Push to GitHub Container Registry

```bash
# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Tag the image
docker tag ai-quiz-generator:latest ghcr.io/YOUR_USERNAME/ai-quiz-generator:latest

# Push
docker push ghcr.io/YOUR_USERNAME/ai-quiz-generator:latest
```

## GitHub Actions CI/CD Pipelines

### 1. CI Pipeline (cicd.yml)

**Triggers:**
- Every push to `main` or `develop` branches
- Every pull request to `main` or `develop` branches
- Manual trigger via workflow_dispatch

**Jobs:**
- **lint-and-test**: 
  - Installs dependencies
  - Runs ESLint
  - Builds the application
  
- **docker-build-push**:
  - Builds Docker image with multi-stage build
  - Pushes to GitHub Container Registry
  - Caches layers for faster rebuilds
  
- **security-scan**:
  - Scans for vulnerabilities with Trivy
  - Reports to GitHub Security tab

### 2. Deployment Pipeline (deploy.yml)

**Triggers:**
- Creating a git tag matching `v*` (e.g., `v1.0.0`)
- Manual trigger with environment selection

**Jobs:**
- **build-and-deploy**:
  - Builds production Docker image
  - Pushes to GHCR with version tag
  - Creates GitHub Release
  - Sends deployment notification

## Setting Up CI/CD

### 1. Enable GitHub Actions

The workflows are automatically detected. No additional setup needed if you have access to the repository.

### 2. Configure GitHub Container Registry

GitHub automatically provides access to GHCR. The pipeline uses `GITHUB_TOKEN` which is created automatically.

### 3. Create a Release/Deployment

To trigger the deployment pipeline:

```bash
# Create and push a version tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

This will:
1. Trigger the deployment workflow
2. Build the Docker image
3. Push to GHCR with tags: `v1.0.0` and `latest`
4. Create a GitHub Release with the image information

### 4. View Workflow Runs

Navigate to your GitHub repository → **Actions** tab to:
- View all workflow runs
- Check logs for each job
- See build history and artifacts
- View security scanning results

## Environment Variables

### Development
The application uses environment variables for API keys and configuration:

```bash
# .env.local
OPENAI_API_KEY=your_key_here
```

For Docker, mount a `.env.local` file:

```bash
docker run -p 3000:3000 -v $(pwd)/.env.local:/app/.env.local ai-quiz-generator:latest
```

### Production
Set environment variables in your deployment platform or Docker run command:

```bash
docker run -p 3000:3000 -e OPENAI_API_KEY=your_key_here ai-quiz-generator:latest
```

## Pipeline Status Badges

Add this to your README.md to display pipeline status:

```markdown
[![CI/CD Pipeline](https://github.com/YOUR_USERNAME/ai-quiz-generator/actions/workflows/cicd.yml/badge.svg)](https://github.com/YOUR_USERNAME/ai-quiz-generator/actions/workflows/cicd.yml)
```

## Troubleshooting

### Docker build fails with "npm ci" error

**Solution:** Ensure `package-lock.json` is committed to the repository:

```bash
npm ci  # Generate package-lock.json
git add package-lock.json
git commit -m "Add package-lock.json"
```

### Image not pushing to GHCR

**Solution:** Verify GitHub token permissions:
1. GitHub Settings → Developer settings → Personal access tokens
2. Ensure token has `write:packages` scope

### Workflow not triggering

**Solution:** Check that workflow files are in `.github/workflows/` directory and valid YAML syntax:

```bash
# Validate YAML
yamllint .github/workflows/
```

### Port 3000 already in use

**Solution:** Use a different port:

```bash
docker run -p 8000:3000 ai-quiz-generator:latest
# Access at http://localhost:8000
```

## Performance Optimization

### Docker Layer Caching
The Dockerfile uses multi-stage builds to minimize image size:
- **Builder stage**: Compiles Next.js application
- **Production stage**: Only includes runtime dependencies
- Result: ~200-300MB smaller image

### GitHub Actions Caching
Pipelines use GitHub's cache action to cache Docker layers, reducing build time by ~60%.

## Security Best Practices

1. **Non-root user**: Production container runs as `nextjs` user (UID 1001)
2. **Vulnerability scanning**: Trivy scans for CVEs on every push
3. **Environment variables**: Never commit secrets; use GitHub Secrets
4. **Image scanning**: Scan before pushing to production

## Next Steps

1. Commit these files to your repository
2. Push to GitHub and monitor the Actions tab
3. Create a release tag to test the deployment pipeline
4. Monitor logs and troubleshoot any issues
5. Customize workflows based on your deployment needs

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [Docker Documentation](https://docs.docker.com/)
- [Next.js Deployment Guide](https://nextjs.org/docs/deployment)
- [Trivy Documentation](https://github.com/aquasecurity/trivy)
