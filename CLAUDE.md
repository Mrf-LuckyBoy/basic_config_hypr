# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal Hyprland + Waybar dotfiles for Arch Linux. There is no build system, no tests, and no package manifest — every file is a config consumed directly by Hyprland, Waybar, Hyprlock, or Hyprpaper.

## Deploy workflow

The repo is not the live config; `~/.config/hypr` and `~/.config/waybar` are. Edits are activated by symlinking those directories to the tracked copies in this repo.

Run from anywhere:

```bash
./scripts/apply.sh
```

`apply.sh` (self-contained; no `link.sh` anymore) does:

1. `rm -rf ~/.config/hypr ~/.config/waybar` (destructive — any un-tracked files there are lost)
2. Creates symlinks `~/.config/hypr → <repo>/hypr` and `~/.config/waybar → <repo>/waybar`
3. Copies the first `*.png` from `wallpapers/` to `~/Pictures/Wallpapers/wallpaper.png` (fixed target that hyprpaper reads)
4. Kills and restarts Waybar and Hyprpaper

`apply.sh` resolves the repo root from its own location, so it's safe to call from anywhere.

Hyprland auto-reloads its config on save (any file under `hypr/conf.d/` too — the entry point sources them). Waybar and Hyprpaper do not — re-run `apply.sh` or restart them manually after editing their configs.

## Layout that matters

`hypr/hyprland.conf` is a thin loader that `source`s modular files under `hypr/conf.d/`. Edit those, not the entry point:

- `hypr/conf.d/env.conf` — variable definitions (`$terminal = ghostty`, `$mod = SUPER`). Loaded first so later files can use them. Adding a new variable used across files goes here.
- `hypr/conf.d/monitors.conf` — per-port monitor rules. `eDP-1` at `0x0`, `HDMI-A-1`/`DP-1` `auto-up` (stacked above the laptop). Rule ordering matters: `eDP-1` must be placed before rules that use `auto-up` relative to it.
- `hypr/conf.d/autostart.conf` — `exec-once` entries (`hyprpaper`, `dunst`, `waybar`, `nm-applet`, `cliphist`, dbus env).
- `hypr/conf.d/input.conf` — keyboard (US+TH, `caps:ctrl_modifier`), touchpad.
- `hypr/conf.d/appearance.conf` — `general`, `decoration` (commented out — uncomment the whole block, not individual lines), `dwindle`, `animations`, `misc`.
- `hypr/conf.d/keybinds.conf` — all `bind =` / `bindm =` lines, grouped by section (Apps, Screenshots, Window management, Workspaces, Media keys).
- `hypr/hyprlock.conf` — lock screen. Hardcoded to `monitor = eDP-1`.
- `hypr/hyprpaper.conf` — wallpaper daemon. Uses standard `preload = …` + `wallpaper = ,…` syntax. Path is `/home/atsawa/Pictures/Wallpapers/wallpaper.png`; the filename is fixed (canonical) so `apply.sh` can always write there regardless of source PNG name. Username in the path is still hardcoded — adjust for other machines.
- `waybar/config.jsonc` — bar modules. Hardcoded to `eDP-1`.
- `waybar/style.css` — bar theme. Requires JetBrainsMono Nerd Font.
- `wallpapers/` — drop-box for wallpaper PNGs (gitignored). `apply.sh` picks the first alphabetically.

## Runtime deps assumed by keybinds

`SUPER+RETURN` → `ghostty`; `SUPER+D` → `wofi` (also used by `SUPER+C` clipboard picker via `cliphist`); `SUPER+E` → `nautilus`; `SUPER+P` → `pavucontrol`; `SUPER+B` → `blueman-manager`; `SUPER+SHIFT+L` → `hyprlock`. Screenshots need `grim`, `slurp`, `swappy`, `wl-clipboard`. Volume/brightness need `pamixer` and `brightnessctl`. Nothing is wired to a package manifest — install manually on a fresh machine.

## Editing notes

- When adding a new conf.d file, add a matching `source =` line to `hypr/hyprland.conf`. `source = ~/.config/hypr/conf.d/*.conf` glob is NOT reliable across Hyprland versions — enumerate each file explicitly.
- Hyprpaper syntax that works is `preload = PATH` + `wallpaper = MONITOR,PATH` (empty MONITOR = all outputs). The `wallpaper { path = … }` block syntax is invalid and silently drops the wallpaper — don't reintroduce it.
