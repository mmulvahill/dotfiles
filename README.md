# Dotfiles

Dot files management for Linux/macOS servers and containers.

## Quick Setup

### One-line Remote Install

To set up a new remote server with these dotfiles, use:

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/setup.sh | bash
```

### Local Install

To set up locally:

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git
cd dotfiles

# Run the setup script
./setup.sh
```

### Options

The setup script supports several options:

- `--minimal`: Install only the essential packages (ideal for servers)
- `--no-oh-my-zsh`: Skip Oh My Zsh installation

Example:
```bash
./setup.sh --minimal --no-oh-my-zsh
```

## What's Included

- **Shell**: zsh configuration with optional Oh My Zsh
- **Package Manager**: mise for managing programming languages
- **Editor**: Neovim configuration
- **Terminal Multiplexer**: tmux with plugin manager
- **Languages**: Configuration for Python, Node.js, and Lua

## Docker Support

Docker containers are available for testing:

- Ubuntu: `docker compose up -d dev-env-ubuntu`
- Amazon Linux: `docker compose up -d dev-env-amazon`

Connect to containers:
```bash
docker compose exec dev-env-ubuntu zsh
docker compose exec dev-env-amazon zsh
```
