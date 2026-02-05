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

# ─────────────────────────────────────────────────────────────────
# 👋 Welcome
# ─────────────────────────────────────────────────────────────────

welcome() {
    local hour=$(date +%H)
    local greeting
    
    if (( hour >= 5 && hour < 12 )); then
        greeting="Good morning"
        local emoji="☀️"
    elif (( hour >= 12 && hour < 17 )); then
        greeting="Good afternoon"
        local emoji="🌤️"
    elif (( hour >= 17 && hour < 21 )); then
        greeting="Good evening"
        local emoji="🌅"
    else
        greeting="Good night"
        local emoji="🌙"
    fi
    
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m         \033[1m$emoji $greeting!\033[0m               \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    echo -e "  \033[38;5;245m📅 $(date '+%A, %B %d, %Y')\033[0m"
    echo -e "  \033[38;5;245m⏰ $(date '+%H:%M')\033[0m"
    echo ""
    
    # Show current directory info
    if [[ -d ".git" ]]; then
        local branch=$(git branch --show-current 2>/dev/null)
        echo -e "  \033[38;5;208m📂 $(basename "$PWD")\033[0m on \033[38;5;46m$branch\033[0m"
    else
        echo -e "  \033[38;5;208m📂 $(basename "$PWD")\033[0m"
    fi
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 🌅 Aliases for ritual (morning) and eod (night)
# ─────────────────────────────────────────────────────────────────

alias goodmorning='ritual'
alias morning='ritual'
alias goodnight='eod'
alias night='eod'


# ─────────────────────────────────────────────────────────────────
# 🎨 ASCII Art Generator
# ─────────────────────────────────────────────────────────────────

asciiart() {
    local text="${*:-Hello}"
    
    echo ""
    echo -e "  \033[38;5;213m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;213m│\033[0m         \033[1m🎨 ASCII Art Generator\033[0m        \033[38;5;213m│\033[0m"
    echo -e "  \033[38;5;213m╰───────────────────────────────────────╯\033[0m"
    echo ""
    
    # Simple block letters
    local -A letters
    letters[A]="  ██  :█  █:████:█  █:█  █"
    letters[B]="███ :█  █:███ :█  █:███ "
    letters[C]=" ███:█   :█   :█   : ███"
    letters[D]="███ :█  █:█  █:█  █:███ "
    letters[E]="████:█   :███ :█   :████"
    letters[F]="████:█   :███ :█   :█   "
    letters[G]=" ███:█   :█ ██:█  █: ███"
    letters[H]="█  █:█  █:████:█  █:█  █"
    letters[I]="███: █ : █ : █ :███"
    letters[J]="  ██:  █:  █:█ █:██ "
    letters[K]="█  █:█ █ :██  :█ █ :█  █"
    letters[L]="█   :█   :█   :█   :████"
    letters[M]="█   █:██ ██:█ █ █:█   █:█   █"
    letters[N]="█   █:██  █:█ █ █:█  ██:█   █"
    letters[O]=" ██ :█  █:█  █:█  █: ██ "
    letters[P]="███ :█  █:███ :█   :█   "
    letters[Q]=" ██ :█  █:█  █:█ █ : ███"
    letters[R]="███ :█  █:███ :█ █ :█  █"
    letters[S]=" ███:█   : ██ :   █:███ "
    letters[T]="█████:  █  :  █  :  █  :  █  "
    letters[U]="█  █:█  █:█  █:█  █: ██ "
    letters[V]="█   █:█   █: █ █ : █ █ :  █  "
    letters[W]="█   █:█   █:█ █ █:██ ██:█   █"
    letters[X]="█   █: █ █ :  █  : █ █ :█   █"
    letters[Y]="█   █: █ █ :  █  :  █  :  █  "
    letters[Z]="█████:   █ :  █  : █   :█████"
    letters[0]=" ██ :█  █:█  █:█  █: ██ "
    letters[1]=" █ :██ : █ : █ :███"
    letters[2]=" ██ :   █:  █ : █  :████"
    letters[3]="███ :   █: ██ :   █:███ "
    letters[4]="█  █:█  █:████:   █:   █"
    letters[5]="████:█   :███ :   █:███ "
    letters[6]=" ██ :█   :███ :█  █: ██ "
    letters[7]="████:   █:  █ : █  :█   "
    letters[8]=" ██ :█  █: ██ :█  █: ██ "
    letters[9]=" ██ :█  █: ███:   █: ██ "
    letters[" "]="   :   :   :   :   "
    letters[!]=" █ : █ : █ :   : █ "
    
    text="${text:u}"  # Uppercase
    
    for row in 1 2 3 4 5; do
        echo -n "  "
        for ((i=0; i<${#text}; i++)); do
            local char="${text:$i:1}"
            local pattern="${letters[$char]:-}"
            if [[ -n "$pattern" ]]; then
                local line=$(echo "$pattern" | cut -d: -f$row)
                echo -ne "\033[38;5;$((196 + i % 60))m${line}\033[0m "
            fi
        done
        echo ""
    done
    echo ""
}


# ─────────────────────────────────────────────────────────────────
# 🏆 Achievements
# ─────────────────────────────────────────────────────────────────

ACHIEVEMENTS_FILE="$HOME/.terminup_achievements"

achievement() {
    local cmd="${1:-list}"
    
    case "$cmd" in
        unlock)
            local name="$2"
            local desc="${3:-Achievement unlocked!}"
            if [[ -z "$name" ]]; then
                echo -e "  \033[38;5;196m✗\033[0m Usage: achievement unlock <name> [description]"
                return 1
            fi
            if ! grep -q "^$name|" "$ACHIEVEMENTS_FILE" 2>/dev/null; then
                echo "$name|$desc|$(date '+%Y-%m-%d %H:%M')" >> "$ACHIEVEMENTS_FILE"
                echo ""
                echo -e "  \033[38;5;226m╭───────────────────────────────────────╮\033[0m"
                echo -e "  \033[38;5;226m│\033[0m      \033[1m🏆 ACHIEVEMENT UNLOCKED!\033[0m         \033[38;5;226m│\033[0m"
                echo -e "  \033[38;5;226m╰───────────────────────────────────────╯\033[0m"
                echo ""
                echo -e "  \033[1;38;5;226m$name\033[0m"
                echo -e "  \033[38;5;245m$desc\033[0m"
                echo ""
            fi
            ;;
        list|ls|*)
            echo ""
            echo -e "  \033[38;5;226m╭───────────────────────────────────────╮\033[0m"
            echo -e "  \033[38;5;226m│\033[0m           \033[1m🏆 Achievements\033[0m             \033[38;5;226m│\033[0m"
            echo -e "  \033[38;5;226m╰───────────────────────────────────────╯\033[0m"
            echo ""
            if [[ -f "$ACHIEVEMENTS_FILE" && -s "$ACHIEVEMENTS_FILE" ]]; then
                while IFS='|' read -r name desc date; do
                    echo -e "    \033[38;5;226m🏆\033[0m \033[1m$name\033[0m"
                    echo -e "       \033[38;5;245m$desc\033[0m"
                    echo -e "       \033[38;5;240m$date\033[0m"
                    echo ""
                done < "$ACHIEVEMENTS_FILE"
            else
                echo -e "    \033[38;5;245mNo achievements yet.\033[0m"
                echo -e "    \033[38;5;240mUnlock with: achievement unlock <name>\033[0m"
            fi
            echo ""
            ;;
    esac
}

# ─────────────────────────────────────────────────────────────────
# 🔌 API Tester
# ─────────────────────────────────────────────────────────────────

api() {
    local method="${1:-GET}"
    local url="$2"
    local data="$3"
    
    if [[ -z "$url" ]]; then
        echo ""
        echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
        echo -e "  \033[38;5;51m│\033[0m           \033[1m🔌 API Tester\033[0m               \033[38;5;51m│\033[0m"
        echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
        echo ""
        echo -e "  Usage:"
        echo -e "    api GET <url>"
        echo -e "    api POST <url> '<json>'"
        echo -e "    api PUT <url> '<json>'"
        echo -e "    api DELETE <url>"
        echo ""
        echo -e "  Examples:"
        echo -e "    api GET https://api.github.com/users/octocat"
        echo -e "    api POST https://httpbin.org/post '{\"test\":\"data\"}'"
        echo ""
        return 1
    fi
    
    echo ""
    echo -e "  \033[38;5;51m⚡ $method\033[0m $url"
    echo ""
    
    local response
    local http_code
    
    if [[ "$method" == "GET" || "$method" == "DELETE" ]]; then
        response=$(curl -s -w "\n%{http_code}" -X "$method" "$url" 2>/dev/null)
    else
        response=$(curl -s -w "\n%{http_code}" -X "$method" -H "Content-Type: application/json" -d "$data" "$url" 2>/dev/null)
    fi
    
    http_code=$(echo "$response" | tail -1)
    response=$(echo "$response" | sed '$d')
    
    # Color code based on status
    if [[ $http_code -ge 200 && $http_code -lt 300 ]]; then
        echo -e "  \033[38;5;46m✓ Status: $http_code\033[0m"
    elif [[ $http_code -ge 400 ]]; then
        echo -e "  \033[38;5;196m✗ Status: $http_code\033[0m"
    else
        echo -e "  \033[38;5;226m● Status: $http_code\033[0m"
    fi
    echo ""
    
    # Pretty print JSON if possible
    if command -v jq &>/dev/null; then
        echo "$response" | jq . 2>/dev/null || echo "$response"
    else
        echo "$response"
    fi
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 🌈 Nyan Cat
# ─────────────────────────────────────────────────────────────────

nyan() {
    local duration=${1:-5}
    
    tput civis
    trap 'tput cnorm; return' INT
    
    local frames=(
        "       ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
       ░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░
 ▀▀▀▀▀░░░░░░░░░█▒▒▒▒▒▒▒▒▒▒▒▒█░░░░░░░░░░
       ░░░░░░░░█▒▒▒▒▒▒▒▒▒▒▒▒█░░░░▄▀▀▄░░░
   ▀▀▀▀░░░░░░░░█▒▒▒▒▒▒▒▒▒▒▒▒█░░░█░░░█░░
       ░░░░░░░░█▒▒▒▒▒▒▒▒▒▒▒▒█░░░░▀▀▀░░░
▀▀▀▀▀▀▀░░░░░░░░░▀▀▀▀▀▀▀▀▀▀▀▀░░░░░░░░░░░"
        "       ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
       ░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░
  ▀▀▀▀▀░░░░░░░░█▒▒▒▒▒▒▒▒▒▒▒▒█░░░░░░░░░░░
       ░░░░░░░░█▒▒▒▒▒▒▒▒▒▒▒▒█░░░░░▄▀▀▄░░
    ▀▀▀▀░░░░░░░█▒▒▒▒▒▒▒▒▒▒▒▒█░░░░█░░░█░░
       ░░░░░░░░█▒▒▒▒▒▒▒▒▒▒▒▒█░░░░░▀▀▀░░░
 ▀▀▀▀▀▀▀░░░░░░░░▀▀▀▀▀▀▀▀▀▀▀▀░░░░░░░░░░░░"
    )
    
    local colors=(196 208 226 46 51 21 93)
    local end=$((SECONDS + duration))
    local frame=0
    
    while ((SECONDS < end)); do
        clear
        echo ""
        echo -e "  \033[38;5;${colors[$((frame % ${#colors[@]}))]}m${frames[$((frame % 2))]}\033[0m"
        echo ""
        echo -e "  \033[38;5;213m♪ Nyan nyan nyan~ ♪\033[0m"
        ((frame++))
        sleep 0.3
    done
    
    tput cnorm
}


# ─────────────────────────────────────────────────────────────────
# 🕐 Clock Widget
# ─────────────────────────────────────────────────────────────────

clockwidget() {
    local duration=${1:-10}
    
    tput civis
    trap 'tput cnorm; return' INT
    
    local end=$((SECONDS + duration))
    
    while ((SECONDS < end)); do
        local time=$(date '+%H:%M:%S')
        local date=$(date '+%a %b %d')
        
        printf "\r  \033[38;5;51m🕐\033[0m \033[1;38;5;226m%s\033[0m \033[38;5;245m│\033[0m %s " "$time" "$date"
        sleep 1
    done
    
    echo ""
    tput cnorm
}

# ─────────────────────────────────────────────────────────────────
# 📊 Command Stats
# ─────────────────────────────────────────────────────────────────

cmdstats() {
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m         \033[1m📊 Command Statistics\033[0m          \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    
    if [[ -f "$HISTFILE" ]]; then
        echo -e "  \033[38;5;226mTop 15 Commands:\033[0m"
        echo ""
        
        cat "$HISTFILE" | \
            sed 's/^: [0-9]*:[0-9]*;//' | \
            awk '{print $1}' | \
            sort | uniq -c | sort -rn | head -15 | \
            while read count cmd; do
                local bar_len=$((count / 10))
                [[ $bar_len -gt 30 ]] && bar_len=30
                local bar=""
                for ((i=0; i<bar_len; i++)); do
                    bar+="█"
                done
                printf "    \033[38;5;46m%-12s\033[0m %5d \033[38;5;208m%s\033[0m\n" "$cmd" "$count" "$bar"
            done
        
        echo ""
        echo -e "  \033[38;5;245mTotal commands in history:\033[0m $(wc -l < "$HISTFILE" | tr -d ' ')"
    else
        echo -e "  \033[38;5;196m✗\033[0m History file not found"
    fi
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 🔗 URL Shortener
# ─────────────────────────────────────────────────────────────────

shorten() {
    local url="$1"
    
    if [[ -z "$url" ]]; then
        echo -e "  \033[38;5;196m✗\033[0m Usage: shorten <url>"
        return 1
    fi
    
    echo ""
    echo -e "  \033[38;5;51m🔗 Shortening URL...\033[0m"
    
    # Using is.gd free API
    local short=$(curl -s "https://is.gd/create.php?format=simple&url=$url" 2>/dev/null)
    
    if [[ -n "$short" && "$short" != "Error"* ]]; then
        echo ""
        echo -e "  \033[38;5;46m✓ Short URL:\033[0m $short"
        
        # Copy to clipboard if possible
        if command -v pbcopy &>/dev/null; then
            echo -n "$short" | pbcopy
            echo -e "  \033[38;5;245m(Copied to clipboard)\033[0m"
        elif command -v xclip &>/dev/null; then
            echo -n "$short" | xclip -selection clipboard
            echo -e "  \033[38;5;245m(Copied to clipboard)\033[0m"
        fi
    else
        echo -e "  \033[38;5;196m✗\033[0m Failed to shorten URL"
    fi
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 📰 Hacker News
# ─────────────────────────────────────────────────────────────────

hn() {
    local count=${1:-10}
    
    echo ""
    echo -e "  \033[38;5;208m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;208m│\033[0m           \033[1m📰 Hacker News\033[0m              \033[38;5;208m│\033[0m"
    echo -e "  \033[38;5;208m╰───────────────────────────────────────╯\033[0m"
    echo ""
    
    # Get top story IDs
    local ids=$(curl -s "https://hacker-news.firebaseio.com/v0/topstories.json" 2>/dev/null | head -c 200)
    
    if [[ -z "$ids" ]]; then
        echo -e "  \033[38;5;196m✗\033[0m Failed to fetch stories"
        return 1
    fi
    
    # Parse first N IDs (simple extraction)
    local i=1
    echo "$ids" | tr ',' '\n' | tr -d '[]' | head -$count | while read id; do
        local story=$(curl -s "https://hacker-news.firebaseio.com/v0/item/${id}.json" 2>/dev/null)
        local title=$(echo "$story" | grep -o '"title":"[^"]*"' | cut -d'"' -f4)
        local score=$(echo "$story" | grep -o '"score":[0-9]*' | cut -d: -f2)
        local url=$(echo "$story" | grep -o '"url":"[^"]*"' | cut -d'"' -f4)
        
        if [[ -n "$title" ]]; then
            echo -e "  \033[38;5;226m$i.\033[0m $title"
            echo -e "     \033[38;5;46m↑$score\033[0m \033[38;5;245m${url:0:50}...\033[0m"
            echo ""
        fi
        ((i++))
    done
}

# ─────────────────────────────────────────────────────────────────
# 😄 Dad Jokes
# ─────────────────────────────────────────────────────────────────

dadjoke() {
    echo ""
    echo -e "  \033[38;5;226m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;226m│\033[0m           \033[1m😄 Dad Joke\033[0m                 \033[38;5;226m│\033[0m"
    echo -e "  \033[38;5;226m╰───────────────────────────────────────╯\033[0m"
    echo ""
    
    local joke=$(curl -s -H "Accept: text/plain" "https://icanhazdadjoke.com/" 2>/dev/null)
    
    if [[ -n "$joke" ]]; then
        # Word wrap the joke
        echo "$joke" | fold -s -w 45 | while read line; do
            echo -e "    \033[1m$line\033[0m"
        done
        echo ""
        echo -e "    \033[38;5;245m😂 Ba dum tss!\033[0m"
    else
        # Fallback jokes
        local jokes=(
            "Why do programmers prefer dark mode? Because light attracts bugs!"
            "A SQL query walks into a bar, walks up to two tables and asks... 'Can I join you?'"
            "Why do Java developers wear glasses? Because they don't C#!"
            "There are only 10 types of people in the world: those who understand binary and those who don't."
            "A programmer's wife tells him: 'Go to the store and buy a loaf of bread. If they have eggs, buy a dozen.' He comes home with 12 loaves of bread."
            "Why did the developer go broke? Because he used up all his cache!"
            "What's a programmer's favorite hangout place? Foo Bar!"
        )
        local joke="${jokes[$((RANDOM % ${#jokes[@]} + 1))]}"
        echo -e "    \033[1m$joke\033[0m"
    fi
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 🧹 Animated Clear Screen (cls)
# ─────────────────────────────────────────────────────────────────

cls() {
    local lines=$(tput lines)
    local cols=$(tput cols)
    
    # Fade out effect - gradually dim each line from bottom to top
    for ((i=lines; i>=1; i--)); do
        tput cup $i 0
        # Print dimmed version of line
        printf "\033[38;5;240m"
        tput el  # Clear to end of line
        sleep 0.008
    done
    
    # Scroll up effect with gradient
    local colors=(255 253 251 249 247 245 243 241 239 237 235 233)
    
    for color in "${colors[@]}"; do
        printf "\033[38;5;${color}m"
        for ((i=0; i<3; i++)); do
            echo ""
        done
        sleep 0.015
    done
    
    # Final clear
    clear
    printf "\033[0m"
}

# Alternative: Quick fade clear
clsq() {
    local lines=$(tput lines)
    
    # Quick fade - just scroll with diminishing brightness
    for fade in 250 245 240 235 232; do
        printf "\033[38;5;${fade}m"
        for ((i=0; i<5; i++)); do
            echo ""
        done
        sleep 0.02
    done
    
    clear
    printf "\033[0m"
}

# ─────────────────────────────────────────────────────────────────
# 🃏 Blackjack
# ─────────────────────────────────────────────────────────────────

blackjack() {
    local -a player_cards dealer_cards
    local player_total=0 dealer_total=0
    local _last_card=0
    
    # Seed random with something unique
    RANDOM=$((RANDOM ^ $$))
    
    # Deal a card and store in _last_card (avoids subshell RANDOM issue)
    _deal_card() {
        _last_card=$((RANDOM % 13 + 1))
    }
    
    # Get card display name
    _card_name() {
        case $1 in
            1) echo "A" ;;
            11) echo "J" ;;
            12) echo "Q" ;;
            13) echo "K" ;;
            *) echo "$1" ;;
        esac
    }
    
    # Get card value
    _card_val() {
        case $1 in
            1) echo 1 ;;
            11|12|13) echo 10 ;;
            *) echo "$1" ;;
        esac
    }
    
    # Calculate hand total (inline, no subshell)
    _calc_total() {
        local total=0 aces=0
        for c in "$@"; do
            case $c in
                1) ((total += 1)); ((aces++)) ;;
                11|12|13) ((total += 10)) ;;
                *) ((total += c)) ;;
            esac
        done
        while ((aces > 0 && total + 10 <= 21)); do
            ((total += 10))
            ((aces--))
        done
        _hand_value=$total
    }
    
    # Format cards for display (inline)
    _fmt_cards() {
        _cards_str=""
        for c in "$@"; do
            case $c in
                1) _cards_str+="[A] " ;;
                11) _cards_str+="[J] " ;;
                12) _cards_str+="[Q] " ;;
                13) _cards_str+="[K] " ;;
                *) _cards_str+="[$c] " ;;
            esac
        done
    }
    
    _draw() {
        local show_dealer=${1:-0}
        
        _fmt_cards "${player_cards[@]}"
        local pcards="$_cards_str"
        _calc_total "${player_cards[@]}"
        local ptotal=$_hand_value
        
        clear
        echo ""
        echo -e "  \033[38;5;46m╔══════════════════════════════════════╗\033[0m"
        echo -e "  \033[38;5;46m║\033[0m       \033[1;38;5;46m🃏 BLACKJACK 🃏\033[0m            \033[38;5;46m║\033[0m"
        echo -e "  \033[38;5;46m╚══════════════════════════════════════╝\033[0m"
        echo ""
        
        # Dealer section
        echo -e "  \033[38;5;208m╭─ DEALER ──────────────────────────────╮\033[0m"
        if [[ $show_dealer -eq 1 ]]; then
            _fmt_cards "${dealer_cards[@]}"
            local dcards="$_cards_str"
            _calc_total "${dealer_cards[@]}"
            local dtotal=$_hand_value
            echo -e "  \033[38;5;208m│\033[0m  $dcards= \033[1m$dtotal\033[0m"
        else
            local first_card=${dealer_cards[1]}
            case $first_card in
                1) echo -e "  \033[38;5;208m│\033[0m  [A] [?]" ;;
                11) echo -e "  \033[38;5;208m│\033[0m  [J] [?]" ;;
                12) echo -e "  \033[38;5;208m│\033[0m  [Q] [?]" ;;
                13) echo -e "  \033[38;5;208m│\033[0m  [K] [?]" ;;
                *) echo -e "  \033[38;5;208m│\033[0m  [$first_card] [?]" ;;
            esac
        fi
        echo -e "  \033[38;5;208m╰───────────────────────────────────────╯\033[0m"
        echo ""
        
        # Player section
        echo -e "  \033[38;5;51m╭─ YOU ─────────────────────────────────╮\033[0m"
        echo -e "  \033[38;5;51m│\033[0m  $pcards= \033[1m$ptotal\033[0m"
        echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
        echo ""
    }
    
    # Deal initial cards (inline random, no subshell)
    _deal_card; player_cards+=($_last_card)
    _deal_card; player_cards+=($_last_card)
    _deal_card; dealer_cards+=($_last_card)
    _deal_card; dealer_cards+=($_last_card)
    
    _draw 0
    _calc_total "${player_cards[@]}"
    player_total=$_hand_value
    
    # Natural blackjack?
    if [[ $player_total -eq 21 ]]; then
        _draw 1
        echo -e "  \033[1;38;5;226m🎉 BLACKJACK! You win! 🎉\033[0m"
        echo ""
        return
    fi
    
    # Player's turn
    while [[ $player_total -lt 21 ]]; do
        echo -e "  \033[38;5;240m[H] Hit  [S] Stand  [Q] Quit\033[0m"
        echo -ne "  \033[38;5;51m>\033[0m "
        read -s -k 1 choice
        
        case "${choice:l}" in
            h)
                _deal_card; player_cards+=($_last_card)
                _calc_total "${player_cards[@]}"
                player_total=$_hand_value
                _draw 0
                ;;
            s)
                break
                ;;
            q)
                echo ""
                echo -e "  \033[38;5;245mGoodbye!\033[0m"
                echo ""
                return
                ;;
            *)
                _draw 0
                ;;
        esac
    done
    
    # Bust check
    if [[ $player_total -gt 21 ]]; then
        _draw 1
        echo -e "  \033[1;38;5;196m💥 BUST! Dealer wins.\033[0m"
        echo ""
        return
    fi
    
    # Dealer's turn
    _draw 1
    echo -e "  \033[38;5;208mDealer reveals...\033[0m"
    sleep 0.6
    
    _calc_total "${dealer_cards[@]}"
    dealer_total=$_hand_value
    while [[ $dealer_total -lt 17 ]]; do
        sleep 0.7
        _deal_card; dealer_cards+=($_last_card)
        _calc_total "${dealer_cards[@]}"
        dealer_total=$_hand_value
        _draw 1
        echo -e "  \033[38;5;208mDealer hits!\033[0m"
    done
    
    sleep 0.4
    _draw 1
    
    # Winner
    if [[ $dealer_total -gt 21 ]]; then
        echo -e "  \033[1;38;5;46m🎉 Dealer BUSTS! You WIN! 🎉\033[0m"
    elif [[ $dealer_total -gt $player_total ]]; then
        echo -e "  \033[1;38;5;196m😔 Dealer wins ($dealer_total vs $player_total)\033[0m"
    elif [[ $dealer_total -lt $player_total ]]; then
        echo -e "  \033[1;38;5;46m🎉 You WIN! ($player_total vs $dealer_total) 🎉\033[0m"
    else
        echo -e "  \033[1;38;5;226m🤝 PUSH! Tie at $player_total\033[0m"
    fi
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 🎰 Terminal Slots with emoji and win animation
# ─────────────────────────────────────────────────────────────────

