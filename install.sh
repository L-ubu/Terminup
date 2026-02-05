#!/bin/bash
# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                                                                            ║
# ║   ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗██╗   ██╗██████╗        ║
# ║   ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██║   ██║██╔══██╗       ║
# ║      ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║██║   ██║██████╔╝       ║
# ║      ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██║   ██║██╔═══╝        ║
# ║      ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║╚██████╔╝██║            ║
# ║      ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝            ║
# ║                                                                            ║
# ║                        🚀 Installation Script 🚀                           ║
# ║                                                                            ║
# ╚════════════════════════════════════════════════════════════════════════════╝

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─────────────────────────────────────────────────────────────────
# Internationalization for Install Script
# ─────────────────────────────────────────────────────────────────

# Detect system language
detect_language() {
    local sys_lang="${LANG:-${LC_ALL:-en_US}}"
    echo "${sys_lang%%_*}"
}

DETECTED_LANG=$(detect_language)
INSTALL_LANG="en"

# Translation function
declare -A T

load_translations() {
    local lang="$1"
    
    case "$lang" in
        nl)
            T[installation]="Installatie"
            T[select_language]="Selecteer je taal"
            T[detected]="Gedetecteerd"
            T[checking_deps]="Afhankelijkheden controleren"
            T[installed]="is geïnstalleerd"
            T[not_found]="niet gevonden"
            T[install_now]="Nu installeren?"
            T[choose_mode]="Kies je Terminup modus"
            T[all_lazy]="Alle modi gebruiken lazy loading - functies laden bij eerste gebruik"
            T[essential_tools]="Alleen essentiële dev tools"
            T[visual_extras]="Dev tools + visuele extra's"
            T[everything]="Alles beschikbaar"
            T[pick_own]="Kies je eigen componenten"
            T[select_mode]="Selecteer modus"
            T[default]="standaard"
            T[selected]="Geselecteerd"
            T[available_components]="Beschikbare componenten"
            T[core]="Kern"
            T[enhanced]="Uitgebreid"
            T[fun]="Plezier"
            T[enter_components]="Voer componenten in gescheiden door spaties"
            T[no_components]="Geen componenten ingevoerd, standaard gebruikt"
            T[invalid_choice]="Ongeldige keuze, volledig modus gebruikt"
            T[config_saved]="Configuratie opgeslagen naar"
            T[setting_up]="Configuratie instellen"
            T[backed_up]="Backup gemaakt van .zshrc naar"
            T[already_configured]="Terminup lijkt al geconfigureerd in .zshrc"
            T[overwrite]="Bestaande configuratie overschrijven?"
            T[skipping]="Overslaan .zshrc wijziging"
            T[added_to]="Toegevoegd aan .zshrc"
            T[created_symlink]="Symlink aangemaakt"
            T[complete]="Installatie Voltooid"
            T[mode]="Modus"
            T[components]="Componenten"
            T[fast_startup]="Alle functies laden lazy voor snelle opstart!"
            T[to_start]="Om Terminup te gebruiken"
            T[mode_management]="Modus Beheer"
            T[quick_ref]="Snelle Referentie"
            T[enjoy]="Geniet van je verbeterde terminal!"
            T[language]="Taal"
            T[language_saved]="Taal opgeslagen"
            ;;
        fr)
            T[installation]="Installation"
            T[select_language]="Sélectionnez votre langue"
            T[detected]="Détecté"
            T[checking_deps]="Vérification des dépendances"
            T[installed]="est installé"
            T[not_found]="non trouvé"
            T[install_now]="Installer maintenant?"
            T[choose_mode]="Choisissez votre mode Terminup"
            T[all_lazy]="Tous les modes utilisent le chargement différé"
            T[essential_tools]="Outils de dev essentiels uniquement"
            T[visual_extras]="Outils de dev + extras visuels"
            T[everything]="Tout disponible"
            T[pick_own]="Choisissez vos propres composants"
            T[select_mode]="Sélectionnez le mode"
            T[default]="par défaut"
            T[selected]="Sélectionné"
            T[available_components]="Composants disponibles"
            T[core]="Base"
            T[enhanced]="Amélioré"
            T[fun]="Amusement"
            T[enter_components]="Entrez les composants séparés par des espaces"
            T[no_components]="Aucun composant entré, utilisation des défauts"
            T[invalid_choice]="Choix invalide, mode complet utilisé"
            T[config_saved]="Configuration enregistrée dans"
            T[setting_up]="Configuration en cours"
            T[backed_up]="Sauvegarde de .zshrc vers"
            T[already_configured]="Terminup semble déjà configuré dans .zshrc"
            T[overwrite]="Écraser la configuration existante?"
            T[skipping]="Modification de .zshrc ignorée"
            T[added_to]="Ajouté à .zshrc"
            T[created_symlink]="Lien symbolique créé"
            T[complete]="Installation Terminée"
            T[mode]="Mode"
            T[components]="Composants"
            T[fast_startup]="Toutes les fonctions se chargent en différé!"
            T[to_start]="Pour utiliser Terminup"
            T[mode_management]="Gestion des Modes"
            T[quick_ref]="Référence Rapide"
            T[enjoy]="Profitez de votre terminal amélioré!"
            T[language]="Langue"
            T[language_saved]="Langue enregistrée"
            ;;
        de)
            T[installation]="Installation"
            T[select_language]="Wählen Sie Ihre Sprache"
            T[detected]="Erkannt"
            T[checking_deps]="Abhängigkeiten prüfen"
            T[installed]="ist installiert"
            T[not_found]="nicht gefunden"
            T[install_now]="Jetzt installieren?"
            T[choose_mode]="Wählen Sie Ihren Terminup-Modus"
            T[all_lazy]="Alle Modi verwenden Lazy Loading"
            T[essential_tools]="Nur wesentliche Dev-Tools"
            T[visual_extras]="Dev-Tools + visuelle Extras"
            T[everything]="Alles verfügbar"
            T[pick_own]="Wählen Sie Ihre eigenen Komponenten"
            T[select_mode]="Modus wählen"
            T[default]="Standard"
            T[selected]="Ausgewählt"
            T[complete]="Installation Abgeschlossen"
            T[mode]="Modus"
            T[enjoy]="Genießen Sie Ihr verbessertes Terminal!"
            T[language]="Sprache"
            T[language_saved]="Sprache gespeichert"
            ;;
        es)
            T[installation]="Instalación"
            T[select_language]="Selecciona tu idioma"
            T[detected]="Detectado"
            T[checking_deps]="Verificando dependencias"
            T[installed]="está instalado"
            T[not_found]="no encontrado"
            T[install_now]="¿Instalar ahora?"
            T[choose_mode]="Elige tu modo Terminup"
            T[all_lazy]="Todos los modos usan carga diferida"
            T[essential_tools]="Solo herramientas dev esenciales"
            T[visual_extras]="Herramientas dev + extras visuales"
            T[everything]="Todo disponible"
            T[pick_own]="Elige tus propios componentes"
            T[select_mode]="Seleccionar modo"
            T[default]="predeterminado"
            T[selected]="Seleccionado"
            T[complete]="Instalación Completada"
            T[mode]="Modo"
            T[enjoy]="¡Disfruta tu terminal mejorada!"
            T[language]="Idioma"
            T[language_saved]="Idioma guardado"
            ;;
        it)
            T[installation]="Installazione"
            T[select_language]="Seleziona la tua lingua"
            T[detected]="Rilevato"
            T[checking_deps]="Controllo dipendenze"
            T[installed]="è installato"
            T[not_found]="non trovato"
            T[install_now]="Installare ora?"
            T[choose_mode]="Scegli la tua modalità Terminup"
            T[all_lazy]="Tutte le modalità usano lazy loading"
            T[essential_tools]="Solo strumenti dev essenziali"
            T[visual_extras]="Strumenti dev + extra visivi"
            T[everything]="Tutto disponibile"
            T[pick_own]="Scegli i tuoi componenti"
            T[select_mode]="Seleziona modalità"
            T[default]="predefinito"
            T[selected]="Selezionato"
            T[available_components]="Componenti disponibili"
            T[core]="Base"
            T[enhanced]="Avanzato"
            T[fun]="Divertimento"
            T[enter_components]="Inserisci componenti separati da spazi"
            T[no_components]="Nessun componente inserito, uso predefiniti"
            T[invalid_choice]="Scelta non valida, uso modalità completa"
            T[config_saved]="Configurazione salvata in"
            T[setting_up]="Configurazione in corso"
            T[backed_up]="Backup di .zshrc in"
            T[already_configured]="Terminup sembra già configurato in .zshrc"
            T[overwrite]="Sovrascrivere configurazione esistente?"
            T[skipping]="Salto modifica .zshrc"
            T[added_to]="Aggiunto a .zshrc"
            T[created_symlink]="Symlink creato"
            T[complete]="Installazione Completata"
            T[mode]="Modalità"
            T[components]="Componenti"
            T[fast_startup]="Tutte le funzioni si caricano lazy per avvio veloce!"
            T[to_start]="Per usare Terminup"
            T[mode_management]="Gestione Modalità"
            T[quick_ref]="Riferimento Rapido"
            T[enjoy]="Goditi il tuo terminale migliorato!"
            T[language]="Lingua"
            T[language_saved]="Lingua salvata"
            ;;
        *)
            # English (default)
            T[installation]="Installation"
            T[select_language]="Select your language"
            T[detected]="Detected"
            T[checking_deps]="Checking dependencies"
            T[installed]="is installed"
            T[not_found]="not found"
            T[install_now]="Install now?"
            T[choose_mode]="Choose your Terminup mode"
            T[all_lazy]="All modes use lazy loading - features load on first use"
            T[essential_tools]="Essential dev tools only"
            T[visual_extras]="Dev tools + visual extras"
            T[everything]="Everything available"
            T[pick_own]="Pick your own components"
            T[select_mode]="Select mode"
            T[default]="default"
            T[selected]="Selected"
            T[available_components]="Available components"
            T[core]="Core"
            T[enhanced]="Enhanced"
            T[fun]="Fun"
            T[enter_components]="Enter components separated by spaces"
            T[no_components]="No components entered, using defaults"
            T[invalid_choice]="Invalid choice, using full mode"
            T[config_saved]="Configuration saved to"
            T[setting_up]="Setting up configuration"
            T[backed_up]="Backed up .zshrc to"
            T[already_configured]="Terminup already appears to be configured in .zshrc"
            T[overwrite]="Overwrite existing configuration?"
            T[skipping]="Skipping .zshrc modification"
            T[added_to]="Added to .zshrc"
            T[created_symlink]="Created symlink"
            T[complete]="Installation Complete"
            T[mode]="Mode"
            T[components]="Components"
            T[fast_startup]="All features lazy-load on first use for fast startup!"
            T[to_start]="To start using Terminup"
            T[mode_management]="Mode Management"
            T[quick_ref]="Quick Reference"
            T[enjoy]="Enjoy your enhanced terminal!"
            T[language]="Language"
            T[language_saved]="Language saved"
            ;;
    esac
}

