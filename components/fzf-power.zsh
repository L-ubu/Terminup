#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │                  🔍 FZF Power Features                        │
# ╰──────────────────────────────────────────────────────────────╯

# Check if fzf is installed
if ! command -v fzf &>/dev/null; then
    echo -e "\033[38;5;226m⚠️  FZF not found. Install it for enhanced Ctrl+R search:\033[0m"
    echo -e "   \033[38;5;245mbrew install fzf\033[0m"
    return
fi

# FZF Configuration - Beautiful theme
export FZF_DEFAULT_OPTS="
    --height 50%
    --layout=reverse
    --border=rounded
    --margin=1
    --padding=1
    --info=inline
    --prompt='   '
    --pointer='▶'
    --marker='✓'
    --header-first
    --cycle
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
    --color=border:#89b4fa
    --bind='ctrl-/:toggle-preview'
    --bind='ctrl-d:half-page-down'
    --bind='ctrl-u:half-page-up'
    --bind='ctrl-y:preview-up'
    --bind='ctrl-e:preview-down'
"

# Enhanced history search with preview
export FZF_CTRL_R_OPTS="
    --header '🔍 Command History'
    --preview 'echo {}'
    --preview-window 'down:3:wrap'
    --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
    --header-first
"

# File search with preview
export FZF_CTRL_T_OPTS="
    --header '📁 File Search'
    --preview 'bat --style=numbers --color=always --line-range=:500 {} 2>/dev/null || cat {} 2>/dev/null || tree -C {} 2>/dev/null'
    --preview-window 'right:60%:wrap'
    --bind 'ctrl-/:toggle-preview'
"

# Directory search
export FZF_ALT_C_OPTS="
    --header '📂 Directory Search'
    --preview 'tree -C {} 2>/dev/null | head -100'
    --preview-window 'right:50%'
"

# Better Ctrl+R - History search with live preview
fzf-history-widget-enhanced() {
    local selected
    setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null
    
    selected=$(fc -rl 1 | awk '{ cmd=$0; sub(/^[ 0-9]+\*?[ ]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
        fzf --query="$LBUFFER" \
            --scheme=history \
            --header='  🔍 Search History (Ctrl+Y to copy)' \
            --preview='echo {}' \
            --preview-window='down:3:wrap' \
            --bind='ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' \
            +m)
    
    local ret=$?
    if [[ -n "$selected" ]]; then
        local num
        num=$(echo "$selected" | awk '{print $1}')
        if [[ -n "$num" ]]; then
            zle vi-fetch-history -n $num
        fi
    fi
    zle reset-prompt
    return $ret
}
zle -N fzf-history-widget-enhanced

# Bind to Ctrl+R
bindkey '^R' fzf-history-widget-enhanced

# File finder with preview
ff() {
    local file
    file=$(find . -type f -not -path '*/\.*' -not -path '*/node_modules/*' 2>/dev/null | 
        fzf --header='  📄 Find Files' \
            --preview 'bat --style=numbers --color=always --line-range=:500 {} 2>/dev/null || cat {}' \
            --preview-window='right:60%:wrap')
    
    if [[ -n "$file" ]]; then
        echo "$file"
        # Open in default editor if EDITOR is set
        [[ -n "$EDITOR" ]] && $EDITOR "$file"
    fi
}

# Git branch selector
fbr() {
    local branch
    branch=$(git branch -a --color=always | 
        grep -v '/HEAD\s' |
        fzf --ansi \
            --header='  🌿 Git Branches' \
            --preview 'git log --oneline --graph --color=always $(echo {} | sed "s/.* //" | sed "s#remotes/[^/]*/##")' \
            --preview-window='right:50%' |
        sed 's/^..//' | 
        sed 's#remotes/[^/]*/##')
    
    if [[ -n "$branch" ]]; then
        git checkout "$branch"
    fi
}

