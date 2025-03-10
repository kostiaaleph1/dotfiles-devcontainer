#!/bin/sh
set -e

echo "Activating feature 'neovim'"

VERSION=${VERSION:-stable}
echo "The version to be installed is: $VERSION"

# Debian / Ubuntu dependencies
install_debian_dependencies() {
  apt-get update -y
  apt-get -y install ninja-build gettext cmake unzip curl build-essential

  apt-get -y clean
  rm -rf /var/lib/apt/lists/*
}

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

ADJUSTED_VERSION=$VERSION

if [  "$VERSION" != "stable" ] && [  "$VERSION" != "nightly" ]; then
    ADJUSTED_VERSION="v$VERSION"
fi

# Bring in ID, ID_LIKE, VERSION_ID, VERSION_CODENAME
. /etc/os-release
# Get an adjusted ID independent of distro variants
if [ "${ID}" = "debian" ] || [ "${ID_LIKE}" = "debian" ]; then
    ADJUSTED_ID="debian"
else
    echo "Linux distro ${ID} not supported."
    exit 1
fi

# Install packages for appropriate OS
case "${ADJUSTED_ID}" in
    "debian")
        install_debian_dependencies
        ;;
esac

echo "Downloading source for ${ADJUSTED_VERSION}..."

curl -sL https://github.com/neovim/neovim/archive/refs/tags/${ADJUSTED_VERSION}.tar.gz | tar -xzC /tmp 2>&1

echo "Building..."

cd /tmp/neovim-${ADJUSTED_VERSION}

make && make CMAKE_INSTALL_PREFIX=/usr/local/nvim install
ln -sf /usr/local/nvim/bin/nvim /usr/local/bin/nvim

rm -rf /tmp/neovim-${ADJUSTED_VERSION}

ROOT_CONFIG_DIR=/root/.config/nvim/
NVIM_DATA_DIR=/root/.local/share/nvim

mkdir -p $ROOT_CONFIG_DIR
mkdir -p $NVIM_DATA_DIR

cd /root

git clone https://github.com/kostiaLelikov1/nvim ${ROOT_CONFIG_DIR}

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install

curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
yes | dpkg -i ripgrep_14.1.0-1_amd64.deb
