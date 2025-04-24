
#!/bin/bash

# Function to get current layout
get_layout() {
    local layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' 2>/dev/null || \
                  hyprctl devices | grep -A 1 "active keymap" | head -n 1 | awk -F': ' '{print $2}')
    case "$layout" in
        "English (US)") echo "󰌌   EN" ;;
        "Khmer (Cambodia)") echo "󰌌   KH" ;;
        *) echo "??" ;;
    esac
}

# If --switch parameter passed (Waybar click)
if [ "$1" = "--switch" ]; then
    current_layout=$(get_layout)
    case "$current_layout" in
        "en")
            hyprctl keyword input:kb_layout "kh"
            notify-send -i input-keyboard "Keyboard Layout" "Khmer Layout" -t 1000
            ;;
        *)
            hyprctl keyword input:kb_layout "us"
            notify-send -i input-keyboard "Keyboard Layout" "US Layout" -t 1000
            ;;
    esac
    exit 0
fi

# If --hyprlock parameter passed (simple output for hyprlock)
if [ "$1" = "--hyprlock" ]; then
    get_layout
    exit 0
fi

# Default behavior for Waybar (JSON output)
case $(get_layout) in
    "EN") echo '{"text": "en", "tooltip": "US Layout"}' ;;
    "KH") echo '{"text": "kh", "tooltip": "Khmer Layout"}' ;;
    *) echo '{"text": "??", "tooltip": "Unknown Layout"}' ;;
esac
