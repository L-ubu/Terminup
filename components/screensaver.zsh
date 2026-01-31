#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │                    🖥️ Screensaver                             │
# ╰──────────────────────────────────────────────────────────────╯

# ASCII digit patterns (5 lines tall, 4 chars wide)
typeset -gA ASCII_DIGITS
ASCII_DIGITS[0]=$'┌──┐\n│  │\n│  │\n│  │\n└──┘'
ASCII_DIGITS[1]=$'  ┐ \n  │ \n  │ \n  │ \n  ┴ '
ASCII_DIGITS[2]=$'┌──┐\n   │\n┌──┘\n│   \n└──┘'
ASCII_DIGITS[3]=$'┌──┐\n   │\n ──┤\n   │\n└──┘'
ASCII_DIGITS[4]=$'┐  ┐\n│  │\n└──┤\n   │\n   ┘'
ASCII_DIGITS[5]=$'┌──┐\n│   \n└──┐\n   │\n└──┘'
ASCII_DIGITS[6]=$'┌──┐\n│   \n├──┐\n│  │\n└──┘'
ASCII_DIGITS[7]=$'┌──┐\n   │\n   │\n   │\n   ┘'
ASCII_DIGITS[8]=$'┌──┐\n│  │\n├──┤\n│  │\n└──┘'
ASCII_DIGITS[9]=$'┌──┐\n│  │\n└──┤\n   │\n└──┘'
ASCII_DIGITS[:]=$'    \n ○  \n    \n ○  \n    '

# Get ASCII representation of a digit
_get_digit_line() {
    local digit="$1"
    local line="$2"
    local pattern="${ASCII_DIGITS[$digit]}"
    echo "${${(f)pattern}[$((line + 1))]}"
}

# Build time display (HH:MM:SS)
_build_time_ascii() {
    local time_str=$(date +%H:%M:%S)
    local lines=("" "" "" "" "")
    
    for ((i = 0; i < ${#time_str}; i++)); do
        local char="${time_str:$i:1}"
        for ((line = 0; line < 5; line++)); do
            local digit_line=$(_get_digit_line "$char" "$line")
            lines[$((line + 1))]+="$digit_line "
        done
    done
    
    printf '%s\n' "${lines[@]}"
}

# Build date display
_build_date_ascii() {
    local date_str=$(date +"%A, %B %d, %Y")
    echo "$date_str"
}

# Calculate center position
_center_text() {
    local text="$1"
    local width=$(tput cols)
    local text_len=${#text}
    local padding=$(( (width - text_len) / 2 ))
    printf "%${padding}s%s" "" "$text"
}

# Main screensaver function
screensaver() {
    local unlock_sequence=("left" "up" "right" "down")
    local current_pos=0
    local hint_shown=false
    
    # Save terminal state
    tput smcup  # Save screen
    tput civis  # Hide cursor
    stty -echo  # Disable echo
    
    # Trap for clean exit
    trap '_screensaver_cleanup' INT TERM
    
    clear
    
    # Set black background
    printf '\033[40m'  # Black background
    printf '\033[2J'   # Clear with background
    
    local cols=$(tput cols)
    local rows=$(tput lines)
    
    while true; do
        # Position for clock (center of screen)
        local clock_start_row=$(( (rows - 10) / 2 ))
        
        # Move to position and draw clock
        tput cup $clock_start_row 0
        
        # Get time ASCII
        local time_lines=("${(@f)$(_build_time_ascii)}")
        
        # Draw each line of the clock centered
        for line in "${time_lines[@]}"; do
            printf '\033[38;5;51m'  # Cyan color
            _center_text "$line"
            echo ""
        done
        
        # Blank line
        echo ""
        
        # Date centered
        local date_str=$(_build_date_ascii)
        printf '\033[38;5;245m'  # Gray color
        _center_text "$date_str"
        echo ""
        echo ""
        
        # Unlock hint (subtle)
        if [[ $current_pos -gt 0 ]]; then
            local progress=""
            for ((i = 0; i < 4; i++)); do
                if [[ $i -lt $current_pos ]]; then
                    progress+="●"
                else
                    progress+="○"
                fi
            done
            printf '\033[38;5;240m'
            _center_text "$progress"
        else
            printf '\033[38;5;238m'
            _center_text "← ↑ → ↓ to unlock"
        fi
        
        # Read key with timeout
        local key=""
        read -t 1 -k 1 key 2>/dev/null
        
        if [[ -n "$key" ]]; then
            # Detect arrow keys (they come as escape sequences)
            if [[ "$key" == $'\e' ]]; then
                read -t 0.1 -k 2 key 2>/dev/null
                case "$key" in
                    "[D") key="left" ;;
                    "[A") key="up" ;;
                    "[C") key="right" ;;
                    "[B") key="down" ;;
                    *) key="" ;;
                esac
            else
                key=""
            fi
            
            # Check sequence
            if [[ "$key" == "${unlock_sequence[$((current_pos + 1))]}" ]]; then
                ((current_pos++))
                if [[ $current_pos -ge 4 ]]; then
                    _screensaver_cleanup
                    echo ""
                    printf '\033[38;5;46m'
                    _center_text "Welcome back!"
                    printf '\033[0m'
                    echo ""
                    echo ""
                    return 0
                fi
            elif [[ -n "$key" ]]; then
                # Wrong key, reset
                current_pos=0
            fi
        fi
    done
}

