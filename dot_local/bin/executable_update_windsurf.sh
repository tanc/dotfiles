#!/bin/bash

# Script to update Windsurf installation
# Finds the newest Windsurf download in Downloads directory and installs it

# Define directories
DOWNLOADS_DIR="/var/home/tanc/Downloads"
INSTALL_DIR="/var/home/tanc/.local/share/Windsurf"
TEMP_DIR="/tmp/windsurf_update"

# Create temp directory if it doesn't exist
mkdir -p "$TEMP_DIR"

# Find the newest Windsurf download (silently)
NEWEST_DOWNLOAD=$(find "$DOWNLOADS_DIR" -name "Windsurf-linux-x64-*.tar.gz" -type f -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -1 | cut -d' ' -f2-)

if [ -z "$NEWEST_DOWNLOAD" ]; then
    echo "No Windsurf download found in $DOWNLOADS_DIR"
    exit 1
fi

echo "Found newest Windsurf download: $NEWEST_DOWNLOAD"

# Extract version from filename for logging
VERSION=$(basename "$NEWEST_DOWNLOAD" | grep -oP 'Windsurf-linux-x64-\K[0-9]+\.[0-9]+\.[0-9]+(?=\.tar\.gz)')
echo "Updating to Windsurf version $VERSION"

# Clean temp directory
rm -rf "$TEMP_DIR"/*

# Extract the tar.gz file (silently)
echo "Extracting $NEWEST_DOWNLOAD to $TEMP_DIR"
tar -xzf "$NEWEST_DOWNLOAD" -C "$TEMP_DIR" 2>/dev/null

# Create install directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Sync the contents to the install directory (silently)
echo "Installing to $INSTALL_DIR"
rsync -a --delete "$TEMP_DIR"/Windsurf/ "$INSTALL_DIR"/ 2>/dev/null

# Clean up
rm -rf "$TEMP_DIR"

echo "Windsurf has been successfully updated to version $VERSION"
