#!/bin/zsh

# Ensure two arguments are provided
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <JDKVersion> <PythonVersion>"
    exit 1
fi

# Assign arguments to variables
jdk_version=$1
python_version=$2

# Set results file
results_file="../run_results.txt"

# Navigate to the JDK directory
cd "$jdk_version" || { echo "Directory $jdk_version not found!"; exit 1; }

# Initialize SDKMAN
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Execute sdk env command
sdk env

# Activate the Python virtual environment
source "$python_version-venv/bin/activate" || { echo "Failed to activate Python environment $python_version"; exit 1; }

# Run the test
{
    echo "from deephaven_server import Server" > test_script.py
    echo "s = Server()" >> test_script.py
    echo "s.start()" >> test_script.py
    echo "s.shutdown()" >> test_script.py
    timeout 15 python3 test_script.py
} && result="PASS" || result="FAIL"

# Record the result
echo "$jdk_version,$python_version,$result" >> "$results_file"

# Clean up
rm test_script.py
deactivate
cd - > /dev/null

echo "Test completed. Result: $result"

