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
        echo -e "  \033[38;5;226m📝 Enter commit message:\033[0m"
        read -r message
    fi
    
    if [[ -z "$message" ]]; then
        echo -e "  \033[38;5;196m✗ Commit cancelled - no message provided\033[0m"
        return 1
    fi
    
    # Animated commit
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    
    git commit -m "$message" &>/dev/null &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  \033[38;5;51m%s\033[0m Committing changes..." "${frames[$((i % 10))]}"
        sleep 0.1
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓\033[0m Changes committed successfully! 🎉\033[K"
        echo ""
        echo -e "  \033[38;5;245mMessage:\033[0m $message"
        echo ""
    else
        echo -e "\r  \033[38;5;196m✗\033[0m Commit failed\033[K"
    fi
    
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
    
    git push $remote $branch 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  %s Pushing to remote..." "${rockets[$((i % 8))]}"
        sleep 0.15
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓\033[0m Successfully pushed to $remote/$branch! ☁️✨\033[K"
        echo ""
        
        # Show celebration
        local emojis=("🎉" "🚀" "✨" "🌟")
        for i in {1..2}; do
            for emoji in "${emojis[@]}"; do
                printf "\r  %s Push complete! %s" "$emoji" "$emoji"
                sleep 0.1
            done
        done
        printf "\r  🎉 Push complete! 🎉\033[K\n"
    else
        echo -e "\r  \033[38;5;196m✗\033[0m Push failed\033[K"
    fi
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
    
    git pull $remote $branch 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  %s Pulling from remote..." "${download[$((i % 8))]}"
        sleep 0.15
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓\033[0m Successfully pulled from $remote/$branch! 📦✨\033[K"
    else
        echo -e "\r  \033[38;5;196m✗\033[0m Pull failed or conflicts detected\033[K"
    fi
    echo ""
    
    return $exit_code
}

# Git add with animation
ga() {
    local files="${@:-.}"
    
    echo -e "\n  \033[38;5;208m📂 Staging files...\033[0m"
    
    git add $files &>/dev/null &
    local pid=$!
    local frames=("▱▱▱▱▱▱▱" "▰▱▱▱▱▱▱" "▰▰▱▱▱▱▱" "▰▰▰▱▱▱▱" "▰▰▰▰▱▱▱" "▰▰▰▰▰▱▱" "▰▰▰▰▰▰▱" "▰▰▰▰▰▰▰")
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  \033[38;5;208m%s\033[0m" "${frames[$((i % 8))]}"
        sleep 0.1
        ((i++))
    done
    
    wait $pid
    
    echo -e "\r  \033[38;5;46m✓ Files staged!\033[0m\033[K"
    echo ""
    
    # Show what was staged
    git diff --cached --name-only | while read file; do
        echo -e "    \033[38;5;46m+\033[0m $file"
    done
    echo ""
}

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
        echo -e "  \033[38;5;196m✗ Please specify a branch name\033[0m"
        return 1
    fi
    
    echo -e "\n  \033[38;5;51m🔄 Switching to branch: $branch\033[0m"
    
    local frames=("◐" "◓" "◑" "◒")
    git checkout $branch 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  \033[38;5;51m%s\033[0m Switching branches..." "${frames[$((i % 4))]}"
        sleep 0.1
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓\033[0m Switched to branch: $branch 🌿\033[K"
    else
        echo -e "\r  \033[38;5;196m✗\033[0m Failed to switch branch\033[K"
    fi
    echo ""
    
    return $exit_code
}

# Git stash with animation
gst() {
    echo -e "\n  \033[38;5;214m📦 Stashing changes...\033[0m"
    
    local frames=("🔒" "🔐" "🔓" "🔐")
    git stash 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  %s Stashing..." "${frames[$((i % 4))]}"
        sleep 0.2
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓\033[0m Changes stashed safely! 🔒\033[K"
    else
        echo -e "\r  \033[38;5;196m✗\033[0m Stash failed\033[K"
    fi
    echo ""
    
    return $exit_code
}

# Git stash pop with animation
gstp() {
    echo -e "\n  \033[38;5;214m📦 Popping stash...\033[0m"
    
    local frames=("🔓" "📂" "📄" "✨")
    git stash pop 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  %s Restoring..." "${frames[$((i % 4))]}"
        sleep 0.2
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓\033[0m Stash restored! ✨\033[K"
    else
        echo -e "\r  \033[38;5;196m✗\033[0m Failed to restore stash\033[K"
    fi
    echo ""
    
    return $exit_code
}

# Git merge with ASCII art
gm() {
    local branch="$1"
    
    if [[ -z "$branch" ]]; then
        echo -e "  \033[38;5;196m✗ Please specify a branch to merge\033[0m"
        return 1
    fi
    
    echo -e "\033[38;5;177m$GIT_MERGE_ART\033[0m"
    
    local current=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    echo -e "  \033[38;5;245mMerging:\033[0m $branch → $current"
    echo ""
    
    local frames=("╭─" "├─" "├─" "╰─" "──" "▶▶")
    git merge $branch 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  \033[38;5;177m%s\033[0m Merging branches..." "${frames[$((i % 6))]}"
        sleep 0.15
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓\033[0m Merge complete! 🌟\033[K"
    else
        echo -e "\r  \033[38;5;196m✗\033[0m Merge failed or has conflicts\033[K"
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
        echo -e "  \033[38;5;46m⇡ $ahead\033[0m commits ahead of remote"
    fi
    if [[ "$behind" != "0" ]]; then
        echo -e "  \033[38;5;196m⇣ $behind\033[0m commits behind remote"
    fi
    if [[ "$ahead" == "0" && "$behind" == "0" ]]; then
        echo -e "  \033[38;5;46m✓\033[0m Up to date with remote"
    fi
    
    echo ""
    echo -e "  \033[38;5;46m● Staged:\033[0m $staged files"
    echo -e "  \033[38;5;208m● Modified:\033[0m $unstaged files"
    echo -e "  \033[38;5;196m● Untracked:\033[0m $untracked files"
    echo ""
}
