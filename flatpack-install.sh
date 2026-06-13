#!/usr/bin/env bash

flatpak remote-delete flathub

sudo wget -O /var/lib/flatpak/repo/flathub.trustedkeys.gpg https://flathub.org/repo/flathub.gpg

flatpak remote-add --gpg-import=/var/lib/flatpak/repo/flathub.trustedkeys.gpg flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub io.github.flattool.Warehouse -y

