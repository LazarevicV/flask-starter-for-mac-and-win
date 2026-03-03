#!/bin/bash

# Installer for generate-flask-project (Mac/Linux)
# Run this once: bash install.sh
# After that, use 'generate-flask-project' from any directory.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_SRC="$SCRIPT_DIR/generate-flask-project"

echo "Installing generate-flask-project..."

# Try /usr/local/bin first (requires no PATH changes, already in PATH on macOS)
if [ -w /usr/local/bin ] || sudo -n true 2>/dev/null; then
    if sudo cp "$SCRIPT_SRC" /usr/local/bin/generate-flask-project && sudo chmod +x /usr/local/bin/generate-flask-project; then
        echo "Installed to /usr/local/bin/generate-flask-project"
        echo "You can now run 'generate-flask-project' from any directory."
        exit 0
    fi
fi

# Fallback: install to ~/.local/bin (no sudo needed)
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"
cp "$SCRIPT_SRC" "$INSTALL_DIR/generate-flask-project"
chmod +x "$INSTALL_DIR/generate-flask-project"

# Add ~/.local/bin to PATH in shell config if not already there
for RC in "$HOME/.zshrc" "$HOME/.bash_profile" "$HOME/.bashrc"; do
    if [ -f "$RC" ] && ! grep -q '.local/bin' "$RC"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$RC"
        echo "Added ~/.local/bin to PATH in $RC"
    fi
done

echo "Installed to $INSTALL_DIR/generate-flask-project"
echo ""
echo "Restart your terminal (or run: source ~/.zshrc)"
echo "Then you can run 'generate-flask-project' from any directory."
