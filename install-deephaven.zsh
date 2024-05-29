#!/bin/zsh

# Function to install deephaven-server in each Python virtual environment
install_deephaven() {
    local jdk_dir=$1
    local py_versions_file=$2

    echo "Processing JDK directory: $jdk_dir"

    cd "$jdk_dir" || { echo "Failed to change directory to $jdk_dir"; return; }

    # Initialize SDKMAN
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

    # Execute sdk env command
    sdk env

    while IFS= read -r py_version; do
        if [[ -n "$py_version" ]]; then
            echo "Processing Python version: $py_version in $jdk_dir"
            source "$py_version-venv/bin/activate"
            if pip3 install deephaven-server; then
                echo "Installed deephaven-server in virtual environment for Python $py_version in $jdk_dir"
            else
                echo "Failed to install deephaven-server in virtual environment for Python $py_version in $jdk_dir"
            fi
            deactivate
        fi
    done < "$py_versions_file"

    cd - > /dev/null || { echo "Failed to return to previous directory"; return; }
}

# Parse arguments
jdk_files=()
python_versions_file=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --jdk-versions)
            shift
            jdk_files+=("$1")
            ;;
        --python-versions)
            shift
            python_versions_file="$1"
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
    shift
done

# Ensure all arguments are provided
if [[ ${#jdk_files[@]} -eq 0 || -z "$python_versions_file" ]]; then
    echo "Usage: $0 --jdk-versions open-jdk-versions.txt --jdk-versions sdk-jdk-versions.txt --python-versions python-versions.txt"
    exit 1
fi

# Get the absolute path of the Python versions file
python_versions_file=$(realpath "$python_versions_file")

# Iterate through each provided JDK version file
for jdk_file in "${jdk_files[@]}"; do
    if [[ ! -f "$jdk_file" ]]; then
        echo "File $jdk_file not found!"
        continue
    fi

    # Read each JDK directory from the file and install deephaven-server in each Python virtual environment
    while IFS= read -r jdk_dir; do
        if [[ -d "$jdk_dir" ]]; then
            install_deephaven "$jdk_dir" "$python_versions_file"
        else
            echo "Directory $jdk_dir does not exist."
        fi
    done < "$jdk_file"
done

echo "Deephaven server installation complete in all virtual environments."



