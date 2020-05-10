#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$(dirname "$0/")/.."

if [ "$(bash ci/submit-workflow/get-workflows.sh | wc -l)" != 1 ]; then
  echo "the number of workflows must be 1" >&2
  exit 1
fi

parameter="$(bash ci/submit-workflow/get-workflows.sh)"
workflow="$(bash ci/submit-workflow/get_workflow_from_parameter_file.sh)"
bash ci/submit-workflow/run-workflow.sh "$workflow" "$parameter"
