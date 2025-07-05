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

# Load FMDeveloperTool paths and tags from the .env file
if [ -f .env ]; then
    source .env
else
    echo ".env file not found. Please create a .env file with FMDeveloperTool version paths."
    exit 1
fi

# Loop through all environment variables starting with FMDEVELOPERTOOL
for var in $(compgen -v | grep '^FMDEVELOPERTOOL'); do
    # Use indirect expansion to get the value of the environment variable
    fmdevelopertool_path="${!var}"

    # Derive the version tag from the variable name
    # Remove the 'FMDEVELOPERTOOL' prefix
    version_tag=$(echo "$var" | sed 's/^FMDEVELOPERTOOL//')
    # Extract the 'saxml' version part (e.g., '2_2_1_0') for echoing
    saxml_version=$(echo "$version_tag" | sed 's/^__saxml_\(.*\)__fm_.*/\1/')

    # Check if the version path exists
    if [ ! -f "$fmdevelopertool_path" ]; then
        echo "FMDeveloperTool not found at $fmdevelopertool_path. Skipping version $version_tag."
        continue
    fi

    # # Check if this version supports the -include_ddrinfo option
    # if [[ "$var" == "$FMDEVELOPERTOOL_DDRINFO" ]]; then
    #     include_ddrinfo=true
    # else
    #     include_ddrinfo=false
    # fi
    # Check if this version supports the -include_ddrinfo option
    if [[ " $VERSIONS_WITH_DDRINFO " =~ " $var " ]]; then
        include_ddrinfo=true
    else
        include_ddrinfo=false
    fi

    # Loop through all .fmp12 files in the input folder
    for input_file in "$input_folder"/*.fmp12; do
        # Check if there are any .fmp12 files
        if [ ! -f "$input_file" ]; then
            echo "No .fmp12 files found in $input_folder"
            exit 1
        fi

        # Extract the base name (without path and extension)
        base_name=$(basename "$input_file" .fmp12)
        
        # Set the output XML file name
        output_xml="$output_folder/${base_name}${version_tag}.xml"
        
        # Run the FMDeveloperTool to generate XML
        echo
        echo "Converting $input_file to $output_xml using $saxml_version"
        command="\"$fmdevelopertool_path\" saveAsXML \"$input_file\" $DB_ACCOUNT_NAME $DB_PASSWORD -target_filename \"$output_xml\" -f"
        echo "$command"
        eval "$command"
        
        # Check if the conversion was successful
        if [ $? -ne 0 ]; then
            echo "❌ Failed to convert $input_file using $version_tag"
        fi

        # If the version supports -include_ddrinfo, run the command with that option
        if [ "$include_ddrinfo" == true ]; then
            # Append __ddr_info to the output file name
            output_xml_ddr="$output_folder/${base_name}${version_tag}__ddr_info.xml"
            
            command="\"$fmdevelopertool_path\" saveAsXML \"$input_file\" $DB_ACCOUNT_NAME $DB_PASSWORD -target_filename \"$output_xml_ddr\" -f -include_ddrinfo"
            
            # Run the FMDeveloperTool to generate XML with -include_ddrinfo
            echo
            echo "Running command with -include_ddrinfo"
            echo "$command"
            eval "$command"
            
            # Check if the conversion was successful
            if [ $? -ne 0 ]; then
                echo "❌ Failed to convert $input_file with -include_ddrinfo using $version_tag"
            fi
        fi
    done
done

echo
