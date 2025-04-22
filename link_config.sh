#!/bin/bash

# Define the source directories
SOURCE_DIRS=(
    "$HOME/hyprstellar/.config/ctp"
    "$HOME/hyprstellar/.config/kitty"
    "$HOME/hyprstellar/.config/mpv"
    "$HOME/hyprstellar/.config/spicetify"
    "$HOME/hyprstellar/.config/wlogout"
    "$HOME/hyprstellar/.config/fastfetch"
    "$HOME/hyprstellar/.config/lf"
    "$HOME/hyprstellar/.config/nvim"
    "$HOME/hyprstellar/.config/swaync"
    "$HOME/hyprstellar/.config/zsh"
    "$HOME/hyprstellar/.config/hypr"
    "$HOME/hyprstellar/.config/lsd"
    "$HOME/hyprstellar/.config/rofi"
    "$HOME/hyprstellar/.config/waybar"
)

# Create symlinks in ~/.config
for dir in "${SOURCE_DIRS[@]}"; do
    # Get the base name of the directory
    base_name=$(basename "$dir")
    # Create the symlink
    ln -sfn "$dir" "$HOME/.config/$base_name"
    echo "Linked $dir to $HOME/.config/$base_name"
done

# Link the .zshrc file
ln -sfn "$HOME/hyprstellar/.zshrc" "$HOME/.zshrc"
echo "Linked $HOME/hyprstellar/.zshrc to $HOME/.zshrc"

