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

# ─────────────────────────────────────────────────────────────────
# 📤 Quick Share (upload file to temp host)
# ─────────────────────────────────────────────────────────────────

share() {
    local file="$1"
    
    if [[ -z "$file" ]]; then
        echo -e "  \033[38;5;196m✗\033[0m Usage: share <file>"
        return 1
    fi
    
    if [[ ! -f "$file" ]]; then
        echo -e "  \033[38;5;196m✗\033[0m File not found: $file"
        return 1
    fi
    
    # Check file size (most services limit to ~100MB)
    local size=$(wc -c < "$file" 2>/dev/null)
    if [[ $size -gt 104857600 ]]; then
        echo -e "  \033[38;5;196m✗\033[0m File too large (max 100MB)"
        return 1
    fi
    
    echo -e "  \033[38;5;51m📤 Uploading...\033[0m"
    
    local url=""
    local filename=$(basename "$file")
    
    # Try litterbox.catbox.moe (reliable, allows larger files)
    url=$(curl -s -F "reqtype=fileupload" -F "time=72h" -F "fileToUpload=@$file" "https://litterbox.catbox.moe/resources/internals/api.php" 2>/dev/null)
    
    # Fallback to 0x0.st
    if [[ -z "$url" || ! "$url" =~ ^https?:// ]]; then
        url=$(curl -s -F "file=@$file" "https://0x0.st" 2>/dev/null)
    fi
    
    # Fallback to bashupload.com
    if [[ -z "$url" || ! "$url" =~ ^https?:// ]]; then
        local response=$(curl -s -T "$file" "https://bashupload.com/$filename" 2>/dev/null)
        url=$(echo "$response" | grep -o 'https://bashupload.com/[^ ]*' | head -1)
    fi
    
    if [[ -n "$url" && "$url" =~ ^https?:// ]]; then
        echo -e "  \033[38;5;46m✓\033[0m Uploaded!"
        echo ""
        echo -e "  \033[38;5;226mURL:\033[0m $url"
        echo ""
        _copy "$url" 2>/dev/null
        echo -e "  \033[38;5;245m(Copied to clipboard)\033[0m"
    else
        echo -e "  \033[38;5;196m✗\033[0m Upload failed"
        echo -e "  \033[38;5;245mPossible causes:\033[0m"
        echo -e "  \033[38;5;245m  • No internet connection\033[0m"
        echo -e "  \033[38;5;245m  • File hosting services are down\033[0m"
        echo -e "  \033[38;5;245m  • File type not allowed\033[0m"
    fi
}

# ─────────────────────────────────────────────────────────────────
# 📱 QR Code Generator
# ─────────────────────────────────────────────────────────────────

qr() {
    local text="$*"
    
    if [[ -z "$text" ]]; then
        echo -e "  \033[38;5;196m✗\033[0m Usage: qr <text or url>"
        return 1
    fi
    
    echo ""
    echo -e "  \033[38;5;51m📱 QR Code:\033[0m"
    echo ""
    
    # Try qrencode first
    if command -v qrencode &>/dev/null; then
        qrencode -t ANSI256 -o - "$text"
    else
        # Fallback to online API
        curl -s "https://qrenco.de/$text" 2>/dev/null || echo "  Install qrencode for offline QR codes: brew install qrencode"
    fi
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 🔔 Push Notification (ntfy.sh)
# ─────────────────────────────────────────────────────────────────

# Configure your ntfy topic
TERMINUP_NTFY_TOPIC="${TERMINUP_NTFY_TOPIC:-}"

pushnotify() {
    local message="$*"
    
    if [[ -z "$TERMINUP_NTFY_TOPIC" ]]; then
        echo -e "  \033[38;5;196m✗\033[0m Set TERMINUP_NTFY_TOPIC in ~/.zshrc first"
        echo -e "  \033[38;5;245mexport TERMINUP_NTFY_TOPIC=\"your-topic-name\"\033[0m"
        return 1
    fi
    
    if [[ -z "$message" ]]; then
        echo -e "  \033[38;5;196m✗\033[0m Usage: pushnotify <message>"
        return 1
    fi
    
    curl -s -d "$message" "https://ntfy.sh/$TERMINUP_NTFY_TOPIC" &>/dev/null
    echo -e "  \033[38;5;46m✓\033[0m Notification sent!"
}

# ─────────────────────────────────────────────────────────────────
# 📊 Project Context
# ─────────────────────────────────────────────────────────────────

context() {
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m         \033[1m📊 Project Context\033[0m             \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    
    # Directory
    echo -e "  \033[38;5;226m📁 Directory:\033[0m ${PWD/#$HOME/~}"
    
    # Git info
    if [[ -d ".git" ]]; then
        local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        local status=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        local last_commit=$(git log -1 --format="%s" 2>/dev/null)
        echo -e "  \033[38;5;226m🌿 Branch:\033[0m $branch"
        echo -e "  \033[38;5;226m📝 Changes:\033[0m $status files"
        echo -e "  \033[38;5;226m💬 Last:\033[0m ${last_commit:0:40}..."
    fi
    
    # Detect framework
    echo ""
    echo -e "  \033[38;5;51m🔍 Detected:\033[0m"
    
    [[ -f "package.json" ]] && echo -e "    • Node.js project"
    [[ -f "next.config.js" || -f "next.config.mjs" ]] && echo -e "    • Next.js"
    [[ -f "vite.config.js" || -f "vite.config.ts" ]] && echo -e "    • Vite"
    [[ -f "nuxt.config.ts" || -f "nuxt.config.js" ]] && echo -e "    • Nuxt.js"
    [[ -f "angular.json" ]] && echo -e "    • Angular"
    [[ -f "svelte.config.js" ]] && echo -e "    • Svelte"
    [[ -f "composer.json" ]] && echo -e "    • PHP/Composer"
    [[ -f "Cargo.toml" ]] && echo -e "    • Rust"
    [[ -f "go.mod" ]] && echo -e "    • Go"
    [[ -f "requirements.txt" || -f "pyproject.toml" ]] && echo -e "    • Python"
    [[ -f "Gemfile" ]] && echo -e "    • Ruby"
    [[ -f ".ddev/config.yaml" ]] && echo -e "    • DDEV"
    [[ -f "docker-compose.yml" || -f "docker-compose.yaml" ]] && echo -e "    • Docker Compose"
    
    # Recent files
    echo ""
    echo -e "  \033[38;5;51m📄 Recent files:\033[0m"
    ls -t | head -5 | while read f; do
        echo -e "    • $f"
    done
    
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 🔍 What's Here (Directory Analyzer)
# ─────────────────────────────────────────────────────────────────

whatshere() {
    echo ""
    echo -e "  \033[38;5;51m🔍 Analyzing directory...\033[0m"
    echo ""
    
    # Count files
    local total=$(find . -maxdepth 3 -type f 2>/dev/null | wc -l | tr -d ' ')
    local dirs=$(find . -maxdepth 3 -type d 2>/dev/null | wc -l | tr -d ' ')
    
    echo -e "  \033[38;5;245mFiles:\033[0m $total  \033[38;5;245mDirectories:\033[0m $dirs"
    echo ""
    
    # File types
    echo -e "  \033[38;5;226mFile types:\033[0m"
    find . -maxdepth 3 -type f -name "*.*" 2>/dev/null | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10 | while read count ext; do
        printf "    %4d  .%s\n" "$count" "$ext"
    done
    
    echo ""
    
    # Suggested commands
    echo -e "  \033[38;5;46m💡 Suggested commands:\033[0m"
    [[ -f "package.json" ]] && echo "    • dev     - Start dev server"
    [[ -f "package.json" ]] && echo "    • scripts - List npm scripts"
    [[ -d ".git" ]] && echo "    • gss     - Git status"
    [[ -f "docker-compose.yml" ]] && echo "    • docker-compose up"
    [[ -f ".ddev/config.yaml" ]] && echo "    • dstart  - Start DDEV"
    
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 👤 Pretty Git Blame
# ─────────────────────────────────────────────────────────────────

blame() {
    local file="$1"
    
    if [[ -z "$file" ]]; then
        echo -e "  \033[38;5;196m✗\033[0m Usage: blame <file>"
        return 1
    fi
    
    if [[ ! -f "$file" ]]; then
        echo -e "  \033[38;5;196m✗\033[0m File not found: $file"
        return 1
    fi
    
    echo ""
    echo -e "  \033[38;5;51m👤 Git Blame: $file\033[0m"
    echo ""
    
    git blame --color-lines --color-by-age "$file" 2>/dev/null | head -50 | while read line; do
        echo "  $line"
    done
    
    echo ""
    echo -e "  \033[38;5;245m(Showing first 50 lines)\033[0m"
}

# ─────────────────────────────────────────────────────────────────
# ☀️ Morning Ritual
# ─────────────────────────────────────────────────────────────────

ritual() {
    echo ""
    echo -e "  \033[38;5;226m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;226m│\033[0m         \033[1m☀️ Good Morning!\033[0m              \033[38;5;226m│\033[0m"
    echo -e "  \033[38;5;226m╰───────────────────────────────────────╯\033[0m"
    echo ""
    
    # Date and time
    echo -e "  \033[38;5;51m📅 $(date '+%A, %B %d, %Y')\033[0m"
    echo -e "  \033[38;5;51m⏰ $(date '+%H:%M')\033[0m"
    echo ""
    
    # Weather (if available)
    echo -e "  \033[38;5;245m─────────────────────────────────────────\033[0m"
    weather 2>/dev/null || echo "  (weather unavailable)"
    
    # Notes
    echo -e "  \033[38;5;245m─────────────────────────────────────────\033[0m"
    echo -e "  \033[38;5;226m📝 Your Notes:\033[0m"
    note list 2>/dev/null | head -10
    
    # Git status if in repo
    if [[ -d ".git" ]]; then
        echo -e "  \033[38;5;245m─────────────────────────────────────────\033[0m"
        echo -e "  \033[38;5;226m🌿 Git Status:\033[0m"
        gss 2>/dev/null
    fi
    
    echo ""
    echo -e "  \033[38;5;46m✨ Have a great day!\033[0m"
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 🌙 End of Day
# ─────────────────────────────────────────────────────────────────

eod() {
    echo ""
    echo -e "  \033[38;5;141m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;141m│\033[0m         \033[1m🌙 End of Day\033[0m                 \033[38;5;141m│\033[0m"
    echo -e "  \033[38;5;141m╰───────────────────────────────────────╯\033[0m"
    echo ""
    
    # What you did today (git commits)
    if [[ -d ".git" ]]; then
        echo -e "  \033[38;5;226m📝 Today's commits:\033[0m"
        git log --oneline --since="6am" --author="$(git config user.email)" 2>/dev/null | while read line; do
            echo "    • $line"
        done
        
        # Uncommitted changes
        local changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        if [[ "$changes" -gt 0 ]]; then
            echo ""
            echo -e "  \033[38;5;208m⚠️  You have $changes uncommitted changes\033[0m"
            echo -ne "  Commit WIP? [y/N] "
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                git add -A && git commit -m "WIP: End of day $(date +%Y-%m-%d)"
                echo -e "  \033[38;5;46m✓\033[0m WIP committed!"
            fi
        fi
    fi
    
    echo ""
    echo -e "  \033[38;5;46m🌙 Good night! See you tomorrow.\033[0m"
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 📊 Standup Report
# ─────────────────────────────────────────────────────────────────

standup() {
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m         \033[1m📊 Standup Report\033[0m              \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    
    if [[ ! -d ".git" ]]; then
        echo -e "  \033[38;5;196m✗\033[0m Not a git repository"
        return 1
    fi
    
    local user=$(git config user.email)
    
    echo -e "  \033[38;5;226m📅 Yesterday:\033[0m"
    git log --oneline --since="yesterday 6am" --until="today 6am" --author="$user" 2>/dev/null | while read line; do
        echo "    • ${line#* }"
    done
    
    echo ""
    echo -e "  \033[38;5;226m📅 Today:\033[0m"
    git log --oneline --since="today 6am" --author="$user" 2>/dev/null | while read line; do
        echo "    • ${line#* }"
    done
    
    local changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    [[ "$changes" -gt 0 ]] && echo "    • (WIP: $changes uncommitted files)"
    
    echo ""
    
    # Copy to clipboard
    echo -ne "  Copy to clipboard? [y/N] "
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        local report="Yesterday:\n$(git log --oneline --since='yesterday 6am' --until='today 6am' --author="$user" 2>/dev/null | sed 's/^[^ ]* /• /')\n\nToday:\n$(git log --oneline --since='today 6am' --author="$user" 2>/dev/null | sed 's/^[^ ]* /• /')"
        echo -e "$report" | _copy
        echo -e "  \033[38;5;46m✓\033[0m Copied!"
    fi
}

# ─────────────────────────────────────────────────────────────────
# ⌨️ Typing Test
# ─────────────────────────────────────────────────────────────────

typetest() {
    local phrases=(
        "The quick brown fox jumps over the lazy dog"
        "Pack my box with five dozen liquor jugs"
        "How vexingly quick daft zebras jump"
        "The five boxing wizards jump quickly"
        "Sphinx of black quartz judge my vow"
    )
    
    local phrase="${phrases[$((RANDOM % ${#phrases[@]} + 1))]}"
    
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m         \033[1m⌨️ Typing Test\033[0m                 \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    echo -e "  Type this:"
    echo ""
    echo -e "  \033[1;38;5;226m$phrase\033[0m"
    echo ""
    echo -ne "  > "
    
    local start_sec=$(date +%s)
    read -r typed
    local end_sec=$(date +%s)
    
    local elapsed=$((end_sec - start_sec))
    [[ $elapsed -lt 1 ]] && elapsed=1
    
    local words=$(echo "$phrase" | wc -w | tr -d ' ')
    local wpm=$((words * 60 / elapsed))
    
    # Calculate accuracy
    local correct=0
    local total=${#phrase}
    for ((i=0; i<${#typed} && i<${#phrase}; i++)); do
        [[ "${typed:$i:1}" == "${phrase:$i:1}" ]] && ((correct++))
    done
    local accuracy=$((correct * 100 / total))
    
    echo ""
    echo -e "  \033[38;5;46m⏱️ Time:\033[0m ${elapsed}s"
    echo -e "  \033[38;5;46m🚀 Speed:\033[0m ${wpm} WPM"
    echo -e "  \033[38;5;46m🎯 Accuracy:\033[0m ${accuracy}%"
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 🌤️ Weather
# ─────────────────────────────────────────────────────────────────

weather() {
    local location="${1:-}"
    
    echo ""
    curl -s "wttr.in/${location}?format=3" 2>/dev/null || echo "  Weather unavailable"
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 🔌 Ports in Use
# ─────────────────────────────────────────────────────────────────

ports() {
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m         \033[1m🔌 Ports in Use\033[0m               \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    
    case "$TERMINUP_OS" in
        macos)
            lsof -iTCP -sTCP:LISTEN -P 2>/dev/null | awk 'NR>1 {printf "  %-6s  %-20s  %s\n", $9, $1, $2}'
            ;;
        linux)
            ss -tlnp 2>/dev/null | awk 'NR>1 {print "  " $4 "  " $7}'
            ;;
        *)
            netstat -an 2>/dev/null | grep LISTEN | head -20
            ;;
    esac
    
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# ⏱️ Stopwatch
# ─────────────────────────────────────────────────────────────────

stopwatch() {
    echo ""
    echo -e "  \033[38;5;51m⏱️ Stopwatch\033[0m (Press Enter to stop)"
    echo ""
    
    local start=$(date +%s)
    
    while true; do
        local now=$(date +%s)
        local elapsed=$((now - start))
        local mins=$((elapsed / 60))
        local secs=$((elapsed % 60))
        
        printf "\r  \033[1;38;5;226m%02d:%02d\033[0m" "$mins" "$secs"
        
        read -t 1 -k 1 2>/dev/null && break
    done
    
    echo ""
    echo ""
    echo -e "  \033[38;5;46m✓\033[0m Stopped at $mins:$(printf "%02d" $secs)"
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# ⏰ Remind
# ─────────────────────────────────────────────────────────────────

remind() {
    local time="$1"
    shift
    local message="$*"
    
    if [[ -z "$time" || -z "$message" ]]; then
        echo -e "  \033[38;5;196m✗\033[0m Usage: remind <minutes> <message>"
        echo -e "  \033[38;5;245mExample: remind 10 Take a break\033[0m"
        return 1
    fi
    
    echo -e "  \033[38;5;46m✓\033[0m Reminder set for $time minutes"
    
    (
        sleep $((time * 60))
        _notify "⏰ Reminder" "$message"
        echo -e "\n  \033[38;5;226m⏰ REMINDER:\033[0m $message\n"
    ) &
}

# ─────────────────────────────────────────────────────────────────
# 📊 Project Stats
# ─────────────────────────────────────────────────────────────────

projectstats() {
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m         \033[1m📊 Project Stats\033[0m              \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    
    # Lines of code
    echo -e "  \033[38;5;226m📝 Lines of code:\033[0m"
    find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.py" -o -name "*.go" -o -name "*.rs" -o -name "*.php" -o -name "*.zsh" -o -name "*.sh" \) -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | while read f; do
        wc -l < "$f"
    done | awk '{sum += $1} END {printf "    %d total lines\n", sum}'
    
    # File breakdown
    echo ""
    echo -e "  \033[38;5;226m📁 File breakdown:\033[0m"
    find . -type f -not -path "*/node_modules/*" -not -path "*/.git/*" -name "*.*" 2>/dev/null | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -8 | while read count ext; do
        printf "    %4d  .%s\n" "$count" "$ext"
    done
    
    # Git stats
    if [[ -d ".git" ]]; then
        echo ""
        echo -e "  \033[38;5;226m🌿 Git stats:\033[0m"
        echo "    Commits: $(git rev-list --count HEAD 2>/dev/null || echo 0)"
        echo "    Contributors: $(git shortlog -sn 2>/dev/null | wc -l | tr -d ' ')"
        echo "    First commit: $(git log --reverse --format='%ar' 2>/dev/null | head -1)"
    fi
    
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 📜 Log Viewer
# ─────────────────────────────────────────────────────────────────

logs() {
    local file="${1:-}"
    
    if [[ -z "$file" ]]; then
        # Try common log locations
        if [[ -f "storage/logs/laravel.log" ]]; then
            file="storage/logs/laravel.log"
        elif [[ -f ".next/server.log" ]]; then
            file=".next/server.log"
        elif [[ -f "npm-debug.log" ]]; then
            file="npm-debug.log"
        else
            echo -e "  \033[38;5;196m✗\033[0m Usage: logs <file>"
            return 1
        fi
    fi
    
    echo -e "  \033[38;5;51m📜 Tailing: $file\033[0m"
    echo -e "  \033[38;5;245m(Press Ctrl+C to stop)\033[0m"
    echo ""
    
    tail -f "$file" 2>/dev/null | while read line; do
        # Colorize errors/warnings
        if [[ "$line" == *"error"* || "$line" == *"ERROR"* ]]; then
            echo -e "\033[38;5;196m$line\033[0m"
        elif [[ "$line" == *"warn"* || "$line" == *"WARN"* ]]; then
            echo -e "\033[38;5;208m$line\033[0m"
        elif [[ "$line" == *"info"* || "$line" == *"INFO"* ]]; then
            echo -e "\033[38;5;39m$line\033[0m"
        else
            echo "$line"
        fi
    done
}

# ─────────────────────────────────────────────────────────────────
# 🔄 Git Undo
# ─────────────────────────────────────────────────────────────────

gundo() {
    echo ""
    echo -e "  \033[38;5;51m🔄 Git Undo Options:\033[0m"
    echo ""
    echo -e "    \033[38;5;226m1\033[0m) Undo last commit (keep changes)"
    echo -e "    \033[38;5;226m2\033[0m) Undo last commit (discard changes)"
    echo -e "    \033[38;5;226m3\033[0m) Unstage all files"
    echo -e "    \033[38;5;226m4\033[0m) Discard all local changes"
    echo -e "    \033[38;5;226m5\033[0m) Cancel"
    echo ""
    echo -ne "  Choice: "
    read -r choice
    
    case "$choice" in
        1)
            git reset --soft HEAD~1
            echo -e "  \033[38;5;46m✓\033[0m Last commit undone (changes kept)"
            ;;
        2)
            git reset --hard HEAD~1
            echo -e "  \033[38;5;46m✓\033[0m Last commit undone (changes discarded)"
            ;;
        3)
            git reset HEAD
            echo -e "  \033[38;5;46m✓\033[0m All files unstaged"
            ;;
        4)
            echo -ne "  \033[38;5;196mAre you sure? [y/N]\033[0m "
            read -r confirm
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                git checkout -- .
                echo -e "  \033[38;5;46m✓\033[0m All local changes discarded"
            fi
            ;;
        *)
            echo -e "  \033[38;5;245mCancelled\033[0m"
            ;;
    esac
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 📋 JSON Pretty Print
# ─────────────────────────────────────────────────────────────────

jpp() {
    local input="$1"
    
    if [[ -z "$input" ]]; then
        # Read from stdin
        python3 -m json.tool 2>/dev/null || jq '.' 2>/dev/null || cat
    elif [[ -f "$input" ]]; then
        # File
        cat "$input" | python3 -m json.tool 2>/dev/null || jq '.' "$input" 2>/dev/null || cat "$input"
    else
        # String
        echo "$input" | python3 -m json.tool 2>/dev/null || echo "$input" | jq '.' 2>/dev/null || echo "$input"
    fi
}

# ─────────────────────────────────────────────────────────────────
# ✅ Simple Todo
# ─────────────────────────────────────────────────────────────────

TODO_FILE="$HOME/.terminup_todos"

todo() {
    local cmd="${1:-list}"
    
    case "$cmd" in
        add|a)
            shift
            local task="$*"
            [[ -z "$task" ]] && echo -ne "  Task: " && read task
            echo "[ ] $task" >> "$TODO_FILE"
            echo -e "  \033[38;5;46m✓\033[0m Added: $task"
            ;;
        done|d)
            local num="${2:-1}"
            if [[ -f "$TODO_FILE" ]]; then
                sed -i'' "${num}s/\[ \]/[x]/" "$TODO_FILE" 2>/dev/null
                echo -e "  \033[38;5;46m✓\033[0m Marked #$num as done"
            fi
            ;;
        rm|remove)
            local num="${2:-1}"
            if [[ -f "$TODO_FILE" ]]; then
                sed -i'' "${num}d" "$TODO_FILE" 2>/dev/null
                echo -e "  \033[38;5;46m✓\033[0m Removed #$num"
            fi
            ;;
        clear)
            echo "" > "$TODO_FILE"
            echo -e "  \033[38;5;46m✓\033[0m Todos cleared"
            ;;
        list|ls|*)
            echo ""
            echo -e "  \033[38;5;51m✅ Todo List\033[0m"
            echo ""
            if [[ -f "$TODO_FILE" && -s "$TODO_FILE" ]]; then
                local i=1
                while IFS= read -r line; do
                    if [[ "$line" == "[x]"* ]]; then
                        echo -e "    \033[38;5;245m$i. \033[9m${line:4}\033[0m"
                    else
                        echo -e "    \033[38;5;46m$i.\033[0m ${line:4}"
                    fi
                    ((i++))
                done < "$TODO_FILE"
            else
                echo -e "    \033[38;5;245mNo todos. Add one: todo add <task>\033[0m"
            fi
            echo ""
            ;;
    esac
}
