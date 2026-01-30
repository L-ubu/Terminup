#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │                    🎨 Theme Switcher                          │
# ╰──────────────────────────────────────────────────────────────╯

# Theme storage
TERMINUP_THEME_FILE="$HOME/.terminup_theme"
TERMINUP_CUSTOM_THEME_FILE="$HOME/.terminup_custom_theme"

# ─────────────────────────────────────────────────────────────────
# Predefined Themes
# ─────────────────────────────────────────────────────────────────

typeset -gA THEMES

# Theme format: "primary,secondary,accent,success,warning,error,muted"
THEMES=(
    # Dark themes
    catppuccin   "183,189,245,148,223,210,102"
    dracula      "189,141,117,80,215,204,60"
    nord         "110,147,180,108,222,167,60"
    tokyo-night  "111,219,195,114,221,204,60"
    gruvbox      "214,142,167,142,214,167,102"
    synthwave    "213,177,219,156,226,197,60"
    cyberpunk    "201,51,226,46,226,196,240"
    matrix       "46,40,82,46,226,196,22"
    ocean        "75,111,153,80,222,167,60"
    sunset       "216,209,203,156,226,196,95"
    
    # Light themes
    github-light "33,99,166,40,178,160,245"
    solarized    "37,136,166,64,136,160,102"
    
    # Fun themes
    neon         "201,51,226,46,226,196,240"
    retro        "208,214,220,46,226,196,95"
    pastel       "183,152,189,156,222,210,145"
    monochrome   "255,250,245,255,250,245,240"
)

# Current theme colors (defaults to catppuccin)
typeset -g TERM_PRIMARY=183
typeset -g TERM_SECONDARY=189
typeset -g TERM_ACCENT=245
typeset -g TERM_SUCCESS=148
typeset -g TERM_WARNING=223
typeset -g TERM_ERROR=210
typeset -g TERM_MUTED=102

# ─────────────────────────────────────────────────────────────────
# Theme Functions
# ─────────────────────────────────────────────────────────────────

# Load theme from file on startup
_load_saved_theme() {
    if [[ -f "$TERMINUP_THEME_FILE" ]]; then
        local saved_theme=$(cat "$TERMINUP_THEME_FILE")
        if [[ -n "${THEMES[$saved_theme]}" ]]; then
            _apply_theme "$saved_theme" "quiet"
        elif [[ "$saved_theme" == "custom" && -f "$TERMINUP_CUSTOM_THEME_FILE" ]]; then
            _apply_custom_theme "quiet"
        fi
    fi
}

# Apply a theme
_apply_theme() {
    local theme_name="$1"
    local quiet="$2"
    local colors="${THEMES[$theme_name]}"
    
    if [[ -z "$colors" ]]; then
        echo -e "  \033[38;5;196m✗ Theme not found: $theme_name\033[0m"
        return 1
    fi
    
    # Parse colors
    local color_array=(${(s:,:)colors})
    TERM_PRIMARY=${color_array[1]}
    TERM_SECONDARY=${color_array[2]}
    TERM_ACCENT=${color_array[3]}
    TERM_SUCCESS=${color_array[4]}
    TERM_WARNING=${color_array[5]}
    TERM_ERROR=${color_array[6]}
    TERM_MUTED=${color_array[7]}
    
    # Save theme preference
    echo "$theme_name" > "$TERMINUP_THEME_FILE"
    
    if [[ "$quiet" != "quiet" ]]; then
        echo -e "  \033[38;5;${TERM_SUCCESS}m✓\033[0m Theme set to: \033[38;5;${TERM_PRIMARY}m$theme_name\033[0m"
    fi
}

# Apply custom theme
_apply_custom_theme() {
    local quiet="$1"
    
    if [[ -f "$TERMINUP_CUSTOM_THEME_FILE" ]]; then
        source "$TERMINUP_CUSTOM_THEME_FILE"
        echo "custom" > "$TERMINUP_THEME_FILE"
        
        if [[ "$quiet" != "quiet" ]]; then
            echo -e "  \033[38;5;${TERM_SUCCESS}m✓\033[0m Custom theme applied"
        fi
    fi
}

