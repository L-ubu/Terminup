#!/usr/bin/env zsh
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                                                                            ║
# ║   ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗██╗   ██╗██████╗        ║
# ║   ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██║   ██║██╔══██╗       ║
# ║      ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║██║   ██║██████╔╝       ║
# ║      ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██║   ██║██╔═══╝        ║
# ║      ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║╚██████╔╝██║            ║
# ║      ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝            ║
# ║                                                                            ║
# ║              🚀 Terminal Enhancements for Power Users 🚀                   ║
# ║                                                                            ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# Source component files
TERMINUP_DIR="${0:A:h}"

# ─────────────────────────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────────────────────────
# Modes: minimal | fun | full | custom
# All modes use lazy loading for fast startup
# Modes control which features are AVAILABLE, not when they load

TERMINUP_MODE="${TERMINUP_MODE:-full}"
TERMINUP_CONFIG_DIR="$HOME/.config/terminup"
TERMINUP_MODE_CONFIG="$TERMINUP_CONFIG_DIR/mode"
TERMINUP_COMPONENTS_CONFIG="$TERMINUP_CONFIG_DIR/components"

# Create config dir if needed
[[ ! -d "$TERMINUP_CONFIG_DIR" ]] && mkdir -p "$TERMINUP_CONFIG_DIR"

# Load config
[[ -f "$TERMINUP_MODE_CONFIG" ]] && source "$TERMINUP_MODE_CONFIG"
[[ -f "$TERMINUP_COMPONENTS_CONFIG" ]] && source "$TERMINUP_COMPONENTS_CONFIG"

# ─────────────────────────────────────────────────────────────────
# Core Components (always loaded - required for basic operation)
# ─────────────────────────────────────────────────────────────────
[[ -f "$TERMINUP_DIR/components/platform.zsh" ]] && source "$TERMINUP_DIR/components/platform.zsh"
[[ -f "$TERMINUP_DIR/components/i18n.zsh" ]] && source "$TERMINUP_DIR/components/i18n.zsh"
[[ -f "$TERMINUP_DIR/components/colors.zsh" ]] && source "$TERMINUP_DIR/components/colors.zsh"

# ─────────────────────────────────────────────────────────────────
# Lazy Loading Helper
# ─────────────────────────────────────────────────────────────────
_terminup_lazy_load() {
    local component="$1"
    local trigger_functions=("${@:2}")
    
    for func in "${trigger_functions[@]}"; do
        eval "
        $func() {
            unfunction $func 2>/dev/null
            source \"\$TERMINUP_DIR/components/${component}.zsh\"
            $func \"\$@\"
        }
        "
    done
}

# ─────────────────────────────────────────────────────────────────
# Component Definitions
# ─────────────────────────────────────────────────────────────────
# Each component and its trigger functions for lazy loading

_terminup_load_component() {
    local component="$1"
    
    case "$component" in
        git)
            _terminup_lazy_load "git-magic" gc gp gl ga gco gss gb gst gstp gm
            ;;
        nav)
            _terminup_lazy_load "navigation" ll l lt fcd mkcd recent bm jb
            ;;
        npm)
            _terminup_lazy_load "npm-pnpm" ni pi dev build test scripts fscript add add-dev remove outdated
            ;;
        ddev)
            _terminup_lazy_load "ddev" dni dpi ddev-dev ddev-build dstart dstop drestart dssh dlogs dinfo dcomposer dartisan dmysql fddev dlist is_ddev_project ddev_status
            ;;
        fzf)
            _terminup_lazy_load "fzf-power" ff fbr flog fkill fdocker
            ;;
        animations)
            _terminup_lazy_load "animations" animate_text spinner progress_bar
            ;;
        themes)
            _terminup_lazy_load "themes" theme colors
            ;;
        extras)
            _terminup_lazy_load "extras" pomo focus todo note remind stopwatch stats genpass weather quote spotify cleanup decide welcome ritual eod standup google github typetest snake asciiart slots achievement api nyan fireworks clockwidget cmdstats shorten hn dadjoke cls clsq
            ;;
        screensaver)
            _terminup_lazy_load "screensaver" lock aclock alock matrix pipes syslock autolock rain fire aquarium stars bounce
            ;;
        startup)
            _terminup_lazy_load "startup" terminup_startup
            ;;
        cursor)
            _terminup_lazy_load "cursor-effects" cursor_effect
            ;;
        completions)
            _terminup_lazy_load "completions" _terminup_completions
            ;;
    esac
}

