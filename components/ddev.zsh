#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │                    🐳 DDEV Enhancements                       │
# ╰──────────────────────────────────────────────────────────────╯

DDEV_ART='
   ╭─────────────────────────────────────╮
   │  🐳 DDEV                            │
   ╰─────────────────────────────────────╯
'

# Check if we're in a DDEV project
is_ddev_project() {
    [[ -f ".ddev/config.yaml" ]] && return 0
    return 1
}

# DDEV status indicator
ddev_status() {
    if is_ddev_project; then
        local status=$(ddev describe -j 2>/dev/null | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
        case "$status" in
            running)
                echo -e "\033[38;5;46m●\033[0m DDEV running"
                ;;
            stopped)
                echo -e "\033[38;5;196m●\033[0m DDEV stopped"
                ;;
            *)
                echo -e "\033[38;5;245m●\033[0m DDEV status unknown"
                ;;
        esac
    else
        echo -e "\033[38;5;245mNot a DDEV project\033[0m"
    fi
}

# ─────────────────────────────────────────────────────────────────
# DDEV NPM/PNPM Commands
# ─────────────────────────────────────────────────────────────────

# Smart npm - uses ddev if in ddev project
dd.ni() {
    local packages="$@"
    
    if is_ddev_project; then
        echo -e "\033[38;5;39m$DDEV_ART\033[0m"
        echo -e "  \033[38;5;39m🐳 Running npm install inside DDEV container\033[0m"
        echo ""
        
        local frames=("📦    " "📦📦   " "📦📦📦  " "📦📦📦📦 " "📦📦📦📦📦")
        
        ddev npm install $packages 2>&1 &
        local pid=$!
        local i=0
        
        while kill -0 $pid 2>/dev/null; do
            printf "\r  %s Installing packages..." "${frames[$((i % 5))]}"
            sleep 0.2
            ((i++))
        done
        
        wait $pid
        local exit_code=$?
        
        if [[ $exit_code -eq 0 ]]; then
            echo -e "\r  \033[38;5;46m✓ DDEV npm install complete!\033[0m 🐳✨\033[K"
        else
            echo -e "\r  \033[38;5;196m✗ DDEV npm install failed\033[0m\033[K"
        fi
    else
        # Fall back to regular npm install
        ni $packages
    fi
}

# Smart pnpm - uses ddev if in ddev project
dd.pi() {
    local packages="$@"
    
    if is_ddev_project; then
        echo -e "\033[38;5;208m$DDEV_ART\033[0m"
        echo -e "  \033[38;5;208m🐳 Running pnpm install inside DDEV container\033[0m"
        echo ""
        
        local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
        
        ddev pnpm install $packages 2>&1 &
        local pid=$!
        local i=0
        
        while kill -0 $pid 2>/dev/null; do
            printf "\r  \033[38;5;208m%s\033[0m Installing packages..." "${frames[$((i % 10))]}"
            sleep 0.1
            ((i++))
        done
        
        wait $pid
        local exit_code=$?
        
        if [[ $exit_code -eq 0 ]]; then
            echo -e "\r  \033[38;5;46m✓ DDEV pnpm install complete!\033[0m 🐳✨\033[K"
        else
            echo -e "\r  \033[38;5;196m✗ DDEV pnpm install failed\033[0m\033[K"
        fi
    else
        # Fall back to regular pnpm install
        pi $packages
    fi
}

# DDEV dev server
dd.pd() {
    if ! is_ddev_project; then
        echo -e "  \033[38;5;196m✗ Not in a DDEV project\033[0m"
        return 1
    fi
    
    echo -e "\033[38;5;46m$DDEV_ART\033[0m"
    
    # Rocket animation
    local rocket_frames=("🐳       " " 🐳      " "  🐳     " "   🐳    " "    🐳   " "     🐳  " "      🐳 " "       🐳")
    for frame in "${rocket_frames[@]}"; do
        printf "\r  %s" "$frame"
        sleep 0.08
    done
    echo ""
    
    echo -e "  \033[38;5;46m▶ Starting DDEV dev server...\033[0m"
    echo ""
    
    # Check for package manager preference
    if [[ -f "pnpm-lock.yaml" ]]; then
        ddev pnpm run dev
    elif [[ -f "yarn.lock" ]]; then
        ddev yarn dev
    else
        ddev npm run dev
    fi
}

