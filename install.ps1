# Installer for generate-flask-project (Windows)
# Run this once: powershell -ExecutionPolicy Bypass -File install.ps1
# After that, use 'generate-flask-project' from any PowerShell window.

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ScriptSrc = Join-Path $ScriptDir "generate-flask-project.ps1"
$InstallDir = "$env:USERPROFILE\bin"

Write-Host "Installing generate-flask-project..." -ForegroundColor Cyan

# Create install directory
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir | Out-Null
}

# Copy script to install dir
Copy-Item $ScriptSrc "$InstallDir\generate-flask-project.ps1" -Force

# Add install dir to user PATH if not already there
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notlike "*$InstallDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$userPath;$InstallDir", "User")
    Write-Host "Added $InstallDir to your PATH." -ForegroundColor Green
}

# Add a function to PowerShell profile so you can type 'generate-flask-project'
# without needing the .ps1 extension
$funcDefinition = @"

# Flask Project Generator
function generate-flask-project {
    & "$InstallDir\generate-flask-project.ps1" @args
}
"@

if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
if ($profileContent -notlike "*generate-flask-project*") {
    Add-Content -Path $PROFILE -Value $funcDefinition
    Write-Host "Added 'generate-flask-project' function to your PowerShell profile." -ForegroundColor Green
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host "Restart PowerShell, then run 'generate-flask-project' from any directory." -ForegroundColor Cyan
