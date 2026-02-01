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

# Available languages
typeset -gA TERMINUP_LANGUAGES
TERMINUP_LANGUAGES=(
    en "English"
    nl "Nederlands"
    fr "Français"
    de "Deutsch"
    es "Español"
    pt "Português"
    it "Italiano"
    pl "Polski"
    ru "Русский"
    zh "中文"
    ja "日本語"
    ko "한국어"
)

# ─────────────────────────────────────────────────────────────────
# Translation Strings
# ─────────────────────────────────────────────────────────────────

# English (default)
typeset -gA _T_en
_T_en=(
    # General
    welcome "Welcome back"
    goodbye "Goodbye"
    success "Success"
    error "Error"
    warning "Warning"
    loading "Loading"
    done "Done"
    cancelled "Cancelled"
    
    # Git
    git_commit "Committing changes"
    git_push "Pushing to remote"
    git_pull "Pulling from remote"
    git_add "Staging files"
    git_checkout "Switching branch"
    git_merge "Merging branch"
    git_stash "Stashing changes"
    git_stash_pop "Applying stash"
    git_no_changes "No changes to commit"
    git_nothing_to_push "Nothing to push"
    
    # Navigation
    dir_changed "Changed to"
    dir_created "Created directory"
    dir_not_found "Directory not found"
    bookmark_saved "Bookmark saved"
    bookmark_removed "Bookmark removed"
    
    # NPM/PNPM
    npm_installing "Installing packages"
    npm_installed "Packages installed"
    npm_building "Building project"
    npm_build_done "Build complete"
    npm_dev_starting "Starting dev server"
    
    # Screensaver
    unlock_hint "to unlock"
    press_any_key "Press any key to exit"
    
    # Extras
    timer_complete "Timer complete"
    note_saved "Note saved"
    notes_cleared "Notes cleared"
    password_generated "Password generated"
    password_copied "Copied to clipboard"
    
    # System
    shell_reloaded "Shell reloaded"
    config_saved "Configuration saved"
    language_changed "Language changed to"
)

# Dutch (Nederlands)
typeset -gA _T_nl
_T_nl=(
    welcome "Welkom terug"
    goodbye "Tot ziens"
    success "Gelukt"
    error "Fout"
    warning "Waarschuwing"
    loading "Laden"
    done "Klaar"
    cancelled "Geannuleerd"
    
    git_commit "Wijzigingen committen"
    git_push "Pushen naar remote"
    git_pull "Pullen van remote"
    git_add "Bestanden stagen"
    git_checkout "Branch wisselen"
    git_merge "Branch mergen"
    git_stash "Wijzigingen stashen"
    git_stash_pop "Stash toepassen"
    git_no_changes "Geen wijzigingen om te committen"
    git_nothing_to_push "Niets om te pushen"
    
    dir_changed "Gewijzigd naar"
    dir_created "Map aangemaakt"
    dir_not_found "Map niet gevonden"
    bookmark_saved "Bladwijzer opgeslagen"
    bookmark_removed "Bladwijzer verwijderd"
    
    npm_installing "Pakketten installeren"
    npm_installed "Pakketten geïnstalleerd"
    npm_building "Project bouwen"
    npm_build_done "Build voltooid"
    npm_dev_starting "Dev server starten"
    
    unlock_hint "om te ontgrendelen"
    press_any_key "Druk op een toets om af te sluiten"
    
    timer_complete "Timer voltooid"
    note_saved "Notitie opgeslagen"
    notes_cleared "Notities gewist"
    password_generated "Wachtwoord gegenereerd"
    password_copied "Gekopieerd naar klembord"
    
    shell_reloaded "Shell herladen"
    config_saved "Configuratie opgeslagen"
    language_changed "Taal gewijzigd naar"
)

# French (Français)
typeset -gA _T_fr
_T_fr=(
    welcome "Bon retour"
    goodbye "Au revoir"
    success "Succès"
    error "Erreur"
    warning "Attention"
    loading "Chargement"
    done "Terminé"
    cancelled "Annulé"
    
    git_commit "Validation des modifications"
    git_push "Envoi vers le dépôt"
    git_pull "Récupération du dépôt"
    git_add "Ajout des fichiers"
    git_checkout "Changement de branche"
    git_merge "Fusion de branche"
    git_stash "Mise de côté"
    git_stash_pop "Application du stash"
    git_no_changes "Aucune modification à valider"
    git_nothing_to_push "Rien à envoyer"
    
    dir_changed "Changé vers"
    dir_created "Répertoire créé"
    dir_not_found "Répertoire introuvable"
    bookmark_saved "Signet enregistré"
    bookmark_removed "Signet supprimé"
    
    npm_installing "Installation des paquets"
    npm_installed "Paquets installés"
    npm_building "Construction du projet"
    npm_build_done "Construction terminée"
    npm_dev_starting "Démarrage du serveur dev"
    
    unlock_hint "pour déverrouiller"
    press_any_key "Appuyez sur une touche pour quitter"
    
    timer_complete "Minuterie terminée"
    note_saved "Note enregistrée"
    notes_cleared "Notes effacées"
    password_generated "Mot de passe généré"
    password_copied "Copié dans le presse-papiers"
    
    shell_reloaded "Shell rechargé"
    config_saved "Configuration enregistrée"
    language_changed "Langue changée en"
)

