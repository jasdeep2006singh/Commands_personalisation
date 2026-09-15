#!/bin/bash

# Define theme names for Light and Dark modes
LIGHT_GTK="Mint-Y"
DARK_GTK="Mint-Y-Dark"

# Check current GTK theme and toggle
CURRENT_THEME=$(gsettings get org.cinnamon.desktop.interface gtk-theme)

if [ "$CURRENT_THEME" = "'$LIGHT_GTK'" ]; then
    echo "Switching to Dark Mode..."
    gsettings set org.cinnamon.desktop.interface gtk-theme "$DARK_GTK"
    gsettings set org.cinnamon.desktop.wm.preferences theme "$DARK_GTK"
    gsettings set org.cinnamon.theme name "$DARK_GTK"
    gsettings set org.cinnamon.desktop.interface icon-theme "$DARK_GTK"
    gsettings set org.x.apps.portal color-scheme 'prefer-dark'
    cp -R ~/.config/ulauncher/settings_dark.json ~/.config/ulauncher/settings.json
    pkill ulauncher && ulauncher &
else
    echo "Switching to Light Mode..."
    gsettings set org.cinnamon.desktop.interface gtk-theme "$LIGHT_GTK"
    gsettings set org.cinnamon.desktop.wm.preferences theme "$LIGHT_GTK"
    gsettings set org.cinnamon.theme name "$LIGHT_GTK"
    gsettings set org.cinnamon.desktop.interface icon-theme "$LIGHT_GTK"
    gsettings set org.x.apps.portal color-scheme 'prefer-light'
    cp -R ~/.config/ulauncher/settings_light.json ~/.config/ulauncher/settings.json
    pkill ulauncher && ulauncher &

fi
