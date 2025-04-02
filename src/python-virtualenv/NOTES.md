<!-- markdownlint-disable MD041 -->

## About this Feature

This feature is designed to create a Python virtualenv

## Notes

### Usage

```json
"features": {
    "ghcr.io/itsalljustdata/devcontainers-custom-features/python-virtualenv:1": {
        "venvLocation": "",
        "requirementsFile": "",
        "includeSetupTools": false
    }
}
```

#### Defaults

* venvLocation

If this is not supplied (or is empty) it will be assumed to be `${containerWorkspaceFolder}/.venv`.

Note that if you look at the code, it actually uses `$CWD/.venv` - because `$containerWorkspaceFolder` is not available during the `postCreateCommand` when this runs. All things being equal though, $CWD will be `$containerWorkspaceFolder`

* requirementsFile

If this is not supplied (or is empty) it will be assumed to be `${containerWorkspaceFolder}/requirements.txt`.

As per `venvlocation` the code actually references `$CWD` instead of `$containerWorkspaceFolder`

If you supply a value and there is no corresponding file of that name, the feature will attempt to `touch` that file to create an empty file.


## Credits


## Supported Linux Versions

This feature is tested and supported on Debian and Ubuntu-based development containers. It may work on other Linux versions, but is currently untested.
