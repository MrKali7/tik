#!/bin/bash

# Load configuration
CONFIG_FILE="bots_config.json"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file $CONFIG_FILE not found!"
    exit 1
fi

# Parse configuration
BOTS=$(jq -r 'keys[]' "$CONFIG_FILE")

for BOT in $BOTS; do
    # Derive directory name from the bot key (e.g., bot1 => bot1)
    DIR="$BOT"

    # Extract details from the JSON configuration
    SCRIPT=$(jq -r ".\"$BOT\".run" "$CONFIG_FILE")  # Script to run

    # Create a temporary .env file for the bot
    ENV_FILE=".env_$BOT"
    jq -r ".\"$BOT\".env | to_entries | map(\"\(.key)=\(.value)\") | .[]" "$CONFIG_FILE" > "$ENV_FILE"

    # Export environment variables from the .env file
    echo "Setting environment variables for $BOT"
    set -a
    source "$ENV_FILE"
    set +a

    # Start the bot
    echo "Starting $BOT from $DIR/$SCRIPT"
    cd "$DIR" || exit 1
    python3 "$SCRIPT" &
    cd - > /dev/null

    # Clean up the temporary .env file
    rm "$ENV_FILE"
done

wait
echo "All bots are running."
echo " 
███╗░░░███╗██████╗░  ██╗░░██╗░█████╗░██╗░░░░░██╗███████╗
████╗░████║██╔══██╗  ██║░██╔╝██╔══██╗██║░░░░░██║╚════██║
██╔████╔██║██████╔╝  █████═╝░███████║██║░░░░░██║░░░░██╔╝
██║╚██╔╝██║██╔══██╗  ██╔═██╗░██╔══██║██║░░░░░██║░░░██╔╝░
██║░╚═╝░██║██║░░██║  ██║░╚██╗██║░░██║███████╗██║░░██╔╝░░
╚═╝░░░░░╚═╝╚═╝░░╚═╝  ╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝░░░"
