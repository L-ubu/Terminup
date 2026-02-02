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
[[ -f "$TERMINUP_DIR/components/platform.zsh" ]] && source "$TERMINUP_DIR/components/platform.zsh"
[[ -f "$TERMINUP_DIR/components/i18n.zsh" ]] && source "$TERMINUP_DIR/components/i18n.zsh"
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

_tup_header() {
    echo ""
    echo -e "  \033[38;5;51m╔═══════════════════════════════════════════╗\033[0m"
    echo -e "  \033[38;5;51m║\033[0m    \033[1;38;5;213m✨ TERMINUP\033[0m - Terminal Enhancements    \033[38;5;51m║\033[0m"
    echo -e "  \033[38;5;51m╚═══════════════════════════════════════════╝\033[0m"
    echo ""
}

_tup_git() {
    echo -e "  \033[1;38;5;226m🔮 GIT COMMANDS\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;46mgc\033[0m [msg]      Animated git commit"
    echo -e "    \033[38;5;46mgp\033[0m           Git push with rocket effect"
    echo -e "    \033[38;5;46mgl\033[0m           Git pull"
    echo -e "    \033[38;5;46mga\033[0m [files]   Git add"
    echo -e "    \033[38;5;46mgco\033[0m <branch> Branch checkout"
    echo -e "    \033[38;5;46mgss\033[0m          Status overview panel"
    echo -e "    \033[38;5;46mglog\033[0m         Pretty git log graph"
    echo -e "    \033[38;5;46mgs\033[0m           Short status"
    echo -e "    \033[38;5;46mgd\033[0m           Word-level diff"
    echo -e "    \033[38;5;46mgb\033[0m           Branch list"
    echo -e "    \033[38;5;46mgst\033[0m/\033[38;5;46mgstp\033[0m     Stash / stash pop"
    echo -e "    \033[38;5;46mgm\033[0m <branch>  Merge"
    echo ""
}

_tup_nav() {
    echo -e "  \033[1;38;5;226m📂 NAVIGATION\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;39mll\033[0m / \033[38;5;39ml\033[0m       Enhanced listing"
    echo -e "    \033[38;5;39mlt\033[0m [n]       Tree view (depth n)"
    echo -e "    \033[38;5;39mfcd\033[0m          Fuzzy directory finder"
    echo -e "    \033[38;5;39mmkcd\033[0m <dir>   Create and enter directory"
    echo -e "    \033[38;5;39mrecent\033[0m       Recent directories"
    echo -e "    \033[38;5;39m..\033[0m \033[38;5;39m...\033[0m \033[38;5;39m....\033[0m  Quick parent navigation"
    echo -e "    \033[38;5;214mbm\033[0m / \033[38;5;214mjb\033[0m     Bookmark / Jump to bookmark"
    echo ""
}

_tup_npm() {
    echo -e "  \033[1;38;5;226m📦 NPM / PNPM\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;208mni\033[0m / \033[38;5;208mpi\033[0m     npm/pnpm install"
    echo -e "    \033[38;5;208mdev\033[0m          Start dev server"
    echo -e "    \033[38;5;208mbuild\033[0m        Production build"
    echo -e "    \033[38;5;208mtest\033[0m         Run tests"
    echo -e "    \033[38;5;208mscripts\033[0m      List npm scripts"
    echo -e "    \033[38;5;208mfscript\033[0m      Fuzzy pick script"
    echo -e "    \033[38;5;208madd\033[0m/\033[38;5;208madd-dev\033[0m  Add dependency"
    echo -e "    \033[38;5;208mremove\033[0m       Remove dependency"
    echo -e "    \033[38;5;208moutdated\033[0m     Check outdated packages"
    echo ""
}

_tup_fzf() {
    echo -e "  \033[1;38;5;226m🔍 FZF POWER\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;177mCtrl+R\033[0m       Enhanced history search"
    echo -e "    \033[38;5;177mff\033[0m           Fuzzy file finder"
    echo -e "    \033[38;5;177mfbr\033[0m          Git branch selector"
    echo -e "    \033[38;5;177mflog\033[0m         Git log browser"
    echo -e "    \033[38;5;177mfkill\033[0m        Process killer"
    echo -e "    \033[38;5;177mfdocker\033[0m      Docker container selector"
    echo ""
}

_tup_ddev() {
    echo -e "  \033[1;38;5;226m🐳 DDEV\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;39mdstart\033[0m/\033[38;5;39mdstop\033[0m Start/Stop DDEV"
    echo -e "    \033[38;5;39mdssh\033[0m         SSH into container"
    echo -e "    \033[38;5;39mdinfo\033[0m        Project info"
    echo -e "    \033[38;5;39mdni\033[0m/\033[38;5;39mdpi\033[0m      DDEV npm/pnpm install"
    echo -e "    \033[38;5;39mddev-dev\033[0m     DDEV dev server"
    echo -e "    \033[38;5;39mfddev\033[0m        Fuzzy DDEV project selector"
    echo ""
}