_screensaver_cleanup() {
    printf '\033[0m'   # Reset colors
    tput cnorm         # Show cursor
    tput rmcup         # Restore screen
    stty echo          # Re-enable echo
    clear
}

# ─────────────────────────────────────────────────────────────────
# Fullscreen Lock Mode
# ─────────────────────────────────────────────────────────────────

# Remove any previous lock alias to allow function definition
unalias lock 2>/dev/null

# Check if terminal is in fullscreen
_is_fullscreen() {
    local result
    result=$(osascript -e 'tell application "System Events"
        tell (first process whose frontmost is true)
            tell (first window whose subrole is "AXStandardWindow" or subrole is "AXFullScreenWindow")
                return value of attribute "AXFullScreen"
            end tell
        end tell
    end tell' 2>/dev/null)
    [[ "$result" == "true" ]]
}

# Toggle fullscreen for the current terminal window
_toggle_fullscreen() {
    osascript -e 'tell application "System Events"
        tell (first process whose frontmost is true)
            keystroke "f" using {command down, control down}
        end tell
    end tell' 2>/dev/null
}

# Lock with fullscreen terminal screensaver
lock() {
    local was_fullscreen=false
    
    # Check if already fullscreen
    if _is_fullscreen; then
        was_fullscreen=true
    else
        # Enter fullscreen
        _toggle_fullscreen
        # Wait for fullscreen animation
        sleep 0.5
    fi
    
    # Run screensaver
    screensaver
    
    # Exit fullscreen if we entered it
    if [[ "$was_fullscreen" == "false" ]]; then
        _toggle_fullscreen
    fi
}

# Lock the actual Mac (system lock screen)
syslock() {
    echo -e "  \033[38;5;208m🔒 Locking Mac...\033[0m"
    sleep 0.3
    # Use pmset to lock (works on all macOS versions)
    osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}' 2>/dev/null
}

# Combined: Fullscreen screensaver + system lock when unlocked
lockall() {
    local was_fullscreen=false
    
    # Check if already fullscreen
    if _is_fullscreen; then
        was_fullscreen=true
    else
        _toggle_fullscreen
        sleep 0.5
    fi
    
    # Run screensaver
    screensaver
    
    # Exit fullscreen
    if [[ "$was_fullscreen" == "false" ]]; then
        _toggle_fullscreen
        sleep 0.3
    fi
    
    # Then lock the Mac
    syslock
}

# Screensaver alias (non-fullscreen)
alias ss='screensaver'

