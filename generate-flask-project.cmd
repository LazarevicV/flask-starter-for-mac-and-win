@echo off
rem = """
:: Flask Project Generator for Windows
:: Usage: double-click this file, or run generate-flask-project.cmd from a terminal.
::
:: This file is a batch script and a Python script at the same time. The batch
:: part finds Python and runs the rest of this file with it ("python -x" skips
:: the first line). PowerShell is not used, so execution policy does not apply.
:: Keep CRLF line endings (see .gitattributes), cmd.exe needs them.
::
:: On success this window closes and the app starts in a new window with the
:: venv activated. On errors this window stays open so the message can be read.

setlocal
title Flask Project Generator

set "PY="
py -3 -c "import sys; sys.exit(sys.version_info < (3, 8))" <nul >nul 2>&1 && set "PY=py -3"
if not defined PY (
    python -c "import sys; sys.exit(sys.version_info < (3, 8))" <nul >nul 2>&1 && set "PY=python"
)
if not defined PY (
    echo Error: Python 3.8 or newer was not found.
    echo Install Python from https://www.python.org/downloads/ and run this file again.
    echo.
    pause
    exit /b 1
)

%PY% -x "%~f0"
set "RC=%ERRORLEVEL%"
if not "%RC%"=="0" (
    echo.
    pause
)
exit /b %RC%
"""

import os
import shutil
import subprocess
import sys
from pathlib import Path

PIP_ERROR = "Could not install packages (see the messages above). Check your internet connection."

MAIN_PY = """\
from flask import Flask, render_template
import mysql.connector

app = Flask(__name__)

# Uncomment to connect to MySQL (the MySQL server must be running and the database must exist)
# mydb = mysql.connector.connect(
#     host='localhost',
#     user='root',
#     password='',
#     database='db'  # change this to the name of your database
# )

@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=True)
"""

INDEX_HTML = """\
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
"""

GITIGNORE = """\
# Virtual Environment
venv/
env/
ENV/

# Python
__pycache__/
*.py[cod]
*$py.class
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
"""

README_MD = r"""# {name}

Flask application project.

## Setup

1. Activate virtual environment (Command Prompt):
   `venv\Scripts\activate.bat`

   Or PowerShell:
   `.\venv\Scripts\Activate.ps1`

2. Install dependencies (if needed):
   `pip install -r requirements.txt`

3. Run the application:
   `python main.py`

   Or without activating the virtual environment:
   `venv\Scripts\python main.py`

4. Open your browser and navigate to: http://127.0.0.1:5000

## Project Structure

```
{name}/
├── main.py              # Main application file
├── requirements.txt     # Python dependencies
├── templates/           # HTML templates
│   └── index.html
└── venv/                # Virtual environment
```
"""


class SetupError(Exception):
    pass


def enable_colors():
    """Turn on ANSI colors in the Windows console; returns False if unsupported."""
    try:
        import ctypes
        kernel32 = ctypes.windll.kernel32
        handle = kernel32.GetStdHandle(-11)  # STD_OUTPUT_HANDLE
        mode = ctypes.c_uint32()
        if not kernel32.GetConsoleMode(handle, ctypes.byref(mode)):
            return False
        return bool(kernel32.SetConsoleMode(handle, mode.value | 0x0004))  # ENABLE_VIRTUAL_TERMINAL_PROCESSING
    except (ImportError, AttributeError, OSError):
        return False


COLORS = {"cyan": "\033[96m", "green": "\033[92m", "yellow": "\033[93m"}
USE_COLORS = enable_colors()


def say(text="", color=None):
    if color and USE_COLORS:
        text = f"{COLORS[color]}{text}\033[0m"
    print(text, flush=True)


def run(args, error, **kwargs):
    result = subprocess.run(args, **kwargs)
    if result.returncode != 0:
        raise SetupError(error)
    return result


def write(path, content):
    path.write_text(content, encoding="utf-8")


