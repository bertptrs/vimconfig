#!/bin/bash

# Caps-lock as compose key
gsettings set org.gnome.desktop.input-sources xkb-options "['compose:caps']"

# Focus follows mouse, sloppily
gsettings set org.gnome.desktop.wm.preferences focus-mode "'sloppy'"

# No audible bell
gsettings set org.gnome.desktop.wm.preferences audible-bell false
