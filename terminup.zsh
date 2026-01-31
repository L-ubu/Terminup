#!/usr/bin/env zsh
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                                                                            ║
# ║   ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗██╗   ██╗██████╗        ║
# ║   ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██║   ██║██╔══██╗       ║
# ║      ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║██║   ██║██████╔╝       ║
# ║      ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██║   ██║██╔═══╝        ║
# ║      ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║╚██████╔╝██║            ║
# ║      ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝            ║
# ║                                                                            ║
# ║              🚀 Terminal Enhancements for Power Users 🚀                   ║
# ║                                                                            ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# Source component files
TERMINUP_DIR="${0:A:h}"

# Load all components
[[ -f "$TERMINUP_DIR/components/colors.zsh" ]] && source "$TERMINUP_DIR/components/colors.zsh"
[[ -f "$TERMINUP_DIR/components/animations.zsh" ]] && source "$TERMINUP_DIR/components/animations.zsh"
[[ -f "$TERMINUP_DIR/components/git-magic.zsh" ]] && source "$TERMINUP_DIR/components/git-magic.zsh"
[[ -f "$TERMINUP_DIR/components/navigation.zsh" ]] && source "$TERMINUP_DIR/components/navigation.zsh"
[[ -f "$TERMINUP_DIR/components/npm-pnpm.zsh" ]] && source "$TERMINUP_DIR/components/npm-pnpm.zsh"
[[ -f "$TERMINUP_DIR/components/ddev.zsh" ]] && source "$TERMINUP_DIR/components/ddev.zsh"
[[ -f "$TERMINUP_DIR/components/fzf-power.zsh" ]] && source "$TERMINUP_DIR/components/fzf-power.zsh"
[[ -f "$TERMINUP_DIR/components/cursor-effects.zsh" ]] && source "$TERMINUP_DIR/components/cursor-effects.zsh"
[[ -f "$TERMINUP_DIR/components/completions.zsh" ]] && source "$TERMINUP_DIR/components/completions.zsh"
[[ -f "$TERMINUP_DIR/components/themes.zsh" ]] && source "$TERMINUP_DIR/components/themes.zsh"
[[ -f "$TERMINUP_DIR/components/extras.zsh" ]] && source "$TERMINUP_DIR/components/extras.zsh"
[[ -f "$TERMINUP_DIR/components/screensaver.zsh" ]] && source "$TERMINUP_DIR/components/screensaver.zsh"
[[ -f "$TERMINUP_DIR/components/startup.zsh" ]] && source "$TERMINUP_DIR/components/startup.zsh"

# Print welcome message on first load
if [[ -z "$TERMINUP_LOADED" ]]; then
    export TERMINUP_LOADED=1
fi

# ─────────────────────────────────────────────────────────────────
# Help Command
# ─────────────────────────────────────────────────────────────────

