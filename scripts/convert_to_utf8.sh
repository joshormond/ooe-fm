#!/bin/bash

# Check if both input and output folders are provided as arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_folder> <output_folder>"
    exit 1
fi

# Assign input and output folders from arguments
input_folder="$1"
output_folder="$2"

# Create the output folder if it doesn't exist
mkdir -p "$output_folder"

# Loop through all files in the input folder
for input_file in "$input_folder"/*; do
    # Skip directories
    if [ -d "$input_file" ]; then
        continue
    fi
    
    # Get the filename from the full path
    filename=$(basename "$input_file")
    
    # Set the output file path
    output_file="$output_folder/$filename"

    # Convert the file from UTF-16 LE to UTF-8
    iconv -f UTF-16LE -t UTF-8 "$input_file" > "$output_file"
    
    # Check if the conversion was successful
    if [ $? -eq 0 ]; then
        echo "Successfully converted: $filename"
    else
        echo "Failed to convert: $filename"
    fi
done

echo "Conversion completed for all files."
