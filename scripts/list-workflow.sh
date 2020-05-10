#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")/.."

find workflow -name workflow.yaml | sed "s/^workflow\/\(.*\)\/workflow\.yaml$/\1/"
