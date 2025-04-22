
#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print colored status messages
print_status() {
    echo -e "${2}==>${NC} ${1}"
}

# Define the hyprstellar directory
HYPRSTELLAR_DIR="$HOME/hyprstellar"

# Check if current directory is hyprstellar, if not move everything there
current_dir=$(pwd)
if [ "$current_dir" != "$HYPRSTELLAR_DIR" ]; then
    # Create hyprstellar directory if it doesn't exist
    if [ ! -d "$HYPRSTELLAR_DIR" ]; then
        mkdir -p "$HYPRSTELLAR_DIR"
        print_status "Created hyprstellar directory" "$GREEN"
    fi

    # Move all files to hyprstellar directory
    print_status "Moving files to $HYPRSTELLAR_DIR" "$YELLOW"
    cp -r ./* "$HYPRSTELLAR_DIR/"
    cd "$HYPRSTELLAR_DIR"
fi

# Define the source directories
SOURCE_DIRS=(
    "$HYPRSTELLAR_DIR/.config/ctp"
    "$HYPRSTELLAR_DIR/.config/kitty"
    "$HYPRSTELLAR_DIR/.config/mpv"
    "$HYPRSTELLAR_DIR/.config/spicetify"
    "$HYPRSTELLAR_DIR/.config/wlogout"
    "$HYPRSTELLAR_DIR/.config/fastfetch"
    "$HYPRSTELLAR_DIR/.config/lf"
    "$HYPRSTELLAR_DIR/.config/nvim"
    "$HYPRSTELLAR_DIR/.config/swaync"
    "$HYPRSTELLAR_DIR/.config/zsh"
    "$HYPRSTELLAR_DIR/.config/hypr"
    "$HYPRSTELLAR_DIR/.config/lsd"
    "$HYPRSTELLAR_DIR/.config/rofi"
    "$HYPRSTELLAR_DIR/.config/waybar"
)

# Create symlinks in ~/.config
for dir in "${SOURCE_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        base_name=$(basename "$dir")
        ln -sfn "$dir" "$HOME/.config/$base_name"
        print_status "Linked $dir to $HOME/.config/$base_name" "$GREEN"
    else
        print_status "Directory $dir does not exist, skipping" "$YELLOW"
    fi
done

# Link the .zshrc file
if [ -f "$HYPRSTELLAR_DIR/.zshrc" ]; then
    ln -sfn "$HYPRSTELLAR_DIR/.zshrc" "$HOME/.zshrc"
    print_status "Linked $HYPRSTELLAR_DIR/.zshrc to $HOME/.zshrc" "$GREEN"
else
    print_status "$HYPRSTELLAR_DIR/.zshrc does not exist, skipping" "$YELLOW"
fi
