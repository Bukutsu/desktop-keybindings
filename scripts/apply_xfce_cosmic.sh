#!/bin/sh
set -eu

# Faithful COSMIC shortcut port using native XFCE/xfwm4 actions where possible.
# Unmapped COSMIC features (overview, directional focus, stacking, swap, zoom)
# are intentionally left alone rather than approximated with surprising commands.

channel=xfce4-keyboard-shortcuts
backup="${XDG_STATE_HOME:-$HOME/.local/state}/cosmic-keybindings-xfce/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup"
cp "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml" "$backup/" 2>/dev/null || true

set_key() {
  xfconf-query -c "$channel" -p "$1" --create -t string -s "$2"
}

remove_key() {
  xfconf-query -c "$channel" -p "$1" -r 2>/dev/null || true
}

wm() { set_key "/xfwm4/custom/$1" "$2"; }
cmd() { set_key "/commands/custom/$1" "$2"; }

# Remove existing command bindings that collide with COSMIC's Super shortcuts.
for key in \
  '<Super>' '<Super>a' '<Super>b' '<Super>e' '<Super>f' '<Super>m' \
  '<Super>p' '<Super>q' '<Super>r' '<Super>t' '<Super>w' '<Super>Escape' \
  '<Super>Tab' '<Super><Shift>Tab' '<Super>F11' '<Super>Print'; do
  remove_key "/commands/custom/$key"
done

# Native xfwm4 window actions.
wm '<Super>q' close_window_key
wm '<Super>m' maximize_window_key
wm '<Super>F11' fullscreen_key
wm '<Super>r' resize_window_key
wm '<Super>Tab' switch_window_key
wm '<Super><Shift>Tab' cycle_reverse_windows_key

# COSMIC Move -> closest XFWM4 native tiling actions.
for pair in \
  '<Super><Shift>Left:tile_left_key' \
  '<Super><Shift>Right:tile_right_key' \
  '<Super><Shift>Up:tile_up_key' \
  '<Super><Shift>Down:tile_down_key' \
  '<Super><Shift>h:tile_left_key' \
  '<Super><Shift>j:tile_down_key' \
  '<Super><Shift>k:tile_up_key' \
  '<Super><Shift>l:tile_right_key'; do
  key=${pair%%:*}; action=${pair#*:}; wm "$key" "$action"
done

# Nine numbered workspaces, plus adjacent workspace navigation.
xfconf-query -c xfwm4 -p /general/workspace_count --create -t int -s 9
for i in 1 2 3 4 5 6 7 8 9; do
  wm "<Super>$i" "workspace_${i}_key"
  wm "<Super><Shift>$i" "move_window_workspace_${i}_key"
done

for pair in \
  '<Super><Primary>Left:left_workspace_key' \
  '<Super><Primary>Right:right_workspace_key' \
  '<Super><Primary>Up:up_workspace_key' \
  '<Super><Primary>Down:down_workspace_key' \
  '<Super><Primary>h:left_workspace_key' \
  '<Super><Primary>l:right_workspace_key' \
  '<Super><Primary>k:up_workspace_key' \
  '<Super><Primary>j:down_workspace_key' \
  '<Super><Primary><Shift>Left:move_window_left_workspace_key' \
  '<Super><Primary><Shift>Right:move_window_right_workspace_key' \
  '<Super><Primary><Shift>Up:move_window_up_workspace_key' \
  '<Super><Primary><Shift>Down:move_window_down_workspace_key' \
  '<Super><Primary><Shift>h:move_window_left_workspace_key' \
  '<Super><Primary><Shift>l:move_window_right_workspace_key' \
  '<Super><Primary><Shift>k:move_window_up_workspace_key' \
  '<Super><Primary><Shift>j:move_window_down_workspace_key'; do
  key=${pair%%:*}; action=${pair#*:}; wm "$key" "$action"
done

# COSMIC output movement -> closest XFWM4 move-to-monitor actions.
for pair in \
  '<Super><Shift><Alt>Left:move_window_to_monitor_left_key' \
  '<Super><Shift><Alt>Right:move_window_to_monitor_right_key' \
  '<Super><Shift><Alt>Up:move_window_to_monitor_up_key' \
  '<Super><Shift><Alt>Down:move_window_to_monitor_down_key'; do
  key=${pair%%:*}; action=${pair#*:}; wm "$key" "$action"
done

# COSMIC application/system shortcuts.
cmd '<Super>' 'xfce4-appfinder -c'
cmd '<Super>slash' 'xfce4-appfinder -c'
cmd '<Super>a' "sh -c 'pkill -x xfce4-appfinder || xfce4-appfinder'"
cmd '<Super>b' 'exo-open --launch WebBrowser'
cmd '<Super>f' 'exo-open --launch FileManager'
cmd '<Super>t' 'exo-open --launch TerminalEmulator'
cmd '<Super>Escape' 'xflock4'
cmd '<Super><Alt>Escape' 'xkill'

# Prevent XFCE's generic custom-command override from masking the mappings.
set_key /commands/custom/override true
set_key /xfwm4/custom/override true

printf 'Applied COSMIC-compatible XFCE shortcuts. Backup: %s\n' "$backup"
printf '%s\n' 'Unmapped: directional focus, overview, stacking, swap, floating, orientation, zoom, last workspace.'
