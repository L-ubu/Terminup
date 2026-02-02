#!/bin/bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                                                                            ║
# ║   ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗██╗   ██╗██████╗        ║
# ║   ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██║   ██║██╔══██╗       ║
# ║      ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║██║   ██║██████╔╝       ║
# ║      ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██║   ██║██╔═══╝        ║
# ║      ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║╚██████╔╝██║            ║
# ║      ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝            ║
# ║                                                                            ║
# ║                        🚀 Installation Script 🚀                           ║
# ║                                                                            ║
# ╚════════════════════════════════════════════════════════════════════════════╝

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║${RESET}           ${PURPLE}✨ Terminup Installation ✨${RESET}                    ${CYAN}║${RESET}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Function to print status
print_status() {
    echo -e "  ${GREEN}✓${RESET} $1"
}

print_warning() {
    echo -e "  ${YELLOW}⚠${RESET} $1"
}

print_error() {
    echo -e "  ${RED}✗${RESET} $1"
}

print_info() {
    echo -e "  ${BLUE}ℹ${RESET} $1"
}

# Check for zsh
if [[ ! -n "$ZSH_VERSION" ]] && [[ "$SHELL" != *"zsh"* ]]; then
    print_warning "This script is designed for zsh. Current shell: $SHELL"
fi

# Check for fzf
echo ""
echo -e "  ${CYAN}Checking dependencies...${RESET}"
echo ""

if command -v fzf &>/dev/null; then
    print_status "fzf is installed"
else
    print_warning "fzf not found - Ctrl+R enhanced search won't work"
    echo ""
    echo -e "     To install fzf:"
    echo -e "     ${YELLOW}brew install fzf${RESET}"
    echo ""
    read -p "     Install fzf now? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if command -v brew &>/dev/null; then
            brew install fzf
            print_status "fzf installed"
        else
            print_error "Homebrew not found, please install fzf manually"
        fi
    fi
fi

# Check for bat (optional, for previews)
if command -v bat &>/dev/null; then
    print_status "bat is installed (enhanced previews enabled)"
else
    print_info "bat not found - file previews will use cat instead"
    echo -e "     Optional: ${YELLOW}brew install bat${RESET}"
fi

# ─────────────────────────────────────────────────────────────────
# Mode Selection (all modes use lazy loading for fast startup)
# ─────────────────────────────────────────────────────────────────
echo ""
echo -e "  ${CYAN}Choose your Terminup mode:${RESET}"
echo -e "  ${PURPLE}(All modes use lazy loading - features load on first use)${RESET}"
echo ""
echo -e "  ${GREEN}[1] minimal${RESET} - ${YELLOW}Essential dev tools only${RESET}"
echo -e "      ├─ git      : gc, gp, gl, gss, glog..."
echo -e "      ├─ nav      : ll, lt, fcd, mkcd, bookmarks..."
echo -e "      ├─ npm      : ni, pi, dev, build, scripts..."
echo -e "      └─ ddev     : dstart, dstop, dssh..."
echo ""
echo -e "  ${GREEN}[2] fun${RESET} - ${YELLOW}Dev tools + visual extras${RESET}"
echo -e "      ├─ All minimal features, plus:"
echo -e "      ├─ animations, themes, extras (pomo, todo, notes...)"
echo -e "      └─ screensaver (lock, matrix, pipes...), startup"
echo ""
echo -e "  ${GREEN}[3] full${RESET} - ${YELLOW}Everything available${RESET}"
echo -e "      ├─ All fun features, plus:"
echo -e "      └─ fzf power, cursor effects, completions"
echo ""
echo -e "  ${GREEN}[4] custom${RESET} - ${YELLOW}Pick your own components${RESET}"
echo -e "      └─ Choose exactly which features you want"
echo ""

# Default mode
TERMINUP_MODE="full"
TERMINUP_CUSTOM_COMPONENTS=""

read -p "     Select mode [1/2/3/4] (default: 3): " mode_choice
case "$mode_choice" in
    1)
        TERMINUP_MODE="minimal"
        print_status "Selected: minimal mode (git, nav, npm, ddev)"
        ;;
    2)
        TERMINUP_MODE="fun"
        print_status "Selected: fun mode (+ animations, themes, extras, screensaver)"
        ;;
    3|"")
        TERMINUP_MODE="full"
        print_status "Selected: full mode (everything)"
        ;;
    4)
        TERMINUP_MODE="custom"
        echo ""
        echo -e "  ${CYAN}Available components:${RESET}"
        echo ""
        echo -e "    ${GREEN}Core:${RESET}"
        echo -e "      git         - Git commands (gc, gp, gl, gss, glog...)"
        echo -e "      nav         - Navigation (ll, lt, fcd, mkcd, bookmarks...)"
        echo -e "      npm         - NPM/PNPM (ni, pi, dev, build, scripts...)"
        echo -e "      ddev        - DDEV integration (dstart, dssh, dinfo...)"
        echo ""
        echo -e "    ${YELLOW}Enhanced:${RESET}"
        echo -e "      fzf         - FZF power (ff, fbr, flog, fkill...)"
        echo -e "      animations  - Text animations and spinners"
        echo -e "      themes      - Color themes and palettes"
        echo -e "      extras      - Productivity (pomo, todo, notes, weather...)"
        echo ""
        echo -e "    ${PURPLE}Fun:${RESET}"
        echo -e "      screensaver - Lock screen, matrix, pipes, rain..."
        echo -e "      startup     - Welcome message, ritual, standup..."
        echo -e "      cursor      - Cursor effects"
        echo -e "      completions - Tab completions"
        echo ""
        echo -e "  ${CYAN}Enter components separated by spaces:${RESET}"
        read -p "     > " TERMINUP_CUSTOM_COMPONENTS
        
        if [[ -z "$TERMINUP_CUSTOM_COMPONENTS" ]]; then
            TERMINUP_CUSTOM_COMPONENTS="git nav npm ddev"
            print_warning "No components entered, using defaults: git nav npm ddev"
        else
            print_status "Selected components: $TERMINUP_CUSTOM_COMPONENTS"
        fi
        ;;
    *)
        print_warning "Invalid choice, using full mode"
        TERMINUP_MODE="full"
        ;;