_tup_theme() {
    echo -e "  \033[1;38;5;226m🎨 THEMES\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;213mtheme list\033[0m   Show all themes"
    echo -e "    \033[38;5;213mtheme set\033[0m <n> Apply a theme"
    echo -e "    \033[38;5;213mtheme fzf\033[0m    Pick with fuzzy finder"
    echo -e "    \033[38;5;213mcolors\033[0m       Show 256 color palette"
    echo ""
}

_tup_extras() {
    echo -e "  \033[1;38;5;226m✨ EXTRAS & PRODUCTIVITY\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;141mpomo\033[0m [mins]  Pomodoro timer"
    echo -e "    \033[38;5;141mfocus\033[0m [mins] Focus mode"
    echo -e "    \033[38;5;141mtodo\033[0m         Todo list (add/done/rm)"
    echo -e "    \033[38;5;141mnote\033[0m [text]  Quick notes"
    echo -e "    \033[38;5;141mremind\033[0m m msg Set reminder"
    echo -e "    \033[38;5;141mstopwatch\033[0m    Stopwatch"
    echo -e "    \033[38;5;141mstats\033[0m        System stats"
    echo -e "    \033[38;5;141mgenpass\033[0m [n]  Generate password"
    echo -e "    \033[38;5;141mweather\033[0m      Weather forecast"
    echo -e "    \033[38;5;141mquote\033[0m        Random quote"
    echo -e "    \033[38;5;141mspotify\033[0m      Spotify control"
    echo ""
}

_tup_tools() {
    echo -e "  \033[1;38;5;226m🛠️ TOOLS\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;208mcontext\033[0m      Project context info"
    echo -e "    \033[38;5;208mwhatshere\033[0m    Analyze directory"
    echo -e "    \033[38;5;208mblame\033[0m <file> Pretty git blame"
    echo -e "    \033[38;5;208mprojectstats\033[0m Code statistics"
    echo -e "    \033[38;5;208mports\033[0m        Ports in use"
    echo -e "    \033[38;5;208mlogs\033[0m [file]  Log viewer"
    echo -e "    \033[38;5;208mgundo\033[0m        Git undo menu"
    echo -e "    \033[38;5;208mjpp\033[0m          JSON pretty print"
    echo -e "    \033[38;5;208mshare\033[0m <file> Upload & share file"
    echo -e "    \033[38;5;208mqr\033[0m <text>    Generate QR code"
    echo -e "    \033[38;5;208mcleanup\033[0m      Quick cleanup"
    echo ""
}

_tup_workflow() {
    echo -e "  \033[1;38;5;226m📋 WORKFLOW\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;226mritual\033[0m       Morning routine"
    echo -e "    \033[38;5;226meod\033[0m          End of day summary"
    echo -e "    \033[38;5;226mstandup\033[0m      Generate standup report"
    echo -e "    \033[38;5;226mtypetest\033[0m     Typing speed test"
    echo -e "    \033[38;5;226mgoogle\033[0m       Google search"
    echo -e "    \033[38;5;226mgithub\033[0m       GitHub search"
    echo ""
}

_tup_fun() {
    echo -e "  \033[1;38;5;226m🎮 FUN\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;39mrain\033[0m         Peaceful rain"
    echo -e "    \033[38;5;39mfire\033[0m         Animated fire"
    echo -e "    \033[38;5;39maquarium\033[0m     ASCII fish tank"
    echo -e "    \033[38;5;39mstars\033[0m        Starfield"
    echo -e "    \033[38;5;39mbounce\033[0m       DVD bounce"
    echo -e "    \033[38;5;39mdecide\033[0m a b c Random decision"
    echo ""
}

_tup_screen() {
    echo -e "  \033[1;38;5;226m🖥️ SCREENSAVER & LOCK\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;87mlock\033[0m         Fullscreen digital clock"
    echo -e "    \033[38;5;87mss\033[0m           Digital clock screensaver"
    echo -e "    \033[38;5;87maclock\033[0m [s]   Analog clock (shapes below)"
    echo -e "    \033[38;5;87malock\033[0m [s]    Fullscreen analog clock"
    echo -e "    \033[38;5;87mmatrix\033[0m       Matrix rain"
    echo -e "    \033[38;5;87mpipes\033[0m        Pipes screensaver"
    echo -e "    \033[38;5;87msyslock\033[0m      Lock system"
    echo -e "    \033[38;5;87mautolock\033[0m [s] Auto-lock after idle"
    echo -e "    \033[38;5;240m  Shapes: circle square diamond hexagon octagon decagon\033[0m"
    echo -e "    \033[38;5;240m  Unlock: ← ↑ → ↓\033[0m"
    echo ""
}

