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

# Check if terminal is in fullscreen (macOS only, returns false on other platforms)
_is_fullscreen() {
    [[ "$TERMINUP_OS" != "macos" ]] && return 1
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

# Toggle fullscreen for the current terminal window (macOS only)
_toggle_fullscreen() {
    [[ "$TERMINUP_OS" != "macos" ]] && return
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

# Lock the system (cross-platform)
syslock() {
    echo -e "  \033[38;5;208m🔒 $(_t locking_system "Locking system")...\033[0m"
    sleep 0.3
    _lock_screen
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
            # Include background color to prevent artifacts
            printf "\033[48;5;235;38;5;${color}m${char}\033[0m"
        fi
    done
}

# Draw a regular polygon with n sides
_draw_polygon() {
    local cx=$1 cy=$2 radius=$3 sides=$4
    local i j x1 y1 x2 y2 angle1 angle2 steps dx dy
    local step_angle=$((360 / sides))
    
    # Draw each edge of the polygon
    for ((i = 0; i < sides; i++)); do
        # Calculate vertices (start from top, 90 degrees)
        angle1=$((90 + i * step_angle))
        angle2=$((90 + (i + 1) * step_angle))
        
        x1=$(( cx + (radius * $(_cos_deg $angle1) * 2) / 1000 ))
        y1=$(( cy - (radius * $(_sin_deg $angle1)) / 1000 ))
        x2=$(( cx + (radius * $(_cos_deg $angle2) * 2) / 1000 ))
        y2=$(( cy - (radius * $(_sin_deg $angle2)) / 1000 ))
        
        # Draw line between vertices using interpolation
        dx=$((x2 - x1))
        dy=$((y2 - y1))
        
        # Number of steps based on distance
        if [[ ${dx#-} -gt ${dy#-} ]]; then
            steps=${dx#-}
        else
            steps=${dy#-}
        fi
        [[ $steps -eq 0 ]] && steps=1
        
        for ((j = 0; j <= steps; j++)); do
            local px=$((x1 + dx * j / steps))
            local py=$((y1 + dy * j / steps))
            
            if [[ $px -ge 0 && $py -ge 0 ]]; then
                tput cup $py $px
                # Use different characters based on line angle
                if [[ ${dx#-} -gt $((${dy#-} * 2)) ]]; then
                    printf '\033[38;5;240m─\033[0m'
                elif [[ ${dy#-} -gt $((${dx#-} * 2)) ]]; then
                    printf '\033[38;5;240m│\033[0m'
                elif [[ $dx -gt 0 && $dy -lt 0 ]] || [[ $dx -lt 0 && $dy -gt 0 ]]; then
                    printf '\033[38;5;240m/\033[0m'
                else
                    printf '\033[38;5;240m\\\033[0m'
                fi
            fi
        done
        
        # Draw vertex marker
        if [[ $x1 -ge 0 && $y1 -ge 0 ]]; then
            tput cup $y1 $x1
            printf '\033[38;5;245m●\033[0m'
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
            # Draw diamond shape (4 sides, rotated square)
            for ((i = 0; i <= radius; i++)); do
                local offset=$((radius - i))
                tput cup $((cy - offset)) $((cx - i * 2)); printf '\033[38;5;240m/\033[0m'
                tput cup $((cy - offset)) $((cx + i * 2)); printf '\033[38;5;240m\\\033[0m'
                tput cup $((cy + offset)) $((cx - i * 2)); printf '\033[38;5;240m\\\033[0m'
                tput cup $((cy + offset)) $((cx + i * 2)); printf '\033[38;5;240m/\033[0m'
            done
            ;;
        hexagon)
            # Draw hexagon (6 sides) - vertices every 60 degrees
            _draw_polygon $cx $cy $radius 6
            ;;
        octagon)
            # Draw octagon (8 sides) - vertices every 45 degrees
            _draw_polygon $cx $cy $radius 8
            ;;
        decagon)
            # Draw decagon (10 sides) - vertices every 36 degrees
            _draw_polygon $cx $cy $radius 10
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

# Erase a hand by drawing spaces along its path (preserving background)
_erase_hand() {
    local cx=$1 cy=$2 len=$3 angle=$4
    local i px py sin_v cos_v
    
    sin_v=$(_sin_deg $angle)
    cos_v=$(_cos_deg $angle)
    
    for ((i = 1; i <= len; i++)); do
        px=$(( cx + (i * cos_v * 2) / 1000 ))
        py=$(( cy - (i * sin_v) / 1000 ))
        
        if [[ $px -ge 0 && $py -ge 0 ]]; then
            tput cup $py $px
            # Preserve the dark gray background (color 235)
            printf '\033[48;5;235m \033[0m'
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
    local prev_h_angle prev_m_angle prev_s_angle
    local first_draw=true
    
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
    
    # Draw static elements once
    _draw_clock_face $cx $cy $radius "$shape"
    
    # Draw date below clock
    date_str=$(date +"%A, %B %d, %Y")
    local date_x=$(( (cols - ${#date_str}) / 2 ))
    tput cup $((cy + radius + 3)) $date_x
    printf '\033[38;5;245m%s\033[0m' "$date_str"
    
    # Draw shape indicator
    tput cup $((rows - 2)) 2
    printf '\033[38;5;238mShape: %s │ Press any key to exit\033[0m' "$shape"
    
    # Initialize previous angles
    prev_h_angle=999
    prev_m_angle=999
    prev_s_angle=999
    
    while true; do
        # Get current time
        hour=$(date +%I)
        minute=$(date +%M)
        second=$(date +%S)
        
        # Remove leading zeros for calculation
        local h_val=$((10#$hour))
        local m_val=$((10#$minute))
        local s_val=$((10#$second))
        
        # Calculate hand angles
        h_angle=$((90 - (h_val * 30 + m_val / 2)))
        m_angle=$((90 - m_val * 6))
        s_angle=$((90 - s_val * 6))
        
        # Only redraw if angles changed
        if [[ $s_angle -ne $prev_s_angle || $first_draw == true ]]; then
            
            # Erase previous hands (if not first draw)
            if [[ $first_draw != true ]]; then
                _erase_hand $cx $cy $s_len $prev_s_angle
                
                # Only erase minute/hour if they changed
                if [[ $m_angle -ne $prev_m_angle ]]; then
                    _erase_hand $cx $cy $m_len $prev_m_angle
                fi
                if [[ $h_angle -ne $prev_h_angle ]]; then
                    _erase_hand $cx $cy $h_len $prev_h_angle
                fi
            fi
            
            # Draw hands (hour first, then minute, then second on top)
            _draw_hand $cx $cy $h_len $h_angle 214 "█"
            _draw_hand $cx $cy $m_len $m_angle 255 "▓"
            _draw_hand $cx $cy $s_len $s_angle 196 "─"
            
            # Draw center dot (might get overwritten by erase)
            tput cup $cy $cx
            printf '\033[1;38;5;255m◉\033[0m'
            
            # Update date at midnight
            if [[ $h_val -eq 12 && $m_val -eq 0 && $s_val -eq 0 ]]; then
                date_str=$(date +"%A, %B %d, %Y")
                tput cup $((cy + radius + 3)) $date_x
                printf '\033[38;5;245m%s\033[0m' "$date_str"
            fi
            
            # Store current angles
            prev_h_angle=$h_angle
            prev_m_angle=$m_angle
            prev_s_angle=$s_angle
            first_draw=false
        fi
        
        # Wait and check for keypress
        read -t 0.5 -k 1 2>/dev/null && break
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

# ═══════════════════════════════════════════════════════════════════
# 🌧️ Rain Animation
# ═══════════════════════════════════════════════════════════════════

rain() {
    tput smcup
    tput civis
    stty -echo
    clear
    
    local cols=$(tput cols)
    local rows=$(tput lines)
    
    # Rain drops: position and speed
    typeset -A drops_y drops_speed drops_char
    local num_drops=$((cols / 2))
    local rain_chars=('│' '┃' '|' '¦' '╎' '╏')
    local splash_chars=('·' '.' '∙' '°' '•')
    
    # Initialize drops
    for ((i=1; i<=num_drops; i++)); do
        drops_y[$i]=$((RANDOM % rows))
        drops_speed[$i]=$((RANDOM % 3 + 1))
        drops_char[$i]=${rain_chars[$((RANDOM % 6 + 1))]}
    done
    
    trap 'tput cnorm; tput rmcup; stty echo; return' INT TERM
    
    while true; do
        for ((i=1; i<=num_drops; i++)); do
            local x=$((i * 2 % cols))
            local y=${drops_y[$i]}
            local speed=${drops_speed[$i]}
            local char=${drops_char[$i]}
            
            # Erase old position
            tput cup $y $x
            printf " "
            
            # Move drop
            y=$((y + speed))
            
            # Splash and reset
            if [[ $y -ge $rows ]]; then
                # Show splash
                tput cup $((rows - 1)) $x
                printf "\033[38;5;39m%s\033[0m" "${splash_chars[$((RANDOM % 5 + 1))]}"
                
                # Reset drop
                y=0
                drops_speed[$i]=$((RANDOM % 3 + 1))
                drops_char[$i]=${rain_chars[$((RANDOM % 6 + 1))]}
            fi
            
            drops_y[$i]=$y
            
            # Draw new position
            tput cup $y $x
            local shade=$((232 + RANDOM % 8))
            printf "\033[38;5;%dm%s\033[0m" "$shade" "$char"
        done
        
        read -t 0.05 -k 1 2>/dev/null && break
    done
    
    tput cnorm
    tput rmcup
    stty echo
}

# ═══════════════════════════════════════════════════════════════════
# 🔥 Fire Animation
# ═══════════════════════════════════════════════════════════════════

fire() {
    tput smcup
    tput civis
    stty -echo
    clear
    
    local cols=$(tput cols)
    local rows=$(tput lines)
    local height=$((rows / 2))
    [[ $height -gt 20 ]] && height=20
    
    trap 'tput cnorm; tput rmcup; stty echo; return' INT TERM
    
    # Simpler fire - just random flames per column
    while true; do
        for ((row=0; row<height; row++)); do
            tput cup $((rows - row - 1)) 0
            for ((col=0; col<cols; col++)); do
                local intensity=$((RANDOM % 100))
                local fade=$((row * 8))
                intensity=$((intensity - fade))
                [[ $intensity -lt 0 ]] && intensity=0
                
                if [[ $intensity -gt 80 ]]; then
                    echo -ne "\033[38;5;231m█\033[0m"
                elif [[ $intensity -gt 60 ]]; then
                    echo -ne "\033[38;5;226m▓\033[0m"
                elif [[ $intensity -gt 40 ]]; then
                    echo -ne "\033[38;5;208m▒\033[0m"
                elif [[ $intensity -gt 20 ]]; then
                    echo -ne "\033[38;5;196m░\033[0m"
                elif [[ $intensity -gt 5 ]]; then
                    echo -ne "\033[38;5;52m.\033[0m"
                else
                    echo -ne " "
                fi
            done
        done
        
        read -t 0.1 -k 1 2>/dev/null && break
    done
    
    tput cnorm
    tput rmcup
    stty echo
}

# ═══════════════════════════════════════════════════════════════════
# 🐠 Aquarium Animation
# ═══════════════════════════════════════════════════════════════════

aquarium() {
    tput smcup
    tput civis
    stty -echo
    clear
    
    integer cols=$(tput cols)
    integer rows=$(tput lines)
    integer num_fish=6
    integer num_bubbles=8
    
    # Pre-define fish positions as simple integers
    integer -a fpx fpy fdir fspd fclr
    integer i
    
    for ((i=1; i<=num_fish; i++)); do
        fpx[i]=$((RANDOM % (cols - 10) + 5))
        fpy[i]=$((RANDOM % (rows - 4) + 2))
        fdir[i]=$((RANDOM % 2))
        fspd[i]=$((RANDOM % 2 + 1))
        fclr[i]=$((RANDOM % 6 + 1))
    done
    
    integer -a bpx bpy
    for ((i=1; i<=num_bubbles; i++)); do
        bpx[i]=$((RANDOM % cols))
        bpy[i]=$((RANDOM % rows))
    done
    
    # Color codes
    integer -a colors
    colors=(196 208 226 46 51 213)
    
    trap 'tput cnorm; tput rmcup; stty echo; return' INT TERM
    
    echo -e "\033[48;5;17m\033[2J"
    
    while true; do
        # Bubbles
        for ((i=1; i<=num_bubbles; i++)); do
            tput cup ${bpy[i]} ${bpx[i]}
            echo -ne "\033[48;5;17m \033[0m"
            ((bpy[i]--))
            ((bpx[i] += RANDOM % 3 - 1))
            [[ ${bpy[i]} -lt 0 ]] && bpy[i]=$((rows - 1)) && bpx[i]=$((RANDOM % cols))
            [[ ${bpx[i]} -lt 0 ]] && bpx[i]=0
            [[ ${bpx[i]} -ge $cols ]] && bpx[i]=$((cols - 1))
            tput cup ${bpy[i]} ${bpx[i]}
            echo -ne "\033[48;5;17m\033[38;5;159m°\033[0m"
        done
        
        # Fish - draw directly without intermediate variables
        for ((i=1; i<=num_fish; i++)); do
            # Erase old position
            tput cup ${fpy[i]} ${fpx[i]}
            echo -ne "\033[48;5;17m        \033[0m"
            
            # Move
            if [[ ${fdir[i]} -eq 0 ]]; then
                ((fpx[i] += fspd[i]))
                [[ ${fpx[i]} -gt $((cols - 8)) ]] && fdir[i]=1 && fpx[i]=$((cols - 8))
            else
                ((fpx[i] -= fspd[i]))
                [[ ${fpx[i]} -lt 0 ]] && fdir[i]=0 && fpx[i]=0
            fi
            
            # Random Y
            [[ $((RANDOM % 15)) -eq 0 ]] && ((fpy[i] += RANDOM % 3 - 1))
            [[ ${fpy[i]} -lt 1 ]] && fpy[i]=1
            [[ ${fpy[i]} -ge $((rows - 1)) ]] && fpy[i]=$((rows - 2))
            
            # Draw fish directly
            tput cup ${fpy[i]} ${fpx[i]}
            if [[ ${fdir[i]} -eq 0 ]]; then
                echo -ne "\033[48;5;17m\033[38;5;${colors[${fclr[i]}]}m><>    \033[0m"
            else
                echo -ne "\033[48;5;17m\033[38;5;${colors[${fclr[i]}]}m    <><\033[0m"
            fi
        done
        
        read -t 0.12 -k 1 2>/dev/null && break
    done
    
    tput cnorm
    tput rmcup
    stty echo
}

# ═══════════════════════════════════════════════════════════════════
# ⭐ Stars/Starfield Animation
# ═══════════════════════════════════════════════════════════════════

stars() {
    tput smcup
    tput civis
    stty -echo
    
    local cols rows i x y b
    cols=$(tput cols)
    rows=$(tput lines)
    
    trap 'tput cnorm; tput rmcup; stty echo; return' INT TERM
    
    # Dark space background
    printf '\033[48;5;16m\033[2J'
    
    # Create star field - just draw random stars each frame
    while true; do
        # Draw ~30 random stars
        for ((i=0; i<30; i++)); do
            x=$((RANDOM % cols))
            y=$((RANDOM % rows))
            b=$((RANDOM % 24 + 232))
            
            tput cup $y $x
            if ((b > 250)); then
                printf "\033[48;5;16m\033[38;5;%dm✦\033[0m" "$b"
            elif ((b > 245)); then
                printf "\033[48;5;16m\033[38;5;%dm*\033[0m" "$b"
            else
                printf "\033[48;5;16m\033[38;5;%dm.\033[0m" "$b"
            fi
        done
        
        # Erase some random spots for twinkling effect
        for ((i=0; i<10; i++)); do
            x=$((RANDOM % cols))
            y=$((RANDOM % rows))
            tput cup $y $x
            printf "\033[48;5;16m \033[0m"
        done
        
        read -t 0.15 -k 1 2>/dev/null && break
    done
    
    tput cnorm
    tput rmcup
    stty echo
}

# ═══════════════════════════════════════════════════════════════════
# 📀 DVD Bounce Animation
# ═══════════════════════════════════════════════════════════════════

bounce() {
    tput smcup
    tput civis
    stty -echo
    clear
    
    local cols=$(tput cols)
    local rows=$(tput lines)
    
    local logo=(
        "╔═══════════╗"
        "║  D V D    ║"
        "║   VIDEO   ║"
        "╚═══════════╝"
    )
    local logo_w=13
    local logo_h=4
    
    local x=$((RANDOM % (cols - logo_w)))
    local y=$((RANDOM % (rows - logo_h)))
    local dx=1
    local dy=1
    
    local colors=(196 208 226 46 51 201 213 39 199 129)
    local color_idx=1
    local corner_hits=0
    
    trap 'tput cnorm; tput rmcup; stty echo; return' INT TERM
    
    while true; do
        for ((i=0; i<logo_h; i++)); do
            tput cup $((y + i)) $x
            printf "%${logo_w}s" ""
        done
        
        x=$((x + dx))
        y=$((y + dy))
        
        local hit_wall=0
        
        if [[ $x -le 0 || $x -ge $((cols - logo_w)) ]]; then
            dx=$((-dx))
            hit_wall=1
        fi
        if [[ $y -le 0 || $y -ge $((rows - logo_h)) ]]; then
            dy=$((-dy))
            ((hit_wall++))
        fi
        
        if [[ $hit_wall -gt 0 ]]; then
            color_idx=$(( (color_idx % 10) + 1 ))
        fi
        
        if [[ $hit_wall -eq 2 ]]; then
            ((corner_hits++))
            for ((flash=0; flash<3; flash++)); do
                for ((i=0; i<logo_h; i++)); do
                    tput cup $((y + i)) $x
                    printf "\033[1;38;5;231m%s\033[0m" "${logo[$((i+1))]}"
                done
                sleep 0.05
                for ((i=0; i<logo_h; i++)); do
                    tput cup $((y + i)) $x
                    printf "\033[38;5;${colors[$color_idx]}m%s\033[0m" "${logo[$((i+1))]}"
                done
                sleep 0.05
            done
        fi
        
        [[ $x -lt 0 ]] && x=0
        [[ $y -lt 0 ]] && y=0
        [[ $x -gt $((cols - logo_w)) ]] && x=$((cols - logo_w))
        [[ $y -gt $((rows - logo_h)) ]] && y=$((rows - logo_h))
        
        local color=${colors[$color_idx]}
        for ((i=0; i<logo_h; i++)); do
            tput cup $((y + i)) $x
            printf "\033[38;5;%dm%s\033[0m" "$color" "${logo[$((i+1))]}"
        done
        
        tput cup 0 0
        printf "\033[38;5;245mCorner hits: %d\033[0m" "$corner_hits"
        
        read -t 0.06 -k 1 2>/dev/null && break
    done
    
    tput cnorm
    tput rmcup
    stty echo
}
