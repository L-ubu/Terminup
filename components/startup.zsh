#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │                   JARVIS-Style Startup                        │
# ╰──────────────────────────────────────────────────────────────╯

# Configuration
TERMINUP_STARTUP_ENABLED="${TERMINUP_STARTUP_ENABLED:-true}"
TERMINUP_STARTUP_STYLE="${TERMINUP_STARTUP_STYLE:-full}"  # full, minimal, off

# TUP Logo ASCII Art
TUP_LOGO='
    ████████╗██╗   ██╗██████╗ 
    ╚══██╔══╝██║   ██║██╔══██╗
       ██║   ██║   ██║██████╔╝
       ██║   ██║   ██║██╔═══╝ 
       ██║   ╚██████╔╝██║     
       ╚═╝    ╚═════╝ ╚═╝     
'

TUP_LOGO_SMALL='
  ╔════╗╔═╗╔═╗╔════╗
  ╚═╗╔═╝║ ║║ ║║ ╔══╝
    ║║  ║ ║║ ║║ ╚══╗
    ║║  ╚═╝╚═╝╚════╝
'

# Animated line drawing
_draw_line() {
    local width="${1:-60}"
    local char="${2:-─}"
    local color="${3:-245}"
    local delay="${4:-0.01}"
    
    printf "  \033[38;5;${color}m"
    for ((i=0; i<width; i++)); do
        printf "%s" "$char"
        sleep $delay
    done
    printf "\033[0m\n"
}

# Status message with animation
_status() {
    local message="$1"
    local stat_type="${2:-ok}"
    local delay="${3:-0.02}"
    
    printf "  \033[38;5;245m[\033[0m"
    
    case "$stat_type" in
        loading)
            printf "\033[38;5;226m....\033[0m"
            ;;
        ok|success)
            printf "\033[38;5;46m OK \033[0m"
            ;;
        warn)
            printf "\033[38;5;226mWARN\033[0m"
            ;;
        fail|error)
            printf "\033[38;5;196mFAIL\033[0m"
            ;;
        info)
            printf "\033[38;5;51mINFO\033[0m"
            ;;
    esac
    
    printf "\033[38;5;245m]\033[0m "
    
    # Type out message
    for ((i=0; i<${#message}; i++)); do
        printf "%s" "${message:$i:1}"
        sleep $delay
    done
    echo ""
}

# Quick status (no typing animation)
_qstatus() {
    local message="$1"
    local stat_type="${2:-ok}"
    
    printf "  \033[38;5;245m[\033[0m"
    
    case "$stat_type" in
        ok) printf "\033[38;5;46m OK \033[0m" ;;
        warn) printf "\033[38;5;226mWARN\033[0m" ;;
        fail) printf "\033[38;5;196mFAIL\033[0m" ;;
        info) printf "\033[38;5;51mINFO\033[0m" ;;
    esac
    
    printf "\033[38;5;245m]\033[0m %s\n" "$message"
}

# System check
_check_system() {
    local checks_passed=0
    local checks_total=0
    
    # Shell check
    ((checks_total++))
    if [[ -n "$ZSH_VERSION" ]]; then
        _qstatus "Shell: zsh $ZSH_VERSION" "ok"
        ((checks_passed++))
    else
        _qstatus "Shell: Not running zsh" "warn"
    fi
    
    # Terminal
    ((checks_total++))
    _qstatus "Terminal: ${TERM_PROGRAM:-$TERM}" "info"
    ((checks_passed++))
    
    # Git
    ((checks_total++))
    if command -v git &>/dev/null; then
        local git_version=$(git --version | awk '{print $3}')
        _qstatus "Git: $git_version" "ok"
        ((checks_passed++))
    else
        _qstatus "Git: Not installed" "warn"
    fi
    
    # Node
    ((checks_total++))
    if command -v node &>/dev/null; then
        local node_version=$(node --version)
        _qstatus "Node: $node_version" "ok"
        ((checks_passed++))
    else
        _qstatus "Node: Not installed" "warn"
    fi
    
    # FZF
    ((checks_total++))
    if command -v fzf &>/dev/null; then
        _qstatus "FZF: Available" "ok"
        ((checks_passed++))
    else
        _qstatus "FZF: Not installed (optional)" "warn"
    fi
    
    # DDEV
    ((checks_total++))
    if command -v ddev &>/dev/null; then
        _qstatus "DDEV: Available" "ok"
        ((checks_passed++))
    else
        _qstatus "DDEV: Not installed (optional)" "info"
    fi
    
    echo ""
    _qstatus "Systems check: $checks_passed/$checks_total passed" "info"
}