# Preview a single theme
_preview_theme() {
    local theme_name="$1"
    local colors="${THEMES[$theme_name]}"
    local color_array=(${(s:,:)colors})
    
    local p=${color_array[1]}   # primary
    local s=${color_array[2]}   # secondary
    local a=${color_array[3]}   # accent
    local su=${color_array[4]}  # success
    local w=${color_array[5]}   # warning
    local e=${color_array[6]}   # error
    local m=${color_array[7]}   # muted
    
    printf "    \033[38;5;${p}m████\033[0m"
    printf "\033[38;5;${s}m████\033[0m"
    printf "\033[38;5;${a}m████\033[0m"
    printf "\033[38;5;${su}m████\033[0m"
    printf "\033[38;5;${w}m████\033[0m"
    printf "\033[38;5;${e}m████\033[0m"
    printf "\033[38;5;${m}m████\033[0m"
    printf "  \033[38;5;${p}m%s\033[0m\n" "$theme_name"
}

# ─────────────────────────────────────────────────────────────────
# Theme Command
# ─────────────────────────────────────────────────────────────────

theme() {
    local cmd="${1:-list}"
    
    case "$cmd" in
        list|ls)
            echo ""
            echo -e "  \033[38;5;51m╭───────────────────────────────────────────────────────╮\033[0m"
            echo -e "  \033[38;5;51m│\033[0m              \033[1m🎨 Available Themes\033[0m                    \033[38;5;51m│\033[0m"
            echo -e "  \033[38;5;51m╰───────────────────────────────────────────────────────╯\033[0m"
            echo ""
            
            local current_theme=""
            [[ -f "$TERMINUP_THEME_FILE" ]] && current_theme=$(cat "$TERMINUP_THEME_FILE")
            
            echo -e "  \033[38;5;245m  Pri Sec Acc Suc War Err Mut   Name\033[0m"
            echo ""
            
            for theme_name in ${(k)THEMES}; do
                if [[ "$theme_name" == "$current_theme" ]]; then
                    printf "  \033[38;5;46m▶\033[0m"
                else
                    printf "   "
                fi
                _preview_theme "$theme_name"
            done
            
            echo ""
            echo -e "  \033[38;5;245m─────────────────────────────────────────────────────────\033[0m"
            echo -e "  \033[38;5;240mUsage: theme set <name> | theme preview <name>\033[0m"
            echo -e "  \033[38;5;240m       theme custom | theme current\033[0m"
            echo ""
            ;;
            
        set|use)
            local theme_name="$2"
            if [[ -z "$theme_name" ]]; then
                echo -e "  \033[38;5;196m✗ Please specify a theme name\033[0m"
                return 1
            fi
            _apply_theme "$theme_name"
            ;;
            
        preview|try)
            local theme_name="$2"
            if [[ -z "$theme_name" ]]; then
                echo -e "  \033[38;5;196m✗ Please specify a theme name\033[0m"
                return 1
            fi
            
            if [[ -z "${THEMES[$theme_name]}" ]]; then
                echo -e "  \033[38;5;196m✗ Theme not found: $theme_name\033[0m"
                return 1
            fi
            
            local colors="${THEMES[$theme_name]}"
            local color_array=(${(s:,:)colors})
            local p=${color_array[1]}
            local s=${color_array[2]}
            local a=${color_array[3]}
            local su=${color_array[4]}
            local w=${color_array[5]}
            local e=${color_array[6]}
            local m=${color_array[7]}
            
            echo ""
            echo -e "  \033[38;5;${p}m╭─────────────────────────────────────────────────────╮\033[0m"
            echo -e "  \033[38;5;${p}m│\033[0m           \033[1;38;5;${p}m🎨 Theme Preview: $theme_name\033[0m"
            echo -e "  \033[38;5;${p}m╰─────────────────────────────────────────────────────╯\033[0m"
            echo ""
            echo -e "    \033[38;5;${p}m████ Primary\033[0m    \033[38;5;${s}m████ Secondary\033[0m   \033[38;5;${a}m████ Accent\033[0m"
            echo -e "    \033[38;5;${su}m████ Success\033[0m    \033[38;5;${w}m████ Warning\033[0m     \033[38;5;${e}m████ Error\033[0m"
            echo -e "    \033[38;5;${m}m████ Muted\033[0m"
            echo ""
            echo -e "  \033[38;5;${p}m  Sample Text:\033[0m The quick \033[38;5;${s}mbrown fox\033[0m jumps over"
            echo -e "                the \033[38;5;${a}mlazy dog\033[0m"
            echo ""
            echo -e "    \033[38;5;${su}m✓ Success message\033[0m"
            echo -e "    \033[38;5;${w}m⚠ Warning message\033[0m"
            echo -e "    \033[38;5;${e}m✗ Error message\033[0m"
            echo -e "    \033[38;5;${m}m# Muted/comment text\033[0m"
            echo ""
            echo -e "  \033[38;5;245m─────────────────────────────────────────────────────────\033[0m"
            echo -e "  \033[38;5;240mApply this theme? Run: theme set $theme_name\033[0m"
            echo ""
            ;;
            
        current)
            local current_theme="default"
            [[ -f "$TERMINUP_THEME_FILE" ]] && current_theme=$(cat "$TERMINUP_THEME_FILE")
            
            echo ""
            echo -e "  \033[38;5;51m🎨 Current theme:\033[0m \033[38;5;${TERM_PRIMARY}m$current_theme\033[0m"
            echo ""
            echo -e "    \033[38;5;${TERM_PRIMARY}m████\033[0m Primary ($TERM_PRIMARY)"
            echo -e "    \033[38;5;${TERM_SECONDARY}m████\033[0m Secondary ($TERM_SECONDARY)"
            echo -e "    \033[38;5;${TERM_ACCENT}m████\033[0m Accent ($TERM_ACCENT)"
            echo -e "    \033[38;5;${TERM_SUCCESS}m████\033[0m Success ($TERM_SUCCESS)"
            echo -e "    \033[38;5;${TERM_WARNING}m████\033[0m Warning ($TERM_WARNING)"
            echo -e "    \033[38;5;${TERM_ERROR}m████\033[0m Error ($TERM_ERROR)"
            echo -e "    \033[38;5;${TERM_MUTED}m████\033[0m Muted ($TERM_MUTED)"
            echo ""
            ;;
            
        custom)
            echo ""
            echo -e "  \033[38;5;51m╭───────────────────────────────────────────────────────╮\033[0m"
            echo -e "  \033[38;5;51m│\033[0m           \033[1m🎨 Custom Theme Builder\033[0m                  \033[38;5;51m│\033[0m"
            echo -e "  \033[38;5;51m╰───────────────────────────────────────────────────────╯\033[0m"
            echo ""
            echo -e "  \033[38;5;245mPick colors for each element (0-255)\033[0m"
            echo -e "  \033[38;5;245mTip: Run 'colors' to see the color palette\033[0m"
            echo ""
            
            # Color picker helper
            _pick_color() {
                local label="$1"
                local default="$2"
                local color
                
                echo -ne "  $label [\033[38;5;${default}m████\033[0m $default]: "
                read color
                [[ -z "$color" ]] && color=$default
                echo "$color"
            }
            
            local new_primary=$(_pick_color "Primary color" "$TERM_PRIMARY")
            local new_secondary=$(_pick_color "Secondary color" "$TERM_SECONDARY")
            local new_accent=$(_pick_color "Accent color" "$TERM_ACCENT")
            local new_success=$(_pick_color "Success color" "$TERM_SUCCESS")
            local new_warning=$(_pick_color "Warning color" "$TERM_WARNING")
            local new_error=$(_pick_color "Error color" "$TERM_ERROR")
            local new_muted=$(_pick_color "Muted color" "$TERM_MUTED")
            
            # Save custom theme
            cat > "$TERMINUP_CUSTOM_THEME_FILE" << EOF