_tup_system() {
    echo -e "  \033[1;38;5;226m🌍 SYSTEM & LANGUAGE\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;39mlang list\033[0m    Show available languages"
    echo -e "    \033[38;5;39mlang set\033[0m <c> Set language (en/nl/fr/de/es...)"
    echo -e "    \033[38;5;39mplatform\033[0m     Show platform info"
    echo -e "    \033[38;5;39mstats\033[0m        System stats"
    echo -e "    \033[38;5;240m  Supported: macOS, Linux (Ubuntu/Arch/Fedora), WSL\033[0m"
    echo ""
}

terminup() {
    local cmd="${1:-help}"
    
    case "$cmd" in
        help|--help|-h)
            _tup_header
            echo -e "  \033[1;38;5;255m⚡ ESSENTIALS\033[0m"
            echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
            echo -e "    \033[38;5;46mgc\033[0m/\033[38;5;46mgp\033[0m/\033[38;5;46mgl\033[0m    Git commit/push/pull"
            echo -e "    \033[38;5;46mgss\033[0m         Git status panel"
            echo -e "    \033[38;5;39mll\033[0m/\033[38;5;39mlt\033[0m       List/Tree view"
            echo -e "    \033[38;5;39mfcd\033[0m         Fuzzy cd"
            echo -e "    \033[38;5;208mdev\033[0m/\033[38;5;208mbuild\033[0m   Dev server/Build"
            echo -e "    \033[38;5;177mff\033[0m          Fuzzy file finder"
            echo -e "    \033[38;5;87mlock\033[0m        Lock screen"
            echo -e "    \033[38;5;141mstats\033[0m       System stats"
            echo ""
            echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
            echo -e "  \033[1;38;5;51mCATEGORIES:\033[0m  \033[38;5;240mtup <category> for details\033[0m"
            echo ""
            echo -e "    \033[38;5;46mgit\033[0m     \033[38;5;39mnav\033[0m     \033[38;5;208mnpm\033[0m     \033[38;5;177mfzf\033[0m     \033[38;5;39mddev\033[0m"
            echo -e "    \033[38;5;213mtheme\033[0m   \033[38;5;141mextras\033[0m  \033[38;5;208mtools\033[0m   \033[38;5;226mworkflow\033[0m"
            echo -e "    \033[38;5;87mscreen\033[0m  \033[38;5;39mfun\033[0m     \033[38;5;39msystem\033[0m  \033[38;5;255mall\033[0m"
            echo ""
            echo -e "  \033[38;5;240mReload: \033[38;5;51mtups\033[38;5;240m  │  Version: \033[38;5;51mtup version\033[0m"
            echo ""
            ;;
        git)
            _tup_header
            _tup_git
            ;;
        nav|navigation)
            _tup_header
            _tup_nav
            ;;
        npm|pnpm|node)
            _tup_header
            _tup_npm
            ;;
        fzf|fuzzy)
            _tup_header
            _tup_fzf
            ;;
        ddev|docker)
            _tup_header
            _tup_ddev
            ;;
        theme|themes)
            _tup_header
            _tup_theme
            ;;
        extras|extra|productivity)
            _tup_header
            _tup_extras
            ;;
        tools|util|utils)
            _tup_header
            _tup_tools
            ;;
        workflow|work)
            _tup_header
            _tup_workflow
            ;;
        fun|games|animations)
            _tup_header
            _tup_fun
            ;;
        screen|lock|screensaver)
            _tup_header
            _tup_screen
            ;;
        system|sys|lang|platform)
            _tup_header
            _tup_system
            ;;
        all|full)
            _tup_header
            _tup_git
            _tup_nav
            _tup_npm
            _tup_fzf
            _tup_ddev
            _tup_theme
            _tup_extras
            _tup_tools
            _tup_workflow
            _tup_fun
            _tup_screen
            _tup_system
            ;;
        version|--version|-v)
            echo -e "  \033[38;5;51mTerminup\033[0m v1.0.0"
            ;;
        reload)
            source "$TERMINUP_DIR/terminup.zsh"
            echo -e "  \033[38;5;46m✓\033[0m Terminup reloaded!"
            ;;
        *)
            echo -e "  \033[38;5;196m✗\033[0m Unknown: $cmd"
            echo -e "  \033[38;5;245mTry: tup [git|nav|npm|extras|tools|workflow|fun|screen|all]\033[0m"
            ;;
    esac
}

# Aliases for quick access
alias tup='terminup'
alias tups='source ~/.zshrc && echo -e "  \033[38;5;46m✓\033[0m Shell reloaded!"'
