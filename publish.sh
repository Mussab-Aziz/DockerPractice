#!/bin/bash

# GHCR Publishing Script for Linux/macOS
# Usage: ./publish.sh v1.0.1 "Release description"

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
if [ $# -lt 2 ]; then
    echo -e "${RED}❌ Usage: $0 <version> <message>${NC}"
    echo -e "${YELLOW}Example: $0 v1.0.1 \"Bug fixes and improvements\"${NC}"
    exit 1
fi

VERSION=$1
MESSAGE=$2

# Add 'v' prefix if not present
if [[ ! $VERSION =~ ^v ]]; then
    VERSION="v$VERSION"
fi

# Validate version format
if ! [[ $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}❌ Invalid version format. Use: v1.0.0${NC}"
    exit 1
fi

echo -e "\n${BLUE}🚀 GHCR Publishing Script${NC}"
echo -e "${BLUE}===================================================${NC}"
echo -e "${BLUE}📦 Version: $VERSION${NC}"
echo -e "${BLUE}📝 Message: $MESSAGE${NC}"
echo ""

# Check if tag already exists
if git rev-parse "$VERSION" >/dev/null 2>&1; then
    echo -e "${RED}❌ Tag $VERSION already exists!${NC}"
    echo -e "${YELLOW}💡 Delete it first: git tag -d $VERSION && git push origin --delete $VERSION${NC}"
    exit 1
fi

# Check git status
echo -e "${BLUE}🔍 Checking git status...${NC}"
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}⚠️  Uncommitted changes detected:${NC}"
    git status --short
    echo -e "${YELLOW}💡 Commit your changes first: git add . && git commit -m 'message'${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Git status clean${NC}"

# Create tag
echo -e "\n${BLUE}🏷️  Creating version tag: $VERSION${NC}"
git tag -a "$VERSION" -m "Release $VERSION - $MESSAGE"
echo -e "${GREEN}✅ Tag created${NC}"

# Push tag
echo -e "\n${BLUE}📤 Pushing tag to GitHub...${NC}"
echo -e "${YELLOW}   This will trigger the 'Deploy to Production' workflow${NC}"
git push origin "$VERSION"
echo -e "${GREEN}✅ Tag pushed successfully${NC}"

# Summary
echo -e "\n${BLUE}===================================================${NC}"
echo -e "${GREEN}✅ PUBLISHING INITIATED!${NC}"
echo -e "${BLUE}===================================================${NC}"
echo ""
echo -e "${BLUE}📊 Next steps:${NC}"
echo -e "  ${YELLOW}1. Go to: https://github.com/Mussab-Aziz/DockerPractice/actions${NC}"
echo -e "  ${YELLOW}2. Wait for 'Deploy to Production' workflow to complete${NC}"
echo -e "  ${YELLOW}3. Image will be available at:${NC}"
echo -e "     ${GREEN}ghcr.io/mussab-aziz/dockerpractice:$VERSION${NC}"
echo -e "     ${GREEN}ghcr.io/mussab-aziz/dockerpractice:latest${NC}"
echo ""
echo -e "${BLUE}🧪 Test the image:${NC}"
echo -e "  ${YELLOW}docker pull ghcr.io/mussab-aziz/dockerpractice:$VERSION${NC}"
echo -e "  ${YELLOW}docker run -p 3000:3000 ghcr.io/mussab-aziz/dockerpractice:$VERSION${NC}"
echo ""
echo -e "${BLUE}⏱️  Build time: ~5-10 minutes${NC}"
echo ""
