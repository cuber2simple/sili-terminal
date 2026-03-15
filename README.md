# Sili Terminal

Minimalist AI coding workspace built on **Ghostty + tmux**.
One fullscreen pane, popup-driven workflow, zero clutter.

```
┌─────────────────────────────────────────────────────────┐
│ [Catppuccin Status Bar]                    22:03 15-Mar │
│                                                         │
│                                                         │
│              Claude Code / Codex (fullscreen)            │
│                                                         │
│                                                         │
│    ┌─────────────────────────────────────────────┐      │
│    │                                             │      │
│    │   Alt+s  →  File Search Popup (fzf+vim)     │      │
│    │   Alt+d  →  Scratch Terminal Popup           │      │
│    │   Alt+q  →  Quit Session                    │      │
│    │                                             │      │
│    │   Esc    →  Close popup                     │      │
│    │                                             │      │
│    └─────────────────────────────────────────────┘      │
│                                                         │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Features

- **Fullscreen single-pane** — no splits, no sidebars, no distractions
- **Alt+s** — fuzzy file search (fzf + bat preview → vim edit → back to search)
- **Alt+d** — scratch terminal popup (toggle on/off)
- **Alt+q** — kill session instantly
- **Ctrl+y** — copy file path to clipboard (in search)
- **Ctrl+o** — copy file content to clipboard (in search)
- **Catppuccin Mocha** theme everywhere
- **Mouse copy** works natively (no Shift needed)
- **Vi-mode** copy with `v` select, `y` yank

## Architecture

```
sili-terminal/
├── config/
│   ├── ghostty.conf        # Ghostty terminal config
│   └── tmux.conf            # tmux config (keybindings, plugins, theme)
├── tmux-hacker.sh           # Launch workspace (general)
├── tmux-claude.sh           # Launch workspace (Claude Code)
├── tmux-codex.sh            # Launch workspace (Codex)
├── sili-file-search.sh      # Alt+s file search (fzf → vim loop)
├── sili-notify.sh           # Notification system (info/warn/error/ai)
├── sili-dup.sh              # Open new Ghostty window
├── install.sh               # One-click installer
└── README.md
```

## Requirements

| Tool | Install |
|------|---------|
| [Ghostty](https://ghostty.org) | Download from website |
| tmux | `brew install tmux` |
| fzf | `brew install fzf` |
| fd | `brew install fd` |
| bat | `brew install bat` |
| vim | Pre-installed on macOS |
| [JetBrainsMono Nerd Font](https://www.nerdfonts.com/) | `brew install --cask font-jetbrains-mono-nerd-font` |

## Install

```bash
git clone https://github.com/YOUR_USER/sili-terminal.git
cd sili-terminal
bash install.sh
```

The installer will:
1. Back up your existing Ghostty/tmux configs
2. Install Sili configs
3. Install TPM (tmux plugin manager)
4. Check for required fonts
5. Print aliases to add to your `~/.zshrc`

After install:
```bash
# Restart Ghostty, then:
tmux source ~/.tmux.conf     # reload tmux config
# Press Ctrl+a I             # install tmux plugins (Catppuccin, etc.)
ai-hacker                    # launch workspace
```

## Keybindings

### Global (no prefix)

| Key | Action |
|-----|--------|
| `Alt+s` | File search popup |
| `Alt+d` | Scratch terminal popup (toggle) |
| `Alt+q` | Kill session |
| `Alt+h/j/k/l` | Navigate panes (if split) |

### In File Search (Alt+s)

| Key | Action |
|-----|--------|
| Type | Fuzzy search files |
| `Enter` | Open in vim |
| `:q` in vim | Back to search |
| `Ctrl+y` | Copy file path |
| `Ctrl+o` | Copy file content |
| `Esc` | Close search |

### tmux (Ctrl+a prefix)

| Key | Action |
|-----|--------|
| `\|` | Split vertical |
| `-` | Split horizontal |
| `h/j/k/l` | Navigate panes |
| `H/J/K/L` | Resize panes |
| `x` | Kill pane |
| `X` | Kill window |
| `r` | Reload config |
| `[` | Enter copy mode |

### Copy mode (vi)

| Key | Action |
|-----|--------|
| `v` | Begin selection |
| `y` | Yank to clipboard |
| Mouse drag | Copy to clipboard |

## Workspaces

```bash
ai-hacker    # General hacker workspace
ai-claude    # Claude Code workspace
ai-codex     # Codex workspace
```

## License

MIT
