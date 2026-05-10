#!/usr/bin/env bash

OUTPUT="$HOME/.cache/hyprlock-media"

update() {
    STATUS=$(playerctl status 2>/dev/null)

    if [[ "$STATUS" == "Playing" || "$STATUS" == "Paused" ]]; then
        TITLE=$(playerctl metadata title 2>/dev/null)
        ARTIST=$(playerctl metadata artist 2>/dev/null)

        TEXT="$TITLE"

        if [[ -n "$ARTIST" ]]; then
            TEXT="$TITLE  -  $ARTIST"
        fi

        MAX=45
        if [ ${#TEXT} -gt $MAX ]; then
            TEXT="${TEXT:0:$MAX}..."
        fi

        echo "󰎈  $TEXT" > "$OUTPUT"
    else
        echo "" > "$OUTPUT"
    fi
}

# initial update
update

# listen for changes
playerctl --follow metadata --format '{{title}}' 2>/dev/null | while read -r _; do
    update
done

