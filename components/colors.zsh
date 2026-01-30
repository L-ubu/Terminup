#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │                    🎨 Color Definitions                       │
# ╰──────────────────────────────────────────────────────────────╯

# Reset
export RESET='\033[0m'

# Regular Colors
export BLACK='\033[0;30m'
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export WHITE='\033[0;37m'

# Bold Colors
export BOLD_BLACK='\033[1;30m'
export BOLD_RED='\033[1;31m'
export BOLD_GREEN='\033[1;32m'
export BOLD_YELLOW='\033[1;33m'
export BOLD_BLUE='\033[1;34m'
export BOLD_PURPLE='\033[1;35m'
export BOLD_CYAN='\033[1;36m'
export BOLD_WHITE='\033[1;37m'

# High Intensity
export HI_BLACK='\033[0;90m'
export HI_RED='\033[0;91m'
export HI_GREEN='\033[0;92m'
export HI_YELLOW='\033[0;93m'
export HI_BLUE='\033[0;94m'
export HI_PURPLE='\033[0;95m'
export HI_CYAN='\033[0;96m'
export HI_WHITE='\033[0;97m'

# 256 Color shortcuts for gradients
gradient_text() {
    local text="$1"
    local start_color="${2:-196}"  # Start color (default red)
    local end_color="${3:-201}"    # End color (default pink)
    local len=${#text}
    local step=$(( (end_color - start_color) / (len > 1 ? len - 1 : 1) ))
    local result=""
    
    for ((i=0; i<len; i++)); do
        local color=$((start_color + step * i))
        result+="\033[38;5;${color}m${text:$i:1}"
    done
    echo -e "${result}${RESET}"
}

# Rainbow text effect
rainbow_text() {
    local text="$1"
    local colors=(196 208 226 46 51 171)
    local len=${#text}
    local result=""
    
    for ((i=0; i<len; i++)); do
        local color=${colors[$((i % ${#colors[@]}))]}
        result+="\033[38;5;${color}m${text:$i:1}"
    done
    echo -e "${result}${RESET}"
}

# Neon glow effect (simulated with bold + color)
neon() {
    local color="$1"
    local text="$2"
    echo -e "\033[1;38;5;${color}m✨ ${text} ✨${RESET}"
}
