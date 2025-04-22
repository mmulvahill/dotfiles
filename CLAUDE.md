# Development Environment Guide

## Build Commands
- `docker compose build dev-env-ubuntu` - Build Ubuntu development container
- `docker compose build dev-env-amazon` - Build Amazon Linux 2 container
- `docker compose up -d dev-env-ubuntu` - Start Ubuntu container in detached mode
- Aliases: `ub-build` (Ubuntu), `al2-build` (Amazon Linux)

## Container Usage
- `ub` - Run Ubuntu container with AWS credentials mounted
- `al2` - Run Amazon Linux container with AWS credentials mounted

## Development Environments
- Uses mise (https://mise.jdx.dev) for language management
- Configured languages: Python, Node.js, R (see mise/config.toml)
- R packages include data science, ML, and development libraries

## Shell & Editor Conventions
- zsh is the default shell
- tmux uses vi mode for navigation
- Neovim as the primary editor
- Uses 2-space indentation

## Code Style Guidelines  
- For R: Follows lintr defaults
- Python: Format with standard library conventions
- Shell scripts: Commented section headers with descriptive aliases
- Configuration files: Organized by functionality with clear comments

## File Organization
- All dotfiles stored in dotfiles/ directory
- Docker configurations in docker/ directory
- Config files organized in .config/ subdirectories