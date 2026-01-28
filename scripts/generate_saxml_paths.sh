#!/bin/bash

# Check if both input and output folders are provided as arguments
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "Usage: $0 <input_folder> <output_folder> [depth]"
    exit 1
fi

# Assign input and output folders from arguments
input_folder="$1"
output_folder="$2"
depth="${3:-4}"

# Validate depth (positive integer, minimum 2 for level-2 separator logic)
if ! [[ "$depth" =~ ^[0-9]+$ ]] || [ "$depth" -lt 2 ]; then
    echo "Depth must be an integer >= 2"
    exit 1
fi

# Create the output folder if it doesn't exist
mkdir -p "$output_folder"

# Ensure xmlstarlet is available
if ! command -v xmlstarlet >/dev/null 2>&1; then
    echo "xmlstarlet not found. Please install it first."
    exit 1
fi

# Loop through all XML files in the input folder
for input_file in "$input_folder"/*.xml; do
    # Check if there are any .xml files
    if [ ! -f "$input_file" ]; then
        echo "No .xml files found in $input_folder"
        exit 1
    fi

    # Extract the base name (without path and extension)
    base_name=$(basename "$input_file" .xml)

    # Set the output file path
    output_file="$output_folder/${base_name}_saxml_paths.txt"

    # Build match expression for the requested depth
    match="/*"
    for ((i=1; i<depth; i++)); do
        match="${match}/*"
    done

    # Build path expression for the requested depth
    path_expr="concat('/'"
    for ((i=depth-1; i>=1; i--)); do
        path_expr="${path_expr}, name(ancestor::*[${i}]), '/'"
    done
    path_expr="${path_expr}, name(.))"

    # Extract element paths, adding separators when level 2 changes
    level2_index=$((depth - 2))
    xmlstarlet sel -t \
        -m "$match" \
        -v "name(ancestor::*[${level2_index}])" -o $'\t' \
        -v "$path_expr" \
        -n "$input_file" \
    | awk -F'\t' 'NR==1{prev=$1} $1!=prev{print "--"; prev=$1} {print $2}' \
        > "$output_file"

    # Check if the extraction was successful
    if [ $? -eq 0 ]; then
        if [ -s "$output_file" ]; then
            echo "Wrote: $output_file"
        else
            rm -f "$output_file"
            echo "Removed empty output: $output_file"
        fi
    else
        echo "Failed: $input_file"
    fi

    # echo "Match: $match"
    # echo "Path expression: $path_expr"

done

echo "SaXML path extraction completed."
