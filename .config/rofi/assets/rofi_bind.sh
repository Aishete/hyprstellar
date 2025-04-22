#!/bin/bash

# Use the actual binds.conf file location
HYPR_CONF="$HOME/.config/hypr/configs/binds.conf"

# Extract keybindings with better formatting
mapfile -t BINDS < <(grep '^bind' "$HYPR_CONF" | \
    sed -e 's/^bind *= *//' | \
    awk -F', ' '{
        # Clean up the key combination
        key=$1;
        gsub(/\$mod/, "SUPER", key);

        # Get the command/action
        cmd="";
        for(i=3;i<=NF;i++) cmd=cmd $(i) " ";

        # Handle comments
        comment="";
        if(index(cmd,"#")) {
            split(cmd,parts,"#");
            cmd=parts[1];
            comment=parts[2];
        }

        # Format the output with more spaces
        print key "    " $2 "    |    " comment
    }')

# Add static binds that might not be in the config file
EXTRA_BINDS=(
    "SUPER+MouseDrag | Move window with left mouse button"
    "SUPER+RightMouseDrag | Resize window with right mouse button"
)

# Combine all binds
ALL_BINDS=("${BINDS[@]}" "${EXTRA_BINDS[@]}")

# Show in rofi with increased width
while true; do
    result=$(
        rofi -dmenu \
        -kb-custom-1 "Control-Delete" \
        -kb-custom-2 "Alt-Delete" \
        -config ~/.config/rofi/keybinds.rasi < <(printf '%s\n' "${ALL_BINDS[@]}")
    )

    case "$?" in
        1)
            exit
            ;;
        0)
            case "$result" in
                "")
                    continue
                    ;;
                *)
                    KEY=$(echo "$result" | awk -F' | ' '{print $1}')
                    COMMAND=$(grep -E "^bind *= *$mod, $KEY," "$HYPR_CONF" | awk -F'#' '{print $1}' | sed -e 's/^bind *= *//' -e 's/, exec, //')

                    if [[ "$COMMAND" == exec* ]]; then
                        eval "$COMMAND"
                    elif [[ -n "$COMMAND" ]]; then
                        hyprctl dispatch "$COMMAND"
                    fi
                    exit
                    ;;
            esac
            ;;
        10)
            # Handle custom action 1 (e.g., delete entry)
            ;;
        11)
            # Handle custom action 2 (e.g., wipe all)
            ;;
    esac
done