# ─────────────────────────────────────────────────────────────────
# Mode-based Component Loading (all lazy-loaded)
# ─────────────────────────────────────────────────────────────────

# Define which components each mode includes
typeset -gA TERMINUP_MODE_COMPONENTS
TERMINUP_MODE_COMPONENTS=(
    minimal "git nav npm ddev"
    fun "git nav npm ddev animations themes extras screensaver startup"
    full "git nav npm ddev fzf animations themes extras screensaver startup cursor completions"
)

# Load components based on mode
_terminup_init_mode() {
    local mode="$1"
    local components=""
    
    if [[ "$mode" == "custom" ]]; then
        # Custom mode: use user-defined components
        components="${TERMINUP_CUSTOM_COMPONENTS:-git nav npm}"
    else
        # Preset mode
        components="${TERMINUP_MODE_COMPONENTS[$mode]}"
    fi
    
    # Load each enabled component (lazy)
    for component in ${=components}; do
        _terminup_load_component "$component"
    done
}

# Initialize based on current mode
_terminup_init_mode "$TERMINUP_MODE"

# Print welcome message on first load
if [[ -z "$TERMINUP_LOADED" ]]; then
    export TERMINUP_LOADED=1
fi

# ─────────────────────────────────────────────────────────────────
# Mode Management Commands
# ─────────────────────────────────────────────────────────────────
terminup_mode() {
    local cmd="${1:-status}"
    
    case "$cmd" in
        status)
            echo ""
            echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
            echo -e "  \033[38;5;51m│\033[0m      \033[1m⚙️  Terminup Configuration\033[0m       \033[38;5;51m│\033[0m"
            echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
            echo ""
            echo -e "  \033[38;5;226mCurrent mode:\033[0m \033[1m$TERMINUP_MODE\033[0m"
            echo ""
            if [[ "$TERMINUP_MODE" == "custom" ]]; then
                echo -e "  \033[38;5;245mEnabled components:\033[0m"
                for comp in ${=TERMINUP_CUSTOM_COMPONENTS}; do
                    echo -e "    \033[38;5;46m●\033[0m $comp"
                done
            else
                echo -e "  \033[38;5;245mEnabled components:\033[0m ${TERMINUP_MODE_COMPONENTS[$TERMINUP_MODE]}"
            fi
            echo ""
            echo -e "  \033[38;5;245mAll features are lazy-loaded for fast startup!\033[0m"
            echo ""
            ;;
        set)
            local new_mode="$2"
            if [[ "$new_mode" =~ ^(minimal|fun|full|custom)$ ]]; then
                echo "TERMINUP_MODE=\"$new_mode\"" > "$TERMINUP_MODE_CONFIG"
                echo -e "  \033[38;5;46m✓\033[0m Mode set to \033[1m$new_mode\033[0m"
                echo -e "  \033[38;5;245mReload shell: tups\033[0m"
            else
                echo -e "  \033[38;5;196m✗\033[0m Invalid mode. Use: minimal, fun, full, or custom"
            fi
            ;;
        list)
            echo ""
            echo -e "  \033[38;5;51mAvailable modes:\033[0m"
            echo ""
            echo -e "  \033[38;5;46m[1] minimal\033[0m"
            echo -e "      Components: git, nav, npm, ddev"
            echo -e "      Best for: quick tasks, slow machines"
            echo ""
            echo -e "  \033[38;5;226m[2] fun\033[0m"
            echo -e "      Components: + animations, themes, extras, screensaver, startup"
            echo -e "      Best for: daily use with visual flair"
            echo ""
            echo -e "  \033[38;5;213m[3] full\033[0m"
            echo -e "      Components: + fzf, cursor effects, completions"
            echo -e "      Best for: power users wanting everything"
            echo ""
            echo -e "  \033[38;5;208m[4] custom\033[0m"
            echo -e "      Pick exactly which components you want"
            echo -e "      Best for: specific workflows"
            echo ""
            ;;
        components)
            echo ""
            echo -e "  \033[38;5;51mAvailable components:\033[0m"
            echo ""
            echo -e "    \033[38;5;46mgit\033[0m         - Git commands (gc, gp, gl, gss...)"
            echo -e "    \033[38;5;46mnav\033[0m         - Navigation (ll, lt, fcd, mkcd...)"
            echo -e "    \033[38;5;46mnpm\033[0m         - NPM/PNPM (ni, pi, dev, build...)"
            echo -e "    \033[38;5;46mddev\033[0m        - DDEV integration (dstart, dssh...)"
            echo -e "    \033[38;5;226mfzf\033[0m         - FZF power (ff, fbr, flog...)"
            echo -e "    \033[38;5;226manimations\033[0m  - Text animations"
            echo -e "    \033[38;5;226mthemes\033[0m      - Color themes"
            echo -e "    \033[38;5;226mextras\033[0m      - Productivity (pomo, todo, notes...)"
            echo -e "    \033[38;5;213mscreensaver\033[0m - Lock screen, matrix, pipes..."
            echo -e "    \033[38;5;213mstartup\033[0m     - Welcome, ritual, standup..."
            echo -e "    \033[38;5;213mcursor\033[0m      - Cursor effects"
            echo -e "    \033[38;5;213mcompletions\033[0m - Tab completions"
            echo ""
            ;;
        custom)
            shift
            local components="$*"
            if [[ -z "$components" ]]; then
                echo -e "  \033[38;5;245mUsage: terminup_mode custom <component1> <component2> ...\033[0m"
                echo -e "  \033[38;5;245mExample: terminup_mode custom git nav npm ddev fzf\033[0m"
                echo ""
                terminup_mode components
                return
            fi
            echo "TERMINUP_MODE=\"custom\"" > "$TERMINUP_MODE_CONFIG"
            echo "TERMINUP_CUSTOM_COMPONENTS=\"$components\"" > "$TERMINUP_COMPONENTS_CONFIG"
            echo -e "  \033[38;5;46m✓\033[0m Custom mode set with: $components"
            echo -e "  \033[38;5;245mReload shell: tups\033[0m"
            ;;
        *)
            echo ""
            echo -e "  \033[38;5;51mUsage:\033[0m terminup_mode <command>"
            echo ""
            echo -e "  \033[38;5;245mCommands:\033[0m"
            echo -e "    \033[38;5;46mstatus\033[0m              Show current configuration"
            echo -e "    \033[38;5;46mlist\033[0m                Show available modes"
            echo -e "    \033[38;5;46mcomponents\033[0m          Show available components"
            echo -e "    \033[38;5;46mset\033[0m <mode>          Set mode (minimal/fun/full/custom)"
            echo -e "    \033[38;5;46mcustom\033[0m <comp...>    Set custom components"
            echo ""
            ;;
    esac
}

