#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │              🌐 Internationalization (i18n)                   │
# ╰──────────────────────────────────────────────────────────────╯

# ─────────────────────────────────────────────────────────────────
# Language Configuration
# ─────────────────────────────────────────────────────────────────

# Default language (can be overridden in ~/.terminup_config)
TERMINUP_LANG="${TERMINUP_LANG:-en}"

# Config file for user preferences
TERMINUP_CONFIG="$HOME/.terminup_config"

# Load user config if exists
[[ -f "$TERMINUP_CONFIG" ]] && source "$TERMINUP_CONFIG"

# Available languages (only those with translations)
typeset -gA TERMINUP_LANGUAGES
TERMINUP_LANGUAGES=(
    en "English"
    nl "Nederlands"
    fr "Français"
    de "Deutsch"
    es "Español"
    it "Italiano"
)

# ─────────────────────────────────────────────────────────────────
# Load Language Files
# ─────────────────────────────────────────────────────────────────

# Language files directory
_I18N_DIR="${TERMINUP_DIR}/components"

# Only load English (fallback) + the active language
source "$_I18N_DIR/languages/en.zsh"
if [[ "$TERMINUP_LANG" != "en" && -f "$_I18N_DIR/languages/${TERMINUP_LANG}.zsh" ]]; then
    source "$_I18N_DIR/languages/${TERMINUP_LANG}.zsh"
fi

# ─────────────────────────────────────────────────────────────────
# Translation Function
# ─────────────────────────────────────────────────────────────────

# Get translated string
# Usage: _t "key" or _t "key" "fallback"
_t() {
    local key="$1"
    local fallback="${2:-$key}"
    local result=""
    
    # Try current language
    case "$TERMINUP_LANG" in
        nl) result="${_T_nl[$key]}" ;;
        fr) result="${_T_fr[$key]}" ;;
        de) result="${_T_de[$key]}" ;;
        es) result="${_T_es[$key]}" ;;
        it) result="${_T_it[$key]}" ;;
        *) result="${_T_en[$key]}" ;;
    esac
    
    # Fallback to English if not found
    if [[ -z "$result" ]]; then
        result="${_T_en[$key]}"
    fi
    
    # Fallback to key itself
    echo "${result:-$fallback}"
}

# ─────────────────────────────────────────────────────────────────
# Language Management Commands
# ─────────────────────────────────────────────────────────────────

# List available languages
lang_list() {
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m       \033[1m🌐 Available Languages\033[0m          \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    
    for code in ${(k)TERMINUP_LANGUAGES}; do
        if [[ "$code" == "$TERMINUP_LANG" ]]; then
            echo -e "    \033[38;5;46m●\033[0m \033[1m$code\033[0m - ${TERMINUP_LANGUAGES[$code]} \033[38;5;46m(current)\033[0m"
        else
            echo -e "    \033[38;5;245m○\033[0m $code - ${TERMINUP_LANGUAGES[$code]}"
        fi
    done
    echo ""
}

# Set language
lang_set() {
    local new_lang="$1"
    
    if [[ -z "$new_lang" ]]; then
        lang_list
        echo -e "  \033[38;5;245mUsage: lang set <code>\033[0m"
        echo -e "  \033[38;5;245mExample: lang set nl\033[0m"
        return 1
    fi
    
    if [[ -z "${TERMINUP_LANGUAGES[$new_lang]}" ]]; then
        echo -e "  \033[38;5;196m✗\033[0m Unknown language: $new_lang"
        lang_list
        return 1
    fi
    
    # Save to config
    echo "TERMINUP_LANG=\"$new_lang\"" > "$TERMINUP_CONFIG"
    export TERMINUP_LANG="$new_lang"
    
    # Load the new language file
    if [[ "$new_lang" != "en" && -f "$_I18N_DIR/languages/${new_lang}.zsh" ]]; then
        source "$_I18N_DIR/languages/${new_lang}.zsh"
    fi
    
    echo -e "  \033[38;5;46m✓\033[0m Language changed to ${TERMINUP_LANGUAGES[$new_lang]}"
}

# Main language command
lang() {
    local cmd="${1:-list}"
    
    case "$cmd" in
        list|ls)
            lang_list
            ;;
        set|s)
            lang_set "$2"
            ;;
        current)
            echo -e "  \033[38;5;51mCurrent:\033[0m $TERMINUP_LANG - ${TERMINUP_LANGUAGES[$TERMINUP_LANG]}"
            ;;
        *)
            echo -e "  \033[38;5;245mUsage: lang [list|set <code>|current]\033[0m"
            ;;
    esac
}

# Detect language from system locale
_detect_language() {
    local locale="${LANG:-${LC_ALL:-en_US}}"
    local lang_code="${locale%%_*}"
    
    # Check if we have translations for this language
    if [[ -n "${TERMINUP_LANGUAGES[$lang_code]}" ]]; then
        echo "$lang_code"
    else
        echo "en"
    fi
}

# Auto-detect on first run if no config exists
if [[ ! -f "$TERMINUP_CONFIG" ]]; then
    export TERMINUP_LANG=$(_detect_language)
fi
