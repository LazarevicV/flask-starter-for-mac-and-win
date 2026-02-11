# Flask Project Generator for Windows
# Usage: .\generate-flask-project.ps1
# Or: powershell -ExecutionPolicy Bypass -File .\generate-flask-project.ps1

$ErrorActionPreference = "Stop"

Write-Host "=== Flask Project Generator ===" -ForegroundColor Cyan
Write-Host ""

$projectName = Read-Host "Enter project name"

if ([string]::IsNullOrWhiteSpace($projectName)) {
    Write-Host "Error: Project name cannot be empty!" -ForegroundColor Yellow
    exit 1
}

if (Test-Path $projectName) {
    Write-Host "Error: Directory '$projectName' already exists!" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Creating Flask project: $projectName" -ForegroundColor Green
Write-Host ""

# Create project directory and enter it
New-Item -ItemType Directory -Path $projectName | Out-Null
Push-Location $projectName

try {
    # Create virtual environment (try py first, then python)
    Write-Host "Creating virtual environment..." -ForegroundColor Cyan
    $py = if (Get-Command py -ErrorAction SilentlyContinue) { "py" } else { "python" }
    & $py -m venv venv
    if ($LASTEXITCODE -ne 0) { throw "Failed to create venv" }

    # Activate and install
    Write-Host "Activating virtual environment..." -ForegroundColor Cyan
    & .\venv\Scripts\Activate.ps1

    Write-Host "Upgrading pip..." -ForegroundColor Cyan
    python -m pip install --upgrade pip -q

    Write-Host "Installing Flask (latest version)..." -ForegroundColor Cyan
    pip install flask -q

    $flaskVersion = python -c "import importlib.metadata; print(importlib.metadata.version('flask'))" 2>$null
    if (-not $flaskVersion) { $flaskVersion = "latest" }
    Write-Host "Flask $flaskVersion installed successfully!" -ForegroundColor Green
    Write-Host ""

    # Project structure
    Write-Host "Creating project structure..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Path templates -Force | Out-Null
    New-Item -ItemType Directory -Path "static\css" -Force | Out-Null
    New-Item -ItemType Directory -Path "static\js" -Force | Out-Null

    # main.py
    @"
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=True)
"@ | Set-Content -Path main.py -Encoding UTF8

    # templates/index.html
    @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flask App</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
        }
        .container {
            text-align: center;
            padding: 2rem;
        }
        h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Flask!</h1>
        <p>Your Flask application is running successfully.</p>
    </div>
</body>
</html>
"@ | Set-Content -Path "templates\index.html" -Encoding UTF8

    # requirements.txt
    Write-Host "Creating requirements.txt..." -ForegroundColor Cyan
    pip freeze | Out-File -FilePath requirements.txt -Encoding UTF8

    # .gitignore
    @"
# Virtual Environment
venv/
env/
ENV/

# Python
__pycache__/
*.py[cod]
*`$py.class
*.so
.Python

# Flask
instance/
.webassets-cache

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Environment variables
.env
.env.local
"@ | Set-Content -Path .gitignore -Encoding UTF8

    # README.md (Windows activation instructions)
    @"
# $projectName

Flask application project.

## Setup

1. Activate virtual environment (PowerShell):
   ``.\venv\Scripts\Activate.ps1``

   Or Command Prompt:
   ``.\venv\Scripts\activate.bat``

2. Install dependencies (if needed):
   ``pip install -r requirements.txt``

3. Run the application:
   ``python main.py``

4. Open your browser and navigate to: http://127.0.0.1:5000

## Project Structure

```
$projectName/
├── main.py              # Main application file
├── requirements.txt     # Python dependencies
├── templates/           # HTML templates
│   └── index.html
├── static/              # Static files (CSS, JS, images)
│   ├── css/
│   └── js/
└── venv/                # Virtual environment
```
"@ | Set-Content -Path README.md -Encoding UTF8

    Write-Host ""
    Write-Host "Project created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Project structure:" -ForegroundColor Cyan
    Get-ChildItem -Recurse -Depth 1 | Where-Object { $_.FullName -notmatch "\\venv\\" } | ForEach-Object { Write-Host "  $($_.FullName.Replace((Get-Location).Path + '\', ''))" }

    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Green
    Write-Host "1. cd $projectName"
    Write-Host "2. .\venv\Scripts\Activate.ps1"
    Write-Host "3. python main.py"
    Write-Host ""
    Write-Host "Your Flask app will be available at: http://127.0.0.1:5000" -ForegroundColor Cyan
    Write-Host ""
}
finally {
    Pop-Location
}