# Auto-lock after idle (optional - user can enable)
# Usage: autolock 300  (lock after 5 minutes)
autolock() {
    local timeout="${1:-300}"  # Default 5 minutes
    
    echo -e "  \033[38;5;51mAuto-lock enabled:\033[0m $timeout seconds"
    echo -e "  \033[38;5;245mPress any key to cancel...\033[0m"
    
    TMOUT=$timeout
    TRAPALRM() {
        screensaver
        TMOUT=0
    }
}

# Disable auto-lock
noautolock() {
    TMOUT=0
    unfunction TRAPALRM 2>/dev/null
    echo -e "  \033[38;5;46m✓\033[0m Auto-lock disabled"
}

# ─────────────────────────────────────────────────────────────────
# Analog Clock Screensaver
# ─────────────────────────────────────────────────────────────────

# Sine/Cosine lookup tables (pre-computed for 0-360 degrees, scaled by 1000)
# Index 0-90 degrees, values are sin*1000
typeset -ga _SIN_TABLE
_SIN_TABLE=(0 17 35 52 70 87 105 122 139 156 174 191 208 225 242 259 276 292 309 326 342 358 375 391 407 423 438 454 469 485 500 515 530 545 559 574 588 602 616 629 643 656 669 682 695 707 719 731 743 755 766 777 788 799 809 819 829 839 848 857 866 875 883 891 899 906 914 921 927 934 940 946 951 956 961 966 970 974 978 982 985 988 990 993 995 996 998 999 1000 1000 1000)

# Get sine value (angle in degrees 0-360)
_sin_deg() {
    local angle=$(( ($1 % 360 + 360) % 360 ))
    local idx val
    
    if [[ $angle -le 90 ]]; then
        val=${_SIN_TABLE[$((angle + 1))]}
    elif [[ $angle -le 180 ]]; then
        val=${_SIN_TABLE[$((180 - angle + 1))]}
    elif [[ $angle -le 270 ]]; then
        val=-${_SIN_TABLE[$((angle - 180 + 1))]}
    else
        val=-${_SIN_TABLE[$((360 - angle + 1))]}
    fi
    echo ${val:-0}
}

# Get cosine value (angle in degrees 0-360)  
_cos_deg() {
    _sin_deg $(($1 + 90))
}

# Draw clock hand from center to edge
_draw_hand() {
    local cx=$1 cy=$2 len=$3 angle=$4 color=$5 char=$6
    local i px py sin_v cos_v
    
    sin_v=$(_sin_deg $angle)
    cos_v=$(_cos_deg $angle)
    
    for ((i = 1; i <= len; i++)); do
        # Multiply x by 2 for terminal aspect ratio
        px=$(( cx + (i * cos_v * 2) / 1000 ))
        py=$(( cy - (i * sin_v) / 1000 ))
        
        if [[ $px -ge 0 && $py -ge 0 ]]; then
            tput cup $py $px
            printf "\033[38;5;${color}m${char}\033[0m"
        fi
    done
}

