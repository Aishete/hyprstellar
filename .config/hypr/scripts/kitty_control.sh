
#!/bin/bash

# Script to control Kitty terminal blur and opacity with notifications
# Usage: ./kitty_control.sh [option]
# Options:
#   opacity-increase  - Increase opacity by 0.1
#   opacity-decrease  - Decrease opacity by 0.1
#   blur-increase     - Increase blur by 1
#   blur-decrease     - Decrease blur by 1
#   opacity-reset     - Reset opacity to default (0.4)
#   blur-reset        - Reset blur to default (1)

# Path to kitty config
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
TEMP_FILE="/tmp/kitty_conf_temp"
iDIR="$HOME/.config/hypr/scripts/icons"

# Get icons for opacity
get_opacity_icon() {
    local current_percent=$(echo "$1 * 100" | awk '{printf "%.0f", $1}')

    if [ $(echo "$current_percent <= 20" | bc -l) -eq 1 ]; then
        icon="$iDIR/brightness-20.png"
    elif [ $(echo "$current_percent <= 40" | bc -l) -eq 1 ]; then
        icon="$iDIR/brightness-40.png"
    elif [ $(echo "$current_percent <= 60" | bc -l) -eq 1 ]; then
        icon="$iDIR/brightness-60.png"
    elif [ $(echo "$current_percent <= 80" | bc -l) -eq 1 ]; then
        icon="$iDIR/brightness-80.png"
    else
        icon="$iDIR/brightness-100.png"
    fi

    # If icon doesn't exist, use a fallback
    if [ ! -f "$icon" ]; then
        icon="utilities-terminal"
    fi
}

# Get icons for blur
get_blur_icon() {
    local current=$1
    local percentage=$(echo "$current * 5" | bc)

    if [ "$percentage" -le "20" ]; then
        icon="$iDIR/brightness-20.png"
    elif [ "$percentage" -le "40" ]; then
        icon="$iDIR/brightness-40.png"
    elif [ "$percentage" -le "60" ]; then
        icon="$iDIR/brightness-60.png"
    elif [ "$percentage" -le "80" ]; then
        icon="$iDIR/brightness-80.png"
    else
        icon="$iDIR/brightness-100.png"
    fi

    # If icon doesn't exist, use a fallback
    if [ ! -f "$icon" ]; then
        icon="utilities-terminal"
    fi
}

# Function to notify user with progress bar
notify_user() {
    local title="$1"
    local message="$2"
    local value="$3"
    local icon="$4"
    local is_opacity="$5"

    # Convert value to percentage for progress bar
    if [ "$is_opacity" = "true" ]; then
        # Convert opacity (0.0-1.0) to percentage (0-100)
        value_percent=$(echo "$value * 100" | bc | sed 's/\..*//')
    else
        # Convert blur (0-20) to percentage (0-100)
        value_percent=$(echo "$value * 5" | bc | sed 's/\..*//')
        if [ "$value_percent" -gt "100" ]; then
            value_percent=100
        fi
    fi

    notify-send -e -h string:x-canonical-private-synchronous:kitty_control \
                -h int:value:"$value_percent" -u low -i "$icon" \
                "$title : $message"
}

# Function to reload kitty config
reload_kitty() {
    # Check if kitty is running
    if pgrep kitty > /dev/null; then
        # Send USR1 signal to all kitty processes to reload config
        pkill -USR1 kitty
        return 0
    else
        notify-send "Kitty Control" "No running Kitty instances found to reload"
        return 1
    fi
}

# Function to update opacity
update_opacity() {
    local current_opacity=$(grep "^background_opacity" "$KITTY_CONF" | awk '{print $2}')
    local new_opacity=$1

    # Ensure opacity is within range 0.1-1.0 using bc
    new_opacity=$(echo "if ($new_opacity < 0.0) x=0.1 else if ($new_opacity > 1.0) x=1.0 else x=$new_opacity; scale=1; x" | bc)

    # Update the config file
    sed "s/^background_opacity .*/background_opacity $new_opacity/" "$KITTY_CONF" > "$TEMP_FILE"
    mv "$TEMP_FILE" "$KITTY_CONF"

    # Get appropriate icon based on opacity
    get_opacity_icon "$new_opacity"

    # Send notification with progress bar
    notify_user "Opacity" "$new_opacity" "$new_opacity" "$icon" "true"

    # Reload kitty config
    reload_kitty
}

# Function to update blur
update_blur() {
    local current_blur=$(grep "^background_blur" "$KITTY_CONF" | awk '{print $2}')
    local new_blur=$1

    # Ensure blur is within range -1-20
    if [ "$new_blur" -lt "-20" ]; then
        new_blur=-20
    elif [ "$new_blur" -gt "20" ]; then
        new_blur=20
    fi

    # Update the config file
    sed "s/^background_blur .*/background_blur $new_blur/" "$KITTY_CONF" > "$TEMP_FILE"
    mv "$TEMP_FILE" "$KITTY_CONF"

    # Get appropriate icon based on blur
    get_blur_icon "$new_blur"

    # Send notification with progress bar
    notify_user "Blur" "$new_blur" "$new_blur" "$icon" "false"

    # Reload kitty config
    reload_kitty
}

# Check if kitty config exists
if [ ! -f "$KITTY_CONF" ]; then
    notify-send "Kitty Control Error" "Config file not found at $KITTY_CONF"
    exit 1
fi

# Process command line argument
case "$1" in
    "opacity-increase")
        current_opacity=$(grep "^background_opacity" "$KITTY_CONF" | awk '{print $2}')
        # Use bc for arithmetic with decimal numbers
        new_opacity=$(echo "$current_opacity + 0.1" | bc)
        update_opacity "$new_opacity"
        ;;
    "opacity-decrease")
        current_opacity=$(grep "^background_opacity" "$KITTY_CONF" | awk '{print $2}')
        # Use bc for arithmetic with decimal numbers
        new_opacity=$(echo "$current_opacity - 0.1" | bc)
        update_opacity "$new_opacity"
        ;;
    "blur-increase")
        current_blur=$(grep "^background_blur" "$KITTY_CONF" | awk '{print $2}')
        new_blur=$((current_blur + 1))
        update_blur "$new_blur"
        ;;
    "blur-decrease")
        current_blur=$(grep "^background_blur" "$KITTY_CONF" | awk '{print $2}')
        new_blur=$((current_blur - 1))
        update_blur "$new_blur"
        ;;
    "opacity-reset")
        update_opacity 0.4
        ;;
    "blur-reset")
        update_blur 1
        ;;
    "status")
        current_opacity=$(grep "^background_opacity" "$KITTY_CONF" | awk '{print $2}')
        current_blur=$(grep "^background_blur" "$KITTY_CONF" | awk '{print $2}')
        get_opacity_icon "$current_opacity"
        notify_user "Kitty Settings" "Opacity: $current_opacity, Blur: $current_blur" "$current_opacity" "$icon" "true"
        ;;
    *)
        echo "Usage: $0 [option]"
        echo "Options:"
        echo "  opacity-increase  - Increase opacity by 0.1"
        echo "  opacity-decrease  - Decrease opacity by 0.1"
        echo "  blur-increase     - Increase blur by 1"
        echo "  blur-decrease     - Decrease blur by 1"
        echo "  opacity-reset     - Reset opacity to default (0.4)"
        echo "  blur-reset        - Reset blur to default (1)"
        echo "  status            - Display current opacity and blur settings"
        exit 1
        ;;
esac

exit 0