# Load English as default
load_translations "en"

# ─────────────────────────────────────────────────────────────────
# Print Functions
# ─────────────────────────────────────────────────────────────────

print_status() {
    echo -e "  ${GREEN}✓${RESET} $1"
}

print_warning() {
    echo -e "  ${YELLOW}⚠${RESET} $1"
}

print_error() {
    echo -e "  ${RED}✗${RESET} $1"
}

print_info() {
    echo -e "  ${BLUE}ℹ${RESET} $1"
}

# ─────────────────────────────────────────────────────────────────
# Header
# ─────────────────────────────────────────────────────────────────

echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║${RESET}           ${PURPLE}✨ Terminup ${T[installation]} ✨${RESET}                    ${CYAN}║${RESET}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# ─────────────────────────────────────────────────────────────────
# Language Selection
# ─────────────────────────────────────────────────────────────────

echo -e "  ${CYAN}🌐 ${T[select_language]}:${RESET}"
echo ""
echo -e "  ${GREEN}[1]${RESET} English"
echo -e "  ${GREEN}[2]${RESET} Nederlands"
echo -e "  ${GREEN}[3]${RESET} Français"
echo -e "  ${GREEN}[4]${RESET} Deutsch"
echo -e "  ${GREEN}[5]${RESET} Español"
echo -e "  ${GREEN}[6]${RESET} Italiano"
echo ""

