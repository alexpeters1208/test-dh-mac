#!/bin/zsh

# Initialize SDKMAN
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Parse arguments
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <versions-file>"
    exit 1
fi

filename=$1

# Check if the file exists
if [[ ! -f "$filename" ]]; then
    echo "File $filename not found!"
    exit 1
fi

# Iterate through each version in the file and install it using sdkman
echo "Installing versions from $filename..."
while IFS= read -r version; do
    if [[ -n "$version" ]]; then
        sdk install java "$version"
        echo "Attempted to install Java version: $version"
    fi
done < "$filename"

echo "All versions processed."
