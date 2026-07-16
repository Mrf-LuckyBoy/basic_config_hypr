#!/bin/bash
#
# Deploy this repo to the live config locations:
#   1. Symlinks ~/.config/hypr and ~/.config/waybar to this repo.
#   2. Copies the first PNG in wallpapers/ to ~/Pictures/Wallpapers/wallpaper.png
#      (the canonical path hyprpaper.conf reads — any source filename works).
#   3. Restarts Waybar and Hyprpaper.
#
# Safe to re-run. Destructive on ~/.config/hypr and ~/.config/waybar — any
# untracked files under those paths will be lost.

set -e

CONFIG_DIR="$HOME/.config"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Re-applying configs..."

mkdir -p "$CONFIG_DIR" "$WALLPAPER_DIR"

# Symlink repo → live config locations
rm -rf "$CONFIG_DIR/hypr" "$CONFIG_DIR/waybar"
ln -s "$REPO_DIR/hypr"   "$CONFIG_DIR/hypr"
ln -s "$REPO_DIR/waybar" "$CONFIG_DIR/waybar"
echo "  → symlinked ~/.config/{hypr,waybar}"

# Install wallpaper (canonical filename so hyprpaper.conf never changes)
shopt -s nullglob
wallpapers=("$REPO_DIR"/wallpapers/*.png)
shopt -u nullglob
if (( ${#wallpapers[@]} > 0 )); then
  cp -f "${wallpapers[0]}" "$WALLPAPER_DIR/wallpaper.png"
  echo "  → wallpaper set from $(basename "${wallpapers[0]}")"
  if (( ${#wallpapers[@]} > 1 )); then
    echo "     (${#wallpapers[@]} PNGs in wallpapers/ — using first alphabetically)"
  fi
else
  echo "  → no PNG in wallpapers/, skipping wallpaper copy"
fi

# Restart bars so config changes take effect (Hyprland auto-reloads itself)
pkill waybar    2>/dev/null || true; waybar    &
pkill hyprpaper 2>/dev/null || true; hyprpaper &

echo "Done ✅"
