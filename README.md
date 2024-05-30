This test suite requires [`SDKMAN!`](https://sdkman.io/install) for managing JDK versions, and [`pyenv`](https://github.com/pyenv/pyenv) for managing Python versions. Follow the installation guides at those links for MacOS to get started - you should [install `pyenv` with Homebrew](https://github.com/pyenv/pyenv?tab=readme-ov-file#homebrew-in-macos).


Then, run these tests as follows:

1. Add the following lines to your `.zshrc` profile:

   ```
   export PYENV_ROOT="$HOME/.pyenv"
   export PATH="$PYENV_ROOT/shims:$PATH"

   if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
   ```

   _You must then restart your shell for these changes to take effect._

2. Clone and navigate this repo
   
   `git clone https://github.com/alexpeters1208/test-dh-mac.git`

   `cd test-dh-mac`

3. Make the test script executable and run

   `chmod +x run-tests.zsh`

   `./run-tests.zsh`

This might take a while (15 - 30 minutes). The results will be written to a new file called `run_results.txt`.
