#!/bin/bash

set -e

CONFIG_DIR="$HOME/.config"
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Linking repo configs → system..."

mkdir -p "$CONFIG_DIR"

# Remove old configs
rm -rf "$CONFIG_DIR/hypr"
rm -rf "$CONFIG_DIR/waybar"

# Create symlinks
ln -s "$REPO_DIR/hypr" "$CONFIG_DIR/hypr"
ln -s "$REPO_DIR/waybar" "$CONFIG_DIR/waybar"

echo "Symlinked successfully ✅"

pkill waybar 2>/dev/null || true
waybar &
