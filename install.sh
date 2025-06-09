
#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_status() {
    echo -e "${2}==>${NC} ${1}"
}

# Function to check if a command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        print_status "$1 is not installed. Installing..." "$YELLOW"
        return 1
    else
        print_status "$1 is already installed." "$GREEN"
        return 0
    fi
}

# Function to setup directory structure
setup_directory_structure() {
    print_status "Setting up directory structure..." "$YELLOW"

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
}

# Function to install official repository packages
install_official_packages() {
    local pkgs=(
        # Base
        "hyprland"
        "waybar"
        "kitty"
        "zsh"
        "starship"
        "zed"
        "zen-browser"
	"qutebrowser"

        # Fonts
        "adobe-source-han-sans-otc-fonts"
        "noto-fonts-emoji"

        # Utilities
        "rofi"
        "neovim"
        "lf"
        "lsd"
        "zoxide"
        "fastfetch"
        "wlogout"
        "hyprshot"
        "wf-recorder"
        "mpv"
        "socat"
        "bc"
	"uutils-coreutils"
    )

    print_status "Installing packages from official repositories..." "$YELLOW"
    sudo pacman -S --needed "${pkgs[@]}"
}

# Function to install AUR packages
install_aur_packages() {
    # First install paru if not present
    if ! command -v paru &> /dev/null; then
        print_status "Installing paru AUR helper..." "$YELLOW"
        git clone https://aur.archlinux.org/paru.git
        cd paru
        makepkg -si --noconfirm
        cd ..
        rm -rf paru
    fi

    local aur_pkgs=(
        # Fonts
        "ttf-nerd-fonts-symbols-common"
        "nothing-font-git"
        "departure-mono"

        # UI & Input
        "rofi-emoji"
        "cliphist"
        "pywal16-git"

        # Utilities
        "sway"
	"swww"
	"eww"
        "swaync-git"
        "hyprlock-git"
        "hypridle-git"
        "wifimenu"
        "bluetui"
        "hyprshade"

        # Browser
        "librewolf-bin"
        "pywalfox"

        # Multimedia
        "spicetify-cli"
        "spicetify-themes-git"
    )

    print_status "Installing AUR packages..." "$YELLOW"
    paru -S --needed "${aur_pkgs[@]}"
}

# Setup ZSH
setup_zsh() {
    print_status "Setting up ZSH..." "$YELLOW"

    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Configure Starship
    if [ ! -f "$HOME/.config/starship.toml" ]; then
        curl -sS https://starship.rs/install.sh | sh
    fi
}

# Setup Neovim
setup_neovim() {
    print_status "Setting up Neovim..." "$YELLOW"
    # Install Rose Pine theme
    git clone https://github.com/rose-pine/neovim.git ~/.local/share/nvim/site/pack/rose-pine/start/rose-pine
}

# Function to setup configurations
setup_configurations() {
    print_status "Setting up configurations..." "$YELLOW"

    # Make the link_config.sh script executable and run it
    chmod +x link_config.sh
    ./link_config.sh

    # Setup Pywalfox
    pywalfox install

    # Setup Spicetify with Lucid theme
    spicetify backup apply
    spicetify config current_theme Lucid
    spicetify apply

    # Make scripts executable
    chmod +x "$HOME/.config/hypr/scripts/"*.sh
}

# Main installation
main() {
    print_status "Starting Hyprstellar installation..." "$GREEN"

    setup_directory_structure
    install_official_packages
    install_aur_packages
    setup_zsh
    setup_neovim
    setup_configurations

    print_status "Installation complete!" "$GREEN"
    print_status "Please log out and back in for all changes to take effect." "$YELLOW"
    print_status "You can now use Super + Shift + B to select wallpapers" "$GREEN"
    print_status "and Super + A to set random wallpapers." "$GREEN"
}

# Check if running on Arch Linux
if [ ! -f "/etc/arch-release" ]; then
    print_status "This script is designed for Arch Linux" "$RED"
    exit 1
fi

# Check if script is run with root privileges
if [ "$EUID" -eq 0 ]; then
    print_status "Please do not run this script as root" "$RED"
    exit 1
fi

# Run the installation
main
