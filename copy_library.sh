#!/bin/bash

# Check if the filename and target folder parameters are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <csv_file> <target_folder> [csv_file_new]"
    exit 1
fi

csv_file="$1"
target_folder="$2"

#Check if a third parameter for the output csv was provided
csv_file_new=""
if [ $# -eq 3 ]; then
  csv_file_new="$3"
else
  csv_file_new="my_cards.csv"
fi

# Write the header to the CSV file
echo "artist;album;mode;folder_number;number_of_files;rfid_content" > "$csv_file_new"
#13 37 B3 47 02 $folder_number $mode 00 00 00 00 00 00 00 00 00
#mode 2 = Album (kompletter Ordner)
#mode 3 = Party (zufällig)
#mode 5 = Hörbuch (Fortschritt speichern)

# Read the CSV file and process each line
while IFS=';' read -r artist album path card_number mode; do
    # Check if card_number is a number
    if [[ "$card_number" =~ ^[0-9]+$ ]]; then
        # Create a folder with the card_number value in the target folder
        folder_name=$(printf "%02d" "$card_number")
        folder_path="$target_folder/$folder_name"
        mkdir -p "$folder_path"


        # Copy and rename MP3 files in alphabetical order
        count=1
        while IFS= read -r -d '' file; do
            new_filename=$(printf "%03d.mp3" "$count")
            cp "$file" "$folder_path/$new_filename"
            count=$((count+1))
        done < <(find "$path" -type f -name "*.mp3" -print0 | sort -z)
        
        folder_hex=$(printf "%02x" "$card_number")
        if [[ ! "$mode" =~ ^[0-9]+$ ]]; then
            mode=2
        fi
        mode_hex=$(printf "%02x" "$mode")
        rfid_content="13 37 B3 47 02 $folder_hex $mode_hex 00 00 00 00 00 00 00 00 00"

        echo "$artist;$album;$mode;$card_number;$count;$rfid_content" >> "$csv_file_new"
    fi

    echo "Album files have been copied successfully. You can find the card file at $csv_file_new"
done < "$csv_file"