terminup() {
    local cmd="${1:-help}"
    
    case "$cmd" in
        help|--help|-h)
            echo ""
            echo -e "  \033[38;5;51m╔════════════════════════════════════════════════════════════╗\033[0m"
            echo -e "  \033[38;5;51m║\033[0m        \033[1;38;5;213m✨ TERMINUP - Terminal Enhancements ✨\033[0m             \033[38;5;51m║\033[0m"
            echo -e "  \033[38;5;51m╚════════════════════════════════════════════════════════════╝\033[0m"
            echo ""
            echo -e "  \033[1;38;5;226m🔮 GIT COMMANDS\033[0m"
            echo -e "  \033[38;5;245m─────────────────────────────────────────────────────────────\033[0m"
            echo -e "    \033[38;5;46mgc\033[0m [msg]        Animated git commit with ASCII art"
            echo -e "    \033[38;5;46mgp\033[0m [remote]     Animated git push with rocket effect"
            echo -e "    \033[38;5;46mgl\033[0m [remote]     Animated git pull"
            echo -e "    \033[38;5;46mga\033[0m [files]      Animated git add"
            echo -e "    \033[38;5;46mgb\033[0m              Pretty branch list"
            echo -e "    \033[38;5;46mgco\033[0m <branch>    Animated branch checkout"
            echo -e "    \033[38;5;46mgst\033[0m             Animated stash"
            echo -e "    \033[38;5;46mgstp\033[0m            Animated stash pop"
            echo -e "    \033[38;5;46mgm\033[0m <branch>     Animated merge"
            echo -e "    \033[38;5;46mgss\033[0m             Git status overview panel"
            echo -e "    \033[38;5;46mglog\033[0m            Pretty git log graph"
            echo -e "    \033[38;5;46mgs\033[0m              Short status"
            echo -e "    \033[38;5;46mgd\033[0m              Word-level diff"
            echo ""
            echo -e "  \033[1;38;5;226m📂 NAVIGATION\033[0m"
            echo -e "  \033[38;5;245m─────────────────────────────────────────────────────────────\033[0m"
            echo -e "    \033[38;5;39mcd\033[0m <dir>        Animated directory change"
            echo -e "    \033[38;5;39mll\033[0m [dir]        Enhanced listing with icons"
            echo -e "    \033[38;5;39ml\033[0m [dir]         Quick compact listing"
            echo -e "    \033[38;5;39mlt\033[0m [dir] [n]    Tree view (depth n)"
            echo -e "    \033[38;5;39mrecent\033[0m          Show recent directories"
            echo -e "    \033[38;5;39mfcd\033[0m             Fuzzy directory finder"
            echo -e "    \033[38;5;39mmkcd\033[0m <dir>      Create and enter directory"
            echo -e "    \033[38;5;39m..\033[0m \033[38;5;39m...\033[0m \033[38;5;39m....\033[0m      Quick parent navigation"
            echo ""
            echo -e "  \033[1;38;5;226m📦 NPM / PNPM\033[0m"
            echo -e "  \033[38;5;245m─────────────────────────────────────────────────────────────\033[0m"
            echo -e "    \033[38;5;208mni\033[0m [pkgs]       Animated npm install"
            echo -e "    \033[38;5;208mpi\033[0m [pkgs]       Animated pnpm install"
            echo -e "    \033[38;5;208mdev\033[0m             Start dev server with animation"
            echo -e "    \033[38;5;208mbuild\033[0m           Animated production build"
            echo -e "    \033[38;5;208mtest\033[0m            Run tests"
            echo -e "    \033[38;5;208mscripts\033[0m         List available npm scripts"
            echo -e "    \033[38;5;208mfscript\033[0m         Fuzzy pick and run script"
            echo -e "    \033[38;5;208madd\033[0m <pkg>       Add dependency"
            echo -e "    \033[38;5;208madd-dev\033[0m <pkg>   Add dev dependency"
            echo -e "    \033[38;5;208mremove\033[0m <pkg>    Remove dependency"
            echo -e "    \033[38;5;208moutdated\033[0m        Check outdated packages"
            echo ""
            echo -e "  \033[1;38;5;226m🔍 FZF POWER\033[0m"
            echo -e "  \033[38;5;245m─────────────────────────────────────────────────────────────\033[0m"
            echo -e "    \033[38;5;177mCtrl+R\033[0m          Enhanced history search with preview"
            echo -e "    \033[38;5;177mff\033[0m              Fuzzy file finder"
            echo -e "    \033[38;5;177mfbr\033[0m             Git branch selector"
            echo -e "    \033[38;5;177mflog\033[0m            Git log browser"
            echo -e "    \033[38;5;177mfkill\033[0m           Process killer"
            echo -e "    \033[38;5;177mfdocker\033[0m         Docker container selector"
            echo ""
            echo -e "  \033[1;38;5;226m🔖 BOOKMARKS\033[0m"
            echo -e "  \033[38;5;245m─────────────────────────────────────────────────────────────\033[0m"
            echo -e "    \033[38;5;214mbm\033[0m              Bookmark current directory"
            echo -e "    \033[38;5;214mjb\033[0m              Jump to bookmark"
            echo -e "    \033[38;5;214mrbm\033[0m             Remove bookmark"
            echo ""
            echo -e "  \033[1;38;5;226m🐳 DDEV\033[0m"
            echo -e "  \033[38;5;245m─────────────────────────────────────────────────────────────\033[0m"
            echo -e "    \033[38;5;39mdni\033[0m [pkgs]      DDEV npm install (auto-detects)"
            echo -e "    \033[38;5;39mdpi\033[0m [pkgs]      DDEV pnpm install (auto-detects)"
            echo -e "    \033[38;5;39mddev-dev\033[0m        DDEV dev server"
            echo -e "    \033[38;5;39mddev-build\033[0m      DDEV build"
            echo -e "    \033[38;5;39mdstart\033[0m          Start DDEV with animation"
            echo -e "    \033[38;5;39mdstop\033[0m           Stop DDEV"
            echo -e "    \033[38;5;39mdssh\033[0m            SSH into DDEV container"
            echo -e "    \033[38;5;39mdinfo\033[0m           DDEV project info"
            echo -e "    \033[38;5;39mfddev\033[0m           Fuzzy DDEV project selector"
            echo ""
            echo -e "  \033[1;38;5;226m🎨 THEMES\033[0m"
            echo -e "  \033[38;5;245m─────────────────────────────────────────────────────────────\033[0m"
            echo -e "    \033[38;5;213mtheme list\033[0m      Show all themes with preview"
            echo -e "    \033[38;5;213mtheme set\033[0m <n>   Apply a theme"
            echo -e "    \033[38;5;213mtheme preview\033[0m   Preview a theme"
            echo -e "    \033[38;5;213mtheme custom\033[0m    Build your own theme"
            echo -e "    \033[38;5;213mtheme fzf\033[0m       Pick theme with fuzzy finder"
            echo -e "    \033[38;5;213mcolors\033[0m          Show 256 color palette"
            echo ""
            echo -e "  \033[1;38;5;226m✨ EXTRAS\033[0m"
            echo -e "  \033[38;5;245m─────────────────────────────────────────────────────────────\033[0m"
            echo -e "    \033[38;5;141mpomo\033[0m [mins]     Pomodoro timer (default 25m)"
            echo -e "    \033[38;5;141mfocus\033[0m [mins]    Focus mode with timer"
            echo -e "    \033[38;5;141mnote\033[0m [text]     Quick notes (note list, note add)"
            echo -e "    \033[38;5;141mquote\033[0m           Random programming quote"
            echo -e "    \033[38;5;141mdecide\033[0m a b c    Random decision maker"
            echo -e "    \033[38;5;141mcountdown\033[0m [s]   Countdown timer"
            echo -e "    \033[38;5;141mstats\033[0m           Quick system stats"
            echo -e "    \033[38;5;141mgenpass\033[0m [len]   Generate password"
            echo -e "    \033[38;5;141mcleanup\033[0m [type]  Quick cleanup (cache/node/ds/git)"
            echo -e "    \033[38;5;141mspotify\033[0m [cmd]   Spotify control (play/pause/next)"
            echo -e "    \033[38;5;141mgoogle\033[0m <query>  Web search"
            echo -e "    \033[38;5;141mstackoverflow\033[0m   Search Stack Overflow"
            echo -e "    \033[38;5;141mgithub\033[0m <query>  Search GitHub"
            echo -e "    \033[38;5;141mwelcome\033[0m         Animated welcome message"
            echo ""
            echo -e "  \033[1;38;5;226m🖥️ SCREENSAVER & LOCK\033[0m"
            echo -e "  \033[38;5;245m─────────────────────────────────────────────────────────────\033[0m"
            echo -e "    \033[38;5;87mlock\033[0m            Fullscreen digital clock lock"
            echo -e "    \033[38;5;87mss\033[0m              Digital clock screensaver"
            echo -e "    \033[38;5;87maclock\033[0m [shape]  Analog clock (circle/square/diamond)"
            echo -e "    \033[38;5;87malock\033[0m [shape]   Fullscreen analog clock lock"
            echo -e "    \033[38;5;87mmatrix\033[0m          Matrix rain animation"
            echo -e "    \033[38;5;87mpipes\033[0m           Pipes screensaver"
            echo -e "    \033[38;5;87msyslock\033[0m         Lock actual Mac (system lock)"
            echo -e "    \033[38;5;87mlockall\033[0m         Screensaver + system lock"
            echo -e "    \033[38;5;87mautolock\033[0m [sec]  Auto-lock after idle"
            echo -e "    \033[38;5;87mnoautolock\033[0m      Disable auto-lock"
            echo -e "                   \033[38;5;240mUnlock: ← ↑ → ↓\033[0m"
            echo ""
            echo -e "  \033[38;5;245m─────────────────────────────────────────────────────────────\033[0m"
            echo -e "  \033[38;5;240mType \033[38;5;51mterminup\033[38;5;240m or \033[38;5;51mtup\033[38;5;240m to see this menu\033[0m"
            echo -e "  \033[38;5;240mConfig: ~/.terminup or ~/Projects/Terminup\033[0m"
            echo ""
            ;;
        version|--version|-v)
            echo -e "  \033[38;5;51mTerminup\033[0m v1.0.0"
            ;;
        reload)
            source "$TERMINUP_DIR/terminup.zsh"
            echo -e "  \033[38;5;46m✓\033[0m Terminup reloaded!"
            ;;
        *)
            echo -e "  \033[38;5;196m✗\033[0m Unknown command: $cmd"
            echo -e "  \033[38;5;245mTry: terminup help\033[0m"
            ;;
    esac
}

# Alias for quick access
alias tup='terminup'
