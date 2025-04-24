
#!/bin/bash

# Function to get current layout
get_layout() {
    local layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' 2>/dev/null || \
                  hyprctl devices | grep -A 1 "active keymap" | head -n 1 | awk -F': ' '{print $2}')
    case "$layout" in
        "English (US)") echo '{"text": " EN", "tooltip": "US Layout"}' ;;
        "Khmer (Cambodia)") echo '{"text": " KH", "tooltip": "Khmer Layout"}' ;;
        *) echo '{"text": "??", "tooltip": "Unknown Layout"}' ;;
    esac
}

# If --switch parameter passed, change layout
if [ "$1" = "--switch" ]; then
    current_layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' 2>/dev/null)
    case "$current_layout" in
        "English (US)")
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

# Get Hyprland instance signature
HYPRLAND_INSTANCE_SIGNATURE=$(hyprctl instances -j | jq -r '.[0].instance')

# Main execution
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    echo '{"text": "ERR", "tooltip": "Hyprland not running"}'
    exit 1
fi

SOCKET_PATH="/tmp/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

# Initial output
get_layout

# Watch for changes if socket exists
if [ -S "$SOCKET_PATH" ]; then
    socat -u "UNIX-CONNECT:$SOCKET_PATH" - | while read -r line; do
        if [[ $line == *"keyboardlayout"* ]] || [[ $line == *"activewindow"* ]]; then
            get_layout
        fi
    done
else
    # Fallback: output once and exit if socket doesn't exist
    exit 0
fi