# ─────────────────────────────────────────────────────────────────
# Help Command
# ─────────────────────────────────────────────────────────────────

_tup_header() {
    echo ""
    echo -e "  \033[38;5;51m╔═══════════════════════════════════════════╗\033[0m"
    echo -e "  \033[38;5;51m║\033[0m    \033[1;38;5;213m✨ TERMINUP\033[0m - $(_t ui_terminal_enhancements)    \033[38;5;51m║\033[0m"
    echo -e "  \033[38;5;51m╚═══════════════════════════════════════════╝\033[0m"
    echo ""
}

_tup_git() {
    echo -e "  \033[1;38;5;226m🔮 $(_t cat_git)\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;46mgc\033[0m [msg]      $(_t desc_gc)"
    echo -e "    \033[38;5;46mgp\033[0m           $(_t desc_gp)"
    echo -e "    \033[38;5;46mgl\033[0m           $(_t desc_gl)"
    echo -e "    \033[38;5;46mga\033[0m [files]   $(_t desc_ga)"
    echo -e "    \033[38;5;46mgco\033[0m <branch> $(_t desc_gco)"
    echo -e "    \033[38;5;46mgss\033[0m          $(_t desc_gss)"
    echo -e "    \033[38;5;46mglog\033[0m         $(_t desc_glog)"
    echo -e "    \033[38;5;46mgs\033[0m           $(_t desc_gs)"
    echo -e "    \033[38;5;46mgd\033[0m           $(_t desc_gd)"
    echo -e "    \033[38;5;46mgb\033[0m           $(_t desc_gb)"
    echo -e "    \033[38;5;46mgst\033[0m/\033[38;5;46mgstp\033[0m     $(_t desc_gst)"
    echo -e "    \033[38;5;46mgm\033[0m <branch>  $(_t desc_gm)"
    echo ""
}