# Custom Terminup Theme
TERM_PRIMARY=$new_primary
TERM_SECONDARY=$new_secondary
TERM_ACCENT=$new_accent
TERM_SUCCESS=$new_success
TERM_WARNING=$new_warning
TERM_ERROR=$new_error
TERM_MUTED=$new_muted
EOF
            
            # Apply custom theme
            TERM_PRIMARY=$new_primary
            TERM_SECONDARY=$new_secondary
            TERM_ACCENT=$new_accent
            TERM_SUCCESS=$new_success
            TERM_WARNING=$new_warning
            TERM_ERROR=$new_error
            TERM_MUTED=$new_muted
            
            echo "custom" > "$TERMINUP_THEME_FILE"
            
            echo ""
            echo -e "  \033[38;5;${TERM_SUCCESS}m✓\033[0m Custom theme saved and applied!"
            echo ""
            echo -e "  Preview:"
            echo -e "    \033[38;5;${TERM_PRIMARY}m████\033[0m \033[38;5;${TERM_SECONDARY}m████\033[0m \033[38;5;${TERM_ACCENT}m████\033[0m \033[38;5;${TERM_SUCCESS}m████\033[0m \033[38;5;${TERM_WARNING}m████\033[0m \033[38;5;${TERM_ERROR}m████\033[0m \033[38;5;${TERM_MUTED}m████\033[0m"
            echo ""
            ;;
            
        fzf|pick)
            if ! command -v fzf &>/dev/null; then
                echo -e "  \033[38;5;196m✗ fzf required for theme picker\033[0m"
                return 1
            fi
            
            local selected
            selected=$(for t in ${(k)THEMES}; do echo "$t"; done | 
                fzf --header='  🎨 Select Theme' \
                    --preview 'theme preview {}' \
                    --preview-window='right:60%')
            
            if [[ -n "$selected" ]]; then
                _apply_theme "$selected"
            fi
            ;;
            
        *)
            echo -e "  \033[38;5;196m✗ Unknown command: $cmd\033[0m"
            echo ""
            echo -e "  \033[38;5;245mAvailable commands:\033[0m"
            echo -e "    theme list          - Show all themes"
            echo -e "    theme set <name>    - Apply a theme"
            echo -e "    theme preview <name>- Preview a theme"
            echo -e "    theme current       - Show current theme"
            echo -e "    theme custom        - Build custom theme"
            echo -e "    theme fzf           - Pick theme with fzf"
            echo ""
            ;;
    esac
}

