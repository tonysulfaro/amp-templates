#!/bin/bash

# The location of the current script.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define paths to the shard directories and executable
MASTER_DIR="$SCRIPT_DIR/../Cluster_1/shard"
CAVES_DIR="$SCRIPT_DIR/../Cluster_1/Caves"
EXECUTABLE="dontstarve_dedicated_server_nullrenderer_x64"

# Define cluster and shard configurations
CLUSTER_NAME="Cluster_1"
MASTER_SHARD="shard"
CAVES_SHARD="Caves"

# Set Steam App and Game IDs
export SteamAppId=322330
export SteamGameId=322330

# Check for xterm
if which xterm > /dev/null; then
    XTERM="xterm"
elif [ -f /usr/bin/xterm ]; then
    XTERM="/usr/bin/xterm"
else
    echo "Error launching dedicated server: Cannot locate xterm."
    exit 1
fi

# Function to start a server in a new xterm window
start_server() {
    local dir="$1"
    local shard="$2"
    local cluster="$3"
    echo "Starting $shard shard in $dir..."
    cd "$dir"
    "$XTERM" -e "$EXECUTABLE" -persistent_storage_root "../dstserver" -conf_dir "dstserver_config" -shard "$shard" &
}

# Start Master shard
start_server "$MASTER_DIR" "$MASTER_SHARD" "$CLUSTER_NAME"

# Start Caves shard
start_server "$CAVES_DIR" "$CAVES_SHARD" "$CLUSTER_NAME"

echo "Both shards are starting..."

# Wait for all background processes to complete
wait
