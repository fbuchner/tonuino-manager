#!/bin/bash

# Check if the filename is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <csv_file>"
    exit 1
fi

csv_file="$1"

# Function to generate QR code and display it
generate_qr_code() {
  local input_text=$1
  qrencode -t ANSI "$input_text"
}

is_first_line=true;
# Read the CSV file
while IFS=";" read -r artist album mode folder_number number_of_files rfid_content
do
  # Skip the first line
  if $is_first_line; then
    is_first_line=false
    continue
  fi

  # Generate QR code
  generate_qr_code "$rfid_content"

  # Wait for user input
  read -n 1 -s -r -p "Press Enter to continue..." < /dev/tty
  
  # Clear the terminal screen
  clear
done <  $csv_file
