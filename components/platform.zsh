#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │              🌍 Cross-Platform Compatibility                  │
# ╰──────────────────────────────────────────────────────────────╯

# ─────────────────────────────────────────────────────────────────
# Platform Detection
# ─────────────────────────────────────────────────────────────────

# Detect operating system
_detect_os() {
    case "$(uname -s)" in
        Darwin*)  echo "macos" ;;
        Linux*)
            if grep -q Microsoft /proc/version 2>/dev/null; then
                echo "wsl"
            elif [[ -f /etc/arch-release ]]; then
                echo "arch"
            elif [[ -f /etc/debian_version ]]; then
                echo "debian"  # Includes Ubuntu
            elif [[ -f /etc/fedora-release ]]; then
                echo "fedora"
            elif [[ -f /etc/redhat-release ]]; then
                echo "redhat"
            else
                echo "linux"
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "windows"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Set global OS variable
export TERMINUP_OS=$(_detect_os)

# ─────────────────────────────────────────────────────────────────
# Cross-Platform Commands
# ─────────────────────────────────────────────────────────────────

# Open URL or file with default application
_open() {
    case "$TERMINUP_OS" in
        macos)
            open "$@"
            ;;
        wsl)
            wslview "$@" 2>/dev/null || explorer.exe "$@"
            ;;
        windows)
            start "$@"
            ;;
        *)  # Linux
            xdg-open "$@" 2>/dev/null || \
            gnome-open "$@" 2>/dev/null || \
            kde-open "$@" 2>/dev/null || \
            echo "Cannot open: $*"
            ;;
    esac
}

# Copy to clipboard
_copy() {
    case "$TERMINUP_OS" in
        macos)
            pbcopy
            ;;
        wsl|windows)
            clip.exe
            ;;
        *)  # Linux
            if command -v xclip &>/dev/null; then
                xclip -selection clipboard
            elif command -v xsel &>/dev/null; then
                xsel --clipboard --input
            elif command -v wl-copy &>/dev/null; then
                wl-copy
            else
                echo "Install xclip, xsel, or wl-copy for clipboard support"
                return 1
            fi
            ;;
    esac
}

# Paste from clipboard
_paste() {
    case "$TERMINUP_OS" in
        macos)
            pbpaste
            ;;
        wsl|windows)
            powershell.exe -command "Get-Clipboard"
            ;;
        *)  # Linux
            if command -v xclip &>/dev/null; then
                xclip -selection clipboard -o
            elif command -v xsel &>/dev/null; then
                xsel --clipboard --output
            elif command -v wl-paste &>/dev/null; then
                wl-paste
            else
                echo "Install xclip, xsel, or wl-paste for clipboard support"
                return 1
            fi
            ;;
    esac
}

# Send system notification
_notify() {
    local title="$1"
    local message="$2"
    
    case "$TERMINUP_OS" in
        macos)
            osascript -e "display notification \"$message\" with title \"$title\"" 2>/dev/null
            ;;
        wsl|windows)
            powershell.exe -command "[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null; \$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02); \$template.GetElementsByTagName('text')[0].AppendChild(\$template.CreateTextNode('$title')); \$template.GetElementsByTagName('text')[1].AppendChild(\$template.CreateTextNode('$message')); [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Terminup').Show([Windows.UI.Notifications.ToastNotification]::new(\$template))" 2>/dev/null || \
            echo "📢 $title: $message"
            ;;
        *)  # Linux
            if command -v notify-send &>/dev/null; then
                notify-send "$title" "$message"
            else
                echo "📢 $title: $message"
            fi
            ;;
    esac
}

# Lock screen
_lock_screen() {
    case "$TERMINUP_OS" in
        macos)
            osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}' 2>/dev/null
            ;;
        wsl|windows)
            rundll32.exe user32.dll,LockWorkStation
            ;;
        arch|debian|fedora|redhat|linux)
            if command -v loginctl &>/dev/null; then
                loginctl lock-session
            elif command -v gnome-screensaver-command &>/dev/null; then
                gnome-screensaver-command -l
            elif command -v xdg-screensaver &>/dev/null; then
                xdg-screensaver lock
            elif command -v i3lock &>/dev/null; then
                i3lock
            else
                echo "No screen locker found. Install loginctl, gnome-screensaver, or i3lock"
            fi
            ;;
    esac
}

# Get battery percentage
_battery() {
    case "$TERMINUP_OS" in
        macos)
            pmset -g batt | grep -o '[0-9]*%' | head -1
            ;;
        wsl|windows)
            powershell.exe -command "(Get-WmiObject Win32_Battery).EstimatedChargeRemaining" 2>/dev/null | tr -d '\r'
            ;;
        *)  # Linux
            if [[ -f /sys/class/power_supply/BAT0/capacity ]]; then
                cat /sys/class/power_supply/BAT0/capacity
            elif [[ -f /sys/class/power_supply/BAT1/capacity ]]; then
                cat /sys/class/power_supply/BAT1/capacity
            elif command -v acpi &>/dev/null; then
                acpi -b | grep -o '[0-9]*%'
            else
                echo "N/A"
            fi
            ;;
    esac
}

# Package manager install
_pkg_install() {
    local pkg="$1"
    
    case "$TERMINUP_OS" in
        macos)
            if command -v brew &>/dev/null; then
                brew install "$pkg"
            else
                echo "Install Homebrew first: https://brew.sh"
            fi
            ;;
        arch)
            if command -v yay &>/dev/null; then
                yay -S "$pkg"
            elif command -v paru &>/dev/null; then
                paru -S "$pkg"
            else
                sudo pacman -S "$pkg"
            fi
            ;;
        debian)
            sudo apt install -y "$pkg"
            ;;
        fedora)
            sudo dnf install -y "$pkg"
            ;;
        redhat)
            sudo yum install -y "$pkg"
            ;;
        wsl)
            # Detect WSL distro
            if command -v apt &>/dev/null; then
                sudo apt install -y "$pkg"
            elif command -v pacman &>/dev/null; then
                sudo pacman -S "$pkg"
            fi
            ;;
        *)
            echo "Unknown package manager for $TERMINUP_OS"
            ;;
    esac
}

# ─────────────────────────────────────────────────────────────────
# Platform-specific Fixes
# ─────────────────────────────────────────────────────────────────

# Fix for Windows/WSL path handling
if [[ "$TERMINUP_OS" == "wsl" ]]; then
    # Convert Windows paths to WSL paths
    _winpath() {
        wslpath "$1" 2>/dev/null || echo "$1"
    }
fi

# Linux-specific: Check if running in a graphical environment
_has_display() {
    [[ -n "$DISPLAY" ]] || [[ -n "$WAYLAND_DISPLAY" ]] || [[ "$TERMINUP_OS" == "macos" ]]
}

# ─────────────────────────────────────────────────────────────────
# Platform Info
# ─────────────────────────────────────────────────────────────────

platform() {
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m         \033[1m🌍 Platform Info\033[0m              \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    echo -e "    \033[38;5;39mOS:\033[0m $TERMINUP_OS"
    echo -e "    \033[38;5;39mKernel:\033[0m $(uname -r)"
    echo -e "    \033[38;5;39mShell:\033[0m $SHELL"
    echo -e "    \033[38;5;39mTerminal:\033[0m ${TERM_PROGRAM:-$TERM}"
    
    local battery=$(_battery)
    [[ -n "$battery" && "$battery" != "N/A" ]] && echo -e "    \033[38;5;39mBattery:\033[0m ${battery}%"
    
    echo ""
}
