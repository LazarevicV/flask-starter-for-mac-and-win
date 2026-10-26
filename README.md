# Flask Project Generator

Script that creates a new Flask project with virtual environment, Flask, MySQL Connector (`mysql-connector-python`), `main.py`, and a basic `index.html` template.

The generated `main.py` connects to MySQL on startup (`localhost`, user `root`, empty password, database `db`). Change these values in `main.py` to match your database before running the app.

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

1. **Download `generate-flask-project.cmd` and double-click it** (or run it from a terminal).
   It does not use PowerShell, so a disabled execution policy does not block it.
   If Windows shows "Windows protected your PC", click **More info → Run anyway**.

2. **Enter project name** when prompted. The project is created next to the `.cmd` file
   (or in the current folder when run from a terminal).

3. **The app starts by itself**: when the project is created, this window closes and a new
   Command Prompt window opens in the project folder with the virtual environment activated
   and the Flask app running. Stop it with Ctrl+C, start it again there with `python main.py`.

   Later, from any terminal (Command Prompt or PowerShell, no activation needed):
   ```
   cd <project-name>
   venv\Scripts\python main.py
   ```

Alternative (PowerShell script, may be blocked by execution policy):
```powershell
powershell -ExecutionPolicy Bypass -File .\generate-flask-project.ps1
```

### Then

4. Open **http://127.0.0.1:5000** in your browser.

## Requirements

- Python 3 installed
- **macOS/Linux:** bash (default)
- **Windows:** Python 3.8+ (found via the `py` launcher or `python` on PATH)
- A running MySQL server with the database set in `main.py` (needed to start the generated app)
