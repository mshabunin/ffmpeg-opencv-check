#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

pushd "${SCRIPT_DIR}/.."
mkdir -p cache
mkdir -p workdir
popd
