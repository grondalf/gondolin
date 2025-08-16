#!/bin/bash

$PACKAGES = \
  akmod-nvidia \
  xorg-x11-drv-nvidia-cuda \
  xorg-x11-drv-nvidia \
  xorg-x11-drv-nvidia-libs.i686 \
  mokutil

set -ouex pipefail

### Install NVIDIA drivers using RPM Fusion

dnf5 install -y $PACKAGES

# The uBlue build environment already includes the uBlue MOK key:
# /etc/pki/akmods/certs/akmods-ublue.der (public key)
# The modules will be signed automatically with the matching uBlue private key

# Add a helper script or instruction so users can enroll the uBlue MOK key if Secure Boot is enabled:
cat << 'EOF' > /etc/profile.d/enroll-mok.sh
if command -v mokutil &>/dev/null; then
    if mokutil --sb-state | grep -iq enabled; then
        echo "Secure Boot is enabled."
        echo "If NVIDIA drivers fail to load, enroll the uBlue MOK key:"
        echo "sudo mokutil --import /etc/pki/akmods/certs/akmods-ublue.der"
        echo "Then reboot and follow on-screen instructions to complete enrollment."
    fi
fi
EOF

chmod +x /etc/profile.d/enroll-mok.sh

# Enable podman socket as example (optional)
# systemctl enable podman.socket
