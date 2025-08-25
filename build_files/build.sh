#!/bin/bash

set -ouex pipefail

# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

# Enable RPM Fusion repos:
dnf5 install -y \
	https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
	https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
	
# Enable Negativo17 repo for Samsung ULD Drivers:
dnf5 config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-uld.repo --save-filename=negativo17-uld.repo

# Import Insync GPG key and add its repository:
rpm --import https://d2t3ff60b2tol4.cloudfront.net/repomd.xml.key && echo -e "[insync]\nname=insync repo\nbaseurl=http://yum.insync.io/fedora/\$releasever/\ngpgcheck=1\ngpgkey=https://d2t3ff60b2tol4.cloudfront.net/repomd.xml.key\nenabled=1\nmetadata_expire=120m" | sudo tee /etc/yum.repos.d/insync.repo > /dev/null

# Import COPR repos:
dnf5 copr enable -y \
	lukenukem/asus-linux 

# Install packages:  
dnf5 install -y \
	akmod-nvidia \
	xorg-x11-drv-nvidia-cuda \
	uld \
	insync \
	intel-undervolt \
	steam-devices \
	papirus-icon-theme

#### Example for enabling a System Unit File
systemctl enable podman.socket
systemctl enable intel-undervolt


