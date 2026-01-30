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
brew install fzf    # Enhanced search (Ctrl+R)
brew install bat    # Better file previews
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

### Themes

| Command | Description |
|---------|-------------|
| `theme list` | Show all themes |
| `theme set <name>` | Apply theme |
| `theme preview <name>` | Preview theme |
| `theme custom` | Build custom theme |
| `colors` | Show color palette |

### Extras

| Command | Description |
|---------|-------------|
| `pomo [mins]` | Pomodoro timer |
| `note [text]` | Quick notes |
| `quote` | Programming quote |
| `decide a b c` | Decision maker |
| `stats` | System stats |
| `genpass [len]` | Password generator |
| `cleanup [type]` | Quick cleanup |
| `spotify` | Spotify control |

### Startup

| Command | Description |
|---------|-------------|
| `boot` | Full startup animation |
| `bootmin` | Minimal startup |

Use `terminup` or `tup` to see all commands.

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
└── components/
    ├── animations.zsh     # Spinners, progress bars
    ├── colors.zsh         # Color definitions
    ├── completions.zsh    # Tab completion
    ├── cursor-effects.zsh # Cursor styling
    ├── ddev.zsh           # DDEV integration
    ├── extras.zsh         # Productivity tools
    ├── fzf-power.zsh      # FZF integrations
    ├── git-magic.zsh      # Git enhancements
    ├── navigation.zsh     # cd/ls improvements
    ├── npm-pnpm.zsh       # Package manager tools
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
- Translations

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
2. Add the function
3. Update the help in `terminup.zsh`
4. Update this README

---

## FAQ

### Does it work without Powerlevel10k?

**Yes.** Terminup is completely independent. Powerlevel10k handles your prompt, Terminup adds commands and features. They complement each other but neither requires the other.

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
source ~/.zshrc
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
