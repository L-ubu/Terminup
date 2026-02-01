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
    usage "Usage"
    creating "Creating"
    removing "Removing"
    removed "Removed"
    cleaned "cleaned"
    using "Using"
    installing "Installing"
    building "Building"
    searching "Searching for"
    
    # Git
    git_commit "Committing changes"
    git_push "Pushing to remote"
    git_pull "Pulling from remote"
    git_add "Staging files"
    git_checkout "Switching branch"
    git_merge "Merging"
    git_stash "Stashing changes"
    git_stash_pop "Restoring stash"
    git_no_changes "No changes to commit"
    git_nothing_to_push "Nothing to push"
    enter_message "Enter commit message"
    no_message "no message provided"
    specify_branch "Please specify a branch name"
    
    # Navigation
    dir_changed "Changed to"
    dir_created "Directory created and entered"
    dir_not_found "Directory not found"
    directory_listing "Directory Listing"
    empty_dir "empty directory"
    tree_view "Tree view"
    recent_dirs "Recent Directories"
    specify_dir "Please provide a directory name"
    bookmark_saved "Bookmark saved"
    bookmark_removed "Bookmark removed"
    
    # NPM/PNPM
    npm_installing "Installing packages"
    npm_installed "Packages installed"
    npm_success "Packages installed successfully"
    npm_install_deps "Installing dependencies from package.json"
    npm_building "Building project"
    npm_build_done "Build complete"
    npm_dev_starting "Starting dev server"
    install_complete "Installation complete"
    install_failed "Installation failed"
    dev_starting "Starting development server"
    build_compiling "Compiling and bundling"
    build_complete "Build complete"
    build_failed "Build failed"
    tests_running "Running tests"
    available_scripts "Available Scripts"
    no_package_json "No package.json found"
    specify_package "Please specify a package name"
    adding_package "Adding package"
    removing_package "Removing package"
    checking_outdated "Checking for outdated packages"
    
    # Screensaver
    unlock_hint "to unlock"
    press_any_key "Press any key to exit"
    locking_system "Locking system"
    
    # Extras
    pomodoro "Pomodoro Timer"
    session "Session"
    duration "Duration"
    minutes "minutes"
    seconds "seconds"
    pomo_complete "Pomodoro complete"
    break_time "Time for a break"
    timer_complete "Timer complete"
    quick_notes "Quick Notes"
    note "Note"
    note_saved "Note saved"
    notes_cleared "Notes cleared"
    no_notes "No notes yet. Add one with: note add <text>"
    quote_of_day "Quote of the Day"
    need_options "Please provide at least 2 options"
    deciding "Let me decide"
    countdown "Countdown"
    system_stats "System Stats"
    generated_password "Generated password"
    copied_clipboard "Copied to clipboard"
    password_generated "Password generated"
    password_copied "Copied to clipboard"
    playing "Playing"
    paused "Paused"
    now_playing "Now Playing"
    not_playing "not playing"
    calendar "Calendar"
    quick_cleanup "Quick Cleanup"
    clearing_npm "Clearing npm cache"
    clearing_pnpm "Clearing pnpm cache"
    cache_cleared "Cache cleared"
    removing_node "Removing node_modules"
    removing_ds "Removing .DS_Store files"
    files_removed "files removed"
    cleaning_git "Cleaning git"
    clear_cache "Clear npm/pnpm cache"
    remove_node "Remove node_modules"
    remove_ds "Remove .DS_Store files"
    clean_git "Clean git (gc + prune)"
    run_all "Run all cleanups"
    searching_so "Searching Stack Overflow for"
    searching_gh "Searching GitHub for"
    focus_active "Focus Mode Active"
    stay_focused "Stay focused! No distractions"
    
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
    usage "Gebruik"
    creating "Aanmaken"
    removing "Verwijderen"
    removed "Verwijderd"
    cleaned "opgeschoond"
    using "Gebruikt"
    installing "Installeren"
    building "Bouwen"
    searching "Zoeken naar"
    
    git_commit "Wijzigingen committen"
    git_push "Pushen naar remote"
    git_pull "Pullen van remote"
    git_add "Bestanden stagen"
    git_checkout "Branch wisselen"
    git_merge "Mergen"
    git_stash "Wijzigingen stashen"
    git_stash_pop "Stash herstellen"
    git_no_changes "Geen wijzigingen om te committen"
    git_nothing_to_push "Niets om te pushen"
    enter_message "Voer commit bericht in"
    no_message "geen bericht opgegeven"
    specify_branch "Geef een branch naam op"
    
    dir_changed "Gewijzigd naar"
    dir_created "Map aangemaakt en geopend"
    dir_not_found "Map niet gevonden"
    directory_listing "Map Inhoud"
    empty_dir "lege map"
    tree_view "Boomweergave"
    recent_dirs "Recente Mappen"
    specify_dir "Geef een mapnaam op"
    bookmark_saved "Bladwijzer opgeslagen"
    bookmark_removed "Bladwijzer verwijderd"
    
    npm_installing "Pakketten installeren"
    npm_installed "Pakketten geïnstalleerd"
    npm_success "Pakketten succesvol geïnstalleerd"
    npm_install_deps "Afhankelijkheden installeren van package.json"
    npm_building "Project bouwen"
    npm_build_done "Build voltooid"
    npm_dev_starting "Dev server starten"
    install_complete "Installatie voltooid"
    install_failed "Installatie mislukt"
    dev_starting "Development server starten"
    build_compiling "Compileren en bundelen"
    build_complete "Build voltooid"
    build_failed "Build mislukt"
    tests_running "Tests uitvoeren"
    available_scripts "Beschikbare Scripts"
    no_package_json "Geen package.json gevonden"
    specify_package "Geef een pakketnaam op"
    adding_package "Pakket toevoegen"
    removing_package "Pakket verwijderen"
    checking_outdated "Controleren op verouderde pakketten"
    
    unlock_hint "om te ontgrendelen"
    press_any_key "Druk op een toets om af te sluiten"
    locking_system "Systeem vergrendelen"
    
    pomodoro "Pomodoro Timer"
    session "Sessie"
    duration "Duur"
    minutes "minuten"
    seconds "seconden"
    pomo_complete "Pomodoro voltooid"
    break_time "Tijd voor een pauze"
    timer_complete "Timer voltooid"
    quick_notes "Snelle Notities"
    note "Notitie"
    note_saved "Notitie opgeslagen"
    notes_cleared "Notities gewist"
    no_notes "Nog geen notities. Voeg toe met: note add <tekst>"
    quote_of_day "Quote van de Dag"
    need_options "Geef minimaal 2 opties op"
    deciding "Even kijken"
    countdown "Aftellen"
    system_stats "Systeem Statistieken"
    generated_password "Gegenereerd wachtwoord"
    copied_clipboard "Gekopieerd naar klembord"
    password_generated "Wachtwoord gegenereerd"
    password_copied "Gekopieerd naar klembord"
    playing "Afspelen"
    paused "Gepauzeerd"
    now_playing "Nu aan het spelen"
    not_playing "speelt niet"
    calendar "Kalender"
    quick_cleanup "Snelle Opruiming"
    clearing_npm "npm cache legen"
    clearing_pnpm "pnpm cache legen"
    cache_cleared "Cache geleegd"
    removing_node "node_modules verwijderen"
    removing_ds ".DS_Store bestanden verwijderen"
    files_removed "bestanden verwijderd"
    cleaning_git "Git opschonen"
    clear_cache "npm/pnpm cache legen"
    remove_node "node_modules verwijderen"
    remove_ds ".DS_Store bestanden verwijderen"
    clean_git "Git opschonen (gc + prune)"
    run_all "Alles uitvoeren"
    searching_so "Stack Overflow doorzoeken naar"
    searching_gh "GitHub doorzoeken naar"
    focus_active "Focus Modus Actief"
    stay_focused "Blijf gefocust! Geen afleidingen"
    
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
    usage "Utilisation"
    creating "Création"
    removing "Suppression"
    removed "Supprimé"
    cleaned "nettoyé"
    using "Utilise"
    installing "Installation"
    building "Construction"
    searching "Recherche de"
    
    git_commit "Validation des modifications"
    git_push "Envoi vers le dépôt"
    git_pull "Récupération du dépôt"
    git_add "Ajout des fichiers"
    git_checkout "Changement de branche"
    git_merge "Fusion"
    git_stash "Mise de côté"
    git_stash_pop "Restauration du stash"
    git_no_changes "Aucune modification à valider"
    git_nothing_to_push "Rien à envoyer"
    enter_message "Entrez le message de commit"
    no_message "aucun message fourni"
    specify_branch "Veuillez spécifier un nom de branche"
    
    dir_changed "Changé vers"
    dir_created "Répertoire créé et ouvert"
    dir_not_found "Répertoire introuvable"
    directory_listing "Contenu du Répertoire"
    empty_dir "répertoire vide"
    tree_view "Vue arborescente"
    recent_dirs "Répertoires Récents"
    specify_dir "Veuillez fournir un nom de répertoire"
    bookmark_saved "Signet enregistré"
    bookmark_removed "Signet supprimé"
    
    npm_installing "Installation des paquets"
    npm_installed "Paquets installés"
    npm_success "Paquets installés avec succès"
    npm_install_deps "Installation des dépendances de package.json"
    npm_building "Construction du projet"
    npm_build_done "Construction terminée"
    npm_dev_starting "Démarrage du serveur dev"
    install_complete "Installation terminée"
    install_failed "Installation échouée"
    dev_starting "Démarrage du serveur de développement"
    build_compiling "Compilation et bundling"
    build_complete "Construction terminée"
    build_failed "Construction échouée"
    tests_running "Exécution des tests"
    available_scripts "Scripts Disponibles"
    no_package_json "Aucun package.json trouvé"
    specify_package "Veuillez spécifier un nom de paquet"
    adding_package "Ajout du paquet"
    removing_package "Suppression du paquet"
    checking_outdated "Vérification des paquets obsolètes"
    
    unlock_hint "pour déverrouiller"
    press_any_key "Appuyez sur une touche pour quitter"
    locking_system "Verrouillage du système"
    
    pomodoro "Minuterie Pomodoro"
    session "Session"
    duration "Durée"
    minutes "minutes"
    seconds "secondes"
    pomo_complete "Pomodoro terminé"
    break_time "C'est l'heure de la pause"
    timer_complete "Minuterie terminée"
    quick_notes "Notes Rapides"
    note "Note"
    note_saved "Note enregistrée"
    notes_cleared "Notes effacées"
    no_notes "Pas encore de notes. Ajoutez-en avec: note add <texte>"
    quote_of_day "Citation du Jour"
    need_options "Veuillez fournir au moins 2 options"
    deciding "Laissez-moi décider"
    countdown "Compte à rebours"
    system_stats "Statistiques Système"
    generated_password "Mot de passe généré"
    copied_clipboard "Copié dans le presse-papiers"
    password_generated "Mot de passe généré"
    password_copied "Copié dans le presse-papiers"
    playing "Lecture"
    paused "En pause"
    now_playing "En cours de lecture"
    not_playing "pas en lecture"
    calendar "Calendrier"
    quick_cleanup "Nettoyage Rapide"
    clearing_npm "Vidage du cache npm"
    clearing_pnpm "Vidage du cache pnpm"
    cache_cleared "Cache vidé"
    removing_node "Suppression de node_modules"
    removing_ds "Suppression des fichiers .DS_Store"
    files_removed "fichiers supprimés"
    cleaning_git "Nettoyage de git"
    clear_cache "Vider le cache npm/pnpm"
    remove_node "Supprimer node_modules"
    remove_ds "Supprimer les fichiers .DS_Store"
    clean_git "Nettoyer git (gc + prune)"
    run_all "Tout exécuter"
    searching_so "Recherche sur Stack Overflow"
    searching_gh "Recherche sur GitHub"
    focus_active "Mode Focus Actif"
    stay_focused "Restez concentré! Pas de distractions"
    
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
    usage "Verwendung"
    creating "Erstellen"
    removing "Entfernen"
    removed "Entfernt"
    cleaned "bereinigt"
    using "Verwendet"
    installing "Installieren"
    building "Bauen"
    searching "Suchen nach"
    
    git_commit "Änderungen committen"
    git_push "Zum Remote pushen"
    git_pull "Vom Remote pullen"
    git_add "Dateien stagen"
    git_checkout "Branch wechseln"
    git_merge "Mergen"
    git_stash "Änderungen stashen"
    git_stash_pop "Stash wiederherstellen"
    git_no_changes "Keine Änderungen zum Committen"
    git_nothing_to_push "Nichts zu pushen"
    enter_message "Commit-Nachricht eingeben"
    no_message "keine Nachricht angegeben"
    specify_branch "Bitte geben Sie einen Branch-Namen an"
    
    dir_changed "Gewechselt zu"
    dir_created "Verzeichnis erstellt und geöffnet"
    dir_not_found "Verzeichnis nicht gefunden"
    directory_listing "Verzeichnisinhalt"
    empty_dir "leeres Verzeichnis"
    tree_view "Baumansicht"
    recent_dirs "Letzte Verzeichnisse"
    specify_dir "Bitte geben Sie einen Verzeichnisnamen an"
    bookmark_saved "Lesezeichen gespeichert"
    bookmark_removed "Lesezeichen entfernt"
    
    npm_installing "Pakete installieren"
    npm_installed "Pakete installiert"
    npm_success "Pakete erfolgreich installiert"
    npm_install_deps "Abhängigkeiten aus package.json installieren"
    npm_building "Projekt bauen"
    npm_build_done "Build abgeschlossen"
    npm_dev_starting "Dev-Server starten"
    install_complete "Installation abgeschlossen"
    install_failed "Installation fehlgeschlagen"
    dev_starting "Entwicklungsserver starten"
    build_compiling "Kompilieren und Bundeln"
    build_complete "Build abgeschlossen"
    build_failed "Build fehlgeschlagen"
    tests_running "Tests ausführen"
    available_scripts "Verfügbare Scripts"
    no_package_json "Keine package.json gefunden"
    specify_package "Bitte geben Sie einen Paketnamen an"
    adding_package "Paket hinzufügen"
    removing_package "Paket entfernen"
    checking_outdated "Prüfe auf veraltete Pakete"
    
    unlock_hint "zum Entsperren"
    press_any_key "Beliebige Taste zum Beenden"
    locking_system "System sperren"
    
    pomodoro "Pomodoro Timer"
    session "Sitzung"
    duration "Dauer"
    minutes "Minuten"
    seconds "Sekunden"
    pomo_complete "Pomodoro abgeschlossen"
    break_time "Zeit für eine Pause"
    timer_complete "Timer abgeschlossen"
    quick_notes "Schnelle Notizen"
    note "Notiz"
    note_saved "Notiz gespeichert"
    notes_cleared "Notizen gelöscht"
    no_notes "Noch keine Notizen. Hinzufügen mit: note add <text>"
    quote_of_day "Zitat des Tages"
    need_options "Bitte geben Sie mindestens 2 Optionen an"
    deciding "Lass mich entscheiden"
    countdown "Countdown"
    system_stats "Systemstatistiken"
    generated_password "Generiertes Passwort"
    copied_clipboard "In Zwischenablage kopiert"
    password_generated "Passwort generiert"
    password_copied "In Zwischenablage kopiert"
    playing "Wiedergabe"
    paused "Pausiert"
    now_playing "Wird gespielt"
    not_playing "spielt nicht"
    calendar "Kalender"
    quick_cleanup "Schnelle Bereinigung"
    clearing_npm "npm Cache leeren"
    clearing_pnpm "pnpm Cache leeren"
    cache_cleared "Cache geleert"
    removing_node "node_modules entfernen"
    removing_ds ".DS_Store Dateien entfernen"
    files_removed "Dateien entfernt"
    cleaning_git "Git bereinigen"
    clear_cache "npm/pnpm Cache leeren"
    remove_node "node_modules entfernen"
    remove_ds ".DS_Store Dateien entfernen"
    clean_git "Git bereinigen (gc + prune)"
    run_all "Alles ausführen"
    searching_so "Stack Overflow durchsuchen nach"
    searching_gh "GitHub durchsuchen nach"
    focus_active "Fokus-Modus Aktiv"
    stay_focused "Bleib fokussiert! Keine Ablenkungen"
    
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
    usage "Uso"
    creating "Creando"
    removing "Eliminando"
    removed "Eliminado"
    cleaned "limpiado"
    using "Usando"
    installing "Instalando"
    building "Construyendo"
    searching "Buscando"
    
    git_commit "Confirmando cambios"
    git_push "Enviando al remoto"
    git_pull "Descargando del remoto"
    git_add "Preparando archivos"
    git_checkout "Cambiando de rama"
    git_merge "Fusionando"
    git_stash "Guardando cambios"
    git_stash_pop "Restaurando stash"
    git_no_changes "Sin cambios para confirmar"
    git_nothing_to_push "Nada que enviar"
    enter_message "Ingrese mensaje de commit"
    no_message "no se proporcionó mensaje"
    specify_branch "Por favor especifique un nombre de rama"
    
    dir_changed "Cambiado a"
    dir_created "Directorio creado y abierto"
    dir_not_found "Directorio no encontrado"
    directory_listing "Contenido del Directorio"
    empty_dir "directorio vacío"
    tree_view "Vista de árbol"
    recent_dirs "Directorios Recientes"
    specify_dir "Por favor proporcione un nombre de directorio"
    bookmark_saved "Marcador guardado"
    bookmark_removed "Marcador eliminado"
    
    npm_installing "Instalando paquetes"
    npm_installed "Paquetes instalados"
    npm_success "Paquetes instalados exitosamente"
    npm_install_deps "Instalando dependencias de package.json"
    npm_building "Construyendo proyecto"
    npm_build_done "Construcción completada"
    npm_dev_starting "Iniciando servidor dev"
    install_complete "Instalación completada"
    install_failed "Instalación fallida"
    dev_starting "Iniciando servidor de desarrollo"
    build_compiling "Compilando y empaquetando"
    build_complete "Construcción completada"
    build_failed "Construcción fallida"
    tests_running "Ejecutando pruebas"
    available_scripts "Scripts Disponibles"
    no_package_json "No se encontró package.json"
    specify_package "Por favor especifique un nombre de paquete"
    adding_package "Agregando paquete"
    removing_package "Eliminando paquete"
    checking_outdated "Verificando paquetes desactualizados"
    
    unlock_hint "para desbloquear"
    press_any_key "Presiona cualquier tecla para salir"
    locking_system "Bloqueando sistema"
    
    pomodoro "Temporizador Pomodoro"
    session "Sesión"
    duration "Duración"
    minutes "minutos"
    seconds "segundos"
    pomo_complete "Pomodoro completado"
    break_time "Hora de un descanso"
    timer_complete "Temporizador completado"
    quick_notes "Notas Rápidas"
    note "Nota"
    note_saved "Nota guardada"
    notes_cleared "Notas borradas"
    no_notes "Aún no hay notas. Agrega una con: note add <texto>"
    quote_of_day "Cita del Día"
    need_options "Por favor proporcione al menos 2 opciones"
    deciding "Déjame decidir"
    countdown "Cuenta regresiva"
    system_stats "Estadísticas del Sistema"
    generated_password "Contraseña generada"
    copied_clipboard "Copiado al portapapeles"
    password_generated "Contraseña generada"
    password_copied "Copiado al portapapeles"
    playing "Reproduciendo"
    paused "Pausado"
    now_playing "Reproduciendo ahora"
    not_playing "no está reproduciendo"
    calendar "Calendario"
    quick_cleanup "Limpieza Rápida"
    clearing_npm "Limpiando caché de npm"
    clearing_pnpm "Limpiando caché de pnpm"
    cache_cleared "Caché limpiado"
    removing_node "Eliminando node_modules"
    removing_ds "Eliminando archivos .DS_Store"
    files_removed "archivos eliminados"
    cleaning_git "Limpiando git"
    clear_cache "Limpiar caché npm/pnpm"
    remove_node "Eliminar node_modules"
    remove_ds "Eliminar archivos .DS_Store"
    clean_git "Limpiar git (gc + prune)"
    run_all "Ejecutar todo"
    searching_so "Buscando en Stack Overflow"
    searching_gh "Buscando en GitHub"
    focus_active "Modo Enfoque Activo"
    stay_focused "¡Mantente enfocado! Sin distracciones"
    
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
