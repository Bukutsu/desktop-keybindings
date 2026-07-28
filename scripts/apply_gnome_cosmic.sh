#!/usr/bin/env bash
set -euo pipefail

backup="${XDG_STATE_HOME:-$HOME/.local/state}/cosmic-keybindings-gnome/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup"
dconf dump /org/gnome/desktop/wm/keybindings/ > "$backup/wm.dconf"
dconf dump /org/gnome/shell/keybindings/ > "$backup/shell.dconf"
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > "$backup/media-keys.dconf"
echo "Backup: $backup"

# Keep GNOME's dynamic workspaces. Free COSMIC's Super+number bindings.
gsettings set org.gnome.mutter dynamic-workspaces true
for i in {1..9}; do
  gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"
  gsettings set org.gnome.shell.keybindings open-new-window-application-$i "[]"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>$i']"
done
gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super>v']"

# Native GNOME window operations.
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q', '<Alt>F4']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>m']"
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>F11']"
gsettings set org.gnome.desktop.wm.keybindings begin-resize "['<Super>r']"
gsettings set org.gnome.desktop.wm.keybindings minimize "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-last "['<Super>0']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-last "['<Super><Shift>0']"

# COSMIC treats H/Left/K/Up as previous and J/Down/L/Right as next.
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Super><Ctrl>Up', '<Super><Ctrl>Left', '<Super><Ctrl>h', '<Super><Ctrl>k']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super><Ctrl>Down', '<Super><Ctrl>Right', '<Super><Ctrl>j', '<Super><Ctrl>l']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Super><Ctrl><Shift>Up', '<Super><Ctrl><Shift>Left', '<Super><Ctrl><Shift>h', '<Super><Ctrl><Shift>k']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Super><Ctrl><Shift>Down', '<Super><Ctrl><Shift>Right', '<Super><Ctrl><Shift>j', '<Super><Ctrl><Shift>l']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "[]"

# GNOME can move a window between monitors, but cannot focus a monitor by direction.
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-left "['<Super><Shift><Alt>Left', '<Super><Shift><Alt>h']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-down "['<Super><Shift><Alt>Down', '<Super><Shift><Alt>j']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-up "['<Super><Shift><Alt>Up', '<Super><Shift><Alt>k']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-right "['<Super><Shift><Alt>Right', '<Super><Shift><Alt>l']"

# Shell and applications.
gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>w', '<Super>slash']"
gsettings set org.gnome.shell.keybindings toggle-application-view "['<Super>a']"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>f']"
gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Super>b']"
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>Escape']"
gsettings set org.gnome.settings-daemon.plugins.media-keys logout "['<Super><Shift>Escape']"

# Preserve existing custom shortcuts while adding Super+T.
path='/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/cosmic-terminal/'
current="$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)"
# Remove the legacy entry created by older versions of this script.
legacy="'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-terminal/'"
current="${current//$legacy, /}"
current="${current//, $legacy/}"
current="${current//$legacy/}"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$current"
dconf reset -f /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-terminal/
if [[ "$current" != *"$path"* ]]; then
  [[ "$current" == '@as []' ]] && current='[]'
  current="${current%]}"
  [[ "$current" != '[' ]] && current+=", "
  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$current'$path']"
fi
terminal="$(command -v ptyxis || command -v gnome-terminal || command -v kgx || command -v x-terminal-emulator || true)"
if [[ -n "$terminal" ]]; then
  schema="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path"
  gsettings set "$schema" name 'Terminal'
  gsettings set "$schema" command "$terminal"
  gsettings set "$schema" binding '<Super>t'
else
  echo 'Warning: no supported terminal executable found; Super+T was not configured.' >&2
fi

if ! gsettings list-schemas | grep -Eq 'org.gnome.shell.extensions.(pop-shell|forge)'; then
  echo 'Warning: GNOME has no native directional window focus/move or COSMIC tiling.' >&2
  echo 'Super+H/J/K/L and Super+Shift+H/J/K/L require a compatible tiling extension.' >&2
fi

echo 'Applied all COSMIC bindings that stock GNOME supports.'