_tup_nav() {
    echo -e "  \033[1;38;5;226m📂 $(_t cat_nav)\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;39mll\033[0m / \033[38;5;39ml\033[0m       $(_t desc_ll)"
    echo -e "    \033[38;5;39mlt\033[0m [n]       $(_t desc_lt) (depth n)"
    echo -e "    \033[38;5;39mfcd\033[0m          $(_t desc_fcd)"
    echo -e "    \033[38;5;39mmkcd\033[0m <dir>   $(_t desc_mkcd)"
    echo -e "    \033[38;5;39mrecent\033[0m       $(_t desc_recent)"
    echo -e "    \033[38;5;39m..\033[0m \033[38;5;39m...\033[0m \033[38;5;39m....\033[0m  $(_t desc_parent)"
    echo -e "    \033[38;5;214mbm\033[0m / \033[38;5;214mjb\033[0m     $(_t desc_bm)"
    echo ""
}

_tup_npm() {
    echo -e "  \033[1;38;5;226m📦 $(_t cat_npm)\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;208mni\033[0m / \033[38;5;208mpi\033[0m     $(_t desc_ni)"
    echo -e "    \033[38;5;208mdev\033[0m          $(_t desc_dev)"
    echo -e "    \033[38;5;208mbuild\033[0m        $(_t desc_build)"
    echo -e "    \033[38;5;208mtest\033[0m         $(_t desc_test)"
    echo -e "    \033[38;5;208mscripts\033[0m      $(_t desc_scripts)"
    echo -e "    \033[38;5;208mfscript\033[0m      $(_t desc_fscript)"
    echo -e "    \033[38;5;208madd\033[0m/\033[38;5;208madd-dev\033[0m  $(_t desc_add)"
    echo -e "    \033[38;5;208mremove\033[0m       $(_t desc_remove)"
    echo -e "    \033[38;5;208moutdated\033[0m     $(_t desc_outdated)"
    echo ""
}

_tup_fzf() {
    echo -e "  \033[1;38;5;226m🔍 $(_t cat_fzf)\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;177mCtrl+R\033[0m       $(_t desc_history)"
    echo -e "    \033[38;5;177mff\033[0m           $(_t desc_ff)"
    echo -e "    \033[38;5;177mfbr\033[0m          $(_t desc_fbr)"
    echo -e "    \033[38;5;177mflog\033[0m         $(_t desc_flog)"
    echo -e "    \033[38;5;177mfkill\033[0m        $(_t desc_fkill)"
    echo -e "    \033[38;5;177mfdocker\033[0m      $(_t desc_fdocker)"
    echo ""
}

_tup_ddev() {
    echo -e "  \033[1;38;5;226m🐳 $(_t cat_ddev)\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;39mdstart\033[0m/\033[38;5;39mdstop\033[0m $(_t desc_dstart)"
    echo -e "    \033[38;5;39mdssh\033[0m         $(_t desc_dssh)"
    echo -e "    \033[38;5;39mdinfo\033[0m        $(_t desc_dinfo)"
    echo -e "    \033[38;5;39mdni\033[0m/\033[38;5;39mdpi\033[0m      DDEV $(_t desc_ni)"
    echo -e "    \033[38;5;39mddev-dev\033[0m     $(_t desc_ddev_dev)"
    echo -e "    \033[38;5;39mfddev\033[0m        $(_t desc_fddev)"
    echo ""
}

