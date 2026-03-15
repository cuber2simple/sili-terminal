#!/bin/bash
# Sili Terminal - Installer
# Installs Ghostty + tmux configs and scripts

set -e

SILI_DIR="$(cd "$(dirname "$0")" && pwd)"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "================================"
echo " Sili Terminal - Installer"
echo "================================"
echo ""

# --- Check dependencies ---
MISSING=()
command -v ghostty >/dev/null 2>&1 || MISSING+=("Ghostty (https://ghostty.org)")
command -v tmux >/dev/null 2>&1 || MISSING+=("tmux (brew install tmux)")
command -v fzf >/dev/null 2>&1 || MISSING+=("fzf (brew install fzf)")
command -v fd >/dev/null 2>&1 || MISSING+=("fd (brew install fd)")
command -v bat >/dev/null 2>&1 || MISSING+=("bat (brew install bat)")
command -v vim >/dev/null 2>&1 || MISSING+=("vim")

if [ ${#MISSING[@]} -gt 0 ]; then
  echo -e "${YELLOW}Missing dependencies:${NC}"
  for dep in "${MISSING[@]}"; do
    echo "  - $dep"
  done
  echo ""
  read -p "Continue anyway? (y/n) " -n 1 -r
  echo
  [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
fi

# --- Install Ghostty config ---
echo -e "${GREEN}[1/4] Ghostty config${NC}"
mkdir -p ~/.config/ghostty
if [ -f ~/.config/ghostty/config ]; then
  cp ~/.config/ghostty/config ~/.config/ghostty/config.bak
  echo "  Backed up existing config to config.bak"
fi
cp "$SILI_DIR/config/ghostty.conf" ~/.config/ghostty/config
echo "  Installed -> ~/.config/ghostty/config"

# --- Install tmux config ---
echo -e "${GREEN}[2/4] tmux config${NC}"
if [ -f ~/.tmux.conf ]; then
  cp ~/.tmux.conf ~/.tmux.conf.bak
  echo "  Backed up existing config to .tmux.conf.bak"
fi
# Replace $HOME path references with actual home directory
sed "s|\$HOME|$HOME|g" "$SILI_DIR/config/tmux.conf" > ~/.tmux.conf
# Update sili-file-search.sh path to actual install location
sed -i '' "s|$HOME/project/ai/sili-terminal|$SILI_DIR|g" ~/.tmux.conf
echo "  Installed -> ~/.tmux.conf"

# --- Install TPM (tmux plugin manager) ---
echo -e "${GREEN}[3/4] tmux plugins${NC}"
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "  Installed TPM"
else
  echo "  TPM already installed"
fi

# --- Install Nerd Font ---
echo -e "${GREEN}[4/4] Font check${NC}"
if fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd" || ls ~/Library/Fonts/*JetBrains*Nerd* 2>/dev/null | grep -q .; then
  echo "  JetBrainsMono Nerd Font found"
else
  echo -e "  ${YELLOW}JetBrainsMono Nerd Font not found${NC}"
  echo "  Install: brew install --cask font-jetbrains-mono-nerd-font"
fi

# --- Make scripts executable ---
chmod +x "$SILI_DIR"/*.sh

# --- Add aliases ---
echo ""
echo "================================"
echo " Add to your ~/.zshrc:"
echo "================================"
echo ""
echo "  # Sili Terminal"
echo "  alias ai-claude=\"$SILI_DIR/tmux-claude.sh\""
echo "  alias ai-codex=\"$SILI_DIR/tmux-codex.sh\""
echo "  alias ai-hacker=\"$SILI_DIR/tmux-hacker.sh\""
echo "  alias notify=\"$SILI_DIR/sili-notify.sh\""
echo ""
echo "================================"
echo " Done! Next steps:"
echo "================================"
echo ""
echo "  1. Restart Ghostty"
echo "  2. Run: tmux source ~/.tmux.conf"
echo "  3. In tmux, press Ctrl+a I to install plugins"
echo "  4. Run: ai-hacker (or ai-claude / ai-codex)"
echo ""
