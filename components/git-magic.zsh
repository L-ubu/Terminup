#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │                    🔮 Git Magic Commands                      │
# ╰──────────────────────────────────────────────────────────────╯

# ASCII Art for Git operations
GIT_COMMIT_ART='
   ╭─────────────────────────────────╮
   │  📝 COMMIT                      │
   ╰─────────────────────────────────╯
      ║
      ║  ┌──────────────────┐
      ╚══│   Saving code    │══╗
         │    to history    │  ║
         └──────────────────┘  ║
                               ▼
'

GIT_PUSH_ART='
   ╭─────────────────────────────────╮
   │  🚀 PUSHING TO REMOTE           │
   ╰─────────────────────────────────╯
   
      LOCAL          ════════▶         REMOTE
     ┌─────┐                          ┌─────┐
     │ 📦  │  ───── ✨ ─────────────▶ │ ☁️  │
     └─────┘                          └─────┘
'

GIT_PULL_ART='
   ╭─────────────────────────────────╮
   │  📥 PULLING FROM REMOTE         │
   ╰─────────────────────────────────╯
   
      REMOTE         ════════▶         LOCAL
     ┌─────┐                          ┌─────┐
     │ ☁️  │  ───── 💫 ─────────────▶ │ 📦  │
     └─────┘                          └─────┘
'

GIT_MERGE_ART='
   ╭─────────────────────────────────╮
   │  🔀 MERGING BRANCHES            │
   ╰─────────────────────────────────╯
   
         ─────────╮
                  ├─────▶ 🌟
         ─────────╯
'

GIT_BRANCH_ART='
   ╭─────────────────────────────────╮
   │  🌿 BRANCH OPERATIONS           │
   ╰─────────────────────────────────╯
'

# Pretty git log
alias glog='git log --graph --pretty=format:"%C(magenta)%h%C(reset) -%C(yellow)%d%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset) %C(cyan)(%ar)%C(reset)" --abbrev-commit'
alias glog10='glog -10'
alias glog20='glog -20'

# Pretty git status
alias gs='git status -sb'

# Pretty diff
alias gd='git diff --color-words'
alias gds='git diff --staged --color-words'