_tup_theme() {
    echo -e "  \033[1;38;5;226m🎨 $(_t cat_themes)\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;213mtheme list\033[0m   $(_t desc_theme_list)"
    echo -e "    \033[38;5;213mtheme set\033[0m <n> $(_t desc_theme_set)"
    echo -e "    \033[38;5;213mtheme fzf\033[0m    $(_t desc_theme_fzf)"
    echo -e "    \033[38;5;213mcolors\033[0m       $(_t desc_colors)"
    echo ""
}

_tup_extras() {
    echo -e "  \033[1;38;5;226m✨ $(_t cat_extras)\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;141mpomo\033[0m [mins]  $(_t desc_pomo)"
    echo -e "    \033[38;5;141mfocus\033[0m [mins] $(_t desc_focus)"
    echo -e "    \033[38;5;141mtodo\033[0m         $(_t desc_todo)"
    echo -e "    \033[38;5;141mnote\033[0m [text]  $(_t desc_note)"
    echo -e "    \033[38;5;141mremind\033[0m m msg $(_t desc_remind)"
    echo -e "    \033[38;5;141mstopwatch\033[0m    $(_t desc_stopwatch)"
    echo -e "    \033[38;5;141mstats\033[0m        $(_t desc_stats)"
    echo -e "    \033[38;5;141mgenpass\033[0m [n]  $(_t desc_genpass)"
    echo -e "    \033[38;5;141mweather\033[0m      $(_t desc_weather)"
    echo -e "    \033[38;5;141mquote\033[0m        $(_t desc_quote)"
    echo -e "    \033[38;5;141mspotify\033[0m      $(_t desc_spotify)"
    echo -e "    \033[38;5;141mdadjoke\033[0m      $(_t desc_dadjoke)"
    echo -e "    \033[38;5;141mhn\033[0m [n]       $(_t desc_hn)"
    echo -e "    \033[38;5;141mcmdstats\033[0m     $(_t desc_cmdstats)"
    echo -e "    \033[38;5;141mclockwidget\033[0m  $(_t desc_clockwidget)"
    echo ""
}

_tup_tools() {
    echo -e "  \033[1;38;5;226m🛠️ $(_t cat_tools)\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;208mcontext\033[0m      $(_t desc_context)"
    echo -e "    \033[38;5;208mwhatshere\033[0m    $(_t desc_whatshere)"
    echo -e "    \033[38;5;208mblame\033[0m <file> $(_t desc_blame)"
    echo -e "    \033[38;5;208mprojectstats\033[0m $(_t desc_projectstats)"
    echo -e "    \033[38;5;208mports\033[0m        $(_t desc_ports)"
    echo -e "    \033[38;5;208mlogs\033[0m [file]  $(_t desc_logs)"
    echo -e "    \033[38;5;208mgundo\033[0m        $(_t desc_gundo)"
    echo -e "    \033[38;5;208mjpp\033[0m          $(_t desc_jpp)"
    echo -e "    \033[38;5;208mshare\033[0m <file> $(_t desc_share)"
    echo -e "    \033[38;5;208mqr\033[0m <text>    $(_t desc_qr)"
    echo -e "    \033[38;5;208mcleanup\033[0m      $(_t desc_cleanup)"
    echo -e "    \033[38;5;208mapi\033[0m <M> <url> $(_t desc_api)"
    echo -e "    \033[38;5;208mshorten\033[0m <url> $(_t desc_shorten)"
    echo -e "    \033[38;5;208masciiart\033[0m <t> $(_t desc_asciiart)"
    echo -e "    \033[38;5;208mcls\033[0m          $(_t desc_cls)"
    echo ""
}

