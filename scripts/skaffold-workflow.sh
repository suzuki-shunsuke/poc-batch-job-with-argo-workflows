#!/usr/bin/env bash

set -eu

cd "$(dirname "$0/")/.."

workflow_dir="workflow/$WORKFLOW_NAME"
workflow_file="$workflow_dir/workflow.yaml"

mkdir -p "$workflow_dir"
base=$(basename "$WORKFLOW_NAME")
sed "s/\${NAME}/$base/g" template/workflow.yaml > "$workflow_file"
mkdir "$workflow_dir/log"
echo "Generate $workflow_file"
