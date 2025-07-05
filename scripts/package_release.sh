#!/bin/bash

# Generate SaXML
input_folder="fm"
output_folder="saxml_utf16le"
mkdir -p "$output_folder"
echo "Generating SaXML files..."
scripts/generate_saxml.sh "$input_folder" "$output_folder"
if [ $? -ne 0 ]; then
    echo "❌ Error generating SaXML files. Exiting."
    exit 1
fi

# Convert UTF-16 LE to UTF-8
input_folder="saxml_utf16le"
output_folder="saxml_utf8"
echo "Converting to UTF-8..."
scripts/convert_to_utf8.sh "$input_folder" "$output_folder"
if [ $? -ne 0 ]; then
    echo "❌ Error converting XML files to UTF-8. Exiting."
    exit 1
fi

echo "✅ Release packaging complete!"
