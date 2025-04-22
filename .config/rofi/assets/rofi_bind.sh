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
        print "<b>" key "</b>    <i>" $2 "</i>    <span color='\''white'\''>" comment "</span>    <span color='\''gray'\''>" cmd "</span>"
    }')

# Add static binds that might not be in the config file
EXTRA_BINDS=(
    "<b>SUPER+MouseDrag</b>    <i>movewindow</i>    <span color='gray'>Drag to move window</span>    <span color='blue'>Move window with left mouse button</span>"
    "<b>SUPER+RightMouseDrag</b>    <i>resizewindow</i>    <span color='gray'>Drag to resize window</span>    <span color='blue'>Resize window with right mouse button</span>"
)

# Combine all binds
ALL_BINDS=("${BINDS[@]}" "${EXTRA_BINDS[@]}")

# Show in rofi with increased width
CHOICE=$(printf '%s\n' "${ALL_BINDS[@]}" | rofi -dmenu -i -markup-rows -p "Hyprland Keybinds:" -width 80% -location 0)

# Extract and execute command if needed
if [[ -n "$CHOICE" ]]; then
    CMD=$(echo "$CHOICE" | sed -n 's/.*<span color='\''gray'\''>\(.*\)<\/span>.*/\1/p')
    if [[ "$CMD" == exec* ]]; then
        eval "$CMD"
    elif [[ -n "$CMD" ]]; then
        hyprctl dispatch "$CMD"
    fi
fi