esac

# Save mode to config file
TERMINUP_CONFIG_DIR="$HOME/.config/terminup"
mkdir -p "$TERMINUP_CONFIG_DIR"
echo "TERMINUP_MODE=\"$TERMINUP_MODE\"" > "$TERMINUP_CONFIG_DIR/mode"

if [[ "$TERMINUP_MODE" == "custom" ]]; then
    echo "TERMINUP_CUSTOM_COMPONENTS=\"$TERMINUP_CUSTOM_COMPONENTS\"" > "$TERMINUP_CONFIG_DIR/components"
fi

print_status "Configuration saved to ~/.config/terminup/"

# Backup existing .zshrc
echo ""
echo -e "  ${CYAN}Setting up configuration...${RESET}"
echo ""

ZSHRC="$HOME/.zshrc"
BACKUP_FILE="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"

if [[ -f "$ZSHRC" ]]; then
    cp "$ZSHRC" "$BACKUP_FILE"
    print_status "Backed up .zshrc to $BACKUP_FILE"
fi

# Check if terminup is already sourced
TERMINUP_SOURCE="source \"$SCRIPT_DIR/terminup.zsh\""

if grep -q "terminup.zsh" "$ZSHRC" 2>/dev/null; then
    print_warning "Terminup already appears to be configured in .zshrc"
    read -p "     Overwrite existing configuration? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Remove existing terminup lines
        sed -i '' '/# Terminup/d' "$ZSHRC" 2>/dev/null || true
        sed -i '' '/terminup.zsh/d' "$ZSHRC" 2>/dev/null || true
    else
        print_info "Skipping .zshrc modification"
    fi
fi

# Add terminup to .zshrc
if ! grep -q "terminup.zsh" "$ZSHRC" 2>/dev/null; then
    echo "" >> "$ZSHRC"
    echo "# Terminup - Terminal Enhancements" >> "$ZSHRC"
    echo "$TERMINUP_SOURCE" >> "$ZSHRC"
    print_status "Added Terminup to .zshrc"
fi

# Create symbolic link for easy access
if [[ ! -L "$HOME/.terminup" ]]; then
    ln -sf "$SCRIPT_DIR" "$HOME/.terminup"
    print_status "Created ~/.terminup symlink"
fi

# Make scripts executable
chmod +x "$SCRIPT_DIR"/*.zsh 2>/dev/null || true
chmod +x "$SCRIPT_DIR"/components/*.zsh 2>/dev/null || true

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}║${RESET}              ${GREEN}✅ Installation Complete!${RESET}                    ${GREEN}║${RESET}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "  ${CYAN}Mode:${RESET} ${YELLOW}$TERMINUP_MODE${RESET}"
if [[ "$TERMINUP_MODE" == "custom" ]]; then
    echo -e "  ${CYAN}Components:${RESET} ${YELLOW}$TERMINUP_CUSTOM_COMPONENTS${RESET}"
fi
echo ""
echo -e "  ${PURPLE}⚡ All features lazy-load on first use for fast startup!${RESET}"
echo ""
echo -e "  ${CYAN}To start using Terminup:${RESET}"
echo ""
echo -e "     ${YELLOW}source ~/.zshrc${RESET}    or    ${YELLOW}exec zsh${RESET}"
echo ""
echo -e "  ${CYAN}Mode Management:${RESET}"
echo -e "     ${GREEN}terminup_mode status${RESET}      - Show current config"
echo -e "     ${GREEN}terminup_mode list${RESET}        - Show available modes"
echo -e "     ${GREEN}terminup_mode components${RESET}  - Show available components"
echo -e "     ${GREEN}terminup_mode set <mode>${RESET}  - Change mode"
echo -e "     ${GREEN}terminup_mode custom ...${RESET}  - Set custom components"
echo ""
echo -e "  ${CYAN}Quick Reference:${RESET}"
echo ""
echo -e "     ${GREEN}Git:${RESET}        gc, gp, gl, ga, gss, glog, gb, gst"
echo -e "     ${GREEN}Navigation:${RESET} ll, lt, fcd, mkcd, recent, bm, jb"
echo -e "     ${GREEN}NPM/PNPM:${RESET}   ni, pi, dev, build, scripts, fscript"
echo -e "     ${GREEN}DDEV:${RESET}       dstart, dstop, dssh, dinfo, dni, dpi"
echo -e "     ${GREEN}Help:${RESET}       tup (shows all commands by category)"
echo ""
echo -e "  ${PURPLE}Enjoy your enhanced terminal! 🚀${RESET}"
echo ""
