#!/bin/bash -i
set -ex

VENVLOCATION=${VENVLOCATION:-"~/.venv"}
REQUIREMENTSFILE=${REQUIREMENTSFILE:-""}
VENVPROMPT=${VENVPROMPT:-""}
INCLUDESETUPTOOLS=${INCLUDESETUPTOOLS:-"False"}


if [ "$(id -u)" -ne 0 ]; then
  echo -e 'Script must be run as
    root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
  exit 1
elif [ -z "$VENVLOCATION" ]; then
  echo -e "(!) No VirtualEnv location specified."
  exit 1
elif [ -z "$REQUIREMENTSFILE" ]; then
  echo -e "(!) No requirements file specified."
  exit 1
elif [ ! -f "$REQUIREMENTSFILE" ]; then
  echo -e "(!) Requirements file $REQUIREMENTSFILE not found."
  exit 1
fi

if [ -d "$VENVLOCATION" ]; then
  echo -e "(!) VirtualEnv location $VENVLOCATION already exists. Deleting..."
  rm -Rf "$VENVLOCATION"
  echo -e "(i) Deleted $VENVLOCATION."
fi

parentdir=$(dirname "$VENVLOCATION")
if [ ! -d "$parentdir" ]; then
  echo -e "(i) Creating parent directory $parentdir."
  mkdir -p "$parentdir"
  echo -e "(i) Created $parentdir."
fi

if [ "$INCLUDESETUPTOOLS" = "True" ]; then
  virtualenv -q --clear --prompt "${VENVPROMPT}" "${VENVLOCATION}"
else
  virtualenv -q --clear --no-setuptools --prompt "${VENVPROMPT}" "${VENVLOCATION}"
fi