# Git log selector
flog() {
    local commit
    commit=$(git log --oneline --graph --color=always |
        fzf --ansi \
            --header='  📜 Git Log' \
            --preview 'git show --color=always $(echo {} | grep -o "[a-f0-9]\{7,\}" | head -1)' \
            --preview-window='right:60%:wrap' |
        grep -o "[a-f0-9]\{7,\}" | head -1)
    
    if [[ -n "$commit" ]]; then
        echo "$commit"
        echo "$commit" | pbcopy
        echo -e "\033[38;5;46m✓ Commit hash copied to clipboard\033[0m"
    fi
}

# Process killer
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | 
        fzf --header='  ⚡ Kill Process' \
            --preview 'echo {}' \
            --preview-window='down:3:wrap' \
            -m | 
        awk '{print $2}')
    
    if [[ -n "$pid" ]]; then
        echo "$pid" | xargs kill -9
        echo -e "\033[38;5;46m✓ Process killed\033[0m"
    fi
}

# Docker container selector
fdocker() {
    local container
    container=$(docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}" |
        fzf --header='  🐳 Docker Containers' \
            --preview 'docker logs --tail 20 $(echo {} | awk "{print \$1}")' \
            --preview-window='right:50%:wrap' |
        awk '{print $1}')
    
    if [[ -n "$container" ]]; then
        echo "$container"
    fi
}

# npm scripts selector
fscript() {
    if [[ ! -f "package.json" ]]; then
        echo -e "\033[38;5;196m✗ No package.json found\033[0m"
        return 1
    fi
    
    local script
    script=$(node -e "
        const pkg = require('./package.json');
        const scripts = pkg.scripts || {};
        Object.entries(scripts).forEach(([name, cmd]) => {
            console.log(name + '\t' + cmd);
        });
    " | column -t -s $'\t' |
        fzf --header='  📜 NPM Scripts' \
            --preview 'echo "Command: $(echo {} | awk "{print \$NF}")"' \
            --preview-window='down:3:wrap' |
        awk '{print $1}')
    
    if [[ -n "$script" ]]; then
        echo -e "\n  \033[38;5;51m▶ Running:\033[0m $script\n"
        if [[ -f "pnpm-lock.yaml" ]]; then
            pnpm run "$script"
        elif [[ -f "yarn.lock" ]]; then
            yarn "$script"
        else
            npm run "$script"
        fi
    fi
}

# Bookmark directories
BOOKMARK_FILE="$HOME/.dir_bookmarks"
[[ ! -f "$BOOKMARK_FILE" ]] && touch "$BOOKMARK_FILE"

# Add current directory to bookmarks
bm() {
    local current="$PWD"
    if ! grep -q "^${current}$" "$BOOKMARK_FILE" 2>/dev/null; then
        echo "$current" >> "$BOOKMARK_FILE"
        echo -e "  \033[38;5;46m✓ Bookmarked:\033[0m $current"
    else
        echo -e "  \033[38;5;226m⚠ Already bookmarked\033[0m"
    fi
}

# Jump to bookmark
jb() {
    local dir
    dir=$(cat "$BOOKMARK_FILE" | 
        fzf --header='  🔖 Bookmarks' \
            --preview 'ls -la {}' \
            --preview-window='right:50%')
    
    if [[ -n "$dir" && -d "$dir" ]]; then
        cd "$dir"
    fi
}

# Remove bookmark
rbm() {
    local dir
    dir=$(cat "$BOOKMARK_FILE" | 
        fzf --header='  🗑️ Remove Bookmark' \
            --preview 'ls -la {}' \
            --preview-window='right:50%')
    
    if [[ -n "$dir" ]]; then
        grep -v "^${dir}$" "$BOOKMARK_FILE" > "${BOOKMARK_FILE}.tmp"
        mv "${BOOKMARK_FILE}.tmp" "$BOOKMARK_FILE"
        echo -e "  \033[38;5;196m✓ Removed:\033[0m $dir"
    fi
}