# DDEV build
dd.pb() {
    if ! is_ddev_project; then
        echo -e "  \033[38;5;196m✗ Not in a DDEV project\033[0m"
        return 1
    fi
    
    echo -e "\033[38;5;226m$DDEV_ART\033[0m"
    echo -e "  \033[38;5;226m🔨 Building inside DDEV container...\033[0m"
    echo ""
    
    local start_time=$(date +%s)
    
    if [[ -f "pnpm-lock.yaml" ]]; then
        ddev pnpm run build
    elif [[ -f "yarn.lock" ]]; then
        ddev yarn build
    else
        ddev npm run build
    fi
    
    local exit_code=$?
    local total_time=$(($(date +%s) - start_time))
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\n  \033[38;5;46m✓ DDEV build complete!\033[0m (${total_time}s) 🐳"
    fi
}

# DDEV scripts list
dd.ps-list() {
    if ! is_ddev_project; then
        echo -e "  \033[38;5;196m✗ Not in a DDEV project\033[0m"
        return 1
    fi
    
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m      \033[1m🐳 DDEV Available Scripts\033[0m         \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    
    scripts
}

# DDEV start
dd.start() {
    echo -e "\n  \033[38;5;39m🐳 Starting DDEV...\033[0m"
    
    local frames=("◐" "◓" "◑" "◒")
    ddev start 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  \033[38;5;39m%s\033[0m Starting containers..." "${frames[$((i % 4))]}"
        sleep 0.2
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓ DDEV started!\033[0m 🐳\033[K"
        echo ""
        ddev describe 2>/dev/null | grep -E "(URL|mailhog)" | head -5
    else
        echo -e "\r  \033[38;5;196m✗ DDEV start failed\033[0m\033[K"
    fi
    echo ""
}

# DDEV stop
dd.stop() {
    echo -e "\n  \033[38;5;208m🐳 Stopping DDEV...\033[0m"
    
    local frames=("◐" "◓" "◑" "◒")
    ddev stop 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  \033[38;5;208m%s\033[0m Stopping containers..." "${frames[$((i % 4))]}"
        sleep 0.2
        ((i++))
    done
    
    wait $pid
    echo -e "\r  \033[38;5;46m✓ DDEV stopped!\033[0m\033[K"
    echo ""
}

# DDEV restart
dd.restart() {
    echo -e "\n  \033[38;5;226m🐳 Restarting DDEV...\033[0m"
    ddev restart
    echo -e "  \033[38;5;46m✓ DDEV restarted!\033[0m 🐳"
    echo ""
}

# DDEV SSH with style
dd.ssh() {
    echo -e "\n  \033[38;5;51m🐳 Connecting to DDEV container...\033[0m\n"
    ddev ssh
}

# DDEV logs with style  
dd.logs() {
    echo -e "\n  \033[38;5;51m🐳 DDEV Logs\033[0m\n"
    ddev logs -f
}

# DDEV describe with better formatting
dd.describe() {
    if ! is_ddev_project; then
        echo -e "  \033[38;5;196m✗ Not in a DDEV project\033[0m"
        return 1
    fi
    
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m         \033[1m🐳 DDEV Project Info\033[0m           \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    ddev describe
}

# DDEV composer
dd.comp() {
    if ! is_ddev_project; then
        echo -e "  \033[38;5;196m✗ Not in a DDEV project\033[0m"
        return 1
    fi
    
    echo -e "\n  \033[38;5;141m🎼 Running composer inside DDEV...\033[0m\n"
    ddev composer "$@"
}

# DDEV sequelace
dd.seq() {
    if ! is_ddev_project; then
        echo -e "  \033[38;5;196m✗ Not in a DDEV project\033[0m"
        return 1
    fi
    
    echo -e "\n  \033[38;5;33m🗄️ Opening sequelace...\033[0m\n"
    ddev sequelace
}

# DDEV Console
dd.c() {
    if ! is_ddev_project; then
        echo -e "  \033[38;5;196m✗ Not in a DDEV project\033[0m"
        return 1
    fi
    ddev console "$@"
}

# DDEV Console Cache Clear
dd.cc() {
    if ! is_ddev_project; then
        echo -e "  \033[38;5;196m✗ Not in a DDEV project\033[0m"
        return 1
    fi
    echo -e "  \033[38;5;46m🧹 Clearing Symfony cache...\033[0m"
    ddev console cache:clear "$@"
}

# Fuzzy DDEV project selector (if multiple projects)
fddev() {
    if ! command -v fzf &>/dev/null; then
        echo -e "  \033[38;5;196m✗ fzf required for this command\033[0m"
        return 1
    fi
    
    local project
    project=$(ddev list -j 2>/dev/null | grep -o '"name":"[^"]*"' | cut -d'"' -f4 | 
        fzf --header='  🐳 Select DDEV Project' \
            --preview 'ddev describe {} 2>/dev/null')
    
    if [[ -n "$project" ]]; then
        local project_dir=$(ddev describe "$project" -j 2>/dev/null | grep -o '"approot":"[^"]*"' | cut -d'"' -f4)
        if [[ -n "$project_dir" && -d "$project_dir" ]]; then
            cd "$project_dir"
            echo -e "  \033[38;5;46m✓ Switched to:\033[0m $project"
        fi
    fi
}

# List all DDEV projects
dd.list() {
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m          \033[1m🐳 DDEV Projects\033[0m              \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    ddev list
    echo ""
}

# ─────────────────────────────────────────────────────────────────
# DDEV Main Command Dispatcher
# ─────────────────────────────────────────────────────────────────

# dd command with subcommands
dd() {
    if [[ $# -eq 0 ]]; then
        ddev
        return $?
    fi

    local cmd=$1
    shift

    case "$cmd" in
        ni|pi|pd|pb|ps-list|start|stop|restart|ssh|logs|describe|comp|seq|c|cc|list)
            "dd.$cmd" "$@"
            ;;
        *)
            ddev "$cmd" "$@"
            ;;
    esac
}

# ─────────────────────────────────────────────────────────────────
# DDEV Aliases
# ─────────────────────────────────────────────────────────────────
# DDEV alias for ddev
alias dd.="ddev"
