#!/usr/bin/env bash

set -euo pipefail

# Fedora 44 multimedia codec setup
# Installs RPM Fusion Free, full FFmpeg, and common GStreamer codecs.

if [[ $EUID -eq 0 ]]; then
    SUDO=""
else
    SUDO="sudo"
fi

echo "=============================================="
echo " Fedora Multimedia / FFmpeg Setup"
echo "=============================================="
echo

# Verify Fedora
if [[ ! -f /etc/fedora-release ]]; then
    echo "ERROR: This does not appear to be a Fedora system."
    exit 1
fi

FEDORA_VERSION="$(rpm -E %fedora)"

echo "Detected Fedora version: $FEDORA_VERSION"

if [[ "$FEDORA_VERSION" != "44" ]]; then
    echo "WARNING: This script was written for Fedora 44."
    echo "Your system reports Fedora $FEDORA_VERSION."
    echo
    read -r -p "Continue anyway? [y/N] " answer
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

echo
echo "==> Installing RPM Fusion Free..."
$SUDO dnf install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm"

echo
echo "==> Refreshing package metadata..."
$SUDO dnf makecache

echo
echo "==> Replacing Fedora's restricted FFmpeg with full FFmpeg..."
$SUDO dnf swap -y ffmpeg-free ffmpeg --allowerasing

echo
echo "==> Installing GStreamer multimedia plugins..."
$SUDO dnf install -y \
    gstreamer1-plugins-good \
    gstreamer1-plugins-bad-freeworld \
    gstreamer1-plugins-ugly

echo
echo "==> Updating installed packages..."
$SUDO dnf upgrade -y

echo
echo "=============================================="
echo " Multimedia codec setup completed!"
echo "=============================================="
echo
echo "Installed/updated:"
echo "  - RPM Fusion Free"
echo "  - Full FFmpeg"
echo "  - GStreamer Good plugins"
echo "  - GStreamer Bad Freeworld plugins"
echo "  - GStreamer Ugly plugins"
echo
echo "Try playing your MP4 in Dragon Player now."
echo

# Display FFmpeg version as a quick sanity check.
echo "FFmpeg:"
ffmpeg -version | head -n 1 || true