_tup_workflow() {
    echo -e "  \033[1;38;5;226m📋 $(_t cat_workflow)\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;226mwelcome\033[0m      $(_t desc_welcome)"
    echo -e "    \033[38;5;226mritual\033[0m       $(_t desc_ritual)"
    echo -e "    \033[38;5;226meod\033[0m          $(_t desc_eod)"
    echo -e "    \033[38;5;226mstandup\033[0m      $(_t desc_standup)"
    echo -e "    \033[38;5;226mtypetest\033[0m     $(_t desc_typetest)"
    echo -e "    \033[38;5;226mgoogle\033[0m       $(_t desc_google)"
    echo -e "    \033[38;5;226mgithub\033[0m       $(_t desc_github)"
    echo -e "    \033[38;5;226machievement\033[0m  $(_t desc_achievement)"
    echo ""
}

_tup_fun() {
    echo -e "  \033[1;38;5;226m🎮 $(_t cat_fun)\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;39mrain\033[0m         $(_t desc_rain)"
    echo -e "    \033[38;5;39mfire\033[0m         $(_t desc_fire)"
    echo -e "    \033[38;5;39maquarium\033[0m     $(_t desc_aquarium)"
    echo -e "    \033[38;5;39mstars\033[0m        $(_t desc_stars)"
    echo -e "    \033[38;5;39mbounce\033[0m       $(_t desc_bounce)"
    echo -e "    \033[38;5;39mdecide\033[0m a b c $(_t desc_decide)"
    echo -e "    \033[38;5;39msnake\033[0m        $(_t desc_snake)"
    echo -e "    \033[38;5;39mslots\033[0m        $(_t desc_slots)"
    echo -e "    \033[38;5;39mnyan\033[0m [secs]  $(_t desc_nyan)"
    echo -e "    \033[38;5;39mfireworks\033[0m    $(_t desc_fireworks)"
    echo ""
}

_tup_screen() {
    echo -e "  \033[1;38;5;226m🖥️ $(_t cat_screen)\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;87mlock\033[0m         $(_t desc_lock)"
    echo -e "    \033[38;5;87mss\033[0m           $(_t desc_ss)"
    echo -e "    \033[38;5;87maclock\033[0m [s]   $(_t desc_aclock) (shapes below)"
    echo -e "    \033[38;5;87malock\033[0m [s]    $(_t desc_alock)"
    echo -e "    \033[38;5;87mmatrix\033[0m       $(_t desc_matrix)"
    echo -e "    \033[38;5;87mpipes\033[0m        $(_t desc_pipes)"
    echo -e "    \033[38;5;87msyslock\033[0m      $(_t desc_syslock)"
    echo -e "    \033[38;5;87mautolock\033[0m [s] $(_t desc_autolock)"
    echo -e "    \033[38;5;240m  Shapes: circle square diamond hexagon octagon decagon\033[0m"
    echo -e "    \033[38;5;240m  Unlock: ← ↑ → ↓\033[0m"
    echo ""
}

_tup_system() {
    echo -e "  \033[1;38;5;226m🌍 $(_t cat_system)\033[0m"
    echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
    echo -e "    \033[38;5;39mlang list\033[0m    $(_t desc_lang_list)"
    echo -e "    \033[38;5;39mlang set\033[0m <c> $(_t desc_lang_set) (en/nl/fr/de/es...)"
    echo -e "    \033[38;5;39mplatform\033[0m     $(_t desc_platform)"
    echo -e "    \033[38;5;39mstats\033[0m        $(_t desc_stats)"
    echo -e "    \033[38;5;240m  Supported: macOS, Linux (Ubuntu/Arch/Fedora), WSL\033[0m"
    echo ""
}

