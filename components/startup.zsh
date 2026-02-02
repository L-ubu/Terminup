#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │                   JARVIS-Style Startup                        │
# ╰──────────────────────────────────────────────────────────────╯

# Configuration
TERMINUP_STARTUP_ENABLED="${TERMINUP_STARTUP_ENABLED:-true}"
TERMINUP_STARTUP_STYLE="${TERMINUP_STARTUP_STYLE:-full}"  # full, minimal, off
TERMINUP_LOGO_ANIMATION="${TERMINUP_LOGO_ANIMATION:-sweep}"  # sweep, drop, type, none

# TUP Logo ASCII Art (line by line for animation)
typeset -ga TUP_LOGO_LINES
TUP_LOGO_LINES=(
    "    ████████╗██╗   ██╗██████╗ "
    "    ╚══██╔══╝██║   ██║██╔══██╗"
    "       ██║   ██║   ██║██████╔╝"
    "       ██║   ██║   ██║██╔═══╝ "
    "       ██║   ╚██████╔╝██║     "
    "       ╚═╝    ╚═════╝ ╚═╝     "
)

TUP_LOGO_SMALL='
  ╔════╗╔═╗ ╔═╗╔════╗
  ╚═╗╔═╝║ ║ ║ ║║    ║ 
    ║║  ║ ╚═╝ ║║ ╔══╝
    ║║  ╚═════╝╚═╝
'

# Animated logo reveal - color sweep effect
# Press Enter to skip/speed up
_animate_logo() {
    tput civis 2>/dev/null
    
    local rows=${#TUP_LOGO_LINES[@]}
    local colors=(232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 51)
    
    # Print logo in dark gray first
    for ((r=1; r<=rows; r++)); do
        echo -e "\033[38;5;236m${TUP_LOGO_LINES[$r]}\033[0m"
    done
    
    # Animate: brighten from dark to cyan
    for color in "${colors[@]}"; do
        # Check for Enter key to speed up
        if read -t 0.001 -k 1 key 2>/dev/null; then
            _BOOT_SKIP=true
        fi
        
        printf "\033[${rows}A"
        for ((r=1; r<=rows; r++)); do
            echo -e "\033[38;5;${color}m${TUP_LOGO_LINES[$r]}\033[0m"
        done
        [[ "$_BOOT_SKIP" != "true" ]] && sleep 0.03
    done
    
    # Flash white then back to cyan
    [[ "$_BOOT_SKIP" != "true" ]] && sleep 0.05
    printf "\033[${rows}A"
    for ((r=1; r<=rows; r++)); do
        echo -e "\033[1;38;5;231m${TUP_LOGO_LINES[$r]}\033[0m"
    done
    [[ "$_BOOT_SKIP" != "true" ]] && sleep 0.1
    printf "\033[${rows}A"
    for ((r=1; r<=rows; r++)); do
        echo -e "\033[38;5;51m${TUP_LOGO_LINES[$r]}\033[0m"
    done
    
    tput cnorm 2>/dev/null
}

# Alternative: Line-by-line drop animation
# Press Enter to skip/speed up
_animate_logo_drop() {
    tput civis 2>/dev/null
    
    local rows=${#TUP_LOGO_LINES[@]}
    
    # Drop each line from top
    for ((r=1; r<=rows; r++)); do
        # Check for Enter key
        if read -t 0.001 -k 1 key 2>/dev/null; then
            _BOOT_SKIP=true
        fi
        
        # Flash effect for each line
        echo -e "\033[1;38;5;231m${TUP_LOGO_LINES[$r]}\033[0m"
        [[ "$_BOOT_SKIP" != "true" ]] && sleep 0.08
        
        # Recolor to cyan
        printf "\033[1A"
        echo -e "\033[38;5;51m${TUP_LOGO_LINES[$r]}\033[0m"
    done
    
    tput cnorm 2>/dev/null
}

# Typewriter animation
# Press Enter to skip/speed up
_animate_logo_type() {
    tput civis 2>/dev/null
    
    for ((r=1; r<=${#TUP_LOGO_LINES[@]}; r++)); do
        local line="${TUP_LOGO_LINES[$r]}"
        local len=${#line}
        
        for ((c=0; c<len; c++)); do
            # Check for Enter key
            if read -t 0.001 -k 1 key 2>/dev/null; then
                _BOOT_SKIP=true
            fi
            
            local char="${line:$c:1}"
            if [[ "$char" != " " ]]; then
                printf "\033[38;5;51m%s\033[0m" "$char"
                [[ "$_BOOT_SKIP" != "true" ]] && sleep 0.008
            else
                printf " "
            fi
        done
        echo ""
    done
    
    tput cnorm 2>/dev/null
}

# Animated line drawing (respects _BOOT_SKIP for speed-up)
_draw_line() {
    local width="${1:-60}"
    local char="${2:-─}"
    local color="${3:-245}"
    local delay="${4:-0.01}"
    
    printf "  \033[38;5;${color}m"
    for ((i=0; i<width; i++)); do
        # Check for Enter key to speed up
        if read -t 0.001 -k 1 key 2>/dev/null; then
            _BOOT_SKIP=true
        fi
        printf "%s" "$char"
        [[ "$_BOOT_SKIP" != "true" ]] && sleep $delay
    done
    printf "\033[0m\n"
}

# Status message with animation (respects _BOOT_SKIP for speed-up)
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
    
    # Type out message (check for Enter to speed up)
    for ((i=0; i<${#message}; i++)); do
        if read -t 0.001 -k 1 key 2>/dev/null; then
            _BOOT_SKIP=true
        fi
        printf "%s" "${message:$i:1}"
        [[ "$_BOOT_SKIP" != "true" ]] && sleep $delay
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
# Press Enter at any time to speed up animations
terminup_startup() {
    local style="${1:-$TERMINUP_STARTUP_STYLE}"
    
    [[ "$style" == "off" ]] && return
    [[ "$TERMINUP_STARTUP_ENABLED" != "true" ]] && return
    
    # Reset skip flag
    _BOOT_SKIP=false
    
    clear
    echo ""
    
    if [[ "$style" == "full" ]]; then
        # Full JARVIS-style boot sequence
        
        # Animated logo reveal based on preference
        case "$TERMINUP_LOGO_ANIMATION" in
            sweep)
                _animate_logo
                ;;
            drop)
                _animate_logo_drop
                ;;
            type)
                _animate_logo_type
                ;;
            none|*)
                # Simple line-by-line reveal
                for ((r=1; r<=${#TUP_LOGO_LINES[@]}; r++)); do
                    echo -e "\033[38;5;51m${TUP_LOGO_LINES[$r]}\033[0m"
                    sleep 0.03
                done
                ;;
        esac
        
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
