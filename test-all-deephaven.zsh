#!/bin/zsh

# Ensure at least one JDK versions file and one Python versions file are provided
if [[ $# -lt 4 ]]; then
    echo "Usage: $0 --jdk-versions <jdk_versions_files...> --python-versions <python_versions_files...>"
    exit 1
fi

# Parse arguments
jdk_files=()
python_files=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --jdk-versions)
            shift
            while [[ $# -gt 0 && "$1" != --* ]]; do
                jdk_files+=("$1")
                shift
            done
            ;;
        --python-versions)
            shift
            while [[ $# -gt 0 && "$1" != --* ]]; do
                python_files+=("$1")
                shift
            done
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

# Ensure at least one file is provided for each type
if [[ ${#jdk_files[@]} -eq 0 || ${#python_files[@]} -eq 0 ]]; then
    echo "Usage: $0 --jdk-versions <jdk_versions_files...> --python-versions <python_versions_files...>"
    exit 1
fi

# Check for and remove existing run_results.txt file in the top-level directory
results_file="run_results.txt"
if [[ -f "$results_file" ]]; then
    echo "Removing existing $results_file"
    rm "$results_file"
fi

# Read JDK versions from the specified files
jdk_versions=()
for jdk_file in "${jdk_files[@]}"; do
    if [[ -f "$jdk_file" ]]; then
        while IFS= read -r line; do
            [[ -n "$line" ]] && jdk_versions+=("$line")
        done < "$jdk_file"
    else
        echo "File $jdk_file not found!"
    fi
done

# Read Python versions from the specified files
python_versions=()
for python_file in "${python_files[@]}"; do
    if [[ -f "$python_file" ]]; then
        while IFS= read -r line; do
            [[ -n "$line" ]] && python_versions+=("$line")
        done < "$python_file"
    else
        echo "File $python_file not found!"
    fi
done

# Ensure the test-deephaven script is executable
if [[ ! -x "./test-deephaven.zsh" ]]; then
    echo "The script test-deephaven.zsh is not executable or not found!"
    exit 1
fi

# Create the results file and add the header
echo "JDKVersion,PythonVersion,Result" > "$results_file"

# Iterate through each combination of JDK and Python versions
for jdk_version in "${jdk_versions[@]}"; do
    for python_version in "${python_versions[@]}"; do
        echo "Testing JDK version $jdk_version with Python version $python_version"
        ./test-deephaven.zsh "$jdk_version" "$python_version"
    done
done

echo "All tests completed."


