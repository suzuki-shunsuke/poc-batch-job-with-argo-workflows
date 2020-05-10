#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")/.."

workflow_dir="workflow/$WORKFLOW_NAME"
workflow_file="$workflow_dir/workflow.yaml"
template_file="$workflow_dir/parameter.yaml"
log_dir="$workflow_dir/log"
parameter_file="$log_dir/$(date +%Y%m%d%H%M%S%Z).yaml"

if [ ! -f "$workflow_file" ]; then
  echo "$workflow_file isn't found" >&2
  exit 1
fi

mkdir -p "$log_dir"
if [ -f "$template_file" ]; then
  cp "template_file" "$parameter_file"
else
  touch "$parameter_file"
fi

${EDITOR:-vi} "$parameter_file"
