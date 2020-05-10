#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$(dirname "$0/")/../.."

parameter_file="$1"
echo "$(dirname "$(dirname "$parameter_file")")/workflow.yaml"