# Git commit with ASCII art
gc() {
    echo -e "\033[38;5;213m$GIT_COMMIT_ART\033[0m"
    
    if [[ -n "$1" ]]; then
        local message="$*"
    else
        echo -e "  \033[38;5;226m📝 $(_t enter_message "Enter commit message"):\033[0m"
        read -r message
    fi
    
    if [[ -z "$message" ]]; then
        echo -e "  \033[38;5;196m✗ $(_t cancelled) - $(_t no_message "no message provided")\033[0m"
        return 1
    fi
    
    # Animated commit
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    
    local _git_err=$(mktemp)
    git commit -m "$message" >"$_git_err" 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  \033[38;5;51m%s\033[0m $(_t git_commit)..." "${frames[$((i % 10))]}"
        sleep 0.1
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓\033[0m $(_t success)! 🎉\033[K"
        echo ""
        echo -e "  \033[38;5;245mMessage:\033[0m $message"
        echo ""
    else
        echo -e "\r  \033[38;5;196m✗\033[0m $(_t git_commit) $(_t error)\033[K"
        echo -e "  \033[38;5;245m$(cat "$_git_err")\033[0m"
    fi
    rm -f "$_git_err"
    
    return $exit_code
}

# Git push with ASCII art
gp() {
    echo -e "\033[38;5;39m$GIT_PUSH_ART\033[0m"
    
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    local remote="${1:-origin}"
    
    echo -e "  \033[38;5;245mBranch:\033[0m $branch"
    echo -e "  \033[38;5;245mRemote:\033[0m $remote"
    echo ""
    
    # Animated push with rocket
    local rockets=("🚀      " " 🚀     " "  🚀    " "   🚀   " "    🚀  " "     🚀 " "      🚀" "     ☁️ ")
    
    local _git_err=$(mktemp)
    git push $remote $branch >"$_git_err" 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  %s $(_t git_push)..." "${rockets[$((i % 8))]}"
        sleep 0.15
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓\033[0m $(_t success)! ☁️✨\033[K"
        echo ""
        
        local emojis=("🎉" "🚀" "✨" "🌟")
        for i in {1..2}; do
            for emoji in "${emojis[@]}"; do
                printf "\r  %s $(_t done)! %s" "$emoji" "$emoji"
                sleep 0.1
            done
        done
        printf "\r  🎉 $(_t done)! 🎉\033[K\n"
    else
        echo -e "\r  \033[38;5;196m✗\033[0m $(_t git_push) $(_t error)\033[K"
        echo -e "  \033[38;5;245m$(cat "$_git_err")\033[0m"
    fi
    rm -f "$_git_err"
    echo ""
    
    return $exit_code
}

# Git pull with ASCII art
gl() {
    echo -e "\033[38;5;87m$GIT_PULL_ART\033[0m"
    
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    local remote="${1:-origin}"
    
    echo -e "  \033[38;5;245mBranch:\033[0m $branch"
    echo -e "  \033[38;5;245mRemote:\033[0m $remote"
    echo ""
    
    # Animated pull with download effect
    local download=("📥      " " 📥     " "  📥    " "   📥   " "    📥  " "     📥 " "      📥" "      📦")
    
    local _git_err=$(mktemp)
    git pull $remote $branch >"$_git_err" 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  %s $(_t git_pull)..." "${download[$((i % 8))]}"
        sleep 0.15
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓\033[0m $(_t success)! 📦✨\033[K"
    else
        echo -e "\r  \033[38;5;196m✗\033[0m $(_t git_pull) $(_t error)\033[K"
        echo -e "  \033[38;5;245m$(cat "$_git_err")\033[0m"
    fi
    rm -f "$_git_err"
    echo ""
    
    return $exit_code
}

# Git add with animation
ga() {
    local files="${@:-.}"
    
    echo -e "\n  \033[38;5;208m📂 $(_t git_add)...\033[0m"
    
    git add "${=files}" &>/dev/null &
    local pid=$!
    local frames=("▱▱▱▱▱▱▱" "▰▱▱▱▱▱▱" "▰▰▱▱▱▱▱" "▰▰▰▱▱▱▱" "▰▰▰▰▱▱▱" "▰▰▰▰▰▱▱" "▰▰▰▰▰▰▱" "▰▰▰▰▰▰▰")
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  \033[38;5;208m%s\033[0m" "${frames[$((i % 8))]}"
        sleep 0.1
        ((i++))
    done
    
    wait $pid
    
    echo -e "\r  \033[38;5;46m✓ $(_t done)!\033[0m\033[K"
    echo ""
    
    # Show what was staged
    git diff --cached --name-only | while read file; do
        echo -e "    \033[38;5;46m+\033[0m $file"
    done
    echo ""
}

# Fuzzy git add - interactive file selector
fga() {
    if ! command -v fzf &>/dev/null; then
        echo -e "  \033[38;5;196m✗\033[0m fzf required. Install with: brew install fzf"
        return 1
    fi
    
    # Get list of changed files
    local changed=$(git status --porcelain 2>/dev/null)
    
    if [[ -z "$changed" ]]; then
        echo -e "  \033[38;5;245m✓ Nothing to add - working tree clean\033[0m"
        return 0
    fi
    
    # Show header
    echo ""
    echo -e "  \033[38;5;208m╭───────────────────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;208m│\033[0m          \033[1;38;5;208m📂 FUZZY GIT ADD\033[0m                       \033[38;5;208m│\033[0m"
    echo -e "  \033[38;5;208m╰───────────────────────────────────────────────────╯\033[0m"
    echo ""
    echo -e "  \033[38;5;245mTAB to select multiple │ ENTER to stage │ ESC to cancel\033[0m"
    echo ""
    
    # Use fzf to select files with preview
    local selected=$(git status --porcelain | \
        fzf --multi \
            --ansi \
            --header="Select files to stage (TAB for multi-select)" \
            --preview='
                file=$(echo {} | cut -c4-)
                status=$(echo {} | cut -c1-2)
                echo -e "\033[38;5;51m═══ Status: $status ═══\033[0m"
                echo ""
                if [[ -f "$file" ]]; then
                    git diff --color=always -- "$file" 2>/dev/null || cat "$file" 2>/dev/null | head -50
                else
                    echo "File deleted or binary"
                fi
            ' \
            --preview-window='right:60%:wrap' \
            --bind='ctrl-a:select-all' \
            --bind='ctrl-d:deselect-all' \
            --color='header:yellow,info:green,pointer:red,marker:cyan,prompt:magenta' \
        | cut -c4-)
    
    if [[ -z "$selected" ]]; then
        echo -e "  \033[38;5;245mNo files selected.\033[0m"
        return 0
    fi
    
    # Stage selected files
    echo "$selected" | while read -r file; do
        if [[ -n "$file" ]]; then
            git add "$file"
            echo -e "  \033[38;5;46m✓ Staged:\033[0m $file"
        fi
    done
    
    echo ""
    echo -e "  \033[38;5;208m📊 Staged changes:\033[0m"
    git diff --cached --stat | head -20
    echo ""
}

# Alias for convenience
alias gadd='fga'

# Git branch with pretty display
gb() {
    echo -e "\033[38;5;77m$GIT_BRANCH_ART\033[0m"
    
    local current=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    
    echo -e "  \033[38;5;226m★ Current:\033[0m $current"
    echo ""
    echo -e "  \033[38;5;245mLocal branches:\033[0m"
    
    git branch --format='%(refname:short)' | while read branch; do
        if [[ "$branch" == "$current" ]]; then
            echo -e "    \033[38;5;46m▶ $branch\033[0m (current)"
        else
            echo -e "    \033[38;5;245m○\033[0m $branch"
        fi
    done
    echo ""
}

# Git checkout with animation
gco() {
    local branch="$1"
    
    if [[ -z "$branch" ]]; then
        echo -e "  \033[38;5;196m✗ $(_t error): $(_t specify_branch "Please specify a branch name")\033[0m"
        return 1
    fi
    
    echo -e "\n  \033[38;5;51m🔄 $(_t git_checkout): $branch\033[0m"
    
    local frames=("◐" "◓" "◑" "◒")
    git checkout $branch 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  \033[38;5;51m%s\033[0m $(_t git_checkout)..." "${frames[$((i % 4))]}"
        sleep 0.1
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓\033[0m $(_t success): $branch 🌿\033[K"
    else
        echo -e "\r  \033[38;5;196m✗\033[0m $(_t git_checkout) $(_t error)\033[K"
    fi
    echo ""
    
    return $exit_code
}

# Git stash with animation
gst() {
    echo -e "\n  \033[38;5;214m📦 $(_t git_stash)...\033[0m"
    
    local frames=("🔒" "🔐" "🔓" "🔐")
    git stash 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  %s $(_t git_stash)..." "${frames[$((i % 4))]}"
        sleep 0.2
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓\033[0m $(_t success)! 🔒\033[K"
    else
        echo -e "\r  \033[38;5;196m✗\033[0m $(_t git_stash) $(_t error)\033[K"
    fi
    echo ""
    
    return $exit_code
}

# Git stash pop with animation
gstp() {
    echo -e "\n  \033[38;5;214m📦 $(_t git_stash_pop)...\033[0m"
    
    local frames=("🔓" "📂" "📄" "✨")
    git stash pop 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  %s $(_t git_stash_pop)..." "${frames[$((i % 4))]}"
        sleep 0.2
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓\033[0m $(_t success)! ✨\033[K"
    else
        echo -e "\r  \033[38;5;196m✗\033[0m $(_t git_stash_pop) $(_t error)\033[K"
    fi
    echo ""
    
    return $exit_code
}

# Git merge with ASCII art
gm() {
    local branch="$1"
    
    if [[ -z "$branch" ]]; then
        echo -e "  \033[38;5;196m✗ $(_t error): $(_t specify_branch "Please specify a branch to merge")\033[0m"
        return 1
    fi
    
    echo -e "\033[38;5;177m$GIT_MERGE_ART\033[0m"
    
    local current=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    echo -e "  \033[38;5;245m$(_t git_merge):\033[0m $branch → $current"
    echo ""
    
    local frames=("╭─" "├─" "├─" "╰─" "──" "▶▶")
    git merge $branch 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  \033[38;5;177m%s\033[0m $(_t git_merge)..." "${frames[$((i % 6))]}"
        sleep 0.15
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓\033[0m $(_t success)! 🌟\033[K"
    else
        echo -e "\r  \033[38;5;196m✗\033[0m $(_t git_merge) $(_t error)\033[K"
    fi
    echo ""
    
    return $exit_code
}

# Quick status overview
gss() {
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m         \033[1m📊 Git Status Overview\033[0m        \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    local ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
    local behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
    local staged=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    local unstaged=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    local untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
    
    echo -e "  \033[38;5;226m🌿 Branch:\033[0m $branch"
    echo ""
    
    if [[ "$ahead" != "0" ]]; then
        echo -e "  \033[38;5;46m⇡ $ahead\033[0m commits ahead"
    fi
    if [[ "$behind" != "0" ]]; then
        echo -e "  \033[38;5;196m⇣ $behind\033[0m commits behind"
    fi
    if [[ "$ahead" == "0" && "$behind" == "0" ]]; then
        echo -e "  \033[38;5;46m✓\033[0m Up to date"
    fi
    
    echo ""
    echo -e "  \033[38;5;46m● Staged:\033[0m $staged files"
    echo -e "  \033[38;5;208m● Modified:\033[0m $unstaged files"
    echo -e "  \033[38;5;196m● Untracked:\033[0m $untracked files"
    echo ""
}
