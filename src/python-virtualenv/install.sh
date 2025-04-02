#!/bin/bash
set -ex

DEFAULT_VENVLOCATION=$(realpath "$PWD/.venv")

# VENVLOCATION=${VENVLOCATION:-$DEFAULT_VENVLOCATION}
# REQUIREMENTSFILE=${REQUIREMENTSFILE:-""}
# VENVPROMPT=${VENVPROMPT:-""}
# INCLUDESETUPTOOLS=${INCLUDESETUPTOOLS:-"False"}

if [ "$VENVLOCATION" == "" ]; then
  VENVLOCATION="$DEFAULT_VENVLOCATION"
  echo -e "(!) No VirtualEnv location specified."
  echo -e "(i) Using default location $VENVLOCATION."
fi

parentdir=$(dirname "$VENVLOCATION")
echo -e "(i) Parent directory is $parentdir."

pip install --upgrade pip

if [ "$REQUIREMENTSFILE" == "" ]; then
  echo -e "(!) No requirements file specified. Continuing without it."
elif [ ! -f "$REQUIREMENTSFILE" ]; then
  echo -e "(!) Requirements file $REQUIREMENTSFILE not found."
  touch "$REQUIREMENTSFILE"
fi

if [ ! -d "$parentdir" ]; then
  echo -e "(i) Creating parent directory $parentdir."
  mkdir -p "$parentdir"
  echo -e "(i) Created $parentdir."
elif [ -d "$VENVLOCATION" ]; then
  echo -e "(!) VirtualEnv location $VENVLOCATION already exists. Deleting..."
  rm -Rf "$VENVLOCATION"
  echo -e "(i) Deleted $VENVLOCATION."
fi

if [ "$INCLUDESETUPTOOLS" = "True" ]; then
  virtualenv -q --clear --prompt "${VENVPROMPT}" "${VENVLOCATION}"
else
  virtualenv -q --clear --no-setuptools --prompt "${VENVPROMPT}" "${VENVLOCATION}"
fi

source "$VENVLOCATION/bin/activate"
echo -e "(i) Activated virtualenv $VENVLOCATION."
echo -e "(i) $(which python3) $(python3 --version)"

if [ "$REQUIREMENTSFILE" != "" ]; then
  echo -e "(i) Installing requirements from $REQUIREMENTSFILE."
  pip install -r "$REQUIREMENTSFILE"
else
  echo -e "(i) No requirements file specified."
fi
