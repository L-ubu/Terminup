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
echo -e "  ${CYAN}To start using Terminup:${RESET}"
echo ""
echo -e "     ${YELLOW}source ~/.zshrc${RESET}    or    ${YELLOW}exec zsh${RESET}"
echo ""
echo -e "  ${CYAN}Available Commands:${RESET}"
echo ""
echo -e "     ${GREEN}Git:${RESET}"
echo -e "       gc        - Animated git commit"
echo -e "       gp        - Animated git push"
echo -e "       gl        - Animated git pull"
echo -e "       ga        - Animated git add"
echo -e "       gss       - Git status overview"
echo -e "       glog      - Pretty git log"
echo ""
echo -e "     ${GREEN}Navigation:${RESET}"
echo -e "       cd        - Animated directory change"
echo -e "       ll        - Enhanced directory listing"
echo -e "       recent    - Show recent directories"
echo -e "       fcd       - Fuzzy directory finder"
echo ""
echo -e "     ${GREEN}NPM/PNPM:${RESET}"
echo -e "       ni        - Animated npm install"
echo -e "       pi        - Animated pnpm install"
echo -e "       dev       - Start dev server with animation"
echo -e "       build     - Animated build"
echo -e "       scripts   - List available scripts"
echo ""
echo -e "     ${GREEN}FZF Power:${RESET}"
echo -e "       Ctrl+R    - Enhanced history search"
echo -e "       ff        - Fuzzy file finder"
echo -e "       fbr       - Git branch selector"
echo -e "       flog      - Git log browser"
echo -e "       fscript   - NPM script selector"
echo ""
echo -e "     ${GREEN}Extras:${RESET}"
echo -e "       bm        - Bookmark current directory"
echo -e "       jb        - Jump to bookmark"
echo -e "       welcome   - Show welcome message"
echo ""
echo -e "  ${PURPLE}Enjoy your enhanced terminal! 🚀${RESET}"
echo ""
