#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │                 🎯 Completion Enhancements                    │
# ╰──────────────────────────────────────────────────────────────╯

# Load completion system
autoload -Uz compinit
compinit -d ~/.zcompdump

# ─────────────────────────────────────────────────────────────────
# Completion styling
# ─────────────────────────────────────────────────────────────────

# Enable completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Fuzzy matching for completions
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Completion menu styling
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' special-dirs true

# Group completions by type with headers
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format $'\n  \e[38;5;51m── %d ──\e[0m'
zstyle ':completion:*:corrections' format $'  \e[38;5;226m── %d (errors: %e) ──\e[0m'
zstyle ':completion:*:messages' format $'  \e[38;5;245m── %d ──\e[0m'
zstyle ':completion:*:warnings' format $'  \e[38;5;196m── No matches found ──\e[0m'

# Process completion styling
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# Directory completion styling
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'

# Git completion enhancements
zstyle ':completion:*:*:git:*' script ~/.git-completion.bash 2>/dev/null
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:git:*' list-colors '=(#b) #([a-f0-9]#)*=0=38;5;208'

# ─────────────────────────────────────────────────────────────────
# Auto-suggestions (if plugin available)
# ─────────────────────────────────────────────────────────────────

# Styling for zsh-autosuggestions
if [[ -n "$ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE" ]] || typeset -f _zsh_autosuggest_fetch &>/dev/null; then
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
    export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    export ZSH_AUTOSUGGEST_USE_ASYNC=1
fi

# ─────────────────────────────────────────────────────────────────
# Key bindings for completion
# ─────────────────────────────────────────────────────────────────

# Shift-Tab to go backward in menu
bindkey '^[[Z' reverse-menu-complete

# Accept suggestion with right arrow
bindkey '^[[C' forward-char

# Partial accept with Ctrl+Right Arrow
bindkey '^[[1;5C' forward-word

# ─────────────────────────────────────────────────────────────────
# Custom completions for terminup commands
# ─────────────────────────────────────────────────────────────────

# Completion for gc (git commit)
_gc() {
    _arguments \
        '1:commit message:->message' \
    && return 0
    
    case "$state" in
        message)
            _message 'Enter commit message'
            ;;
    esac
}
compdef _gc gc

# Completion for gco (git checkout)
_gco() {
    local branches
    branches=(${(f)"$(git branch -a 2>/dev/null | sed 's/^[* ]*//' | sed 's#remotes/[^/]*/##' | sort -u)"})
    _describe -t branches 'branch' branches
}
compdef _gco gco

# Completion for add (package add)
_add() {
    # No specific completion, just show help
    _message 'package name'
}
compdef _add add

# ─────────────────────────────────────────────────────────────────
# Completion animations (subtle)
# ─────────────────────────────────────────────────────────────────

# Visual feedback when completion is triggered
# This adds a brief "thinking" indicator
typeset -g _COMPLETION_LOADING=false

# Wrap the completion widget
_animated_complete() {
    # Show a brief loading indicator for complex completions
    # (disabled by default as it can be distracting)
    # echo -ne '\r⠋ '
    # sleep 0.05
    # echo -ne '\r  \r'
    
    # Call the original complete
    zle expand-or-complete
}
# zle -N _animated_complete
# bindkey '^I' _animated_complete

# ─────────────────────────────────────────────────────────────────
# Smart tab behavior
# ─────────────────────────────────────────────────────────────────

# Tab at beginning of line inserts actual tab, otherwise completes
smart_tab() {
    if [[ -z "$BUFFER" || "$BUFFER" =~ ^[[:space:]] ]]; then
        # At beginning or only whitespace, insert tab
        BUFFER="$BUFFER	"
        CURSOR=$((CURSOR + 1))
    else
        # Otherwise, do completion
        zle expand-or-complete
    fi
}
zle -N smart_tab
# bindkey '^I' smart_tab  # Uncomment to enable

# ─────────────────────────────────────────────────────────────────
# Directory-aware completions
# ─────────────────────────────────────────────────────────────────

# Completion for common directories
hash -d projects=~/Projects
hash -d desk=~/Desktop
hash -d docs=~/Documents
hash -d down=~/Downloads

# Enable directory shortcuts
setopt AUTO_CD              # cd by typing directory name
setopt AUTO_PUSHD           # Push directories onto stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
setopt PUSHD_SILENT         # Don't print stack after pushd/popd

# ─────────────────────────────────────────────────────────────────
# History completion enhancements
# ─────────────────────────────────────────────────────────────────

# History settings for better completion
setopt HIST_IGNORE_ALL_DUPS  # Remove older duplicate entries
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks
setopt HIST_VERIFY           # Show before executing from history
setopt SHARE_HISTORY         # Share history between sessions
setopt EXTENDED_HISTORY      # Save timestamp with history

HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

# History substring search
bindkey '^[[A' history-beginning-search-backward  # Up arrow
bindkey '^[[B' history-beginning-search-forward   # Down arrow

# ─────────────────────────────────────────────────────────────────
# npm/pnpm script completions
# ─────────────────────────────────────────────────────────────────

# Dynamic npm script completion
_npm_scripts() {
    if [[ -f package.json ]]; then
        local scripts
        scripts=(${(f)"$(node -e "Object.keys(require('./package.json').scripts || {}).forEach(s => console.log(s))" 2>/dev/null)"})
        _describe -t scripts 'npm scripts' scripts
    fi
}
compdef _npm_scripts 'npm run'
compdef _npm_scripts 'pnpm run'
compdef _npm_scripts 'yarn'
