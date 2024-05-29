#!/bin/zsh

# Function to create Python virtual environments for each version
create_venvs() {
    local jdk_dir=$1
    local py_versions_file=$2

    cd "$jdk_dir" || return

    while IFS= read -r py_version; do
        if [[ -n "$py_version" ]]; then
            pyenv local "$py_version"
            python -m venv "$py_version-venv"
            echo "Created virtual environment for Python $py_version in $jdk_dir"
        fi
    done < "$py_versions_file"

    cd - > /dev/null || return
}

# Parse arguments
jdk_files=()
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

# Check if the Python versions file exists
if [[ ! -f "$python_versions_file" ]]; then
    echo "File $python_versions_file not found!"
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

    # Read each JDK directory from the file and create Python virtual environments
    while IFS= read -r jdk_dir; do
        if [[ -d "$jdk_dir" ]]; then
            create_venvs "$jdk_dir" "$python_versions_file"
        else
            echo "Directory $jdk_dir does not exist."
        fi
    done < "$jdk_file"
done

echo "All virtual environments created successfully."



