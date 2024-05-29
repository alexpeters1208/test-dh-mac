#!/bin/zsh

# Function to create .sdkmanrc file in a directory
create_sdkmanrc() {
    local dir=$1
    local version=$dir
    echo "java=$version" > "$dir/.sdkmanrc"
    echo "Created file $dir/.sdkmanrc with content: java=$version"
}

# Check if at least one file is provided as argument
if [[ $# -eq 0 ]]; then
    echo "No files provided. Please provide one or more text files containing directory names."
    exit 1
fi

# Iterate through each provided file
for filename in "$@"; do
    # Check if the file exists
    if [[ ! -f "$filename" ]]; then
        echo "File $filename not found!"
        continue
    fi

    # Read the file and create the .sdkmanrc files
    echo "Processing directories from $filename..."
    while IFS= read -r dir; do
        if [[ -d "$dir" ]]; then
            create_sdkmanrc "$dir"
        else
            echo "Directory $dir does not exist."
        fi
    done < "$filename"
done

echo "All .sdkmanrc files created successfully."