# Show detected language hint
case "$DETECTED_LANG" in
    nl) echo -e "  ${PURPLE}${T[detected]}: Nederlands${RESET}" ;;
    fr) echo -e "  ${PURPLE}${T[detected]}: Français${RESET}" ;;
    de) echo -e "  ${PURPLE}${T[detected]}: Deutsch${RESET}" ;;
    es) echo -e "  ${PURPLE}${T[detected]}: Español${RESET}" ;;
    it) echo -e "  ${PURPLE}${T[detected]}: Italiano${RESET}" ;;
    *) echo -e "  ${PURPLE}${T[detected]}: English${RESET}" ;;
esac
echo ""

read -p "     [1/2/3/4/5/6] (${T[default]}: 1): " lang_choice
case "$lang_choice" in
    2) INSTALL_LANG="nl" ;;
    3) INSTALL_LANG="fr" ;;
    4) INSTALL_LANG="de" ;;
    5) INSTALL_LANG="es" ;;
    6) INSTALL_LANG="it" ;;
    *) INSTALL_LANG="en" ;;
esac

# Reload translations with selected language
load_translations "$INSTALL_LANG"
print_status "${T[language]}: $INSTALL_LANG"

# ─────────────────────────────────────────────────────────────────
# Check for zsh
# ─────────────────────────────────────────────────────────────────