def create_project(project_dir, project_name):
    venv_python = project_dir / "venv" / ("Scripts/python.exe" if os.name == "nt" else "bin/python")

    # The venv is used through its python.exe directly, so Activate.ps1 is never needed
    say("Creating virtual environment...", "cyan")
    run([sys.executable, "-m", "venv", "venv"], "Could not create the virtual environment (see the messages above).", cwd=project_dir)

    say("Upgrading pip...", "cyan")
    run([str(venv_python), "-m", "pip", "install", "--upgrade", "pip", "-q"], PIP_ERROR, cwd=project_dir)

    say("Installing Flask (latest version)...", "cyan")
    run([str(venv_python), "-m", "pip", "install", "flask", "-q"], PIP_ERROR, cwd=project_dir)

    say("Installing MySQL Connector (mysql-connector-python)...", "cyan")
    run([str(venv_python), "-m", "pip", "install", "mysql-connector-python", "-q"], PIP_ERROR, cwd=project_dir)

    version = subprocess.run(
        [str(venv_python), "-c", "import importlib.metadata; print(importlib.metadata.version('flask'))"],
        capture_output=True, text=True,
    )
    flask_version = version.stdout.strip() if version.returncode == 0 else "latest"
    say(f"Flask {flask_version} installed successfully!", "green")
    say()

    say("Creating project structure...", "cyan")
    (project_dir / "templates").mkdir()
    write(project_dir / "main.py", MAIN_PY)
    write(project_dir / "templates" / "index.html", INDEX_HTML)

    say("Creating requirements.txt...", "cyan")
    freeze = run([str(venv_python), "-m", "pip", "freeze"], PIP_ERROR, cwd=project_dir, capture_output=True, text=True)
    write(project_dir / "requirements.txt", freeze.stdout)

    write(project_dir / ".gitignore", GITIGNORE)
    write(project_dir / "README.md", README_MD.format(name=project_name))


def remove_unfinished(project_dir):
    shutil.rmtree(project_dir, ignore_errors=True)
    if project_dir.exists():
        say(f"Delete the folder '{project_dir}' and run this file again.", "yellow")
    else:
        say("The unfinished project folder was removed, so you can run this file again.", "yellow")


def start_server_window(project_dir):
    """Open a new Command Prompt in the project folder, activate the venv and start the app."""
    if os.name != "nt":
        return False
    # A new window, because this generator window closes when we are done. cmd /k keeps
    # it open with the venv active after the server stops (Ctrl+C) or fails to start.
    # pushd also handles network paths, which cmd cannot use as its starting folder.
    command = (
        f'cmd.exe /k pushd "{project_dir}" && call venv\\Scripts\\activate.bat'
        " && echo Starting the Flask server. Stop it with Ctrl+C, start it again with: python main.py"
        " && echo. && python main.py"
    )
    try:
        subprocess.Popen(command, creationflags=subprocess.CREATE_NEW_CONSOLE, cwd=os.environ.get("SystemRoot"))
    except OSError:
        return False
    return True


def main():
    say("=== Flask Project Generator ===", "cyan")
    say()

    # Started as administrator (cwd is System32) or from a network path that cmd
    # cannot use as cwd (falls back to C:\Windows): create the project next to this file.
    windows_dir = os.path.normcase(os.environ.get("SystemRoot", ""))
    cwd = os.path.normcase(os.getcwd())
    if windows_dir and (cwd == windows_dir or cwd.startswith(windows_dir + os.sep)):
        os.chdir(Path(__file__).resolve().parent)

    try:
        project_name = input("Enter project name: ").strip()
    except (EOFError, KeyboardInterrupt):
        say()
        return 1

    if not project_name:
        say("Error: Project name cannot be empty!", "yellow")
        return 1

    project_dir = Path.cwd() / project_name
    if project_dir.exists():
        say(f"Error: Directory '{project_name}' already exists!", "yellow")
        return 1

    say()
    say(f"Creating Flask project: {project_name}", "green")
    say()

    try:
        project_dir.mkdir()
    except OSError as error:
        say(f"Error: Could not create directory '{project_name}': {error.strerror}", "yellow")
        return 1

    try:
        create_project(project_dir, project_name)
    except (SetupError, OSError) as error:
        say()
        say(f"Error: {error}", "yellow")
        remove_unfinished(project_dir)
        return 1
    except KeyboardInterrupt:
        say()
        say("Cancelled.", "yellow")
        remove_unfinished(project_dir)
        return 1

    say()
    say("Project created successfully!", "green")
    say()
    say("Project structure:", "cyan")
    for path in sorted(project_dir.iterdir(), key=lambda p: p.name.lower()):
        say(f"  {path.name}")
        if path.is_dir() and path.name != "venv":
            for child in sorted(path.iterdir(), key=lambda p: p.name.lower()):
                say(f"  {path.name}{os.sep}{child.name}")
    say()
    say(f"Location: {project_dir}")

    say()
    if start_server_window(project_dir):
        say("Starting the Flask server in a new window...", "green")
        return 0

    say("Next steps:", "green")
    say(f'1. cd "{project_name}"' if " " in project_name else f"1. cd {project_name}")
    say(r"2. venv\Scripts\python main.py")
    say()
    say("Your Flask app will be available at: http://127.0.0.1:5000", "cyan")
    # Non-zero exit keeps this window open (the batch part pauses) so the steps can be read
    return 1


if __name__ == "__main__":
    sys.exit(main())
