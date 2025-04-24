
#!/bin/bash

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

# Display layout in a terminal
display_layout() {
    local title="$1"
    local content="$2"

    # Create temp file
    local temp_file
    temp_file=$(mktemp)
    echo -e "$content\n\nPress any key to close or go back to menu..." > "$temp_file"

    # Try to display with the preferred terminal
    if command -v kitty &> /dev/null; then
        kitty --title "Keyboard Layout: $title" -e bash -c "cat $temp_file; read -n 1 -t 30 input || true; rm $temp_file" &
        wait $!
    elif command -v alacritty &> /dev/null; then
        alacritty --title "Keyboard Layout: $title" -e bash -c "cat $temp_file; read -n 1 -t 30 input || true; rm $temp_file" &
        wait $!
    elif command -v xterm &> /dev/null; then
        xterm -T "Keyboard Layout: $title" -e "cat $temp_file; read -n 1 -t 30 input || true; rm $temp_file" &
        wait $!
    else
        # Fall back to standard terminal
        echo -e "Keyboard Layout: $title\n$content\n\nPress any key to close or go back to menu..."
        read -n 1 -t 30 input || true
    fi

    # Clean up
    [ -f "$temp_file" ] && rm "$temp_file"

    # After closing terminal, show menu again
    show_menu
}

# Show menu using rofi
show_menu() {
    # Show menu using rofi (works regardless of layout)
    menu_choice=$(echo -e "1. Khmer NiDA\n2. English QWERTY\n3. Exit" | rofi -dmenu -p "Select Keyboard Layout:" | cut -c1)

    case "$menu_choice" in
        1)
            display_layout "Khmer NiDA Standard keyboard layout KH" "$khmer_nida"
            ;;
        2)
            display_layout "QWERTY (US)" "$english_qwerty"
            ;;
        3|*)
            exit 0
            ;;
    esac
}

# Check command line arguments
if [ "$1" = "--english" ] || [ "$1" = "-e" ]; then
    display_layout "QWERTY (US)" "$english_qwerty"
    exit 0
elif [ "$1" = "--khmer-nida" ] || [ "$1" = "-kn" ]; then
    display_layout "Khmer NiDA (KH)" "$khmer_nida"
    exit 0
fi

# Start with the menu
show_menu
