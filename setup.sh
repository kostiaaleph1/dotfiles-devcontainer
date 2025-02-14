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
    lua5.3-dev \
    liblua5.3-dev \
    luarocks \
    fzf

# Install latest neovim from source
sudo apt install -y neovim
# Create necessary directories
echo "Creating Neovim configuration directories..."
NVIM_CONFIG_DIR="/home/vscode/.config/nvim"
NVIM_DATA_DIR="/home/vscode/.local/share/nvim"

mkdir -p "$NVIM_CONFIG_DIR"
mkdir -p "$NVIM_DATA_DIR"

# Clone your Neovim configuration
echo "Cloning your Neovim configuration..."
git clone https://github.com/kostiaLelikov1/nvim.git /tmp/nvim-config

# Copy configuration files to the correct locations
cp -r /tmp/nvim-config/* "$NVIM_CONFIG_DIR/"
rm -rf /tmp/nvim-config

# Set correct permissions
sudo chown -R vscode:vscode /home/vscode/.local
sudo chown -R vscode:vscode /home/vscode/.config

# Install Python packages
pip3 install pynvim

# Set up executable links
sudo ln -sf $(which fdfind) /usr/local/bin/fd

# Install additional dependencies for plugins
echo "Installing additional plugin dependencies..."
sudo apt-get install -y gcc make

# Ensure Lua is properly set up for Neovim
luarocks install luasocket

# Create a minimal init.lua to verify Lua loading
echo "Installation complete! You can now start Neovim."