# German (Deutsch)
typeset -gA _T_de
_T_de=(
    welcome "Willkommen zurück"
    goodbye "Auf Wiedersehen"
    success "Erfolg"
    error "Fehler"
    warning "Warnung"
    loading "Laden"
    done "Fertig"
    cancelled "Abgebrochen"
    
    git_commit "Änderungen committen"
    git_push "Zum Remote pushen"
    git_pull "Vom Remote pullen"
    git_add "Dateien stagen"
    git_checkout "Branch wechseln"
    git_merge "Branch mergen"
    git_stash "Änderungen stashen"
    git_stash_pop "Stash anwenden"
    git_no_changes "Keine Änderungen zum Committen"
    git_nothing_to_push "Nichts zu pushen"
    
    dir_changed "Gewechselt zu"
    dir_created "Verzeichnis erstellt"
    dir_not_found "Verzeichnis nicht gefunden"
    bookmark_saved "Lesezeichen gespeichert"
    bookmark_removed "Lesezeichen entfernt"
    
    npm_installing "Pakete installieren"
    npm_installed "Pakete installiert"
    npm_building "Projekt bauen"
    npm_build_done "Build abgeschlossen"
    npm_dev_starting "Dev-Server starten"
    
    unlock_hint "zum Entsperren"
    press_any_key "Beliebige Taste zum Beenden"
    
    timer_complete "Timer abgeschlossen"
    note_saved "Notiz gespeichert"
    notes_cleared "Notizen gelöscht"
    password_generated "Passwort generiert"
    password_copied "In Zwischenablage kopiert"
    
    shell_reloaded "Shell neu geladen"
    config_saved "Konfiguration gespeichert"
    language_changed "Sprache geändert zu"
)

# Spanish (Español)
typeset -gA _T_es
_T_es=(
    welcome "Bienvenido de nuevo"
    goodbye "Adiós"
    success "Éxito"
    error "Error"
    warning "Advertencia"
    loading "Cargando"
    done "Hecho"
    cancelled "Cancelado"
    
    git_commit "Confirmando cambios"
    git_push "Enviando al remoto"
    git_pull "Descargando del remoto"
    git_add "Preparando archivos"
    git_checkout "Cambiando de rama"
    git_merge "Fusionando rama"
    git_stash "Guardando cambios"
    git_stash_pop "Aplicando stash"
    git_no_changes "Sin cambios para confirmar"
    git_nothing_to_push "Nada que enviar"
    
    dir_changed "Cambiado a"
    dir_created "Directorio creado"
    dir_not_found "Directorio no encontrado"
    bookmark_saved "Marcador guardado"
    bookmark_removed "Marcador eliminado"
    
    npm_installing "Instalando paquetes"
    npm_installed "Paquetes instalados"
    npm_building "Construyendo proyecto"
    npm_build_done "Construcción completada"
    npm_dev_starting "Iniciando servidor dev"
    
    unlock_hint "para desbloquear"
    press_any_key "Presiona cualquier tecla para salir"
    
    timer_complete "Temporizador completado"
    note_saved "Nota guardada"
    notes_cleared "Notas borradas"
    password_generated "Contraseña generada"
    password_copied "Copiado al portapapeles"
    
    shell_reloaded "Shell recargado"
    config_saved "Configuración guardada"
    language_changed "Idioma cambiado a"
)

# ─────────────────────────────────────────────────────────────────
# Translation Function
# ─────────────────────────────────────────────────────────────────

# Get translated string
# Usage: _t "key" or _t "key" "fallback"
_t() {
    local key="$1"
    local fallback="${2:-$key}"
    local lang_array="_T_${TERMINUP_LANG}"
    
    # Try current language
    local result="${(P)${lang_array}[$key]}"
    
    # Fallback to English
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
    
    echo -e "  \033[38;5;46m✓\033[0m $(_t language_changed) ${TERMINUP_LANGUAGES[$new_lang]}"
    echo -e "  \033[38;5;245mReload shell for full effect: tups\033[0m"
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
