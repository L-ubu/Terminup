#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │                   🧭 Navigation Enhancements                  │
# ╰──────────────────────────────────────────────────────────────╯

# Icon mappings for file types
typeset -gA FILE_ICONS
FILE_ICONS=(
    # Directories
    "dir" "📁"
    ".git" "󰊢"
    "node_modules" "📦"
    "src" "📂"
    "dist" "📤"
    "build" "🔨"
    "test" "🧪"
    "docs" "📚"
    
    # Files
    ".js" "󰌞"
    ".ts" "󰛦"
    ".tsx" "󰜈"
    ".jsx" "󰜈"
    ".json" "󰘦"
    ".md" "󰍔"
    ".py" "󰌠"
    ".rs" "󱘗"
    ".go" "󰟓"
    ".sh" "󰆍"
    ".zsh" "󰆍"
    ".css" "󰌜"
    ".scss" "󰌜"
    ".html" "󰌝"
    ".vue" "󰡄"
    ".svelte" "󰡄"
    ".yaml" "󰈙"
    ".yml" "󰈙"
    ".toml" "󰈙"
    ".env" "󰈙"
    ".gitignore" "󰊢"
    ".dockerignore" "󰡨"
    "Dockerfile" "󰡨"
    "package.json" "󰏗"
    "README" "󰈙"
    "LICENSE" "󰿃"
)

# Get icon for file/directory
get_icon() {
    local name="$1"
    local is_dir="$2"
    
    if [[ "$is_dir" == "true" ]]; then
        # Check for special directories
        [[ -n "${FILE_ICONS[$name]}" ]] && echo "${FILE_ICONS[$name]}" && return
        echo "📁"
        return
    fi
    
    # Check exact filename match
    [[ -n "${FILE_ICONS[$name]}" ]] && echo "${FILE_ICONS[$name]}" && return
    
    # Check extension
    local ext=".${name##*.}"
    [[ -n "${FILE_ICONS[$ext]}" ]] && echo "${FILE_ICONS[$ext]}" && return
    
    # Default file icon
    echo "📄"
}

# Animated cd with directory preview
cd() {
    local target="${1:-$HOME}"
    
    # Expand ~ and resolve path
    target="${target/#\~/$HOME}"
    
    if [[ ! -d "$target" ]]; then
        echo -e "  \033[38;5;196m✗ $(_t dir_not_found):\033[0m $target"
        return 1
    fi
    
    # Actually change directory
    builtin cd "$target" || return 1
    
    # Show compact directory info
    local dir_name="${PWD##*/}"
    local parent_path="${PWD%/*}"
    [[ "$parent_path" == "$HOME"* ]] && parent_path="~${parent_path#$HOME}"
    
    echo -e "  📂 \033[38;5;39m${parent_path}/\033[1;38;5;51m${dir_name}\033[0m"
    
    # Fast file count using zsh globs instead of find
    local dirs=(./*(/N))
    local files=(./*(.N))
    echo -e "     \033[38;5;245m${#dirs} dirs, ${#files} files\033[0m"
}

# Enhanced ls with icons and colors
ll() {
    local target="${1:-.}"
    
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m         \033[1m📂 $(_t directory_listing "Directory Listing")\033[0m          \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    
    # Get current path for display
    local display_path="$target"
    [[ "$display_path" == "." ]] && display_path="$PWD"
    [[ "$display_path" == "$HOME"* ]] && display_path="~${display_path#$HOME}"
    
    echo -e "  \033[38;5;245mLocation:\033[0m $display_path"
    echo ""
    
    # List directories first
    local has_dirs=false
    for item in "$target"/*(/N); do
        [[ ! -e "$item" ]] && continue
        has_dirs=true
        local name="${item##*/}"
        local icon=$(get_icon "$name" "true")
        echo -e "    $icon \033[38;5;39m$name/\033[0m"
    done
    
    # Then list files
    local has_files=false
    for item in "$target"/*(^/N); do
        [[ ! -e "$item" ]] && continue
        has_files=true
        local name="${item##*/}"
        local icon=$(get_icon "$name" "false")
        local size=$(ls -lh "$item" 2>/dev/null | awk '{print $5}')
        
        # Color based on file type
        local color="245"
        [[ -x "$item" ]] && color="46"
        [[ "$name" == .* ]] && color="240"
        
        printf "    %s \033[38;5;${color}m%-30s\033[0m \033[38;5;240m%s\033[0m\n" "$icon" "$name" "$size"
    done
    
    [[ "$has_dirs" == "false" && "$has_files" == "false" ]] && echo -e "    \033[38;5;240m($(_t empty_dir "empty directory"))\033[0m"
    
    echo ""
}

