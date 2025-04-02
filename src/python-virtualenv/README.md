
# Python Virtualenv (python-virtualenv)

A feature to install create and configure a Python virtualenv.

## Example Usage

```json
"features": {
    "ghcr.io/itsalljustdata/devcontainers-custom-features/python-virtualenv:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| venvLocation | The fully qualified location of the virtualenv to create. Will default to ${containerWorkspaceFolder}/.venv file if not set. | string | - |
| requirementsFile | A fully-qualified path to a requirements.txt file inside the container which will be installed. Will default to ${containerWorkspaceFolder}/requirements.txt file if not set. | string | - |
| includeSetupTools | Whether to include setuptools in the virtualenv. | boolean | false |

<!-- markdownlint-disable MD041 -->

## About this Feature

This feature is designed to create a Python virtualenv

## Notes



## Credits


## Supported Linux Versions

This feature is tested and supported on Debian and Ubuntu-based development containers. It may work on other Linux versions, but is currently untested.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/itsalljustdata/devcontainers-custom-features/blob/main/src/python-virtualenv/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
