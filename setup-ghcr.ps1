#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Interactive GHCR Setup Assistant
.DESCRIPTION
    Guides you through creating a GitHub PAT and adds it to your repository secrets
.EXAMPLE
    .\setup-ghcr.ps1
#>

param()

$Green = @{ ForegroundColor = 'Green' }
$Yellow = @{ ForegroundColor = 'Yellow' }
$Red = @{ ForegroundColor = 'Red' }
$Blue = @{ ForegroundColor = 'Blue' }
$Cyan = @{ ForegroundColor = 'Cyan' }

Write-Host "`n" @Blue
Write-Host "╔════════════════════════════════════════════════════════════════╗" @Blue
Write-Host "║         GHCR Publishing - Interactive Setup Guide              ║" @Blue
Write-Host "╚════════════════════════════════════════════════════════════════╝" @Blue
Write-Host ""

Write-Host "📋 STEP 1: Create GitHub Personal Access Token" @Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" @Cyan
Write-Host ""
Write-Host "I'll open GitHub in your browser. Follow these steps:" @Yellow
Write-Host ""
Write-Host "1. Go to: https://github.com/settings/tokens" @Yellow
Write-Host "2. Click: 'Generate new token (classic)'" @Yellow
Write-Host "3. Set Name: GHCR_TOKEN" @Yellow
Write-Host "4. Set Expiration: 90 days" @Yellow
Write-Host "5. Check these scopes:" @Yellow
Write-Host "   ✓ write:packages" @Green
Write-Host "   ✓ read:packages" @Green
Write-Host "   ✓ delete:packages" @Green
Write-Host "6. Click: 'Generate token'" @Yellow
Write-Host "7. COPY the token (shown once only!)" @Red
Write-Host ""

$response = Read-Host "Ready to open GitHub? (y/n)"
if ($response -eq 'y' -or $response -eq 'yes') {
    Start-Process "https://github.com/settings/tokens"
    Write-Host "✅ Browser opened. Creating token..." @Green
    Write-Host ""
    Write-Host "⏳ Waiting for you to complete token creation..." @Yellow
    Write-Host ""
    $pause = Read-Host "Press ENTER once you've copied your token"
}

Write-Host ""
Write-Host "📋 STEP 2: Add Token to Repository Secrets" @Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" @Cyan
Write-Host ""
Write-Host "Now I'll open GitHub repository settings. Follow these steps:" @Yellow
Write-Host ""
Write-Host "1. Go to: Repository → Settings → Secrets and variables → Actions" @Yellow
Write-Host "2. Click: 'New repository secret'" @Yellow
Write-Host "3. Name: GHCR_TOKEN" @Yellow
Write-Host "4. Secret: PASTE your token from Step 1" @Yellow
Write-Host "5. Click: 'Add secret'" @Yellow
Write-Host ""

$response = Read-Host "Ready to open repository settings? (y/n)"
if ($response -eq 'y' -or $response -eq 'yes') {
    Start-Process "https://github.com/Mussab-Aziz/DockerPractice/settings/secrets/actions"
    Write-Host "✅ Browser opened. Adding token..." @Green
    Write-Host ""
    Write-Host "⏳ Waiting for you to add the secret..." @Yellow
    Write-Host ""
    $pause = Read-Host "Press ENTER once you've added the GHCR_TOKEN secret"
}

Write-Host ""
Write-Host "📋 STEP 3: Publish Your First Release" @Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" @Cyan
Write-Host ""

Write-Host "Great! Now let's publish your image to GHCR..." @Green
Write-Host ""

$versionInput = Read-Host "Enter version (default: 1.0.0)"
$version = if ([string]::IsNullOrWhiteSpace($versionInput)) { "1.0.0" } else { $versionInput }

$messageInput = Read-Host "Enter release message (default: 'Initial release')"
$message = if ([string]::IsNullOrWhiteSpace($messageInput)) { "Initial release" } else { $messageInput }

Write-Host ""
Write-Host "Publishing v$version..." @Cyan
Write-Host "Message: $message" @Cyan
Write-Host ""

# Run the publish script
$scriptPath = Join-Path (Get-Location) "publish.ps1"
if (Test-Path $scriptPath) {
    try {
        & $scriptPath -Version $version -Message $message
        Write-Host ""
        Write-Host "✅ SETUP COMPLETE!" @Green
        Write-Host ""
        Write-Host "Your image is being published to GHCR:" @Green
        Write-Host "  ghcr.io/mussab-aziz/dockerpractice:v$version" @Cyan
        Write-Host "  ghcr.io/mussab-aziz/dockerpractice:latest" @Cyan
        Write-Host ""
        Write-Host "📊 Monitor progress:" @Yellow
        Write-Host "  https://github.com/Mussab-Aziz/DockerPractice/actions" @Cyan
        Write-Host ""
        Write-Host "⏱️  Build time: 5-10 minutes" @Yellow
        Write-Host ""
        Write-Host "🧪 Test when ready:" @Green
        Write-Host "  docker pull ghcr.io/mussab-aziz/dockerpractice:v$version" @Cyan
        Write-Host "  docker run -p 3000:3000 ghcr.io/mussab-aziz/dockerpractice:v$version" @Cyan
    } catch {
        Write-Host "❌ Error during publishing: $_" @Red
        exit 1
    }
} else {
    Write-Host "❌ publish.ps1 not found!" @Red
    exit 1
}

Write-Host ""