# Draw clock face based on shape
_draw_clock_face() {
    local cx=$1 cy=$2 radius=$3 shape=$4
    local i px py angle
    
    case "$shape" in
        square)
            # Draw square frame
            for ((i = -radius; i <= radius; i++)); do
                # Top edge
                tput cup $((cy - radius)) $((cx + i * 2))
                printf '\033[38;5;240m─\033[0m'
                # Bottom edge
                tput cup $((cy + radius)) $((cx + i * 2))
                printf '\033[38;5;240m─\033[0m'
            done
            for ((i = -radius; i <= radius; i++)); do
                # Left edge
                tput cup $((cy + i)) $((cx - radius * 2))
                printf '\033[38;5;240m│\033[0m'
                # Right edge
                tput cup $((cy + i)) $((cx + radius * 2))
                printf '\033[38;5;240m│\033[0m'
            done
            # Corners
            tput cup $((cy - radius)) $((cx - radius * 2)); printf '\033[38;5;245m┌\033[0m'
            tput cup $((cy - radius)) $((cx + radius * 2)); printf '\033[38;5;245m┐\033[0m'
            tput cup $((cy + radius)) $((cx - radius * 2)); printf '\033[38;5;245m└\033[0m'
            tput cup $((cy + radius)) $((cx + radius * 2)); printf '\033[38;5;245m┘\033[0m'
            ;;
        diamond)
            # Draw diamond shape
            for ((i = 0; i <= radius; i++)); do
                local offset=$((radius - i))
                tput cup $((cy - offset)) $((cx - i * 2)); printf '\033[38;5;240m/\033[0m'
                tput cup $((cy - offset)) $((cx + i * 2)); printf '\033[38;5;240m\\\033[0m'
                tput cup $((cy + offset)) $((cx - i * 2)); printf '\033[38;5;240m\\\033[0m'
                tput cup $((cy + offset)) $((cx + i * 2)); printf '\033[38;5;240m/\033[0m'
            done
            ;;
        circle|*)
            # Draw circle (default)
            for ((i = 0; i < 60; i++)); do
                angle=$((i * 6 + 90))  # Start from top (90 degrees)
                px=$(( cx + (radius * $(_cos_deg $angle) * 2) / 1000 ))
                py=$(( cy - (radius * $(_sin_deg $angle)) / 1000 ))
                
                if [[ $px -ge 0 && $py -ge 0 ]]; then
                    tput cup $py $px
                    if [[ $((i % 5)) -eq 0 ]]; then
                        printf '\033[38;5;245m●\033[0m'
                    else
                        printf '\033[38;5;238m·\033[0m'
                    fi
                fi
            done
            ;;
    esac
    
    # Draw hour numbers
    local -a positions
    positions=(
        "12:0:-1"    # 12 o'clock
        "3:1:0"      # 3 o'clock
        "6:0:1"      # 6 o'clock
        "9:-1:0"     # 9 o'clock
    )
    
    for pos in "${positions[@]}"; do
        local num="${pos%%:*}"
        local rest="${pos#*:}"
        local dx="${rest%%:*}"
        local dy="${rest#*:}"
        
        local npx=$((cx + dx * (radius + 1) * 2))
        local npy=$((cy + dy * (radius + 1)))
        
        if [[ $npx -ge 0 && $npy -ge 0 ]]; then
            tput cup $npy $npx
            printf '\033[1;38;5;255m%s\033[0m' "$num"
        fi
    done
}

