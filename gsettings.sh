#!/bin/bash

# Caps-lock as compose key
gsettings set org.gnome.desktop.input-sources xkb-options "['compose:caps']"

# Focus follows mouse, sloppily
gsettings set org.gnome.desktop.wm.preferences focus-mode "'sloppy'"

# No audible bell
gsettings set org.gnome.desktop.wm.preferences audible-bell false

# No "Move" with <Alt>+F7. Which happens to be "Find usages" in Netbeans
gsettings set org.gnome.desktop.wm.keybindings begin-move "['']"

# No F1 button in Gnome Terminal
gsettings set "org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/" help 'disabled'
