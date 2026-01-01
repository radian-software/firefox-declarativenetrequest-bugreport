#!/usr/bin/env bash

set -euo pipefail

rm -f *.xpi
for dir in ext-*; do (
    cd "${dir}"
    zip "../${dir}.xpi" *
); done
