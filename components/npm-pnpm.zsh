#!/usr/bin/env zsh
# ╭──────────────────────────────────────────────────────────────╮
# │                 📦 NPM/PNPM Enhancements                      │
# ╰──────────────────────────────────────────────────────────────╯

# ASCII Art for package operations
NPM_INSTALL_ART='
   ╭─────────────────────────────────────╮
   │  📦 INSTALLING PACKAGES             │
   ╰─────────────────────────────────────╯
'

NPM_DEV_ART='
   ╭─────────────────────────────────────╮
   │  🚀 STARTING DEVELOPMENT SERVER     │
   ╰─────────────────────────────────────╯
      
      ╔═══════════════════════════════╗
      ║   💻 Local Development Mode   ║
      ╚═══════════════════════════════╝
'

NPM_BUILD_ART='
   ╭─────────────────────────────────────╮
   │  🔨 BUILDING PROJECT                │
   ╰─────────────────────────────────────╯
'

NPM_TEST_ART='
   ╭─────────────────────────────────────╮
   │  🧪 RUNNING TESTS                   │
   ╰─────────────────────────────────────╯
'

# Animated install function for npm
ni() {
    local packages="$@"
    
    echo -e "\033[38;5;203m$NPM_INSTALL_ART\033[0m"
    
    if [[ -z "$packages" ]]; then
        echo -e "  \033[38;5;245m$(_t npm_install_deps "Installing dependencies from package.json")...\033[0m"
    else
        echo -e "  \033[38;5;245m$(_t installing "Installing"):\033[0m $packages"
    fi
    echo ""
    
    # Animated progress
    local frames=("📦    " "📦📦   " "📦📦📦  " "📦📦📦📦 " "📦📦📦📦📦" "✨📦📦📦📦" "✨✨📦📦📦" "✨✨✨📦📦" "✨✨✨✨📦" "✨✨✨✨✨")
    
    npm install $packages 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r  %s $(_t installing "Installing")..." "${frames[$((i % 10))]}"
        sleep 0.2
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓ $(_t install_complete "Installation complete")!\033[0m ✨✨✨✨✨\033[K"
        echo ""
        
        # Show celebration
        for i in {1..3}; do
            printf "\r  🎉 $(_t npm_success "Packages installed successfully")! 🎉"
            sleep 0.1
            printf "\r  ✨ $(_t npm_success "Packages installed successfully")! ✨"
            sleep 0.1
        done
        printf "\r  🎉 $(_t npm_success "Packages installed successfully")! 🎉\033[K\n"
    else
        echo -e "\r  \033[38;5;196m✗ $(_t install_failed "Installation failed")\033[0m\033[K"
    fi
    echo ""
    
    return $exit_code
}

# Animated install function for pnpm
pi() {
    local packages="$@"
    
    echo -e "\033[38;5;208m$NPM_INSTALL_ART\033[0m"
    
    if [[ -z "$packages" ]]; then
        echo -e "  \033[38;5;245m$(_t npm_install_deps "Installing dependencies from package.json")...\033[0m"
    else
        echo -e "  \033[38;5;245m$(_t installing "Installing"):\033[0m $packages"
    fi
    echo ""
    
    # Animated progress with pnpm style
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local colors=(208 209 210 211 212 213 214 215 216 217)
    
    pnpm install $packages 2>&1 &
    local pid=$!
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        local color=${colors[$((i % 10))]}
        printf "\r  \033[38;5;${color}m%s\033[0m $(_t installing "Installing")..." "${frames[$((i % 10))]}"
        sleep 0.1
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓ pnpm $(_t install_complete "install complete")!\033[0m 🚀\033[K"
        echo ""
        
        # Progress bar completion animation
        for i in {1..40}; do
            local filled=""
            for ((j=0; j<i; j++)); do filled+="█"; done
            for ((j=i; j<40; j++)); do filled+="░"; done
            printf "\r  \033[38;5;208m▐%s▌\033[0m %3d%%" "$filled" "$((i * 100 / 40))"
            sleep 0.02
        done
        echo " ✨"
    else
        echo -e "\r  \033[38;5;196m✗ pnpm $(_t install_failed "install failed")\033[0m\033[K"
    fi
    echo ""
    
    return $exit_code
}

# Dev server with cool startup animation
dev() {
    local runner="${1:-}"
    
    echo -e "\033[38;5;46m$NPM_DEV_ART\033[0m"
    
    # Startup animation
    local rocket_frames=(
        "       🚀"
        "      🚀 "
        "     🚀  "
        "    🚀   "
        "   🚀    "
        "  🚀     "
        " 🚀      "
        "🚀       "
        "🚀💨     "
        "🚀💨💨   "
        "🚀💨💨💨 "
    )
    
    for frame in "${rocket_frames[@]}"; do
        printf "\r  %s" "$frame"
        sleep 0.08
    done
    echo ""
    echo ""
    
    echo -e "  \033[38;5;245m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "  \033[38;5;46m▶ $(_t dev_starting "Starting development server")...\033[0m"
    echo -e "  \033[38;5;245m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    
    # Detect package manager and run
    if [[ -f "pnpm-lock.yaml" ]]; then
        echo -e "  \033[38;5;208m📦 $(_t using "Using") pnpm\033[0m"
        echo ""
        pnpm run dev
    elif [[ -f "yarn.lock" ]]; then
        echo -e "  \033[38;5;39m📦 $(_t using "Using") yarn\033[0m"
        echo ""
        yarn dev
    else
        echo -e "  \033[38;5;203m📦 $(_t using "Using") npm\033[0m"
        echo ""
        npm run dev
    fi
}

# Build with progress animation
build() {
    echo -e "\033[38;5;226m$NPM_BUILD_ART\033[0m"
    
    # Build animation
    local tools=("🔧" "🔨" "⚙️" "🛠️" "⚡")
    
    echo -e "  \033[38;5;245m$(_t build_compiling "Compiling and bundling")...\033[0m"
    echo ""
    
    # Detect package manager
    local cmd="npm run build"
    [[ -f "pnpm-lock.yaml" ]] && cmd="pnpm run build"
    [[ -f "yarn.lock" ]] && cmd="yarn build"
    
    eval "$cmd" 2>&1 &
    local pid=$!
    local i=0
    local start_time=$(date +%s)
    
    while kill -0 $pid 2>/dev/null; do
        local elapsed=$(($(date +%s) - start_time))
        printf "\r  %s $(_t building "Building")... [%02d:%02d]" "${tools[$((i % 5))]}" "$((elapsed / 60))" "$((elapsed % 60))"
        sleep 0.2
        ((i++))
    done
    
    wait $pid
    local exit_code=$?
    local total_time=$(($(date +%s) - start_time))
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\r  \033[38;5;46m✓ $(_t build_complete "Build complete")!\033[0m (${total_time}s) ⚡\033[K"
        echo ""
        
        # Check for dist folder and show size
        if [[ -d "dist" ]]; then
            local size=$(du -sh dist 2>/dev/null | cut -f1)
            echo -e "  \033[38;5;245m📤 Output:\033[0m dist/ ($size)"
        elif [[ -d "build" ]]; then
            local size=$(du -sh build 2>/dev/null | cut -f1)
            echo -e "  \033[38;5;245m📤 Output:\033[0m build/ ($size)"
        fi
    else
        echo -e "\r  \033[38;5;196m✗ $(_t build_failed "Build failed")\033[0m\033[K"
    fi
    echo ""
    
    return $exit_code
}

# Test runner with animation
# Named 'nt' (npm test) to avoid overriding the shell built-in 'test' command
nt() {
    echo -e "\033[38;5;141m$NPM_TEST_ART\033[0m"
    
    # Detect package manager
    local cmd="npm test"
    [[ -f "pnpm-lock.yaml" ]] && cmd="pnpm test"
    [[ -f "yarn.lock" ]] && cmd="yarn test"
    
    echo -e "  \033[38;5;141m🧪 $(_t tests_running "Running tests")...\033[0m"
    echo ""
    
    eval "$cmd"
}
alias ntest='nt'

# Quick scripts
alias nr='npm run'
alias pr='pnpm run'

# List available scripts
scripts() {
    echo ""
    echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
    echo -e "  \033[38;5;51m│\033[0m         \033[1m📜 $(_t available_scripts "Available Scripts")\033[0m           \033[38;5;51m│\033[0m"
    echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
    echo ""
    
    if [[ -f "package.json" ]]; then
        # Parse and display scripts
        node -e "
            const pkg = require('./package.json');
            const scripts = pkg.scripts || {};
            Object.entries(scripts).forEach(([name, cmd]) => {
                console.log('    ▶ \x1b[38;5;51m' + name.padEnd(20) + '\x1b[0m \x1b[38;5;245m' + cmd.substring(0, 40) + (cmd.length > 40 ? '...' : '') + '\x1b[0m');
            });
        " 2>/dev/null || echo -e "  \033[38;5;196m✗ $(_t no_package_json "Could not read package.json")\033[0m"
    else
        echo -e "  \033[38;5;196m✗ $(_t no_package_json "No package.json found")\033[0m"
    fi
    echo ""
}

# Quick add dependency
add() {
    local pkg="$1"
    local flags="${@:2}"
    
    if [[ -z "$pkg" ]]; then
        echo -e "  \033[38;5;196m✗ $(_t specify_package "Please specify a package name")\033[0m"
        return 1
    fi
    
    echo -e "\n  \033[38;5;51m📦 $(_t adding_package "Adding package"):\033[0m $pkg $flags"
    
    if [[ -f "pnpm-lock.yaml" ]]; then
        pnpm add $pkg $flags
    elif [[ -f "yarn.lock" ]]; then
        yarn add $pkg $flags
    else
        npm install $pkg $flags
    fi
}

# Add dev dependency
add-dev() {
    add "$1" -D
}

# Remove dependency
remove() {
    local pkg="$1"
    
    if [[ -z "$pkg" ]]; then
        echo -e "  \033[38;5;196m✗ $(_t specify_package "Please specify a package name")\033[0m"
        return 1
    fi
    
    echo -e "\n  \033[38;5;196m🗑️ $(_t removing_package "Removing package"):\033[0m $pkg"
    
    if [[ -f "pnpm-lock.yaml" ]]; then
        pnpm remove $pkg
    elif [[ -f "yarn.lock" ]]; then
        yarn remove $pkg
    else
        npm uninstall $pkg
    fi
}

# Outdated packages check
outdated() {
    echo ""
    echo -e "  \033[38;5;51m📦 $(_t checking_outdated "Checking for outdated packages")...\033[0m"
    echo ""
    
    if [[ -f "pnpm-lock.yaml" ]]; then
        pnpm outdated
    elif [[ -f "yarn.lock" ]]; then
        yarn outdated
    else
        npm outdated
    fi
}
