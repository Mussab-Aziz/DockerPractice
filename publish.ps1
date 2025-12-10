#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Automated script to publish new versions to GitHub Container Registry (GHCR)
.DESCRIPTION
    This script handles version tagging, git commits, and pushes to trigger
    automated Docker builds and GHCR publishing via GitHub Actions
.PARAMETER Version
    Version number (e.g., 1.0.1, 1.1.0, 2.0.0)
.PARAMETER Message
    Release message describing the changes
.EXAMPLE
    .\publish.ps1 -Version 1.0.1 -Message "Bug fixes and improvements"
    .\publish.ps1 -Version 1.1.0 -Message "New features added"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Version,
    
    [Parameter(Mandatory=$true)]
    [string]$Message
)

# Colors for output
$Green = @{ ForegroundColor = 'Green' }
$Yellow = @{ ForegroundColor = 'Yellow' }
$Red = @{ ForegroundColor = 'Red' }
$Blue = @{ ForegroundColor = 'Blue' }

Write-Host "`n🚀 GHCR Publishing Script" @Blue
Write-Host "=" * 50 @Blue

# Validate version format
if ($Version -notmatch '^v?\d+\.\d+\.\d+$') {
    Write-Host "❌ Invalid version format. Use: 1.0.0 or v1.0.0" @Red
    exit 1
}

# Add 'v' prefix if not present
if (-not $Version.StartsWith('v')) {
    $Version = "v$Version"
}

Write-Host "📦 Version: $Version" @Blue
Write-Host "📝 Message: $Message" @Blue
Write-Host ""

# Check if tag already exists
if (git rev-parse "$Version" 2>$null) {
    Write-Host "❌ Tag $Version already exists!" @Red
    Write-Host "💡 Delete it first: git tag -d $Version && git push origin --delete $Version" @Yellow
    exit 1
}

# Check git status
Write-Host "🔍 Checking git status..." @Blue
$status = git status --porcelain
if ($status) {
    Write-Host "⚠️  Uncommitted changes detected:" @Yellow
    Write-Host $status
    Write-Host "💡 Commit your changes first: git add . && git commit -m 'message'" @Yellow
    exit 1
}

Write-Host "✅ Git status clean" @Green

# Create tag
Write-Host "`n🏷️  Creating version tag: $Version" @Blue
git tag -a $Version -m "Release $Version - $Message"
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to create tag" @Red
    exit 1
}
Write-Host "✅ Tag created" @Green

# Push tag
Write-Host "`n📤 Pushing tag to GitHub..." @Blue
Write-Host "   This will trigger the 'Deploy to Production' workflow" @Yellow
git push origin $Version
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to push tag" @Red
    Write-Host "💡 Roll back: git tag -d $Version" @Yellow
    exit 1
}
Write-Host "✅ Tag pushed successfully" @Green

# Summary
Write-Host "`n" @Blue
Write-Host "=" * 50 @Blue
Write-Host "✅ PUBLISHING INITIATED!" @Green
Write-Host "=" * 50 @Blue
Write-Host ""
Write-Host "📊 Next steps:" @Blue
Write-Host "  1. Go to: https://github.com/Mussab-Aziz/DockerPractice/actions" @Yellow
Write-Host "  2. Wait for 'Deploy to Production' workflow to complete" @Yellow
Write-Host "  3. Image will be available at:" @Yellow
Write-Host "     ghcr.io/mussab-aziz/dockerpractice:$Version" @Green
Write-Host "     ghcr.io/mussab-aziz/dockerpractice:latest" @Green
Write-Host ""
Write-Host "🧪 Test the image:" @Blue
Write-Host "  docker pull ghcr.io/mussab-aziz/dockerpractice:$Version" @Yellow
Write-Host "  docker run -p 3000:3000 ghcr.io/mussab-aziz/dockerpractice:$Version" @Yellow
Write-Host ""
Write-Host "⏱️  Build time: ~5-10 minutes" @Blue
Write-Host ""
