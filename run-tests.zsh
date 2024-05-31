# Install openJDK distributions via Homebrew
chmod +x install-open-jdk-versions.zsh
./install-open-jdk-versions.zsh open-jdk-versions.txt

# Install all other JDK distributions via SDKMAN
chmod +x install-sdk-jdk-versions.zsh
./install-sdk-jdk-versions.zsh sdk-jdk-versions.txt

# Install all Python versions via pyenv
chmod +x install-python-versions.zsh
./install-python-versions.zsh python-versions.txt

# Create JDK directories based on version files
chmod +x create-dirs.zsh
./create-dirs.zsh open-jdk-versions.txt sdk-jdk-versions.txt

# Populate each JDK directory with .sdkmanrc environment file to specify version
chmod +x populate-sdkmanrc.zsh
./populate-sdkmanrc.zsh open-jdk-versions.txt sdk-jdk-versions.txt

# Iterate through JDK directories and create Python venvs for each Python version
chmod +x create-venvs.zsh
./create-venvs.zsh --jdk-versions open-jdk-versions.txt --jdk-versions sdk-jdk-versions.txt --python-versions python-versions.txt

# Install Deephaven in each venv for each JDK version (takes a long, long time)
chmod +x install-deephaven.zsh
./install-deephaven.zsh --jdk-versions open-jdk-versions.txt --jdk-versions sdk-jdk-versions.txt --python-versions python-versions.txt

# Test every Deephaven installation and record results to `run_results.txt`
chmod +x test-all-deephaven.zsh
./test-all-deephaven.zsh --jdk-versions open-jdk-versions.txt --jdk-versions sdk-jdk-versions.txt --python-versions python-versions.txt

