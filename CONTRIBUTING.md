# Contributing to Terminup

```
    ████████╗██╗   ██╗██████╗ 
    ╚══██╔══╝██║   ██║██╔══██╗
       ██║   ██║   ██║██████╔╝
       ██║   ██║   ██║██╔═══╝ 
       ██║   ╚██████╔╝██║     
       ╚═╝    ╚═════╝ ╚═╝     
```

First off, thanks for taking the time to contribute!

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How Can I Contribute?](#how-can-i-contribute)
- [Style Guide](#style-guide)
- [Commit Messages](#commit-messages)

---

## Code of Conduct

Be nice. Be respectful. We're all here to make terminals better.

---

## Getting Started

### Prerequisites

- Zsh 5.1+
- Git
- A terminal that supports 256 colors

### Setup

```bash
# Fork and clone
git clone https://github.com/YOUR_USERNAME/terminup.git
cd terminup

# Create a feature branch
git checkout -b feature/amazing-feature

# Source for testing
source terminup.zsh
```

### Testing Changes

After making changes:

```bash
# Reload
terminup reload

# Or source directly
source terminup.zsh
```

Test in a fresh shell to catch any issues:

```bash
zsh -f
source terminup.zsh
```

---

## How Can I Contribute?

### Reporting Bugs

Before submitting a bug report:

1. Check if it's already reported
2. Check if it's a Zsh compatibility issue
3. Try with a minimal `.zshrc`

Include in your report:

```
- Zsh version: `echo $ZSH_VERSION`
- Terminal: iTerm2 / Terminal.app / Kitty / etc.
- OS: macOS / Linux / WSL
- Steps to reproduce
- Expected vs actual behavior
```

### Suggesting Features

Open an issue with:

- Clear description of the feature
- Use case / problem it solves
- Proposed implementation (if any)

### Pull Requests

1. Fork the repo
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit PR

PRs should:

- Focus on one feature/fix
- Include documentation updates
- Follow the style guide
- Pass shellcheck (if available)

---

## Style Guide

### File Structure

```
components/
├── feature-name.zsh    # One file per feature area
```

### Code Style

```zsh
# ╭──────────────────────────────────────────────────────────────╮
# │                   Section Header                              │
# ╰──────────────────────────────────────────────────────────────╯

# Use descriptive function names
my_function() {
    local variable="value"    # Local variables
    
    # Comments explain why, not what
    if [[ -n "$variable" ]]; then
        echo "Output"
    fi
}

# Aliases at the end of files
alias mf='my_function'
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Functions | snake_case | `git_push_animated` |
| Variables | UPPER_SNAKE | `TERMINUP_CONFIG` |
| Local vars | lower_snake | `local my_var` |
| Aliases | short lowercase | `gp`, `ll` |

### Colors

Use 256-color codes consistently:

```zsh
# Good
echo -e "\033[38;5;46mGreen text\033[0m"

# Use theme variables when available
echo -e "\033[38;5;${TERM_SUCCESS}mThemed text\033[0m"
```

### Output Format

```zsh
# Status messages
echo -e "  \033[38;5;46m✓\033[0m Success message"
echo -e "  \033[38;5;196m✗\033[0m Error message"
echo -e "  \033[38;5;226m⚠\033[0m Warning message"

# Headers
echo ""
echo -e "  \033[38;5;51m╭───────────────────────────────────────╮\033[0m"
echo -e "  \033[38;5;51m│\033[0m           Title Here                  \033[38;5;51m│\033[0m"
echo -e "  \033[38;5;51m╰───────────────────────────────────────╯\033[0m"
echo ""
```

---

## Adding Features

### Adding a New Theme

Edit `components/themes.zsh`:

```zsh
THEMES+=(
    my-theme   "183,189,245,148,223,210,102"
    #           │   │   │   │   │   │   └── muted
    #           │   │   │   │   │   └────── error
    #           │   │   │   │   └────────── warning
    #           │   │   │   └────────────── success
    #           │   │   └────────────────── accent
    #           │   └────────────────────── secondary
    #           └────────────────────────── primary
)
```

### Adding a New Command

1. Add function to appropriate component file
2. Update help in `terminup.zsh`
3. Update README.md
4. Add completion if applicable

### Adding a New Component

1. Create `components/your-feature.zsh`
2. Add source line to `terminup.zsh`
3. Document in README

---

## Commit Messages

Format:

```
type(scope): short description

Longer explanation if needed.

Fixes #123
```

Types:

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `perf`: Performance
- `test`: Tests
- `chore`: Maintenance

Examples:

```
feat(git): add animated rebase command
fix(startup): prevent double boot on nested shells
docs(readme): add FAQ section
style(themes): standardize color code format
```

---

## Questions?

Open an issue or discussion. We're happy to help!

---

```
╔═════════════════════════════════════════════════════════════╗
║                                                             ║
║   Thanks for contributing to making terminals better!       ║
║                                                             ║
╚═════════════════════════════════════════════════════════════╝
```
