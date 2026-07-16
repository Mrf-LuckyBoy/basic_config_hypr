# basic_config_hypr

Personal Hyprland + Waybar dotfiles for Arch Linux. Covers the compositor, bar, lock screen, and wallpaper daemon.

## Layout

```
.
├── hypr/
│   ├── hyprland.conf       # thin entry point — sources conf.d/*
│   ├── hyprlock.conf       # lock screen (monitor hardcoded to eDP-1)
│   ├── hyprpaper.conf      # wallpaper daemon
│   └── conf.d/
│       ├── env.conf         # $terminal, $mod, other variables (loaded first)
│       ├── monitors.conf    # monitor rules per port name
│       ├── autostart.conf   # exec-once entries
│       ├── input.conf       # keyboard, touchpad
│       ├── appearance.conf  # gaps/borders/decoration/animations/misc
│       └── keybinds.conf    # all bind = lines, grouped by purpose
├── waybar/
│   ├── config.jsonc         # bar modules (monitor hardcoded to eDP-1)
│   └── style.css            # bar theme
├── scripts/
│   └── apply.sh             # deploy: symlink configs, install wallpaper, restart bars
└── wallpapers/              # drop a PNG here to set the wallpaper (gitignored)
```

**Where to edit what:** anything about Hyprland lives under `hypr/conf.d/`. Adding a keybind → `keybinds.conf`. Changing monitor positioning → `monitors.conf`. Nothing needs to move into `hyprland.conf` itself.

## Prerequisites

- **Compositor stack:** `hyprland`, `hyprpaper`, `hyprlock`, `waybar`, `dunst`
- **Launcher & clipboard:** `wofi`, `cliphist`, `wl-clipboard`
- **Screenshot tools:** `grim`, `slurp`, `swappy`
- **System control:** `pamixer`, `brightnessctl`, `pavucontrol`, `nm-applet` (from `network-manager-applet`), `blueman`
- **Apps used by keybinds:** `ghostty` (terminal), `nautilus` (file manager)
- **Font:** JetBrainsMono Nerd Font — the Waybar glyphs will not render without it.

## Install

```bash
git clone <this-repo> ~/Project/basic_config_hypr
cd ~/Project/basic_config_hypr
./scripts/apply.sh
```

`apply.sh`:

1. **Deletes** `~/.config/hypr` and `~/.config/waybar` (any untracked files there are lost).
2. Symlinks them to `hypr/` and `waybar/` in this repo.
3. Copies the first PNG in `wallpapers/` to `~/Pictures/Wallpapers/wallpaper.png` — the fixed path `hyprpaper.conf` reads. Drop any PNG (any filename) in `wallpapers/` and re-run to swap the wallpaper.
4. Restarts Waybar and Hyprpaper.

After the initial link, Hyprland auto-reloads on save. Waybar and Hyprpaper do not — re-run `./scripts/apply.sh` (or restart them manually) after editing their configs.

## Keybinds

`$mod = SUPER`

**Apps**

| Key | Action |
|---|---|
| `SUPER+RETURN` | Terminal (ghostty) |
| `SUPER+D` | App launcher (wofi) |
| `SUPER+E` | File manager (nautilus) |
| `SUPER+C` | Clipboard history (cliphist + wofi) |
| `SUPER+P` | Audio mixer (pavucontrol) |
| `SUPER+B` | Bluetooth (blueman-manager) |
| `SUPER+SHIFT+L` | Lock screen (hyprlock) |
| `SUPER+SHIFT+E` | Android emulator (`pixel8` AVD) |

**Windows & workspaces**

| Key | Action |
|---|---|
| `SUPER+Q` | Kill active window |
| `SUPER+F` | Fullscreen |
| `SUPER+V` | Toggle floating |
| `SUPER+H/J/K/L` | Move focus (vim directions) |
| `SUPER+TAB` | Focus current-or-last |
| `ALT+TAB` | Cycle windows |
| `SUPER+1..7` | Switch workspace |
| `SUPER+SHIFT+1..7` | Move window to workspace |
| `SUPER+LMB / RMB` | Drag / resize windows |
| `SUPER+ESCAPE` | Exit Hyprland |

**Screenshots** — saved to `~/Pictures/Screenshots/` with a shutter sound.

| Key | Action |
|---|---|
| `SUPER+S` | Full screen |
| `SUPER+SHIFT+S` | Region select |
| `SUPER+CTRL+S` | Region select → edit in swappy |
| `SUPER+CTRL+SHIFT+S` | Region select → copy to clipboard |

**Media keys** — volume (`XF86AudioRaise/Lower/Mute` via pamixer), brightness (`XF86MonBrightnessUp/Down` via brightnessctl).

## Multi-monitor

`hypr/conf.d/monitors.conf` sets:

- `eDP-1` (laptop built-in) — anchored at `0x0`.
- `HDMI-A-1` and `DP-1` (externals) — `auto-up`, i.e. stacked above the laptop screen.
- Anything else — auto-placed to the right.

Check what's connected with `hyprctl monitors`, or from a TTY:

```bash
for f in /sys/class/drm/card*-*/status; do
  printf "%-25s %s\n" "$(basename "$(dirname "$f")")" "$(cat "$f")"
done
```

## Things to adjust on a new machine

- `hypr/hyprpaper.conf` — path is `/home/atsawa/Pictures/Wallpapers/wallpaper.png`. Change the username; filename stays as-is (`apply.sh` always writes to `wallpaper.png`).
- `hypr/hyprlock.conf` and `waybar/config.jsonc` — hardcoded to `monitor = eDP-1`. Adjust if your primary output has a different name.
- `hypr/conf.d/input.conf` — layout `us, th` with `caps:ctrl_modifier`. Change `kb_layout` / `kb_options` to taste.

## Notes

- The `decoration { … }` block in `hypr/conf.d/appearance.conf` is commented out (rounding/blur/shadow disabled). Uncomment the whole block, not individual lines, to re-enable.
- PNGs are `.gitignore`d — commit any intended assets with `git add -f`.
