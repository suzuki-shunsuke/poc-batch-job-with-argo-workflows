#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$(dirname "$0")/.."

if [ -z "${WORKFLOW_NAME:-}" ]; then
  if command -v fzf > /dev/null 2>&1; then
    WORKFLOW_NAME=$(bash scripts/list-workflow.sh | fzf)
    test -n "${WORKFLOW_NAME:-}" || exit 1
  elif command -v peco > /dev/null 2>&1; then
    WORKFLOW_NAME=$(bash scripts/list-workflow.sh | peco)
    test -n "${WORKFLOW_NAME:-}" || exit 1
  fi
fi

workflow_dir="workflow/$WORKFLOW_NAME"
workflow_file="$workflow_dir/workflow.yaml"
template_file="$workflow_dir/parameter.yaml"
log_dir="$workflow_dir/log"
parameter_file="$log_dir/$(date +%Y%m%d%H%M%S%Z).yaml"

if [ ! -f "$workflow_file" ]; then
  echo "$workflow_file isn't found" >&2
  exit 1
fi

if ! command -v git > /dev/null 2>&1; then
  echo "git is required" >&2
  exit 1
fi

if ! command -v gh > /dev/null 2>&1; then
  echo "gh is required: https://cli.github.com/" >&2
  exit 1
fi

BRANCH="$(git branch | grep "^\* " | sed -e "s/^\* \(.*\)/\1/")"
if [ "$BRANCH" != "master" ]; then
  read -r -p "The current branch isn't master but $BRANCH. Are you ok? (y/n)" YN
  if [ "${YN}" != "y" ]; then
    exit 0
  fi
fi

mkdir -p "$log_dir"
if [ -f "$template_file" ]; then
  cp "template_file" "$parameter_file"
else
  touch "$parameter_file"
fi

${EDITOR:-vi} "$parameter_file"

read -r -p "Do you create a pull request? (y/n)" YN
if [ "${YN}" != "y" ]; then
  exit 0
fi

git checkout -b "$parameter_file"
git add "$parameter_file"
git commit -m "Run $WORKFLOW_NAME"
git push origin "$parameter_file"

gr pr create -t "Run $WORKFLOW_NAME" -w -f
