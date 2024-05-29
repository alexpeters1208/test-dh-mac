#!/bin/zsh

# Initialize pyenv
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
else
    echo "pyenv is not installed. Please install pyenv first."
    exit 1
fi

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

# Iterate through each version in the file and install it using pyenv
echo "Installing Python versions from $filename..."
while IFS= read -r version; do
    if [[ -n "$version" ]]; then
        pyenv install -s "$version"
        echo "Attempted to install Python version: $version"
    fi
done < "$filename"

echo "All Python versions processed."