# ─────────────────────────────────────────────────────────────────
# Color Palette Viewer
# ─────────────────────────────────────────────────────────────────

colors() {
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m                   \033[1m🎨 256 Color Palette\033[0m                         \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────────────────────────────────╯\033[0m"
    echo ""
    
    # Standard colors (0-15)
    echo -e "  \033[38;5;245mStandard colors (0-15):\033[0m"
    echo -n "    "
    for i in {0..15}; do
        printf "\033[48;5;${i}m  \033[0m"
    done
    echo ""
    echo -n "    "
    for i in {0..15}; do
        printf "%2d " "$i"
    done
    echo ""
    echo ""
    
    # 216 colors (16-231)
    echo -e "  \033[38;5;245m216 colors (16-231):\033[0m"
    for row in {0..5}; do
        echo -n "    "
        for col in {0..35}; do
            local i=$((16 + row * 36 + col))
            if [[ $i -le 231 ]]; then
                printf "\033[48;5;${i}m  \033[0m"
            fi
        done
        echo ""
    done
    echo ""
    
    # Grayscale (232-255)
    echo -e "  \033[38;5;245mGrayscale (232-255):\033[0m"
    echo -n "    "
    for i in {232..255}; do
        printf "\033[48;5;${i}m  \033[0m"
    done
    echo ""
    echo -n "    "
    for i in {232..255}; do
        printf "%2d " "$((i - 232))"
    done
    echo ""
    echo ""
    
    echo -e "  \033[38;5;240mUse these numbers with: theme custom\033[0m"
    echo ""
}

# Load saved theme on startup
_load_saved_theme