# Get greeting based on time
_get_greeting() {
    local hour=$(date +%H)
    local name="${USER:-User}"
    
    if ((hour >= 5 && hour < 12)); then
        echo "Good morning, $name"
    elif ((hour >= 12 && hour < 17)); then
        echo "Good afternoon, $name"
    elif ((hour >= 17 && hour < 21)); then
        echo "Good evening, $name"
    else
        echo "Working late, $name?"
    fi
}

# Main startup sequence
terminup_startup() {
    local style="${1:-$TERMINUP_STARTUP_STYLE}"
    
    [[ "$style" == "off" ]] && return
    [[ "$TERMINUP_STARTUP_ENABLED" != "true" ]] && return
    
    clear
    echo ""
    
    if [[ "$style" == "full" ]]; then
        # Full JARVIS-style boot sequence
        
        # Animated logo reveal
        printf "\033[38;5;51m"
        echo "$TUP_LOGO" | while IFS= read -r line; do
            echo "$line"
            sleep 0.05
        done
        printf "\033[0m"
        
        echo ""
        _draw_line 50 "═" 51 0.02
        echo ""
        
        # Greeting
        local greeting=$(_get_greeting)
        _status "$greeting" "info" 0.03
        echo ""
        
        # Boot sequence
        _status "Initializing Terminup v1.0.0" "ok" 0.02
        _status "Loading core modules" "ok" 0.02
        _status "Configuring shell environment" "ok" 0.02
        
        echo ""
        _draw_line 50 "─" 245 0.01
        echo ""
        
        # System checks
        printf "  \033[38;5;51mSYSTEM STATUS\033[0m\n"
        echo ""
        _check_system
        
        echo ""
        _draw_line 50 "─" 245 0.01
        echo ""
        
        # Quick stats
        local pwd_display="${PWD/#$HOME/~}"
        _qstatus "Directory: $pwd_display" "info"
        
        if [[ -d ".git" ]]; then
            local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
            _qstatus "Git branch: $branch" "info"
        fi
        
        if [[ -f "package.json" ]]; then
            local pkg_name=$(node -e "console.log(require('./package.json').name || 'unnamed')" 2>/dev/null)
            _qstatus "Project: $pkg_name" "info"
        fi
        
        echo ""
        _draw_line 50 "═" 51 0.02
        echo ""
        
        _status "All systems operational" "ok" 0.02
        printf "  \033[38;5;245mType \033[38;5;51mtup\033[38;5;245m for help\033[0m\n"
        echo ""
        
    elif [[ "$style" == "minimal" ]]; then
        # Minimal startup
        printf "\033[38;5;51m"
        echo "$TUP_LOGO_SMALL"
        printf "\033[0m"
        
        local greeting=$(_get_greeting)
        echo ""
        printf "  \033[38;5;245m$greeting\033[0m\n"
        printf "  \033[38;5;240mType \033[38;5;51mtup\033[38;5;240m for help\033[0m\n"
        echo ""
    fi
}

# Disable startup for subsequent shells in same session
_terminup_first_run() {
    if [[ -z "$TERMINUP_BOOTED" ]]; then
        export TERMINUP_BOOTED=1
        terminup_startup
    fi
}

# Run on load (only for interactive shells)
[[ -o interactive ]] && _terminup_first_run

# Manual trigger
alias boot='terminup_startup full'
alias bootmin='terminup_startup minimal'
