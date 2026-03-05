#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │                     🔗 General Aliases                       │
# ╰──────────────────────────────────────────────────────────────╯
# Shared aliases for common development workflows

# ─────────────────────────────────────────────────────────────────
# 🌿 Git Aliases
# ─────────────────────────────────────────────────────────────────
# Note: gc, gp, gl, ga, gss are enhanced in git-magic.zsh with
# ASCII art animations. These aliases complement those.

alias g='git'
alias gpu='git push -u'
alias gac='git add .; git commit -m'
alias gbase='git log --pretty=format:'\''%D'\'' HEAD^ | grep '\''origin/'\'' | head -n1 | sed '\''s@origin/@@'\'' | sed '\''s@,.*@@'\'''
alias gch='git checkout'  # Use gch for checkout (gc is commit in git-magic)

# ─────────────────────────────────────────────────────────────────
# 📋 Clipboard (Linux)
# ─────────────────────────────────────────────────────────────────

if command -v xclip &>/dev/null; then
    alias clipboard='xclip -sel clip'
fi

# ─────────────────────────────────────────────────────────────────
# 🐳 Docker Aliases
# ─────────────────────────────────────────────────────────────────

alias i='./install.sh'
alias dup='./docker.sh up'
alias ddown='./docker.sh down'
alias dnode='./docker.sh bash node'
alias dphp='./docker.sh bash php'
alias dms='./docker.sh bash mysql'

# ─────────────────────────────────────────────────────────────────
# 🔧 DDEV Aliases
# ─────────────────────────────────────────────────────────────────

alias ddu='ddev start'
alias ddd='ddev stop'
alias ddr='ddev restart'
alias ddi='ddev install'
alias ddinit='ddev init'
alias dds='ddev ssh'
alias djs='ddev exec yarn dev'
alias djsns='ddev exec yarn dev:ns'

# ─────────────────────────────────────────────────────────────────
# 💧 Drupal Aliases
# ─────────────────────────────────────────────────────────────────

alias drupal:install='ddev exec composer install && ddev drush cim -y && ddev drush cr'
alias drupal:i='drupal:install'

# ─────────────────────────────────────────────────────────────────
# 🐙 Docker Compose Aliases
# ─────────────────────────────────────────────────────────────────

alias dtest='docker-compose exec node yarn test:local'
alias dtestu='docker-compose exec node yarn test:local -u'
alias dnal='docker-compose exec node yarn watch:all'
alias djal='docker-compose exec node yarn watch:js:all:ns'
alias cc='docker-compose exec php bin/console c:c'


# ─────────────────────────────────────────────────────────────────
# 👤 Load User-Specific Aliases
# ─────────────────────────────────────────────────────────────────
# Personal aliases can be added to: ~/.config/terminup/user-aliases.zsh
# This file is gitignored and allows machine-specific customization

if [[ -f "$HOME/.config/terminup/user-aliases.zsh" ]]; then
    source "$HOME/.config/terminup/user-aliases.zsh"
fi