if [[ ! -n "$ZSH_VERSION" ]] && [[ "$SHELL" != *"zsh"* ]]; then
    print_warning "This script is designed for zsh. Current shell: $SHELL"
fi

# ─────────────────────────────────────────────────────────────────
# Check Dependencies
# ─────────────────────────────────────────────────────────────────

echo ""
echo -e "  ${CYAN}${T[checking_deps]}...${RESET}"
echo ""

if command -v fzf &>/dev/null; then
    print_status "fzf ${T[installed]}"
else
    print_warning "fzf ${T[not_found]} - Ctrl+R enhanced search won't work"
    echo ""
    echo -e "     ${YELLOW}brew install fzf${RESET}"
    echo ""
    read -p "     ${T[install_now]} (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if command -v brew &>/dev/null; then
            brew install fzf
            print_status "fzf ${T[installed]}"
        else
            print_error "Homebrew ${T[not_found]}"
        fi
    fi
fi

if command -v bat &>/dev/null; then
    print_status "bat ${T[installed]} (enhanced previews enabled)"
else
    print_info "bat ${T[not_found]} - file previews will use cat instead"
    echo -e "     Optional: ${YELLOW}brew install bat${RESET}"
fi

# ─────────────────────────────────────────────────────────────────
# Mode Selection
# ─────────────────────────────────────────────────────────────────

echo ""
echo -e "  ${CYAN}${T[choose_mode]}:${RESET}"
echo -e "  ${PURPLE}(${T[all_lazy]})${RESET}"
echo ""
echo -e "  ${GREEN}[1] minimal${RESET} - ${YELLOW}${T[essential_tools]}${RESET}"
echo -e "      ├─ git      : gc, gp, gl, gss, glog..."
echo -e "      ├─ nav      : ll, lt, fcd, mkcd, bookmarks..."
echo -e "      ├─ npm      : ni, pi, dev, build, scripts..."
echo -e "      └─ ddev     : dstart, dstop, dssh..."
echo ""
echo -e "  ${GREEN}[2] fun${RESET} - ${YELLOW}${T[visual_extras]}${RESET}"
echo -e "      ├─ All minimal features, plus:"
echo -e "      ├─ animations, themes, extras (pomo, todo, notes...)"
echo -e "      └─ screensaver (lock, matrix, pipes...), startup"
echo ""
echo -e "  ${GREEN}[3] full${RESET} - ${YELLOW}${T[everything]}${RESET}"
echo -e "      ├─ All fun features, plus:"
echo -e "      └─ fzf power, cursor effects, completions"
echo ""
echo -e "  ${GREEN}[4] custom${RESET} - ${YELLOW}${T[pick_own]}${RESET}"
echo -e "      └─ Choose exactly which features you want"
echo ""

