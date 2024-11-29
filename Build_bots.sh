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
    SOURCE=$(jq -r ".\"$BOT\".source" "$CONFIG_FILE")  # GitHub repository URL
    BRANCH=$(jq -r ".\"$BOT\".branch" "$CONFIG_FILE")  # Branch to clone
    SCRIPT=$(jq -r ".\"$BOT\".run" "$CONFIG_FILE")  # Script to run

    # Clone the repository if the directory doesn't exist
    if [ ! -d "$DIR" ]; then
        echo "Cloning $BOT from $SOURCE into $DIR"
        git clone --branch "$BRANCH" "$SOURCE" "$DIR" || { echo "Failed to clone $SOURCE"; exit 1; }
    else
        echo "Directory $DIR already exists. Pulling latest changes."
        cd "$DIR" || exit 1
        git pull || { echo "Failed to pull latest changes for $DIR"; exit 1; }
        cd - > /dev/null
    fi

    # Install dependencies
    echo "Installing dependencies for $BOT"
    cd "$DIR" || exit 1
    pip3 install -r requirements.txt || { echo "Failed to install dependencies for $BOT"; exit 1; }
    cd - > /dev/null
done

echo "Build process completed successfully."
echo " 
███╗░░░███╗██████╗░  ██╗░░██╗░█████╗░██╗░░░░░██╗███████╗
████╗░████║██╔══██╗  ██║░██╔╝██╔══██╗██║░░░░░██║╚════██║
██╔████╔██║██████╔╝  █████═╝░███████║██║░░░░░██║░░░░██╔╝
██║╚██╔╝██║██╔══██╗  ██╔═██╗░██╔══██║██║░░░░░██║░░░██╔╝░
██║░╚═╝░██║██║░░██║  ██║░╚██╗██║░░██║███████╗██║░░██╔╝░░
╚═╝░░░░░╚═╝╚═╝░░╚═╝  ╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝░░░"
