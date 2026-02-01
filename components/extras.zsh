#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │                     🌟 Cool Extras                            │
# ╰──────────────────────────────────────────────────────────────╯

# ─────────────────────────────────────────────────────────────────
# 🍅 Pomodoro Timer
# ─────────────────────────────────────────────────────────────────

pomo() {
    local duration="${1:-25}"  # Default 25 minutes
    local label="${2:-Work}"
    
    echo ""
    echo -e "  \033[38;5;196m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;196m│\033[0m        \033[1m🍅 $(_t pomodoro "Pomodoro Timer")\033[0m               \033[38;5;196m│\033[0m"
    echo -e "  \033[38;5;196m╰───────────────────────────────────────╯\033[0m"
    echo ""
    echo -e "  \033[38;5;245m$(_t session "Session"):\033[0m $label"
    echo -e "  \033[38;5;245m$(_t duration "Duration"):\033[0m $duration $(_t minutes "minutes")"
    echo ""
    
    local total_seconds=$((duration * 60))
    local start_time=$(date +%s)
    local end_time=$((start_time + total_seconds))
    
    while [[ $(date +%s) -lt $end_time ]]; do
        local remaining=$((end_time - $(date +%s)))
        local mins=$((remaining / 60))
        local secs=$((remaining % 60))
        local elapsed=$((total_seconds - remaining))
        local progress=$((elapsed * 40 / total_seconds))
        
        local bar=""
        for ((i=0; i<progress; i++)); do bar+="█"; done
        for ((i=progress; i<40; i++)); do bar+="░"; done
        
        printf "\r  🍅 \033[38;5;196m%02d:%02d\033[0m ▐\033[38;5;196m%s\033[0m▌" "$mins" "$secs" "$bar"
        sleep 1
    done
    
    echo ""
    echo ""
    echo -e "  \033[38;5;46m🎉 $(_t pomo_complete "Pomodoro complete! Time for a break!")!\033[0m"
    
    # Cross-platform notification
    _notify "🍅 $(_t pomo_complete "Pomodoro Complete")" "$(_t break_time "Time for a break!")"
    
    # Terminal bell
    printf '\a'
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 📝 Quick Notes
# ─────────────────────────────────────────────────────────────────

NOTES_FILE="$HOME/.terminup_notes"

note() {
    local cmd="${1:-list}"
    
    case "$cmd" in
        add|a)
            shift
            local note_text="$*"
            if [[ -z "$note_text" ]]; then
                echo -ne "  \033[38;5;226m📝 $(_t note "Note"):\033[0m "
                read note_text
            fi
            if [[ -n "$note_text" ]]; then
                echo "$(date '+%Y-%m-%d %H:%M') | $note_text" >> "$NOTES_FILE"
                echo -e "  \033[38;5;46m✓\033[0m $(_t note_saved "Note saved")!"
            fi
            ;;
            
        list|ls|l)
            echo ""
            echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
            echo -e "  \033[38;5;51m│\033[0m           \033[1m📝 $(_t quick_notes "Quick Notes")\033[0m               \033[38;5;51m│\033[0m"
            echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
            echo ""
            
            if [[ -f "$NOTES_FILE" && -s "$NOTES_FILE" ]]; then
                local i=1
                while IFS= read -r line; do
                    local date="${line%% |*}"
                    local text="${line#* | }"
                    echo -e "    \033[38;5;245m$i.\033[0m \033[38;5;240m$date\033[0m"
                    echo -e "       $text"
                    echo ""
                    ((i++))
                done < "$NOTES_FILE"
            else
                echo -e "    \033[38;5;240m$(_t no_notes "No notes yet. Add one with: note add <text>")\033[0m"
            fi
            echo ""
            ;;
            
        clear)
            echo -n "" > "$NOTES_FILE"
            echo -e "  \033[38;5;46m✓\033[0m $(_t notes_cleared "Notes cleared")!"
            ;;
            
        pop)
            if [[ -f "$NOTES_FILE" && -s "$NOTES_FILE" ]]; then
                local last=$(tail -1 "$NOTES_FILE")
                sed -i '' '$d' "$NOTES_FILE" 2>/dev/null || sed '$d' "$NOTES_FILE" > "$NOTES_FILE.tmp" && mv "$NOTES_FILE.tmp" "$NOTES_FILE"
                echo -e "  \033[38;5;196m✓\033[0m $(_t removed "Removed"): ${last#* | }"
            fi
            ;;
            
        *)
            # Treat as adding a note
            local note_text="$*"
            echo "$(date '+%Y-%m-%d %H:%M') | $note_text" >> "$NOTES_FILE"
            echo -e "  \033[38;5;46m✓\033[0m $(_t note_saved "Note saved")!"
            ;;
    esac
}