slots() {
    local -a symbols=("🍒" "🍋" "🍊" "🍇" "⭐" "💎" "7️⃣" "🔔")
    local slot1 slot2 slot3
    
    tput civis 2>/dev/null
    clear
    
    echo ""
    echo -e "  \033[38;5;226m╔═══════════════════════════════════════════╗\033[0m"
    echo -e "  \033[38;5;226m║\033[0m        \033[1;38;5;226m🎰 TERMINAL SLOTS 🎰\033[0m           \033[38;5;226m║\033[0m"
    echo -e "  \033[38;5;226m╚═══════════════════════════════════════════╝\033[0m"
    echo ""
    echo ""
    
    # Spinning animation with proper positioning
    for spin in {1..20}; do
        slot1="${symbols[$((RANDOM % 8 + 1))]}"
        slot2="${symbols[$((RANDOM % 8 + 1))]}"
        slot3="${symbols[$((RANDOM % 8 + 1))]}"
        
        tput cup 5 0
        echo -e "  \033[38;5;245m╔═════════╦═════════╦═════════╗\033[0m"
        echo -e "  \033[38;5;245m║\033[0m   $slot1    \033[38;5;245m║\033[0m   $slot2    \033[38;5;245m║\033[0m   $slot3    \033[38;5;245m║\033[0m"
        echo -e "  \033[38;5;245m╚═════════╩═════════╩═════════╝\033[0m"
        
        # Slow down near the end
        if ((spin < 10)); then
            sleep 0.06
        elif ((spin < 15)); then
            sleep 0.1
        else
            sleep 0.15
        fi
    done
    
    # Final result
    slot1="${symbols[$((RANDOM % 8 + 1))]}"
    slot2="${symbols[$((RANDOM % 8 + 1))]}"
    slot3="${symbols[$((RANDOM % 8 + 1))]}"
    
    tput cup 5 0
    echo -e "  \033[38;5;226m╔═════════╦═════════╦═════════╗\033[0m"
    echo -e "  \033[38;5;226m║\033[0m   $slot1    \033[38;5;226m║\033[0m   $slot2    \033[38;5;226m║\033[0m   $slot3    \033[38;5;226m║\033[0m"
    echo -e "  \033[38;5;226m╚═════════╩═════════╩═════════╝\033[0m"
    echo ""
    echo ""
    
    # Check for wins
    if [[ "$slot1" == "$slot2" && "$slot2" == "$slot3" ]]; then
        # JACKPOT animation!
        for flash in {1..8}; do
            tput cup 10 0
            if ((flash % 2 == 0)); then
                echo -e "  \033[1;5;38;5;226m🎉🎉🎉 JACKPOT!!! THREE $slot1 🎉🎉🎉\033[0m"
                echo -e "  \033[1;38;5;196m   ★ ★ ★ ★ ★ WINNER! ★ ★ ★ ★ ★\033[0m"
                echo -e "  \033[38;5;226m💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰\033[0m"
            else
                echo -e "  \033[1;5;38;5;196m🎉🎉🎉 JACKPOT!!! THREE $slot1 🎉🎉🎉\033[0m"
                echo -e "  \033[1;38;5;226m   ★ ★ ★ ★ ★ WINNER! ★ ★ ★ ★ ★\033[0m"
                echo -e "  \033[38;5;46m💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰💰\033[0m"
            fi
            sleep 0.2
        done
        # Coin shower effect
        echo ""
        for i in {1..3}; do
            echo -e "  \033[38;5;226m    🪙  💵  🪙  💵  🪙  💵  🪙  💵  🪙\033[0m"
            sleep 0.1
        done
    elif [[ "$slot1" == "$slot2" || "$slot2" == "$slot3" || "$slot1" == "$slot3" ]]; then
        # Two matching - nice win
        echo -e "  \033[38;5;46m✨✨ Nice! Two matching! ✨✨\033[0m"
        echo -e "  \033[38;5;226m   🎊 Small win! 🎊\033[0m"
    else
        echo -e "  \033[38;5;245m😔 No match. Try again!\033[0m"
        echo -e "  \033[38;5;240m   Better luck next time!\033[0m"
    fi
    
    echo ""
    tput cnorm 2>/dev/null
}

