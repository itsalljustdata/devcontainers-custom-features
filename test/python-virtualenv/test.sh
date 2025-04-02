#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'hello' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# Eg:
# {
#    "image": "<..some-base-image...>",
#    "features": {
#      "hello": {}
#    },
#    "remoteUser": "root"
# }
#
# Thus, the value of all options will fall back to the default value in
# the Feature's 'devcontainer-feature.json'.
# For the 'hello' feature, that means the default favorite greeting is 'hey'.
#
# These scripts are run as 'root' by default. Although that can be changed
# with the '--remote-user' flag.
#
# This test can be run with the following command:
#
#    devcontainer features test \
#                   --features hello   \
#                   --remote-user root \
#                   --skip-scenarios   \
#                   --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
#                   /path/to/this/repo

set -e

# Optional: Import test library bundled with the devcontainer CLI
# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib. Syntax is...
# check <LABEL> <cmd> [args...]

check "this File" echo "$0"
check "venv location" echo "VENVLOCATION : $VENVLOCATION"

if [ "$VENVLOCATION" == "$VENVLOCATION" ]; then
    echo -e "(!) No VirtualEnv location specified."
    VENVLOCATION=$(find / -type d -name ".venv" 2>/dev/null | head -n 1)
fi


if [ "$VENVLOCATION" == "" ]; then
    echo -e "(!) No VirtualEnv location specified."
else
    check "venv location" echo "VENVLOCATION : $VENVLOCATION"
    check "python" which python3
    check "python is available" python3 --version
    check "activate venv" source ${VENVLOCATION}/bin/activate
    check "VIRTUAL_ENV" echo $VIRTUAL_ENV
    check "python" which python3
    check "python is available" python3 --version
    check "pip list" pip list
fi


# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults