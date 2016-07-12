#!/bin/bash

# Caps-lock as compose key
gsettings set org.gnome.desktop.input-sources xkb-options "['compose:caps']"

# Focus follows mouse, sloppily
gsettings set org.gnome.desktop.wm.preferences focus-mode "'sloppy'"

# No audible bell
gsettings set org.gnome.desktop.wm.preferences audible-bell false

# Uniform window controls. Looking at you, Unity.
gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Super>Left']"
gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Super>Right']"
gsettings set org.gnome.desktop.wm.keybindings maximize "['<Primary><Super>Up']"
gsettings set org.gnome.desktop.wm.keybindings unmaximize "['<Primary><Super>Down']"

# Lock screen with <Super>l
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "'<Super>l'"