# ─────────────────────────────────────────────────────────────────
# 🐍 Fixed Snake
# ─────────────────────────────────────────────────────────────────

snake() {
    local width=30 height=12
    local head_x=15 head_y=6
    local food_x=$((RANDOM % (width-2) + 2))
    local food_y=$((RANDOM % (height-2) + 2))
    local dir="right" score=0 game_over=0
    local -a body_x body_y
    body_x=($head_x)
    body_y=($head_y)
    
    tput civis
    stty -echo 2>/dev/null
    trap 'stty echo 2>/dev/null; tput cnorm; return' INT EXIT
    
    clear
    
    while [[ $game_over -eq 0 ]]; do
        tput cup 0 0
        echo -e "  \033[38;5;46m🐍 SNAKE\033[0m  Score: $score  [q=quit, wasd=move]"
        echo ""
        
        printf "  +"
        printf -- "-%.0s" $(seq 1 $width)
        echo "+"
        
        for ((y=1; y<=height; y++)); do
            printf "  |"
            for ((x=1; x<=width; x++)); do
                local cell=" "
                
                [[ $x -eq $food_x && $y -eq $food_y ]] && cell="\033[38;5;196m@\033[0m"
                
                for ((i=1; i<=${#body_x[@]}; i++)); do
                    if [[ ${body_x[$i]} -eq $x && ${body_y[$i]} -eq $y ]]; then
                        [[ $i -eq 1 ]] && cell="\033[38;5;46mO\033[0m" || cell="\033[38;5;34mo\033[0m"
                        break
                    fi
                done
                
                echo -ne "$cell"
            done
            echo "|"
        done
        
        printf "  +"
        printf -- "-%.0s" $(seq 1 $width)
        echo "+"
        
        read -t 0.12 -s -n 1 key 2>/dev/null || true
        case "$key" in
            w|W) [[ $dir != "down" ]] && dir="up" ;;
            s|S) [[ $dir != "up" ]] && dir="down" ;;
            a|A) [[ $dir != "right" ]] && dir="left" ;;
            d|D) [[ $dir != "left" ]] && dir="right" ;;
            q|Q) game_over=1; continue ;;
        esac
        
        case "$dir" in
            up) ((head_y--)) ;;
            down) ((head_y++)) ;;
            left) ((head_x--)) ;;
            right) ((head_x++)) ;;
        esac
        
        ((head_x < 1 || head_x > width || head_y < 1 || head_y > height)) && game_over=1
        
        for ((i=2; i<=${#body_x[@]}; i++)); do
            [[ ${body_x[$i]} -eq $head_x && ${body_y[$i]} -eq $head_y ]] && game_over=1
        done
        
        if [[ $head_x -eq $food_x && $head_y -eq $food_y ]]; then
            ((score++))
            food_x=$((RANDOM % (width-2) + 2))
            food_y=$((RANDOM % (height-2) + 2))
            body_x=($head_x "${body_x[@]}")
            body_y=($head_y "${body_y[@]}")
        else
            body_x=($head_x "${body_x[@]:0:${#body_x[@]}-1}")
            body_y=($head_y "${body_y[@]:0:${#body_y[@]}-1}")
        fi
    done
    
    stty echo 2>/dev/null
    tput cnorm
    echo ""
    echo -e "  \033[38;5;196m💀 Game Over!\033[0m Final Score: $score"
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# 🎆 Fixed Fireworks
# ─────────────────────────────────────────────────────────────────

fireworks() {
    local duration=${1:-5}
    local width=$(tput cols)
    local height=$(tput lines)
    local end=$((SECONDS + duration))
    local -a colors=(196 208 226 46 51 93 201 213 202 226)
    
    tput civis
    trap 'tput cnorm; clear; return' INT
    clear
    
    while ((SECONDS < end)); do
        local cx=$((RANDOM % (width - 20) + 10))
        local cy=$((RANDOM % (height - 10) + 3))
        local color=${colors[$((RANDOM % 10 + 1))]}
        
        # Rocket trail going up
        for ((ry=height-2; ry>cy; ry-=2)); do
            tput cup $ry $cx
            echo -ne "\033[38;5;226m|\033[0m"
            sleep 0.015
            tput cup $ry $cx
            echo -n " "
        done
        
        # Explosion - expand outward
        for r in 1 2 3 4 5; do
            # 8 directions
            for dir in "0,1" "1,1" "1,0" "1,-1" "0,-1" "-1,-1" "-1,0" "-1,1"; do
                local dx=${dir%,*}
                local dy=${dir#*,}
                local px=$((cx + dx * r))
                local py=$((cy + dy * r))
                
                if ((px > 0 && px < width-1 && py > 1 && py < height-1)); then
                    tput cup $py $px
                    echo -ne "\033[38;5;${color}m*\033[0m"
                fi
            done
            sleep 0.03
        done
        
        sleep 0.1
        
        # Clear explosion
        for r in 1 2 3 4 5; do
            for dir in "0,1" "1,1" "1,0" "1,-1" "0,-1" "-1,-1" "-1,0" "-1,1"; do
                local dx=${dir%,*}
                local dy=${dir#*,}
                local px=$((cx + dx * r))
                local py=$((cy + dy * r))
                
                if ((px > 0 && px < width-1 && py > 1 && py < height-1)); then
                    tput cup $py $px
                    echo -n " "
                fi
            done
        done
    done
    
    tput cnorm
    clear
    echo -e "  \033[38;5;226m🎆 Happy celebrations! 🎆\033[0m"
}