# Main analog clock function
aclock() {
    local shape="${1:-circle}"  # circle, square, or diamond
    
    tput smcup
    tput civis
    stty -echo
    trap 'tput cnorm; tput rmcup; stty echo; clear; return' INT TERM
    
    clear
    printf '\033[48;5;235m\033[2J'  # Dark gray background
    
    local cols rows cx cy radius
    local hour minute second h_angle m_angle s_angle
    local h_len m_len s_len date_str
    
    cols=$(tput cols)
    rows=$(tput lines)
    
    # Center of clock
    cx=$((cols / 2))
    cy=$((rows / 2 - 2))
    
    # Calculate radius based on terminal size
    if [[ $((cols / 4)) -lt $((rows - 6)) ]]; then
        radius=$((cols / 8 - 1))
    else
        radius=$((rows / 2 - 4))
    fi
    
    # Minimum radius
    [[ $radius -lt 5 ]] && radius=5
    
    # Hand lengths
    h_len=$((radius * 50 / 100))
    m_len=$((radius * 70 / 100))
    s_len=$((radius * 85 / 100))
    
    while true; do
        # Clear clock area
        clear
        printf '\033[48;5;235m\033[2J'
        
        # Get current time
        hour=$(date +%I)
        minute=$(date +%M)
        second=$(date +%S)
        date_str=$(date +"%A, %B %d, %Y")
        
        # Remove leading zeros for calculation
        local h_val=$((10#$hour))
        local m_val=$((10#$minute))
        local s_val=$((10#$second))
        
        # Draw clock face
        _draw_clock_face $cx $cy $radius "$shape"
        
        # Calculate hand angles (0 = right/3 o'clock, going counter-clockwise)
        # We want 12 o'clock = 90 degrees, clockwise movement
        h_angle=$((90 - (h_val * 30 + m_val / 2)))
        m_angle=$((90 - m_val * 6))
        s_angle=$((90 - s_val * 6))
        
        # Draw hands (hour first, then minute, then second on top)
        _draw_hand $cx $cy $h_len $h_angle 214 "█"
        _draw_hand $cx $cy $m_len $m_angle 255 "▓"
        _draw_hand $cx $cy $s_len $s_angle 196 "─"
        
        # Draw center dot
        tput cup $cy $cx
        printf '\033[1;38;5;255m◉\033[0m'
        
        # Draw date below clock
        local date_x=$(( (cols - ${#date_str}) / 2 ))
        tput cup $((cy + radius + 3)) $date_x
        printf '\033[38;5;245m%s\033[0m' "$date_str"
        
        # Draw shape indicator
        tput cup $((rows - 2)) 2
        printf '\033[38;5;238mShape: %s │ Press any key to exit\033[0m' "$shape"
        
        # Wait and check for keypress
        read -t 1 -k 1 2>/dev/null && break
    done
    
    tput cnorm
    tput rmcup
    stty echo
    clear
}

# Fullscreen analog clock lock
alock() {
    local shape="${1:-circle}"
    local was_fullscreen=false
    
    if _is_fullscreen; then
        was_fullscreen=true
    else
        _toggle_fullscreen
        sleep 0.5
    fi
    
    aclock "$shape"
    
    if [[ "$was_fullscreen" == "false" ]]; then
        _toggle_fullscreen
    fi
}

# ─────────────────────────────────────────────────────────────────
# Matrix Rain Screensaver (bonus)
# ─────────────────────────────────────────────────────────────────

matrix() {
    tput smcup
    tput civis
    stty -echo
    trap 'tput cnorm; tput rmcup; stty echo; clear; return' INT TERM
    
    clear
    printf '\033[40m\033[2J'
    
    local cols rows i x y c num_chars effective_cols
    cols=$(tput cols)
    rows=$(tput lines)
    
    # Use array for proper multi-byte character handling
    local -a mchars drops speeds
    mchars=(ア イ ウ エ オ カ キ ク ケ コ サ シ ス セ ソ タ チ ツ テ ト ナ ニ ヌ ネ ノ ハ ヒ フ ヘ ホ マ ミ ム メ モ ヤ ユ ヨ ラ リ ル レ ロ ワ ヲ ン 0 1 2 3 4 5 6 7 8 9)
    num_chars=${#mchars[@]}
    
    # Initialize drops (fewer columns since chars are double-width)
    effective_cols=$((cols / 2))
    for ((i = 1; i <= effective_cols; i++)); do
        drops[$i]=$((RANDOM % rows))
        speeds[$i]=$(( (RANDOM % 3) + 1 ))
    done
    
    while true; do
        for ((i = 1; i <= effective_cols; i++)); do
            y=${drops[$i]}
            x=$((i * 2 - 1))
            c="${mchars[$((RANDOM % num_chars + 1))]}"
            
            # Draw bright head
            tput cup $y $x
            printf "\033[1;38;5;46m${c}\033[0m"
            
            # Fade trail
            if [[ $y -gt 0 ]]; then
                tput cup $((y - 1)) $x
                c="${mchars[$((RANDOM % num_chars + 1))]}"
                printf "\033[38;5;34m${c}\033[0m"
            fi
            if [[ $y -gt 2 ]]; then
                tput cup $((y - 2)) $x
                c="${mchars[$((RANDOM % num_chars + 1))]}"
                printf "\033[38;5;22m${c}\033[0m"
            fi
            
            # Clear old
            if [[ $y -gt 6 ]]; then
                tput cup $((y - 6)) $x
                printf '  '
            fi
            
            # Move drop
            drops[$i]=$((y + speeds[$i]))
            if [[ ${drops[$i]} -gt $rows ]]; then
                drops[$i]=0
                speeds[$i]=$(( (RANDOM % 3) + 1 ))
            fi
        done
        
        read -t 0.03 -k 1 2>/dev/null && break
    done
    
    tput cnorm
    tput rmcup
    stty echo
    clear
}

# ─────────────────────────────────────────────────────────────────
# Pipes Screensaver (bonus)
# ─────────────────────────────────────────────────────────────────

pipes() {
    # Save state
    tput smcup
    tput civis
    stty -echo
    trap 'tput cnorm; tput rmcup; stty echo; clear; return' INT TERM
    
    clear
    printf '\033[40m\033[2J'
    
    local cols rows p x y dir color old_dir c
    cols=$(tput cols)
    rows=$(tput lines)
    
    local -a clrs pipe_x pipe_y pipe_dir pipe_clr
    clrs=(196 208 226 46 51 171 213)
    
    # Initialize 3 pipes
    for p in 1 2 3; do
        pipe_x[$p]=$((RANDOM % cols))
        pipe_y[$p]=$((RANDOM % rows))
        pipe_dir[$p]=$((RANDOM % 4))
        pipe_clr[$p]=${clrs[$((RANDOM % 7 + 1))]}
    done
    
    while true; do
        for p in 1 2 3; do
            x=${pipe_x[$p]}
            y=${pipe_y[$p]}
            dir=${pipe_dir[$p]}
            color=${pipe_clr[$p]}
            
            # Position cursor and draw
            tput cup $y $x
            
            # Select character based on direction
            if [[ $dir -eq 0 || $dir -eq 2 ]]; then
                c="│"
            else
                c="─"
            fi
            printf "\033[38;5;${color}m${c}\033[0m"
            
            # Maybe turn
            if [[ $((RANDOM % 5)) -eq 0 ]]; then
                old_dir=$dir
                if [[ $((RANDOM % 2)) -eq 0 ]]; then
                    dir=$(( (dir + 1) % 4 ))
                else
                    dir=$(( (dir + 3) % 4 ))
                fi
                pipe_dir[$p]=$dir
                
                # Draw corner
                # Directions: 0=up, 1=right, 2=down, 3=left
                # Corner must extend toward previous cell AND next cell
                # └ = UP+RIGHT, ┘ = UP+LEFT, ┌ = DOWN+RIGHT, ┐ = DOWN+LEFT
                tput cup $y $x
                case "${old_dir},${dir}" in
                    2,1|3,0) c="└" ;;  # was going down/left (came from up/right), going right/up
                    1,0|2,3) c="┘" ;;  # was going right/down (came from left/up), going up/left
                    0,1|3,2) c="┌" ;;  # was going up/left (came from down/right), going right/down
                    0,3|1,2) c="┐" ;;  # was going up/right (came from down/left), going left/down
                esac
                printf "\033[38;5;${color}m${c}\033[0m"
            fi
            
            # Move
            case $dir in
                0) y=$((y - 1)) ;;
                1) x=$((x + 1)) ;;
                2) y=$((y + 1)) ;;
                3) x=$((x - 1)) ;;
            esac
            
            # Respawn if out of bounds
            if [[ $x -lt 0 || $x -ge $cols || $y -lt 0 || $y -ge $rows ]]; then
                x=$((RANDOM % cols))
                y=$((RANDOM % rows))
                dir=$((RANDOM % 4))
                color=${clrs[$((RANDOM % 7 + 1))]}
                pipe_clr[$p]=$color
                pipe_dir[$p]=$dir
            fi
            
            pipe_x[$p]=$x
            pipe_y[$p]=$y
        done
        
        read -t 0.03 -k 1 2>/dev/null && break
    done
    
    tput cnorm
    tput rmcup
    stty echo
    clear
}
