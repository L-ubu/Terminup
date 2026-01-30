#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │                   🎬 Animation Functions                      │
# ╰──────────────────────────────────────────────────────────────╯

# Spinner styles
typeset -gA SPINNERS
SPINNERS=(
    dots "⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏"
    dots2 "⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷"
    dots3 "⠁ ⠂ ⠄ ⡀ ⢀ ⠠ ⠐ ⠈"
    line "- \\ | /"
    arc "◜ ◠ ◝ ◞ ◡ ◟"
    circle "◐ ◓ ◑ ◒"
    square "◰ ◳ ◲ ◱"
    bounce "⠁ ⠂ ⠄ ⠂"
    pulse "█ ▓ ▒ ░ ▒ ▓"
    moon "🌑 🌒 🌓 🌔 🌕 🌖 🌗 🌘"
    earth "🌍 🌎 🌏"
    clock "🕛 🕐 🕑 🕒 🕓 🕔 🕕 🕖 🕗 🕘 🕙 🕚"
    arrow "← ↖ ↑ ↗ → ↘ ↓ ↙"
    fire "🔥 💥 ✨ 💫 🔥"
    rocket "🚀 💨 ✨ 🌟 ⭐"
    code "⟨ ⟩ { } [ ] < >"
    nyan "▐▀▀▀▀▀▀▀▀▌ ▐▀▀▀▀▀▀▀▀▌ ▐▀▀▀▀▀▀▀▀▌"
)

# Progress bar function
progress_bar() {
    local current="$1"
    local total="$2"
    local width="${3:-40}"
    local color="${4:-46}"
    
    local percent=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done
    
    printf "\r\033[38;5;${color}m▐%s▌\033[0m %3d%%" "$bar" "$percent"
}

# Animated progress bar
animated_progress() {
    local duration="${1:-2}"
    local label="${2:-Loading}"
    local color="${3:-51}"
    local steps=50
    
    echo ""
    for ((i=0; i<=steps; i++)); do
        local percent=$((i * 100 / steps))
        local filled=$((i * 40 / steps))
        local empty=$((40 - filled))
        
        local bar=""
        for ((j=0; j<filled; j++)); do bar+="█"; done
        for ((j=0; j<empty; j++)); do bar+="░"; done
        
        printf "\r  \033[38;5;${color}m${label}\033[0m ▐\033[38;5;${color}m%s\033[0m▌ %3d%%" "$bar" "$percent"
        sleep $(echo "scale=3; $duration / $steps" | bc)
    done
    echo ""
}

# Spinner function - runs command with spinner
spin() {
    local style="${1:-dots}"
    local message="${2:-Processing}"
    shift 2
    local cmd="$@"
    local frames=(${(s: :)SPINNERS[$style]})
    local frame_count=${#frames[@]}
    
    # Start command in background
    eval "$cmd" &>/dev/null &
    local pid=$!
    
    local i=0
    while kill -0 $pid 2>/dev/null; do
        local frame=${frames[$((i % frame_count + 1))]}
        printf "\r  \033[38;5;51m%s\033[0m %s" "$frame" "$message"
        sleep 0.1
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        printf "\r  \033[38;5;46m✓\033[0m %s\033[K\n" "$message"
    else
        printf "\r  \033[38;5;196m✗\033[0m %s\033[K\n" "$message"
    fi
    
    return $exit_code
}

# Typing animation
type_text() {
    local text="$1"
    local delay="${2:-0.03}"
    local color="${3:-}"
    
    [[ -n "$color" ]] && printf "\033[38;5;${color}m"
    
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep $delay
    done
    
    [[ -n "$color" ]] && printf "\033[0m"
    echo ""
}

# Matrix rain effect (brief)
matrix_rain() {
    local duration="${1:-1}"
    local chars="アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン0123456789"
    local cols=$(tput cols)
    local end_time=$(($(date +%s) + duration))
    
    while [[ $(date +%s) -lt $end_time ]]; do
        local col=$((RANDOM % cols))
        local char="${chars:$((RANDOM % ${#chars})):1}"
        local color=$((22 + RANDOM % 10))
        printf "\033[38;5;${color}m\033[${RANDOM % 10};${col}H${char}"
        sleep 0.01
    done
    clear
}

# Success celebration
celebrate() {
    local message="${1:-Success!}"
    local emojis=("🎉" "🎊" "✨" "🌟" "💫" "🚀" "⭐" "🔥")
    
    for i in {1..3}; do
        for emoji in "${emojis[@]:0:4}"; do
            printf "\r  %s %s %s" "$emoji" "$message" "$emoji"
            sleep 0.1
        done
    done
    printf "\r  🎉 %s 🎉\033[K\n" "$message"
}

# Error shake animation
shake_error() {
    local message="${1:-Error!}"
    local positions=("" " " "  " " " "")
    
    for i in {1..2}; do
        for pos in "${positions[@]}"; do
            printf "\r%s\033[38;5;196m✗ %s\033[0m" "$pos" "$message"
            sleep 0.03
        done
    done
    printf "\r\033[38;5;196m✗ %s\033[0m\033[K\n" "$message"
}

# Wave text animation
wave_text() {
    local text="$1"
    local waves=5
    
    for ((w=0; w<waves; w++)); do
        for ((i=0; i<${#text}; i++)); do
            local offset=$(( (i + w) % 3 ))
            case $offset in
                0) printf "\033[1A" ;;
                1) ;;
                2) printf "\033[1B" ;;
            esac
            printf "%s" "${text:$i:1}"
        done
        printf "\r"
        sleep 0.1
    done
    echo "$text"
}

# Loading dots
loading_dots() {
    local message="${1:-Loading}"
    local duration="${2:-2}"
    local end_time=$(($(date +%s) + duration))
    local dots=""
    
    while [[ $(date +%s) -lt $end_time ]]; do
        printf "\r  \033[38;5;51m%s%s\033[0m   " "$message" "$dots"
        dots+="."
        [[ ${#dots} -gt 3 ]] && dots=""
        sleep 0.3
    done
    printf "\r\033[K"
}