# ─────────────────────────────────────────────────────────────────
# 💡 Random Programming Quote
# ─────────────────────────────────────────────────────────────────

quote() {
    local quotes=(
        "Code is like humor. When you have to explain it, it's bad.|Cory House"
        "First, solve the problem. Then, write the code.|John Johnson"
        "Experience is the name everyone gives to their mistakes.|Oscar Wilde"
        "Programming isn't about what you know; it's about what you can figure out.|Chris Pine"
        "The only way to learn a new programming language is by writing programs in it.|Dennis Ritchie"
        "Sometimes it pays to stay in bed on Monday, rather than spending the rest of the week debugging Monday's code.|Dan Salomon"
        "Measuring programming progress by lines of code is like measuring aircraft building progress by weight.|Bill Gates"
        "Any fool can write code that a computer can understand. Good programmers write code that humans can understand.|Martin Fowler"
        "The best error message is the one that never shows up.|Thomas Fuchs"
        "Simplicity is the soul of efficiency.|Austin Freeman"
        "Make it work, make it right, make it fast.|Kent Beck"
        "Debugging is twice as hard as writing the code in the first place.|Brian Kernighan"
        "The most disastrous thing you can ever learn is your first programming language.|Alan Kay"
        "Talk is cheap. Show me the code.|Linus Torvalds"
        "Programs must be written for people to read, and only incidentally for machines to execute.|Harold Abelson"
    )
    
    local random_quote="${quotes[$((RANDOM % ${#quotes[@]} + 1))]}"
    local text="${random_quote%|*}"
    local author="${random_quote#*|}"
    
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m                    \033[1m💡 $(_t quote_of_day "Quote of the Day")\033[0m                   \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────────────────────────╯\033[0m"
    echo ""
    echo -e "    \033[3;38;5;252m\"$text\"\033[0m"
    echo ""
    echo -e "    \033[38;5;245m— $author\033[0m"
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 🎲 Decision Maker
# ─────────────────────────────────────────────────────────────────

decide() {
    local options=("$@")
    
    if [[ ${#options[@]} -lt 2 ]]; then
        echo -e "  \033[38;5;196m✗ $(_t need_options "Please provide at least 2 options")\033[0m"
        echo -e "  \033[38;5;245m$(_t usage "Usage"): decide option1 option2 [option3...]\033[0m"
        return 1
    fi
    
    echo ""
    echo -e "  \033[38;5;51m🎲 $(_t deciding "Let me decide")...\033[0m"
    
    # Suspenseful animation
    for i in {1..10}; do
        local random_option="${options[$((RANDOM % ${#options[@]} + 1))]}"
        printf "\r    → \033[38;5;226m%s\033[0m   " "$random_option"
        sleep 0.1
    done
    
    local final_choice="${options[$((RANDOM % ${#options[@]} + 1))]}"
    echo -e "\r    → \033[1;38;5;46m$final_choice\033[0m 🎉   "
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# ⏰ Countdown Timer
# ─────────────────────────────────────────────────────────────────

countdown() {
    local seconds="${1:-10}"
    
    echo ""
    echo -e "  \033[38;5;51m⏰ $(_t countdown "Countdown"): $seconds $(_t seconds "seconds")\033[0m"
    echo ""
    
    for ((i=seconds; i>0; i--)); do
        printf "\r    \033[1;38;5;226m%d\033[0m  " "$i"
        sleep 1
    done
    
    echo -e "\r    \033[1;38;5;46m🎉 GO!\033[0m  "
    printf '\a'
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 📊 System Stats (Quick) - Cross-platform
# ─────────────────────────────────────────────────────────────────

stats() {
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m           \033[1m📊 $(_t system_stats "System Stats")\033[0m              \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    
    case "$TERMINUP_OS" in
        macos)
            # CPU
            local cpu=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | tr -d '%')
            echo -e "    \033[38;5;39m💻 CPU:\033[0m ${cpu:-N/A}%"
            
            # Memory
            local mem_used=$(vm_stat | awk '/Pages active/ {print $3}' | tr -d '.')
            local mem_free=$(vm_stat | awk '/Pages free/ {print $3}' | tr -d '.')
            if [[ -n "$mem_used" && -n "$mem_free" ]]; then
                local mem_total=$((mem_used + mem_free))
                local mem_percent=$((mem_used * 100 / mem_total))
                echo -e "    \033[38;5;208m🧠 Memory:\033[0m ~${mem_percent}% used"
            fi
            
            # Battery
            local battery=$(pmset -g batt 2>/dev/null | grep -o '[0-9]*%' | head -1)
            [[ -n "$battery" ]] && echo -e "    \033[38;5;141m🔋 Battery:\033[0m $battery"
            ;;
            
        linux)
            # CPU
            local cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
            echo -e "    \033[38;5;39m💻 CPU:\033[0m ${cpu:-N/A}%"
            
            # Memory
            local mem_info=$(free -m | awk 'NR==2{printf "%.0f", $3*100/$2 }')
            echo -e "    \033[38;5;208m🧠 Memory:\033[0m ${mem_info}% used"
            
            # Battery (if available)
            local battery=$(_battery 2>/dev/null)
            [[ -n "$battery" ]] && echo -e "    \033[38;5;141m🔋 Battery:\033[0m $battery"
            ;;
            
        windows)
            echo -e "    \033[38;5;245m(Stats limited on Windows)\033[0m"
            ;;
    esac
    
    # Disk (cross-platform)
    local disk=$(df -h / 2>/dev/null | awk 'NR==2 {print $5}')
    echo -e "    \033[38;5;226m💾 Disk:\033[0m $disk used"
    
    # Uptime (cross-platform)
    local uptime_str=$(uptime 2>/dev/null | awk -F'up ' '{print $2}' | awk -F',' '{print $1}')
    echo -e "    \033[38;5;46m⏱️  Uptime:\033[0m $uptime_str"
    
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 🔐 Password Generator (Cross-platform)
# ─────────────────────────────────────────────────────────────────

genpass() {
    local length="${1:-16}"
    local password=$(LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()_+' </dev/urandom | head -c "$length")
    
    echo ""
    echo -e "  \033[38;5;46m🔐 $(_t generated_password "Generated password") ($length chars):\033[0m"
    echo ""
    echo -e "    \033[1;38;5;226m$password\033[0m"
    echo ""
    
    # Cross-platform copy to clipboard
    _copy "$password"
    echo -e "  \033[38;5;245m($(_t copied_clipboard "Copied to clipboard"))\033[0m"
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 🌈 ASCII Art Text
# ─────────────────────────────────────────────────────────────────

banner() {
    local text="${1:-Hello}"
    local color="${2:-51}"
    
    echo ""
    # Simple ASCII art letters
    echo -e "\033[38;5;${color}m"
    figlet "$text" 2>/dev/null || echo "  $text"
    echo -e "\033[0m"
}

# ─────────────────────────────────────────────────────────────────
# 🎵 Spotify Control (macOS only)
# ─────────────────────────────────────────────────────────────────

if [[ "$TERMINUP_OS" == "macos" ]]; then
    spotify() {
        local cmd="${1:-status}"
        
        case "$cmd" in
            play)
                osascript -e 'tell application "Spotify" to play'
                echo -e "  \033[38;5;46m▶\033[0m $(_t playing "Playing")"
                ;;
            pause)
                osascript -e 'tell application "Spotify" to pause'
                echo -e "  \033[38;5;208m⏸\033[0m $(_t paused "Paused")"
                ;;
            next)
                osascript -e 'tell application "Spotify" to next track'
                sleep 0.5
                spotify status
                ;;
            prev)
                osascript -e 'tell application "Spotify" to previous track'
                sleep 0.5
                spotify status
                ;;
            status|s)
                local track=$(osascript -e 'tell application "Spotify" to name of current track' 2>/dev/null)
                local artist=$(osascript -e 'tell application "Spotify" to artist of current track' 2>/dev/null)
                
                if [[ -n "$track" ]]; then
                    echo ""
                    echo -e "  \033[38;5;46m🎵 $(_t now_playing "Now Playing"):\033[0m"
                    echo -e "    \033[38;5;252m$track\033[0m"
                    echo -e "    \033[38;5;245m$artist\033[0m"
                    echo ""
                else
                    echo -e "  \033[38;5;245mSpotify $(_t not_playing "not playing")\033[0m"
                fi
                ;;
            *)
                echo -e "  \033[38;5;245m$(_t usage "Usage"): spotify [play|pause|next|prev|status]\033[0m"
                ;;
        esac
    }
fi

# ─────────────────────────────────────────────────────────────────
# 📅 Quick Calendar
# ─────────────────────────────────────────────────────────────────

cal() {
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m           \033[1m📅 $(_t calendar "Calendar")\033[0m                   \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    command cal "$@"
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 🧹 Quick Cleanup
# ─────────────────────────────────────────────────────────────────

cleanup() {
    echo ""
    echo -e "  \033[38;5;51m🧹 $(_t quick_cleanup "Quick Cleanup")\033[0m"
    echo ""
    
    # Clear terminal history for current session
    local cmd="${1:-help}"
    
    case "$cmd" in
        cache)
            echo -e "  \033[38;5;208m▶ $(_t clearing_npm "Clearing npm cache")...\033[0m"
            npm cache clean --force 2>/dev/null
            echo -e "  \033[38;5;208m▶ $(_t clearing_pnpm "Clearing pnpm cache")...\033[0m"
            pnpm store prune 2>/dev/null
            echo -e "  \033[38;5;46m✓ $(_t cache_cleared "Cache cleared")!\033[0m"
            ;;
        node)
            echo -e "  \033[38;5;208m▶ $(_t removing_node "Removing node_modules")...\033[0m"
            rm -rf node_modules
            echo -e "  \033[38;5;46m✓ node_modules $(_t removed "removed")!\033[0m"
            ;;
        ds)
            echo -e "  \033[38;5;208m▶ $(_t removing_ds "Removing .DS_Store files")...\033[0m"
            find . -name '.DS_Store' -delete 2>/dev/null
            echo -e "  \033[38;5;46m✓ .DS_Store $(_t files_removed "files removed")!\033[0m"
            ;;
        git)
            echo -e "  \033[38;5;208m▶ $(_t cleaning_git "Cleaning git")...\033[0m"
            git gc --prune=now
            git remote prune origin 2>/dev/null
            echo -e "  \033[38;5;46m✓ Git $(_t cleaned "cleaned")!\033[0m"
            ;;
        all)
            cleanup cache
            cleanup ds
            cleanup git
            ;;
        *)
            echo -e "  \033[38;5;245m$(_t usage "Usage"): cleanup [cache|node|ds|git|all]\033[0m"
            echo ""
            echo -e "    cache  - $(_t clear_cache "Clear npm/pnpm cache")"
            echo -e "    node   - $(_t remove_node "Remove node_modules")"
            echo -e "    ds     - $(_t remove_ds "Remove .DS_Store files")"
            echo -e "    git    - $(_t clean_git "Clean git (gc + prune)")"
            echo -e "    all    - $(_t run_all "Run all cleanups")"
            ;;
    esac
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 🔍 Quick Web Search (Cross-platform)
# ─────────────────────────────────────────────────────────────────

google() {
    local query="${*// /+}"
    _open "https://www.google.com/search?q=$query"
    echo -e "  \033[38;5;46m✓\033[0m $(_t searching "Searching for"): $*"
}

stackoverflow() {
    local query="${*// /+}"
    _open "https://stackoverflow.com/search?q=$query"
    echo -e "  \033[38;5;46m✓\033[0m $(_t searching_so "Searching Stack Overflow for"): $*"
}

github() {
    local query="${*// /+}"
    if [[ -z "$query" ]]; then
        _open "https://github.com"
    else
        _open "https://github.com/search?q=$query"
        echo -e "  \033[38;5;46m✓\033[0m $(_t searching_gh "Searching GitHub for"): $*"
    fi
}

# ─────────────────────────────────────────────────────────────────
# 🎯 Focus Mode
# ─────────────────────────────────────────────────────────────────

focus() {
    local duration="${1:-30}"
    
    echo ""
    echo -e "  \033[38;5;196m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;196m│\033[0m          \033[1m🎯 $(_t focus_active "Focus Mode Active")\033[0m          \033[38;5;196m│\033[0m"
    echo -e "  \033[38;5;196m╰───────────────────────────────────────╯\033[0m"
    echo ""
    echo -e "  \033[38;5;245m$(_t duration "Duration"):\033[0m $duration $(_t minutes "minutes")"
    echo -e "  \033[38;5;245m$(_t stay_focused "Stay focused! No distractions!")!\033[0m"
    echo ""
    
    # Start pomodoro
    pomo $duration "Focus Session"
}
