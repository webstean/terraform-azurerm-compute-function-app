#!/bin/bash

## devcontainer needs to be created by docker-compose or dockerfile

EXTENSIONS_FILE="/workspace/.devcontainer/extensions-checksum.txt"
CURRENT_EXT=$(code --list-extensions --show-versions | sort)

# Create hash of current extensions
CURRENT_HASH=$(echo "$CURRENT_EXT" | sha256sum)

if [ -f "$EXTENSIONS_FILE" ]; then
    OLD_HASH=$(cat "$EXTENSIONS_FILE")
    if [ "$OLD_HASH" != "$CURRENT_HASH" ]; then
        echo "Extension versions changed. Triggering container restart..."
        echo "$CURRENT_HASH" > "$EXTENSIONS_FILE"
        # This will cause the container to exit and restart if restart policy is set
        kill 1
    else
        echo "Extension versions unchanged."
    fi
else
    echo "$CURRENT_HASH" > "$EXTENSIONS_FILE"
    echo "No previous extension record. Hash stored."
fi