# Quick ls alias (simple version)
l() {
    local target="${1:-.}"
    
    # Compact listing
    for item in "$target"/*(/N); do
        [[ -e "$item" ]] && printf "\033[38;5;39m%s/\033[0m  " "${item##*/}"
    done
    for item in "$target"/*(^/N); do
        [[ -e "$item" ]] && printf "%s  " "${item##*/}"
    done
    echo ""
}

# Tree-like view (limited depth)
lt() {
    local target="${1:-.}"
    local depth="${2:-2}"
    
    echo ""
    echo -e "  \033[38;5;51m🌳 $(_t tree_view "Tree view") (depth: $depth)\033[0m"
    echo ""
    
    # Use find to create tree-like output
    find "$target" -maxdepth "$depth" -print 2>/dev/null | while read -r path; do
        local level=${#path//[^\/]}
        local indent=""
        for ((i=0; i<level; i++)); do
            indent+="  "
        done
        
        local name="${path##*/}"
        [[ -z "$name" ]] && name="$path"
        
        if [[ -d "$path" ]]; then
            echo -e "${indent}\033[38;5;39m📁 ${name}/\033[0m"
        else
            local icon=$(get_icon "$name" "false")
            echo -e "${indent}$icon $name"
        fi
    done
    echo ""
}

# Quick jump to common directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# Project navigation helpers
alias src='cd src'
alias comp='cd src/components'
alias pages='cd src/pages'

# Create directory and cd into it
mkcd() {
    local dir="$1"
    
    if [[ -z "$dir" ]]; then
        echo -e "  \033[38;5;196m✗ $(_t error): $(_t specify_dir "Please provide a directory name")\033[0m"
        return 1
    fi
    
    echo -e "  \033[38;5;51m📁 $(_t creating "Creating"):\033[0m $dir"
    
    mkdir -p "$dir" && cd "$dir"
    
    if [[ $? -eq 0 ]]; then
        echo -e "  \033[38;5;46m✓\033[0m $(_t dir_created)! 🎉"
    else
        echo -e "  \033[38;5;196m✗\033[0m $(_t error)"
    fi
}

# Recent directories (uses zsh's dirstack)
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
DIRSTACKSIZE=10

# Show recent directories
recent() {
    echo ""
    echo -e "  \033[38;5;51m📍 $(_t recent_dirs "Recent Directories")\033[0m"
    echo ""
    
    local i=1
    dirs -v | while read -r num path; do
        
        if [[ "$num" == "0" ]]; then
            echo -e "    \033[38;5;46m▶\033[0m \033[1m$path\033[0m (current)"
        else
            echo -e "    \033[38;5;245m$num\033[0m $path"
        fi
        ((i++))
        [[ $i -gt 10 ]] && break
    done
    echo ""
    echo -e "  \033[38;5;240mTip: Use 'cd -N' to go to directory N\033[0m"
    echo ""
}

# Fuzzy directory jump (if fzf is available)
if command -v fzf &>/dev/null; then
    fcd() {
        local dir
        dir=$(find . -type d -not -path '*/\.*' -not -path '*/node_modules/*' 2>/dev/null | fzf --height 40% --reverse --preview 'ls -la {}') && cd "$dir"
    }
fi
