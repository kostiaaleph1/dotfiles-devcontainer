#!/bin/bash

# Exit on error
set -e

echo "Starting Neovim installation and configuration..."

# Install required packages
sudo apt-get update
sudo apt-get install -y \
    git \
    curl \
    unzip \
    ninja-build \
    gettext \
    cmake \
    python3-pip \
    ripgrep \
    fd-find \
    sqlite3 \
    libsqlite3-dev \
    lua5.3 \
    luarocks \
    fzf

# Install latest neovim from source
echo "Installing Neovim from source..."
sudo apt install -y nvim

# Create necessary directories
echo "Creating Neovim configuration directories..."
NVIM_CONFIG_DIR="/home/vscode/.config/nvim"
mkdir -p "$NVIM_CONFIG_DIR"

export XDG_CONFIG_HOME="$NVIM_CONFIG_DIR"

# Clone your Neovim configuration
echo "Cloning your Neovim configuration..."
git clone https://github.com/kostiaLelikov1/nvim.git "$NVIM_CONFIG_DIR"

# Set correct permissions
sudo chown -R vscode:vscode "$NVIM_CONFIG_DIR"
sudo chown -R vscode:vscode /home/vscode/.local/share/nvim

# Set up executable links
sudo ln -sf $(which fdfind) /usr/local/bin/fd

# Install additional dependencies for plugins
echo "Installing additional plugin dependencies..."
sudo apt-get install -y gcc make

echo "Installation complete! You can now start Neovim."

# Set ownership of all created files to vscode user
sudo chown -R vscode:vscode /home/vscode/.local
sudo chown -R vscode:vscode /home/vscode/.config
