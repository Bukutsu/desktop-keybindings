# Cosmic Keybindings for KDE Plasma 6 & GNOME

Faithful port of [COSMIC desktop](https://system76.com/cosmic) keyboard shortcuts to KDE Plasma 6 and GNOME.

## Installation

### KDE Plasma 6

> [!IMPORTANT]
> Ensure you have virtual desktops configured in **System Settings → Window Management → Virtual Desktops** (e.g., 9 desktops) before importing.

1. Download `scheme/cosmic.kksrc`
2. Open **System Settings → Keyboard → Shortcuts**
3. Click **Manage Schemes → Import Scheme...**
4. Select the file and apply

### XFCE

Apply the COSMIC shortcuts to XFCE using native `xfwm4` actions where possible:

```bash
./scripts/apply_xfce_cosmic.sh
```

This configures nine workspaces, numbered workspace movement, native tiling, window operations, adjacent workspace navigation, monitor movement, launcher, terminal, browser, file manager, lock, and screenshot-compatible system shortcuts. XFCE has no native equivalents for COSMIC's directional focus, overview, stacking, swap, floating, orientation, zoom, or last-workspace actions; those are left unmapped rather than replaced with misleading commands. A timestamped keybinding backup is created under `~/.local/state/cosmic-keybindings-xfce/`.

## GNOME

Apply COSMIC keybindings directly via `gsettings`:

```bash
./scripts/apply_gnome_cosmic.sh
```

To backup current GNOME keybindings and restore default GNOME shortcuts:

```bash
./scripts/reset_gnome_defaults.sh
```

> [!NOTE]
> Do not copy `scheme/cosmic.kksrc` directly to `~/.config/kglobalshortcutsrc`; KDE import schemes and the live shortcut config use different formats.

> [!TIP]
> **Customizing the Browser (`Meta+B`):**
> By default, the web browser shortcut maps to **Firefox** (`org.kde.firefox.desktop`). If you prefer a different browser, simply go to **System Settings → Keyboard → Shortcuts**, search for your browser (e.g. Brave, Chrome, Chromium), and rebind its launch shortcut to `Meta+B`.

## Upstream source

COSMIC default compositor shortcuts are tracked in [`cosmic-comp/data/keybindings.ron`](https://github.com/pop-os/cosmic-comp/blob/master/data/keybindings.ron). Check that file before updating this KDE scheme. The broader COSMIC desktop repository is [`pop-os/cosmic-epoch`](https://github.com/pop-os/cosmic-epoch).

## Mapping

### Window focus (vim-style)
| Shortcut | Action |
|---|---|
| `Meta+H` / `Meta+Left` | Focus window left |
| `Meta+J` / `Meta+Down` | Focus window down |
| `Meta+K` / `Meta+Up` | Focus window up |
| `Meta+L` / `Meta+Right` | Focus window right |

### Move window in direction (COSMIC `Move`)
| Shortcut | Action |
|---|---|
| `Meta+Shift+H` / `Meta+Shift+Left` | Move/pack window left |
| `Meta+Shift+J` / `Meta+Shift+Down` | Move/pack window down |
| `Meta+Shift+K` / `Meta+Shift+Up` | Move/pack window up |
| `Meta+Shift+L` / `Meta+Shift+Right` | Move/pack window right |

### Workspaces
| Shortcut | Action |
|---|---|
| `Meta+1` through `Meta+9` | Switch to workspace 1-9 |
| `Meta+Shift+1` through `Meta+Shift+9` | Move window to workspace 1-9 |
| `Meta+Ctrl+H` / `Meta+Ctrl+Left` | Previous workspace |
| `Meta+Ctrl+L` / `Meta+Ctrl+Right` | Next workspace |
| `Meta+Ctrl+J` / `Meta+Ctrl+Down` | Next workspace |
| `Meta+Ctrl+K` / `Meta+Ctrl+Up` | Previous workspace |
| `Meta+Ctrl+Shift+H/Left` | Move window to previous workspace |
| `Meta+Ctrl+Shift+L/Right` | Move window to next workspace |
| `Meta+Ctrl+Shift+J/Down` | Move window to next workspace |
| `Meta+Ctrl+Shift+K/Up` | Move window to previous workspace |

### Displays
| Shortcut | Action |
|---|---|
| `Meta+Alt+H` / `Meta+Alt+Left` | Switch to display left |
| `Meta+Alt+J` / `Meta+Alt+Down` | Switch to display below |
| `Meta+Alt+K` / `Meta+Alt+Up` | Switch to display above |
| `Meta+Alt+L` / `Meta+Alt+Right` | Switch to display right |
| `Meta+Shift+Alt+H` / `Meta+Shift+Alt+Left` | Move window to display left |
| `Meta+Shift+Alt+J` / `Meta+Shift+Alt+Down` | Move window to display below |
| `Meta+Shift+Alt+K` / `Meta+Shift+Alt+Up` | Move window to display above |
| `Meta+Shift+Alt+L` / `Meta+Shift+Alt+Right` | Move window to display right |

### Window operations
| Shortcut | Action |
|---|---|
| `Meta+Q` | Close window |
| `Meta+M` | Maximize window |
| `Meta+F11` | Fullscreen window |
| `Meta+R` | Resize window |
| `Meta+Alt+Escape` | Kill window |
| `Alt+Tab` / `Meta+Tab` | Switch window |
| `Alt+Shift+Tab` / `Meta+Shift+Tab` | Switch window backward |
| `Meta+=` / `Meta++` / `Meta+.` | Zoom in |
| `Meta+-` / `Meta+,` | Zoom out |

### System
| Shortcut | Action |
|---|---|
| `Meta+Escape` | Lock screen |
| `Meta+Shift+Escape` | Log out |
| `Meta+Space` | Switch input source / keyboard layout |
| `Meta+0` | Switch to previous desktop (COSMIC LastWorkspace equivalent) |
| `Meta+A` | Application Launcher |
| `Meta+W` / `Launch (A)` | Toggle Overview |
| `Meta+F` | File manager (Dolphin) |
| `Meta+T` | Terminal (Konsole) |
| `Meta+B` | Web browser (Firefox by default) |
| `Meta+Alt+S` | Toggle screen reader |
| `Meta` (tap) | KRunner / COSMIC Launcher equivalent |
| `Meta+/` | KRunner / COSMIC Launcher equivalent |
| `Print` | Screenshot (KDE default) |
| `Volume Up/Down/Mute` | Audio volume controls |
| `Microphone Mute` | Toggle microphone mute |
| `Media Play/Previous/Next` | Media playback controls |
| `Monitor Brightness Up/Down` | Display brightness controls |
| `Power Off` | Power off action |
| `Touchpad Toggle` / `Meta+Ctrl+Touchpad Toggle` | Toggle touchpad |

## Krohnkite Tiling Integration

If you use the [Krohnkite](https://codeberg.org/anametologin/Krohnkite) tiling script, the scheme configures the following keybindings to align with COSMIC defaults and prevent hotkey collisions:

| Shortcut | Action | COSMIC / Krohnkite Equivalent |
|---|---|---|
| `Meta+G` | Toggle active window floating | Matches COSMIC `Super+G` (Toggle Window Floating) |
| `Meta+O` | Rotate layout orientation | Matches COSMIC `Super+O` (Toggle Orientation) |
| `Meta+H/J/K/L` | Tiling window focus | Standard direction focus |
| `Meta+Shift+H/J/K/L` | Tiling window movement | Move window in layout |
| `Meta+I` | Increase master area capacity | Standard layout grow |
| `Meta+Y` | Toggle float all (tiling layout on/off) | Matches COSMIC `Super+Y` (Toggle Tiling) |
| `Meta+S` | Toggle stacked layout | Matches COSMIC `Super+S` (Toggle Stacking) |
| `Meta+\` / `Meta+|` | Cycle layouts | Next / Previous layout selection |

*Krohnkite defaults that collide with Cosmic/KDE shortcuts (such as `Meta+Ctrl+H/J/K/L` resizing, or direct layout selectors like `Meta+T/M/R`) are disabled (`none`) to protect workspace navigation and application launchers.*

## Unmapped (no KDE equivalent)

These Cosmic shortcuts have no direct KDE equivalent and are omitted (unless using the Krohnkite integration or workspace mapping above):

- `Super+x` — Swap window in tiling tree
- `Super+u` / `Super+i` — Focus in/out of tiling tree
- `Super+Shift+0` — Move window to last workspace
- `Super+Shift+r` — Resize window inward
- KDE Quick Tile actions — COSMIC does not bind quick tiling; `Super+Arrow` is focus navigation

## License

MIT
