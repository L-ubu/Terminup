<div align="center">

```
                                    ████████╗██╗   ██╗██████╗ 
                                    ╚══██╔══╝██║   ██║██╔══██╗
                                       ██║   ██║   ██║██████╔╝
                                       ██║   ██║   ██║██╔═══╝ 
                                       ██║   ╚██████╔╝██║     
                                       ╚═╝    ╚═════╝ ╚═╝     
```

**Terminal Enhancements for Power Users**

Beautiful animations, ASCII art, and productivity tools for your Zsh terminal.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Shell: Zsh](https://img.shields.io/badge/Shell-Zsh-green.svg)](https://www.zsh.org/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

[Features](#features) · [Installation](#installation) · [Commands](#commands) · [Themes](#themes) · [Contributing](#contributing)

</div>

---

## Overview

Terminup transforms your terminal into a modern, animated development environment. It adds visual feedback to common commands, beautiful ASCII art to git operations, and productivity tools to streamline your workflow.

**Works with any Zsh setup** - Powerlevel10k is optional.

**Cross-platform** - Works on macOS, Linux (Ubuntu, Arch, Fedora), and Windows (WSL).

**Multilingual** - Supports English, Dutch, French, German, Spanish, and more!

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   ╔═══════════════════════════════════════════════════╗     │
│   ║              TERMINUP BOOT SEQUENCE               ║     │
│   ╚═══════════════════════════════════════════════════╝     │
│                                                             │
│   [ OK ] Initializing Terminup v1.0.0                       │
│   [ OK ] Loading core modules                               │
│   [ OK ] Configuring shell environment                      │
│                                                             │
│   ─────────────────────────────────────────────────────     │
│                                                             │
│   SYSTEM STATUS                                             │
│   [ OK ] Shell: zsh 5.9                                     │
│   [ OK ] Git: 2.43.0                                        │
│   [ OK ] Node: v20.10.0                                     │
│   [ OK ] FZF: Available                                     │
│                                                             │
│   ═════════════════════════════════════════════════════     │
│   [ OK ] All systems operational                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Features

### Animated Git Commands

```
   ╭─────────────────────────────────╮
   │  PUSHING TO REMOTE              │
   ╰─────────────────────────────────╯
   
      LOCAL          ════════▶         REMOTE
     ┌─────┐                          ┌─────┐
     │     │  ───── ✨ ─────────────▶ │     │
     └─────┘                          └─────┘
```

Every git operation comes with visual feedback:
- Animated spinners during operations
- ASCII art headers
- Success/failure indicators
- Pretty formatted output

### Screensavers & Lock Screen

```
   ╭─────────────────────────────────╮
   │  🖥️ SCREENSAVER COLLECTION       │
   ╰─────────────────────────────────╯
   
   • Digital Clock - Large ASCII time display
   • Analog Clock - ASCII clock with multiple shapes
   • Matrix Rain - Falling Japanese characters
   • Pipes - Animated pipe maze
   • Stars - Flying starfield effect
   • Aquarium - Swimming fish animation
   • Fire - Burning flames effect
   • Lock Screen - Fullscreen with unlock sequence
```

### Cross-Platform Support

| Feature | macOS | Linux | Windows (WSL) |
|---------|-------|-------|---------------|
| Copy/Paste | ✅ | ✅ | ✅ |
| Open URLs | ✅ | ✅ | ✅ |
| Notifications | ✅ | ✅ | ✅ |
| System Lock | ✅ | ✅ | ✅ |
| Battery Info | ✅ | ✅ | - |

### Multilingual Support

Change the language of all messages:

```bash
lang set nl   # Dutch
lang set fr   # French
lang set de   # German
lang set es   # Spanish
```

Supported: 🇬🇧 English, 🇳🇱 Nederlands, 🇫🇷 Français, 🇩🇪 Deutsch, 🇪🇸 Español, 🇵🇹 Português, 🇮🇹 Italiano, 🇵🇱 Polski, 🇷🇺 Русский, 🇨🇳 中文, 🇯🇵 日本語, 🇰🇷 한국어

### Theme System

```
  ═══════════════════════════════════════════════════════
  
  Available Themes:
  
    ████████████████████████████  catppuccin
    ████████████████████████████  dracula
    ████████████████████████████  nord
    ████████████████████████████  tokyo-night
    ████████████████████████████  cyberpunk
    ████████████████████████████  matrix
    ████████████████████████████  neon
    
  ═══════════════════════════════════════════════════════
```

15+ built-in themes plus a custom theme builder.

### JARVIS-Style Startup

When you open a new terminal, Terminup greets you with:
- Animated logo reveal
- System status checks
- Git branch and project detection
- Time-based greetings

**Tip:** Press **Enter** during boot to speed up the animation!

### And More

- FZF-powered fuzzy finding
- DDEV integration
- Pomodoro timer
- Quick notes
- Spotify control
- Password generator
- Bookmark system

---

## Installation

### Prerequisites

- **Zsh** (5.1 or higher)
- **Git**

### Optional Dependencies

```bash
# macOS
brew install fzf bat

# Ubuntu/Debian
sudo apt install fzf bat xclip

# Arch Linux
sudo pacman -S fzf bat xclip
```

### Quick Install

```bash
git clone https://github.com/yourusername/terminup.git ~/Projects/Terminup
cd ~/Projects/Terminup
./install.sh
```

### Manual Install

Add to your `~/.zshrc`:

```zsh
source ~/Projects/Terminup/terminup.zsh
```

Reload:

```bash
source ~/.zshrc
```

---

## Commands

Use `tup` to see all commands, or `tup <category>` for specific categories.

### Quick Reference

| Command | Description |
|---------|-------------|
| `tup` | Show essential commands |
| `tup all` | Show all commands |
| `tup git` | Git commands |
| `tup nav` | Navigation commands |
| `tup npm` | NPM/PNPM commands |
| `tup screen` | Screensaver commands |
| `tup system` | System & language commands |
| `tups` | Reload shell |

### Git

| Command | Description |
|---------|-------------|
| `gc [message]` | Commit with ASCII art |
| `gp [remote]` | Push with animation |
| `gl [remote]` | Pull with animation |
| `ga [files]` | Stage files |
| `gb` | List branches |
| `gco <branch>` | Checkout branch |
| `gss` | Status overview |
| `glog` | Pretty log graph |
| `gst` / `gstp` | Stash / Stash pop |
| `gm <branch>` | Merge branch |

### Navigation

| Command | Description |
|---------|-------------|
| `cd <dir>` | Animated directory change |
| `ll` | Enhanced listing |
| `lt [depth]` | Tree view |
| `recent` | Recent directories |
| `fcd` | Fuzzy directory finder |
| `mkcd <dir>` | Create and enter |

### Package Managers

| Command | Description |
|---------|-------------|
| `ni` / `pi` | npm/pnpm install |
| `dni` / `dpi` | DDEV npm/pnpm install |
| `dev` | Start dev server |
| `build` | Production build |
| `scripts` | List npm scripts |
| `fscript` | Fuzzy script picker |
| `add <pkg>` | Add dependency |
| `remove <pkg>` | Remove dependency |

### Screensavers & Lock

| Command | Description |
|---------|-------------|
| `lock` | Fullscreen digital clock |
| `ss` | Digital clock screensaver |
| `aclock [shape]` | Analog ASCII clock |
| `alock [shape]` | Fullscreen analog clock |
| `matrix` | Matrix rain effect |
| `pipes` | Pipe maze screensaver |
| `stars` | Flying starfield effect |
| `aquarium` | Swimming fish animation |
| `fire` | Burning flames effect |
| `rain` | Rain animation |
| `bounce` | DVD-style bouncing logo |
| `syslock` | Lock the system |
| `autolock [secs]` | Auto-lock after idle |

**Shapes:** `circle`, `square`, `diamond`, `hexagon`, `octagon`, `decagon`

**Unlock:** Arrow keys ← ↑ → ↓

### System & Language

| Command | Description |
|---------|-------------|
| `lang list` | Show available languages |
| `lang set <code>` | Set language (en/nl/fr/de/es) |
| `lang current` | Show current language |
| `platform` | Show platform info |
| `stats` | System statistics |

### Extras

| Command | Description |
|---------|-------------|
| `pomo [mins]` | Pomodoro timer |
| `focus [mins]` | Focus mode |
| `note [text]` | Quick notes |
| `quote` | Programming quote |
| `decide a b c` | Decision maker |
| `genpass [len]` | Password generator |
| `cleanup [type]` | Quick cleanup |
| `spotify` | Spotify control (macOS) |
| `google <query>` | Web search |
| `github <query>` | GitHub search |
| `share <file>` | Upload & share file (get URL) |
| `qr <text>` | Generate QR code |
| `typetest` | Typing speed test |
| `stopwatch` | Simple stopwatch |
| `weather [city]` | Weather forecast |

### Themes

| Command | Description |
|---------|-------------|
| `theme list` | Show all themes |
| `theme set <name>` | Apply theme |
| `theme preview <name>` | Preview theme |
| `theme custom` | Build custom theme |
| `colors` | Show color palette |

---

## Themes

### Built-in Themes

```
Dark                    Light               Fun
─────────────────────────────────────────────────
catppuccin              github-light        neon
dracula                 solarized           cyberpunk
nord                                        matrix
tokyo-night                                 retro
gruvbox                                     pastel
synthwave                                   monochrome
ocean
sunset
```

### Custom Theme

```bash
theme custom
```

Interactively pick colors for each element.

### Configuration

```bash
# Disable startup animation
export TERMINUP_STARTUP_ENABLED=false

# Minimal startup
export TERMINUP_STARTUP_STYLE=minimal

# Or completely off
export TERMINUP_STARTUP_STYLE=off

# Set default language
export TERMINUP_LANG=nl
```

---

## Project Structure

```
terminup/
├── terminup.zsh           # Main entry point
├── install.sh             # Installation script
├── README.md
├── CONTRIBUTING.md
├── LICENSE
├── ascii-art/             # ASCII art assets
└── components/
    ├── animations.zsh     # Spinners, progress bars
    ├── colors.zsh         # Color definitions
    ├── completions.zsh    # Tab completion
    ├── cursor-effects.zsh # Cursor styling
    ├── ddev.zsh           # DDEV integration
    ├── extras.zsh         # Productivity tools
    ├── fzf-power.zsh      # FZF integrations
    ├── git-magic.zsh      # Git enhancements
    ├── i18n.zsh           # Internationalization
    ├── navigation.zsh     # cd/ls improvements
    ├── npm-pnpm.zsh       # Package manager tools
    ├── platform.zsh       # Cross-platform utilities
    ├── screensaver.zsh    # Screensavers & lock
    ├── startup.zsh        # Boot sequence
    └── themes.zsh         # Theme system
```

---

## Contributing

Contributions are welcome! Whether it's:

- Bug fixes
- New features
- Documentation improvements
- Theme additions
- **Translations** (see `components/i18n.zsh`)

### Development Setup

```bash
# Clone the repo
git clone https://github.com/yourusername/terminup.git
cd terminup

# Create a branch
git checkout -b feature/your-feature

# Make changes and test
source terminup.zsh

# Submit a PR
```

### Guidelines

1. **Keep it fast** - Terminal tools should be instant
2. **Keep it optional** - Features should degrade gracefully
3. **Keep it clean** - Follow existing code style
4. **Test thoroughly** - Test on clean zsh installs
5. **Cross-platform** - Use platform utilities (`_open`, `_copy`, etc.)
6. **Multilingual** - Use `_t()` for user-facing strings

### Adding a Translation

Edit `components/i18n.zsh`:

```zsh
typeset -gA _T_xx  # xx = language code
_T_xx=(
    welcome "Your translation"
    # ... add all keys from _T_en
)
```

### Adding a Theme

Edit `components/themes.zsh`:

```zsh
THEMES+=(
    your-theme   "primary,secondary,accent,success,warning,error,muted"
)
```

Colors are 256-color terminal codes (0-255).

### Adding a Command

1. Create or edit a component file
2. Add the function with `_t()` for messages
3. Update the help in `terminup.zsh`
4. Update this README

---

## FAQ

### Does it work without Powerlevel10k?

**Yes.** Terminup is completely independent. Powerlevel10k handles your prompt, Terminup adds commands and features. They complement each other but neither requires the other.

### Does it work on Linux/Windows?

**Yes.** Full support for:
- **macOS** - All features
- **Linux** - Ubuntu, Arch, Fedora, and others
- **Windows** - Via WSL (Windows Subsystem for Linux)

### How do I change the language?

```bash
lang set nl   # Dutch
lang set fr   # French
# ... etc
```

### How do I disable the startup animation?

Add to your `~/.zshrc` before sourcing terminup:

```zsh
export TERMINUP_STARTUP_STYLE=off
```

### Will it slow down my terminal?

No. All features load lazily. The startup animation only runs once per session and can be disabled.

### How do I update?

```bash
cd ~/Projects/Terminup
git pull
tups  # or: source ~/.zshrc
```

---

## Credits

Built with Zsh and caffeine.

Inspired by:
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Oh My Zsh](https://ohmyz.sh/)
- [fzf](https://github.com/junegunn/fzf)
- Iron Man's JARVIS

---

## License

MIT License - do whatever you want with it.

---

<div align="center">

```
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   "Any sufficiently advanced terminal configuration       ║
║    is indistinguishable from magic."                      ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
```

---

```
████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗██╗   ██╗██████╗ 
╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██║   ██║██╔══██╗
   ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║██║   ██║██████╔╝
   ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██║   ██║██╔═══╝ 
   ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║╚██████╔╝██║     
   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     
```

**[Back to top](#)**

</div>