TERMINUP_MODE="full"
TERMINUP_CUSTOM_COMPONENTS=""

read -p "     ${T[select_mode]} [1/2/3/4] (${T[default]}: 3): " mode_choice
case "$mode_choice" in
    1)
        TERMINUP_MODE="minimal"
        print_status "${T[selected]}: minimal (git, nav, npm, ddev)"
        ;;
    2)
        TERMINUP_MODE="fun"
        print_status "${T[selected]}: fun (+ animations, themes, extras, screensaver)"
        ;;
    3|"")
        TERMINUP_MODE="full"
        print_status "${T[selected]}: full (${T[everything]})"
        ;;
    4)
        TERMINUP_MODE="custom"
        echo ""
        echo -e "  ${CYAN}${T[available_components]}:${RESET}"
        echo ""
        echo -e "    ${GREEN}${T[core]}:${RESET}"
        echo -e "      git         - Git commands (gc, gp, gl, gss, glog...)"
        echo -e "      nav         - Navigation (ll, lt, fcd, mkcd, bookmarks...)"
        echo -e "      npm         - NPM/PNPM (ni, pi, dev, build, scripts...)"
        echo -e "      ddev        - DDEV integration (dstart, dssh, dinfo...)"
        echo ""
        echo -e "    ${YELLOW}${T[enhanced]}:${RESET}"
        echo -e "      fzf         - FZF power (ff, fbr, flog, fkill...)"
        echo -e "      animations  - Text animations and spinners"
        echo -e "      themes      - Color themes and palettes"
        echo -e "      extras      - Productivity (pomo, todo, notes, weather...)"
        echo ""
        echo -e "    ${PURPLE}${T[fun]}:${RESET}"
        echo -e "      screensaver - Lock screen, matrix, pipes, rain..."
        echo -e "      startup     - Welcome message, ritual, standup..."
        echo -e "      cursor      - Cursor effects"
        echo -e "      completions - Tab completions"
        echo ""
        echo -e "  ${CYAN}${T[enter_components]}:${RESET}"
        read -p "     > " TERMINUP_CUSTOM_COMPONENTS
        
        if [[ -z "$TERMINUP_CUSTOM_COMPONENTS" ]]; then
            TERMINUP_CUSTOM_COMPONENTS="git nav npm ddev"
            print_warning "${T[no_components]}: git nav npm ddev"
        else
            print_status "${T[selected]}: $TERMINUP_CUSTOM_COMPONENTS"
        fi
        ;;
    *)
        print_warning "${T[invalid_choice]}"
        TERMINUP_MODE="full"
        ;;
esac

# ─────────────────────────────────────────────────────────────────
# Save Configuration
# ─────────────────────────────────────────────────────────────────

TERMINUP_CONFIG_DIR="$HOME/.config/terminup"
mkdir -p "$TERMINUP_CONFIG_DIR"

# Save mode
echo "TERMINUP_MODE=\"$TERMINUP_MODE\"" > "$TERMINUP_CONFIG_DIR/mode"

# Save custom components if applicable
if [[ "$TERMINUP_MODE" == "custom" ]]; then
    echo "TERMINUP_CUSTOM_COMPONENTS=\"$TERMINUP_CUSTOM_COMPONENTS\"" > "$TERMINUP_CONFIG_DIR/components"
fi

# Save language preference (this will be used by terminup)
echo "TERMINUP_LANG=\"$INSTALL_LANG\"" > "$HOME/.terminup_config"

print_status "${T[config_saved]} ~/.config/terminup/"
print_status "${T[language_saved]}: $INSTALL_LANG"

# ─────────────────────────────────────────────────────────────────
# Setup .zshrc
# ─────────────────────────────────────────────────────────────────

