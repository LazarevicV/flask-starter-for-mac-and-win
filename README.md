# Flask Project Generator

Script that creates a new Flask project with virtual environment, `main.py`, and a basic `index.html` template.

## Installation (optional)

Install once to run `generate-flask-project` from any directory.

### macOS / Linux

```bash
bash install.sh
```

Restart your terminal (or run `source ~/.zshrc`), then use `generate-flask-project` from anywhere.

### Windows

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

Restart PowerShell, then use `generate-flask-project` from anywhere.

---

## How to use

### macOS / Linux

1. **Run the script** (from this folder, or anywhere after installing):
   ```bash
   generate-flask-project
   ```

2. **Enter project name** when prompted.

3. **Start the new project**:
   ```bash
   cd <project-name>
   source venv/bin/activate
   python main.py
   ```

### Windows

1. **Run the script** (from this folder, or anywhere after installing):
   ```powershell
   .\generate-flask-project.ps1
   ```
   If execution is blocked, run:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\generate-flask-project.ps1
   ```

2. **Enter project name** when prompted.

3. **Start the new project**:
   ```powershell
   cd <project-name>
   .\venv\Scripts\Activate.ps1
   python main.py
   ```

### Then

4. Open **http://127.0.0.1:5000** in your browser.

## Requirements

- Python 3 installed
- **macOS/Linux:** bash (default)
- **Windows:** PowerShell 5+ (built into Windows)
