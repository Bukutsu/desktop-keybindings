#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="gnome_backups"
mkdir -p "$BACKUP_DIR"

echo "Backing up current GNOME keybindings to $BACKUP_DIR/..."
dconf dump /org/gnome/desktop/wm/keybindings/ > "$BACKUP_DIR/wm_keybindings.dconf"
dconf dump /org/gnome/shell/keybindings/ > "$BACKUP_DIR/shell_keybindings.dconf"
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > "$BACKUP_DIR/media_keys.dconf"

echo "Resetting GNOME keybindings and workspace settings to defaults..."
gsettings reset org.gnome.mutter dynamic-workspaces
gsettings reset org.gnome.desktop.wm.preferences num-workspaces
gsettings reset-recursively org.gnome.desktop.wm.keybindings
gsettings reset-recursively org.gnome.shell.keybindings
gsettings reset-recursively org.gnome.settings-daemon.plugins.media-keys
gsettings reset org.gnome.settings-daemon.plugins.media-keys custom-keybindings

if gsettings list-schemas | grep -q "org.gnome.shell.extensions.pop-shell"; then
  dconf dump /org/gnome/shell/extensions/pop-shell/ > "$BACKUP_DIR/pop_shell.dconf"
  gsettings reset-recursively org.gnome.shell.extensions.pop-shell
fi

echo "Done! Reset to default GNOME keybindings."
