#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │                  ✨ Cursor & Terminal Effects                 │
# ╰──────────────────────────────────────────────────────────────╯

# Cursor shapes
# 0 or 1 - Blinking block
# 2 - Steady block  
# 3 - Blinking underline
# 4 - Steady underline
# 5 - Blinking bar (line)
# 6 - Steady bar (line)

# Set cursor style
set_cursor() {
    local style="${1:-bar}"
    local blink="${2:-true}"
    
    case "$style" in
        block)
            [[ "$blink" == "true" ]] && echo -ne '\e[1 q' || echo -ne '\e[2 q'
            ;;
        underline)
            [[ "$blink" == "true" ]] && echo -ne '\e[3 q' || echo -ne '\e[4 q'
            ;;
        bar|line)
            [[ "$blink" == "true" ]] && echo -ne '\e[5 q' || echo -ne '\e[6 q'
            ;;
    esac
}

# Different cursor for different vi modes (if using vi mode)
function zle-keymap-select {
    case $KEYMAP in
        vicmd)
            # Command mode - block cursor
            echo -ne '\e[1 q'
            ;;
        viins|main)
            # Insert mode - bar cursor
            echo -ne '\e[5 q'
            ;;
    esac
}
zle -N zle-keymap-select

# Initialize cursor on line init
function zle-line-init {
    echo -ne '\e[5 q'  # Start with blinking bar
}
zle -N zle-line-init

# Reset cursor after command execution
function cursor_reset {
    echo -ne '\e[5 q'  # Blinking bar
}
precmd_functions+=(cursor_reset)

# Cursor color (for terminals that support it)
# Note: This uses OSC escape sequences, supported by iTerm2, Kitty, etc.
set_cursor_color() {
    local color="${1:-#f5e0dc}"
    echo -ne "\e]12;${color}\a"
}

# Animated cursor blink rate (terminal dependent)
# This sets the cursor blink interval in milliseconds
# Works in some terminals like iTerm2
set_cursor_blink_rate() {
    local rate="${1:-500}"  # Default 500ms
    echo -ne "\e[?12;${rate}h"
}

# ─────────────────────────────────────────────────────────────────
# Terminal title customization
# ─────────────────────────────────────────────────────────────────

# Set terminal title to current directory
function set_terminal_title {
    local title="${PWD/#$HOME/~}"
    echo -ne "\033]0;${title}\007"
}
precmd_functions+=(set_terminal_title)

# Set title while command is running
function set_running_title {
    local cmd="${1%% *}"  # Get first word of command
    echo -ne "\033]0;⏳ ${cmd}\007"
}
preexec_functions+=(set_running_title)

# ─────────────────────────────────────────────────────────────────
# Special effects (use sparingly - for fun!)
# ─────────────────────────────────────────────────────────────────

# Screen flash effect (for notifications)
flash() {
    printf '\e[?5h'  # Reverse video
    sleep 0.1
    printf '\e[?5l'  # Normal video
}

# Bell with visual effect
ding() {
    printf '\a'  # Audio bell
    flash        # Visual flash
}

# Clear with style
cls() {
    local style="${1:-fade}"
    
    case "$style" in
        fade)
            for i in {1..5}; do
                printf '\e[2J\e[H'
                sleep 0.02
            done
            ;;
        scroll)
            local lines=$(tput lines)
            for ((i=0; i<lines; i++)); do
                echo ""
                sleep 0.01
            done
            clear
            ;;
        instant|*)
            clear
            ;;
    esac
}

# Welcome message with typing effect
welcome() {
    local messages=(
        "👋 Welcome back!"
        "🚀 Ready to code?"
        "💻 Let's build something awesome!"
        "✨ Time to create magic!"
        "🔥 Let's get productive!"
    )
    local msg="${messages[$((RANDOM % ${#messages[@]} + 1))]}"
    
    echo ""
    echo -n "  "
    for ((i=0; i<${#msg}; i++)); do
        echo -n "${msg:$i:1}"
        sleep 0.03
    done
    echo ""
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# Syntax highlighting improvements
# ─────────────────────────────────────────────────────────────────

# If zsh-syntax-highlighting is installed, enhance it
if [[ -n "$ZSH_HIGHLIGHT_HIGHLIGHTERS" ]]; then
    # Custom highlight styles
    typeset -gA ZSH_HIGHLIGHT_STYLES
    
    ZSH_HIGHLIGHT_STYLES[default]='fg=252'
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=196,bold'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=197,bold'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=39,bold'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=39,bold'
    ZSH_HIGHLIGHT_STYLES[function]='fg=39,bold'
    ZSH_HIGHLIGHT_STYLES[command]='fg=46,bold'
    ZSH_HIGHLIGHT_STYLES[precommand]='fg=46,underline'
    ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=214'
    ZSH_HIGHLIGHT_STYLES[path]='fg=81,underline'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=226'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=226'
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=208'
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=208'
    ZSH_HIGHLIGHT_STYLES[assign]='fg=177'
fi

# ─────────────────────────────────────────────────────────────────
# Command timing display
# ─────────────────────────────────────────────────────────────────

# Track command execution time
typeset -g CMD_START_TIME

preexec_timer() {
    CMD_START_TIME=$SECONDS
}
preexec_functions+=(preexec_timer)

precmd_timer() {
    if [[ -n "$CMD_START_TIME" ]]; then
        local elapsed=$((SECONDS - CMD_START_TIME))
        if [[ $elapsed -gt 5 ]]; then
            # Show notification for long-running commands
            local mins=$((elapsed / 60))
            local secs=$((elapsed % 60))
            if [[ $mins -gt 0 ]]; then
                echo -e "\n  ⏱️  \033[38;5;245mCommand took ${mins}m ${secs}s\033[0m"
            else
                echo -e "\n  ⏱️  \033[38;5;245mCommand took ${secs}s\033[0m"
            fi
        fi
        unset CMD_START_TIME
    fi
}
precmd_functions+=(precmd_timer)
