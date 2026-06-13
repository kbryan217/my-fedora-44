#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Updating system packages ==="
sudo dnf update -y

echo "=== Removing old or conflicting Docker packages ==="
sudo dnf remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

echo "=== Adding official Docker repository (DNF5 syntax) ==="
sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo

echo "=== Installing Docker CE, CLI, and Compose plugin ==="
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Starting and enabling Docker service ==="
sudo systemctl enable --now docker

echo "=== Creating docker group and adding current user ==="
# Create group if it doesn't exist
sudo groupadd -f docker
# Add the logged-in user to the docker group
sudo usermod -aG docker "$USER"

echo "=== Configuring firewall permissions for Docker containers ==="
# Allows Docker containers to communicate with the host and outer network properly under firewalld
sudo firewall-cmd --permanent --zone=trusted --add-interface=docker0
sudo firewall-cmd --reload

echo "========================================================="
echo " SETUP COMPLETE"
echo "========================================================="
echo " To apply the new group permissions without logging out,"
echo " execute the following command in your terminal now:"
echo ""
echo "     newgrp docker"
echo ""
echo " Alternatively, log out and log back into your desktop session."
echo " Try running 'docker compose up' or 'docker run hello-world' after!"
echo "========================================================="
