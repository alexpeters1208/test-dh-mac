#!/bin/zsh

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

    # Read the file and create the directories
    echo "Creating directories from $filename..."
    while IFS= read -r dir; do
        mkdir -p "$dir"
        echo "Created directory: $dir"
    done < "$filename"
done

echo "All directories created successfully."

