#!/bin/zsh

# Parse arguments
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <versions-file>"
    exit 1
fi

VERSIONS_FILE=$1

# Check if the file exists
if [[ ! -f $VERSIONS_FILE ]]; then
    echo "Versions file not found: $VERSIONS_FILE"
    exit 1
fi

# Read each line from the file
while IFS= read -r version; do
    # Extract the version number (e.g., 11, 17, 21)
    version_number=$(echo $version | grep -o '[0-9]*')

    if [[ -z $version_number ]]; then
        echo "Invalid version format: $version"
        continue
    fi

    # Install the JDK using Homebrew
    brew install openjdk@$version_number

    # Define the path to the installed JDK
    jdk_path="/opt/homebrew/opt/openjdk@$version_number/libexec/openjdk.jdk/Contents/Home"

    # Check if the JDK path exists
    if [[ ! -d $jdk_path ]]; then
        echo "JDK path not found: $jdk_path"
        continue
    fi

    # Link the JDK to SDKMAN
    sdk install java $version $jdk_path

done < $VERSIONS_FILE

echo "Java installation and linking completed."


