#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Verifying Fedora 44 Environment ==="
if [ ! -f /etc/fedora-release ] || ! grep -q "44" /etc/fedora-release; then
    echo "ERROR: This script is explicitly tailored for Fedora 44."
    exit 1
fi

echo "=== Adding szpak/system76 COPR Repository (DNF5 Syntax) ==="
# Uses the required DNF5 syntax for remote .repo files
sudo dnf config-manager addrepo --from-repofile=https://fedorainfracloud.org

echo "=== Updating Repository Metadata ==="
sudo dnf check-release-update -y || true

echo "=== Installing Popsicle (CLI & GTK Graphical Tools) ==="
sudo dnf install -y popsicle popsicle-gtk

echo "========================================================="
echo " INSTALLATION COMPLETE"
echo "========================================================="
echo " Popsicle has been successfully added to your system."
echo " You can now launch it by:"
echo " 1. Searching for 'Popsicle' in your Applications menu."
echo " 2. Typing 'popsicle-gtk' directly into your terminal."
echo "========================================================="
