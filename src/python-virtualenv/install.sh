#!/bin/bash
set -e

for pipsy in "--upgrade pip" "virtualenv"; do
  pip install --quiet --root-user-action ignore $pipsy
done

SETUP_VENV_SCRIPT_PATH="/usr/local/share/setup-virtualenv.sh"

env | tee "${SETUP_VENV_SCRIPT_PATH}.txt"

echo -e "(i) Creating setup-virtualenv script at $SETUP_VENV_SCRIPT_PATH."
tee "$SETUP_VENV_SCRIPT_PATH" > /dev/null \
<< EOF
#!/bin/bash

set -ex

env | tee "~/$(basename $0).txt"

VENV_LOCATION='${VENVLOCATION}'
REQUIREMENTS_FILE='${REQUIREMENTSFILE}'
INCLUDE_SETUPTOOLS=${INCLUDESETUPTOOLS}

EOF

tee -a "$SETUP_VENV_SCRIPT_PATH" > /dev/null \
<< 'EOF'

if [ -z $VENV_LOCATION ]; then
  echo -e "(!) No VirtualEnv location specified."
  VENV_LOCATION=${containerWorkspaceFolder}/.venv
fi

if [ -z $REQUIREMENTS_FILE ]; then
  echo -e "(!) No requirements file specified."
  REQUIREMENTS_FILE=${containerWorkspaceFolder}/requirements.txt
fi

parentdir=$(dirname "$VENV_LOCATION")
echo -e "(i) Parent directory is $parentdir."

if [ ! -f "$REQUIREMENTS_FILE" ]; then
  echo -e "(!) Requirements file '$REQUIREMENTS_FILE' not found."
  requirementsdir=$(dirname "$REQUIREMENTS_FILE")
  if [ ! -d "$requirementsdir" ]; then
    echo -e "(i) Creating directory '$requirementsdir'."
    mkdir -p "$requirementsdir"
    echo -e "(i) Created '$requirementsdir'."
  fi
  touch "$REQUIREMENTS_FILE"
fi

if [ ! -d "$parentdir" ]; then
  echo -e "(i) Creating parent directory '$parentdir'."
  mkdir -p "$parentdir"
  echo -e "(i) Created '$parentdir'."
elif [ -d "$VENV_LOCATION" ]; then
  echo -e "(!) VirtualEnv location $VENV_LOCATION already exists. Deleting..."
  rm -Rf "$VENV_LOCATION"
  echo -e "(i) Deleted $VENV_LOCATION."
fi

if [ "$INCLUDE_SETUPTOOLS" = "True" ]; then
  virtualenv -q --clear "${VENV_LOCATION}"
else
  virtualenv -q --clear --no-setuptools "${VENV_LOCATION}"
fi

echo -e "(i) Activating virtualenv $VENV_LOCATION."
ACTIVATE_PATH="$(realpath "$VENV_LOCATION")/bin/activate"
source "${ACTIVATE_PATH}"
echo -e "(i) Activated virtualenv $VENV_LOCATION."
echo -e "(i) $(which python3) $(python3 --version)"

if [ ! -z $REQUIREMENTS_FILE ]; then
  echo -e "(i) Installing requirements from $REQUIREMENTS_FILE."
  pip install -r "$REQUIREMENTS_FILE"
else
  echo -e "(i) No requirements file specified."
fi

proFiles=( "$HOME/.bash_profile" "$HOME/.bashrc" "$HOME/.zprofile" "$HOME/.profile" )
for proFile in "${proFiles[@]}"; do

  if [ -f "$proFile" ]; then
    echo -e "(i) Found profile file $proFile."
    if grep -q "$ACTIVATE_PATH" "$proFile"; then
      echo -e "(!) venv activation already in $proFile. Skipping."
      continue
  fi

  echo -e "(i) venv activation not in $proFile. Adding it."
  echo "source "$ACTIVATE_PATH"" | tee -a "$proFile" > /dev/null 2>&1

done

EOF

chmod 755 "$SETUP_VENV_SCRIPT_PATH"


