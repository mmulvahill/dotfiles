#!/bin/bash

# ====================================================================
# Simple Development Environment Setup Script
# ====================================================================
# This script sets up a development environment with:
# - Base packages (git, curl, zsh, tmux, etc.)
# - Dotfiles configuration
# - mise (language version manager)
# - Tools for development (neovim/vim)
# - oh-my-zsh (optional)
# 
# Usage: 
#   bash setup.sh [--no-oh-my-zsh] [--minimal]
#
# Options:
#   --no-oh-my-zsh  Skip oh-my-zsh installation
#   --minimal       Install minimal packages (useful for servers)
# ====================================================================

set -e  # Exit immediately if a command exits with non-zero status
set -u  # Treat unset variables as an error

# ====================================================================
# CONFIGURATION
# ====================================================================

# Variables
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/dotfiles"
USER_HOME="$HOME"
INSTALL_OH_MY_ZSH=true
MINIMAL_INSTALL=false

# Platform detection
PLATFORM="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" == "ubuntu" || "$ID_LIKE" == *"ubuntu"* ]]; then
            PLATFORM="ubuntu"
        elif [[ "$ID" == "amzn" ]]; then
            PLATFORM="amazon-linux"
        fi
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
fi

# Parse command line arguments
for arg in "$@"; do
    case $arg in
        --no-oh-my-zsh)
            INSTALL_OH_MY_ZSH=false
            shift
            ;;
        --minimal)
            MINIMAL_INSTALL=true
            shift
            ;;
    esac
done

# ====================================================================
# HELPER FUNCTIONS
# ====================================================================

# Print colored messages
print_message() {
    GREEN='\033[0;32m'
    NC='\033[0m' # No Color
    echo -e "${GREEN}>>> $1${NC}"
}

print_error() {
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    echo -e "${RED}ERROR: $1${NC}" >&2
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Create directory if it doesn't exist
ensure_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
    fi
}

# Create symbolic link if it doesn't exist
create_symlink() {
    local source="$1"
    local target="$2"
    local backup_dir="$USER_HOME/.dotfiles.backup/$(date +%Y%m%d%H%M%S)"
    
    # Create backup directory if needed
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        ensure_dir "$backup_dir"
        print_message "Backing up existing $target to $backup_dir/$(basename "$target")"
        mv "$target" "$backup_dir/$(basename "$target")"
    elif [ -L "$target" ]; then
        # Remove existing symlink
        rm "$target"
    fi
    
    # Create parent directory if needed
    ensure_dir "$(dirname "$target")"
    
    # Create symlink
    ln -sf "$source" "$target"
    print_message "Created symlink: $target -> $source"
}

# ====================================================================
# PLATFORM-SPECIFIC SETUP
# ====================================================================

setup_ubuntu() {
    print_message "Setting up Ubuntu system..."
    
    # Update package lists
    sudo apt-get update
    
    # Install dependencies
    if [ "$MINIMAL_INSTALL" = true ]; then
        print_message "Installing minimal packages..."
        sudo apt-get install -y git curl wget zsh unzip build-essential
    else
        print_message "Installing full development packages..."
        sudo apt-get install -y \
            sudo \
            git \
            curl \
            wget \
            zsh \
            tmux \
            build-essential \
            locales \
            tzdata \
            software-properties-common \
            ca-certificates \
            libreadline-dev \
            libncurses-dev \
            unzip
        
        # Install Neovim
        sudo add-apt-repository -y ppa:neovim-ppa/stable
        sudo apt-get update
        sudo apt-get install -y neovim
    fi
    
    # Generate locale
    sudo locale-gen en_US.UTF-8
}

setup_amazon_linux() {
    print_message "Setting up Amazon Linux system..."
    
    # Update package lists
    sudo yum update -y
    
    # Install dependencies
    if [ "$MINIMAL_INSTALL" = true ]; then
        print_message "Installing minimal packages..."
        sudo yum install -y git curl wget zsh unzip make gcc
    else
        print_message "Installing full development packages..."
        sudo yum install -y \
            sudo \
            git \
            curl \
            wget \
            zsh \
            tmux \
            tar \
            gzip \
            make \
            gcc \
            openssl-devel \
            bzip2-devel \
            libffi-devel \
            xz-devel \
            ca-certificates \
            readline-devel \
            ncurses-devel \
            unzip
        
        # Install EPEL and Vim
        sudo amazon-linux-extras install -y epel
        sudo yum install -y vim
    fi
}

setup_macos() {
    print_message "Setting up macOS system..."
    
    # Check if Homebrew is installed
    if ! command_exists brew; then
        print_message "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        print_message "Homebrew already installed, updating..."
        brew update
    fi
    
    # Install dependencies using Homebrew
    if [ "$MINIMAL_INSTALL" = true ]; then
        print_message "Installing minimal packages..."
        brew install git curl wget zsh
    else
        print_message "Installing full development packages..."
        brew install \
            git \
            curl \
            wget \
            zsh \
            tmux \
            neovim \
            readline \
            ncurses
    fi
}

# ====================================================================
# INSTALL MISE (LANGUAGE VERSION MANAGER)
# ====================================================================

install_mise() {
    print_message "Installing mise language version manager..."
    
    if ! command_exists mise; then
        curl -fsSL https://mise.jdx.dev/install.sh | bash
    else
        print_message "mise already installed."
    fi
}

# ====================================================================
# INSTALL OH-MY-ZSH (OPTIONAL)
# ====================================================================

install_oh_my_zsh() {
    if [ "$INSTALL_OH_MY_ZSH" = true ]; then
        print_message "Installing Oh My Zsh..."
        
        if [ ! -d "$USER_HOME/.oh-my-zsh" ]; then
            # Install Oh My Zsh
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        else
            print_message "Oh My Zsh already installed."
        fi
    else
        print_message "Skipping Oh My Zsh installation."
    fi
}

# ====================================================================
# SETUP TMUX PLUGIN MANAGER
# ====================================================================

setup_tmux_plugin_manager() {
    if ! [ "$MINIMAL_INSTALL" = true ]; then
        print_message "Setting up Tmux Plugin Manager..."
        
        if [ ! -d "$USER_HOME/.tmux/plugins/tpm" ]; then
            git clone https://github.com/tmux-plugins/tpm "$USER_HOME/.tmux/plugins/tpm"
        else
            print_message "Tmux Plugin Manager already installed."
        fi
    fi
}

# ====================================================================
# COPY DOTFILES
# ====================================================================

setup_dotfiles() {
    print_message "Setting up dotfiles..."
    
    # Create necessary directories
    ensure_dir "$USER_HOME/.config/shell"
    ensure_dir "$USER_HOME/.config/mise"
    
    # Create symlinks for dotfiles
    create_symlink "$DOTFILES_DIR/.zshrc" "$USER_HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/.tmux.conf" "$USER_HOME/.tmux.conf"
    create_symlink "$DOTFILES_DIR/.gitconfig" "$USER_HOME/.gitconfig"
    create_symlink "$DOTFILES_DIR/.git-prompt.sh" "$USER_HOME/.git-prompt.sh"
    
    # Language-specific config
    create_symlink "$DOTFILES_DIR/.Rprofile" "$USER_HOME/.Rprofile"
    create_symlink "$DOTFILES_DIR/.lintr" "$USER_HOME/.lintr"
    
    # Config directories
    create_symlink "$DOTFILES_DIR/.config/init.lua" "$USER_HOME/.config/init.lua"
    create_symlink "$DOTFILES_DIR/.config/shell/aliases.sh" "$USER_HOME/.config/shell/aliases.sh"
    create_symlink "$DOTFILES_DIR/.config/mise/config.toml" "$USER_HOME/.config/mise/config.toml"
}

# ====================================================================
# FINALIZE SETUP
# ====================================================================

finalize_setup() {
    print_message "Finalizing setup..."
    
    # Add mise to shell initialization
    if ! grep -q "mise activate" "$USER_HOME/.zshrc"; then
        echo 'eval "$(~/.local/bin/mise activate zsh)"' >> "$USER_HOME/.zshrc"
    fi
    
    # Change default shell to zsh if it's not already
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_message "Changing default shell to zsh..."
        chsh -s "$(which zsh)" || print_message "Could not change shell. Please run: chsh -s $(which zsh)"
    fi
    
    print_message "Setup complete! Please restart your shell or run 'source ~/.zshrc'"
    print_message "To install configured languages, run: mise install"
}

# ====================================================================
# MAIN SCRIPT
# ====================================================================

main() {
    print_message "Starting development environment setup on $PLATFORM..."
    
    case "$PLATFORM" in
        ubuntu)
            setup_ubuntu
            ;;
        amazon-linux)
            setup_amazon_linux
            ;;
        macos)
            setup_macos
            ;;
        *)
            print_error "Unsupported platform: $PLATFORM"
            exit 1
            ;;
    esac
    
    install_mise
    install_oh_my_zsh
    setup_tmux_plugin_manager
    setup_dotfiles
    finalize_setup
}

# Run the main function
main