echo ""
echo -e "  ${CYAN}${T[setting_up]}...${RESET}"
echo ""

ZSHRC="$HOME/.zshrc"
BACKUP_FILE="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"

if [[ -f "$ZSHRC" ]]; then
    cp "$ZSHRC" "$BACKUP_FILE"
    print_status "${T[backed_up]} $BACKUP_FILE"
fi

TERMINUP_SOURCE="source \"$SCRIPT_DIR/terminup.zsh\""

if grep -q "terminup.zsh" "$ZSHRC" 2>/dev/null; then
    print_warning "${T[already_configured]}"
    read -p "     ${T[overwrite]} (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sed -i '' '/# Terminup/d' "$ZSHRC" 2>/dev/null || true
        sed -i '' '/terminup.zsh/d' "$ZSHRC" 2>/dev/null || true
    else
        print_info "${T[skipping]}"
    fi
fi

if ! grep -q "terminup.zsh" "$ZSHRC" 2>/dev/null; then
    echo "" >> "$ZSHRC"
    echo "# Terminup - Terminal Enhancements" >> "$ZSHRC"
    echo "$TERMINUP_SOURCE" >> "$ZSHRC"
    print_status "${T[added_to]}"
fi

# Create symlink
if [[ ! -L "$HOME/.terminup" ]]; then
    ln -sf "$SCRIPT_DIR" "$HOME/.terminup"
    print_status "${T[created_symlink]} ~/.terminup"
fi

# Make scripts executable
chmod +x "$SCRIPT_DIR"/*.zsh 2>/dev/null || true
chmod +x "$SCRIPT_DIR"/components/*.zsh 2>/dev/null || true

# ─────────────────────────────────────────────────────────────────
# Complete!
# ─────────────────────────────────────────────────────────────────

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}║${RESET}              ${GREEN}✅ ${T[complete]}!${RESET}                    ${GREEN}║${RESET}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "  ${CYAN}${T[mode]}:${RESET} ${YELLOW}$TERMINUP_MODE${RESET}"
echo -e "  ${CYAN}${T[language]}:${RESET} ${YELLOW}$INSTALL_LANG${RESET}"
if [[ "$TERMINUP_MODE" == "custom" ]]; then
    echo -e "  ${CYAN}${T[components]}:${RESET} ${YELLOW}$TERMINUP_CUSTOM_COMPONENTS${RESET}"
fi
echo ""
echo -e "  ${PURPLE}⚡ ${T[fast_startup]}${RESET}"
echo ""
echo -e "  ${CYAN}${T[to_start]}:${RESET}"
echo ""
echo -e "     ${YELLOW}source ~/.zshrc${RESET}    or    ${YELLOW}exec zsh${RESET}"
echo ""
echo -e "  ${CYAN}${T[mode_management]}:${RESET}"
echo -e "     ${GREEN}terminup_mode status${RESET}      - Show current config"
echo -e "     ${GREEN}terminup_mode list${RESET}        - Show available modes"
echo -e "     ${GREEN}terminup_mode components${RESET}  - Show available components"
echo -e "     ${GREEN}terminup_mode set <mode>${RESET}  - Change mode"
echo -e "     ${GREEN}terminup_mode custom ...${RESET}  - Set custom components"
echo ""
echo -e "  ${CYAN}${T[quick_ref]}:${RESET}"
echo ""
echo -e "     ${GREEN}Git:${RESET}        gc, gp, gl, ga, gss, glog, gb, gst"
echo -e "     ${GREEN}Navigation:${RESET} ll, lt, fcd, mkcd, recent, bm, jb"
echo -e "     ${GREEN}NPM/PNPM:${RESET}   ni, pi, dev, build, scripts, fscript"
echo -e "     ${GREEN}DDEV:${RESET}       dstart, dstop, dssh, dinfo, dni, dpi"
echo -e "     ${GREEN}Help:${RESET}       tup (shows all commands by category)"
echo ""
echo -e "  ${PURPLE}${T[enjoy]} 🚀${RESET}"
echo ""
