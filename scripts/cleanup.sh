#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

pushd "${SCRIPT_DIR}/.."
rm -rf workdir
./scripts/init.sh
popd
