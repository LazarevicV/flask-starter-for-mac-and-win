# Flask Project Generator

Script that creates a new Flask project with virtual environment, `main.py`, and a basic `index.html` template.

## How to use

1. **Run the script** (from this folder):
   ```bash
   ./generate-flask-project
   ```

2. **Enter project name** when prompted.

3. **Start the new project**:
   ```bash
   cd <project-name>
   source venv/bin/activate
   python main.py
   ```

4. Open **http://127.0.0.1:5000** in your browser.

## Requirements

- Python 3 installed
- macOS, Linux, or a Unix-like environment (see **Windows** below)

## Windows

This script is a **bash script** and does **not** run natively in Windows Command Prompt or PowerShell.

**Options:**

- **WSL** (Windows Subsystem for Linux) — run the script inside WSL; it will work as on Linux.
- **Git Bash** — if you have Git for Windows, open Git Bash and run `./generate-flask-project` from this folder.
- **Manual setup** — create a folder, run `python -m venv venv`, activate it, `pip install flask`, then copy/create `main.py` and `templates/index.html` from a generated project.

If you need a Windows-native script (PowerShell or batch), one can be added to this repo.