terminup() {
    local cmd="${1:-help}"
    
    case "$cmd" in
        help|--help|-h)
            _tup_header
            echo -e "  \033[1;38;5;255m⚡ $(_t ui_essentials)\033[0m"
            echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
            echo -e "    \033[38;5;46mgc\033[0m/\033[38;5;46mgp\033[0m/\033[38;5;46mgl\033[0m    $(_t desc_gc)/$(_t desc_gp)/$(_t desc_gl)"
            echo -e "    \033[38;5;46mgss\033[0m         $(_t desc_gss)"
            echo -e "    \033[38;5;39mll\033[0m/\033[38;5;39mlt\033[0m       List/$(_t desc_lt)"
            echo -e "    \033[38;5;39mfcd\033[0m         $(_t desc_fcd)"
            echo -e "    \033[38;5;208mdev\033[0m/\033[38;5;208mbuild\033[0m   $(_t desc_dev)/$(_t desc_build)"
            echo -e "    \033[38;5;177mff\033[0m          $(_t desc_ff)"
            echo -e "    \033[38;5;87mlock\033[0m        $(_t desc_lock)"
            echo -e "    \033[38;5;141mstats\033[0m       $(_t desc_stats)"
            echo ""
            echo -e "  \033[38;5;245m─────────────────────────────────────────────\033[0m"
            echo -e "  \033[1;38;5;51m$(_t ui_categories):\033[0m  \033[38;5;240mtup <category> $(_t ui_category_details)\033[0m"
            echo ""
            echo -e "    \033[38;5;46mgit\033[0m     \033[38;5;39mnav\033[0m     \033[38;5;208mnpm\033[0m     \033[38;5;177mfzf\033[0m     \033[38;5;39mddev\033[0m"
            echo -e "    \033[38;5;213mtheme\033[0m   \033[38;5;141mextras\033[0m  \033[38;5;208mtools\033[0m   \033[38;5;226mworkflow\033[0m"
            echo -e "    \033[38;5;87mscreen\033[0m  \033[38;5;39mfun\033[0m     \033[38;5;39msystem\033[0m  \033[38;5;255mall\033[0m"
            echo ""
            echo -e "  \033[38;5;240mReload: \033[38;5;51mtups\033[38;5;240m  │  Version: \033[38;5;51mtup version\033[0m"
            echo ""
            ;;
        git)
            _tup_header
            _tup_git
            ;;
        nav|navigation)
            _tup_header
            _tup_nav
            ;;
        npm|pnpm|node)
            _tup_header
            _tup_npm
            ;;
        fzf|fuzzy)
            _tup_header
            _tup_fzf
            ;;
        ddev|docker)
            _tup_header
            _tup_ddev
            ;;
        theme|themes)
            _tup_header
            _tup_theme
            ;;
        extras|extra|productivity)
            _tup_header
            _tup_extras
            ;;
        tools|util|utils)
            _tup_header
            _tup_tools
            ;;
        workflow|work)
            _tup_header
            _tup_workflow
            ;;
        fun|games|animations)
            _tup_header
            _tup_fun
            ;;
        screen|lock|screensaver)
            _tup_header
            _tup_screen
            ;;
        system|sys|lang|platform)
            _tup_header
            _tup_system
            ;;
        all|full)
            _tup_header
            _tup_git
            _tup_nav
            _tup_npm
            _tup_fzf
            _tup_ddev
            _tup_theme
            _tup_extras
            _tup_tools
            _tup_workflow
            _tup_fun
            _tup_screen
            _tup_system
            ;;
        version|--version|-v)
            echo -e "  \033[38;5;51mTerminup\033[0m v1.0.0"
            ;;
        reload)
            source "$TERMINUP_DIR/terminup.zsh"
            echo -e "  \033[38;5;46m✓\033[0m Terminup reloaded!"
            ;;
        mode)
            shift 2>/dev/null
            terminup_mode "$@"
            ;;
        install|reinstall|setup)
            echo -e "\n  \033[38;5;51m🔧 Running Terminup installer...\033[0m\n"
            if [[ -f "$TERMINUP_DIR/install.sh" ]]; then
                bash "$TERMINUP_DIR/install.sh"
            else
                echo -e "  \033[38;5;196m✗\033[0m Install script not found at $TERMINUP_DIR/install.sh"
            fi
            ;;
        *)
            echo -e "  \033[38;5;196m✗\033[0m Unknown: $cmd"
            echo -e "  \033[38;5;245mTry: tup [git|nav|npm|extras|tools|workflow|fun|screen|mode|install|all]\033[0m"
            ;;
    esac
}

# Aliases for quick access
alias tup='terminup'
alias tups='source ~/.zshrc && echo -e "  \033[38;5;46m✓\033[0m Shell reloaded!"'
alias tup-install='terminup install'