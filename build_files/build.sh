#!/bin/bash

set -ouex pipefail

# Get full absolute directory of the current script
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

# Specify the path to packages.list
PACKAGES_LIST="$SCRIPT_DIR/build_files/packages.list"

# Check if the file exists before reading
if [[ ! -f "$PACKAGES_LIST" ]]; then
  echo "Error: packages.list not found at $PACKAGES_LIST"
  exit 1
fi

# Read packages from the file
PACKAGES=$(cat "$PACKAGES_LIST")

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf5 install -y tmux

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

# Install the propietary NVIDIA drivers:
dnf5 install -y $PACKAGES

#### Example for enabling a System Unit File
systemctl enable podman.socket


