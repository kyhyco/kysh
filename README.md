# kysh

`kysh` is a batteries included zsh experience.
A modular Zsh configuration with modern tooling and clean organization.

## Features

- **Modular design** - Organized into focused configuration files
- **Modern tooling** - Integrated with mise, fzf, and powerlevel10k
- **Git integration** - Enhanced git aliases and workflow
- **Syntax highlighting** - Real-time command syntax highlighting
- **History sharing** - Shared history across sessions

## Installation

Clone the repository with submodules:

```bash
git clone --recursive https://github.com/kyhyco/kysh ~/.config/kysh
```

Add to your `~/.zshrc`:

```bash
source ~/.config/kysh/kysh.zsh
```

Restart your shell or run:

```bash
exec zsh
```

Install additional external dependencies:

```bash
brew install fzf eza fd tree lazygit gh
gh extension install kyhyco/gh-fh
```

Run this command for `gu` alias:

```bash
git config --global alias.unadd reset HEAD
```

*Note:* Recommended to use either kitty terminal or nerdpatched fonts to display language icons in the prompt when using with `mise`.

## Updating

To update kysh to the latest version, run:

```bash
kysh-update
```

This will pull the latest changes and update all submodules. After updating, reload your shell with `sz`.

## Dependencies

### Git Submodules

- **powerlevel10k** - Fast and customizable prompt theme
- **zsh-syntax-highlighting** - zsh syntax highlighting
- **zsh-autosuggestions** - zsh autosuggestions

### External Tools

- **mise** - Runtime version manager
- **fzf** - Fuzzy finder for enhanced searching
- **eza** - `ls` replacement

## Features Detail

### Mise Integration

- Automatically displays active tool versions in prompt
- Only shows when `mise.toml` is present in directory tree
- Supports multiple language runtimes

### Git Aliases

Enhanced git workflow with aliases like:

- `g` - git
- `ga` - git add
- `gl` - git log
- And many more in `alias/alias-git.zsh`

### FZF Integration

Enhanced command-line experience with:

- Ctrl+R - Command history search
- Ctrl+T - File search (Ctrl+D after to switch to Directory search)
- Alt+C  - Directory navigation

## Structure

```
kysh/
├── external/                # Git submodules
│   ├── powerlevel10k/
│   ├── zsh-autosuggestions/
│   └── zsh-syntax-highlighting/
├── completions/             # Custom completions
├── kysh.zsh                 # Main entry point
├── settings.zsh             # Core settings
├── alias.zsh                # Alias definitions
└── secrets.zsh              # Local secrets (gitignored)
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with a clean zsh installation
5. Submit a pull request

## License

MIT License - see LICENSE file for details
