
#!/bin/bash

# Define your custom Khmer font
KHMER_FONT="Hanuman" # Your Khmer font

# Define layouts with consistent formatting
english_qwerty="
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│ ~\`  │ 1 ! │ 2 @ │ 3 # │ 4 $ │ 5 % │ 6 ^ │ 7 & │ 8 * │ 9 ( │ 0 ) │ - _ │ = + │
├─────┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┐
│ Tab    │ Q   │ W   │ E   │ R   │ T   │ Y   │ U   │ I   │ O   │ P   │ [ { │ ] } │
├────────┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴─────┤
│ Caps Lock │ A   │ S   │ D   │ F   │ G   │ H   │ J   │ K   │ L   │ ; : │ ' \"    │
├───────────┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴───┬────┘
│ Shift        │ Z   │ X   │ C   │ V   │ B   │ N   │ M   │ , < │ . > │ / ?  │
└──────────────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴──────┘
"

khmer_nida="
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│ ~   │ ១ ! │ ២ @ │ ៣ # │ ៤ $ │ ៥ % │ ៦ ^ │ ៧ & │ ៨ * │ ៩ ( │ ០ ) │ - _ │ = + │
├─────┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┐
│ Tab    │ ឆ   │  ឹ   │  េ   │ រ   │ ត   │ យ   │  ុ   │  ិ   │  ោ   │ ផ   │ [ { │ ] } │
├────────┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴─────┤
│ Caps Lock │  ា   │ ស   │ ដ   │ ថ   │ ង   │ ហ   │  ្   │ ក   │ ល   │ ; : │ ' \"    │
├───────────┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴───┬────┘
│ Shift        │ ឋ   │ ខ   │ ច   │ វ   │ ប   │ ន   │ ម   │ , < │ . > │ / ?  │
└──────────────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴──────┘

With Shift pressed:
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│  ~  │  !  │  @  │  #  │  $  │  %  │  ^  │  &  │  *  │  (  │  )  │  _  │  +  │
├─────┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┐
│ Tab    │ ឈ   │  ឺ   │  ែ   │ ឬ   │ ទ   │  ួ   │  ូ   │  ី   │  ៅ   │ ភ   │  {  │  }  │
├────────┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴─────┤
│ Caps Lock │  ាំ   │  ៃ   │ ឌ   │ ធ   │ អ   │  ះ   │ ញ   │ គ   │ ឡ   │  :  │   \"    │
├───────────┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴───┬────┘
│ Shift        │ ឍ   │ ឃ   │ ជ   │   េះ  │ ព   │ ណ   │  ំ   │  <  │  >  │   ?  │
└──────────────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴──────┘
"

# Get current layout (Hyprland-specific)
current_layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' 2>/dev/null || \
                 hyprctl devices | grep -A 1 "active keymap" | head -n 1 | awk -F': ' '{print $2}')

# Simple display function using kitty terminal
display_layout() {
    local title="$1"
    local content="$2"
    local is_khmer="$3"

    # Create a temporary file
    local temp_file
    temp_file=$(mktemp)

    # Write content to the file
    echo -e "$content\n\nPress any key to close..." > "$temp_file"

    # Check which terminal to use
    if command -v kitty &> /dev/null; then
        # For kitty terminal with Khmer font support
        if [ "$is_khmer" = "true" ]; then
            # Create a temporary kitty config
            local kitty_config
            kitty_config=$(mktemp)

            # Write kitty config with proper font settings
            cat > "$kitty_config" << EOF
# Temporary kitty config for Khmer font
font_family $KHMER_FONT
font_size 14
EOF

            # Launch kitty with the custom config
            kitty --config "$kitty_config" --title "Keyboard Layout: $title" -e bash -c "cat \"$temp_file\"; read -n 1; rm \"$temp_file\"" &

            # Wait a moment before removing the config
            sleep 1
            rm -f "$kitty_config"
        else
            # Regular kitty for English layout
            kitty --title "Keyboard Layout: $title" -e bash -c "cat \"$temp_file\"; read -n 1; rm \"$temp_file\"" &
        fi
        wait $!
    elif command -v alacritty &> /dev/null; then
        # For alacritty
        alacritty --title "Keyboard Layout: $title" -e bash -c "cat \"$temp_file\"; read -n 1; rm \"$temp_file\"" &
        wait $!
    else
        # Fallback to console
        clear
        echo -e "===== $title =====\n\n$content\n\nPress Enter to continue..."
        read
        rm -f "$temp_file"
    fi
}

# Simple menu function
show_menu() {
    # Use rofi for menu selection
    menu_choice=$(echo -e "1. Khmer NiDA\n2. English QWERTY\n3. Exit" | rofi -dmenu -p "Select Keyboard Layout:" | cut -c1)

    case "$menu_choice" in
        1)
            display_layout "Khmer NiDA Standard keyboard layout KH" "$khmer_nida" "true"
            show_menu  # Show menu again after viewing
            ;;
        2)
            display_layout "QWERTY (US)" "$english_qwerty" "false"
            show_menu  # Show menu again after viewing
            ;;
        3|*)
            exit 0
            ;;
    esac
}

# Check command line arguments
if [ "$1" = "--english" ] || [ "$1" = "-e" ]; then
    display_layout "QWERTY (US)" "$english_qwerty" "false"
elif [ "$1" = "--khmer-nida" ] || [ "$1" = "-kn" ]; then
    display_layout "Khmer NiDA (KH)" "$khmer_nida" "true"
else
    # Start with the menu
    show_menu
fi
