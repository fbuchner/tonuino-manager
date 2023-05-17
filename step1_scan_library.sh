#!/bin/bash

# Function to recursively scan the music library
scan_library() {
  local path="$1"
  local csv_file="$2"
  
  # Iterate through each item in the current directory
  for item in "$path"/*; do
    if [ -d "$item" ]; then
      # If the item is a directory, assume it's an artist folder
      local artist_path="$item"  # Full path
      local artist="${item##*/}"  # Extract only the folder name

      # Iterate through each album in the artist folder
      for album_path in "$artist_path"/*; do
        if [ -d "$album_path" ]; then
          # If the item is a directory, assume it's an album folder
          local album="${album_path##*/}"  # Extract only the folder name
          echo "$artist;$album;$album_path;;" >> "$csv_file"
        fi
      done

      # Recursively scan the subdirectories of the artist folder
      scan_library "$item" "$csv_file"
    fi
  done
}

# Check if the script was invoked with a path argument
if [ $# -eq 0 ]; then
  echo "Usage: $0 <path> [filename]"
  exit 1
fi

# Check if a second filename argument was provided
if [ $# -eq 2 ]; then
  csv_file="$2"
 else
  csv_file="my_library.csv"
fi

# Get the path argument
library_path="$1"

# Check if the specified path exists and is a directory
if [ ! -d "$library_path" ]; then
  echo "Invalid path: $library_path"
  exit 1
fi

# Write the header to the CSV file
echo "artist;album;path;card_number;mode" > "$csv_file"

# Scan the music library and write album paths to the CSV file
scan_library "$library_path" "$csv_file"

echo "Album paths have been written to $csv_file."
