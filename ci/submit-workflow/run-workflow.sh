#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$(dirname "$0/")/../.."

workflow="$1"
parameter="$2"

if [ -n "${ARGO_TOKEN:-}" ]; then
  alias argo='argo --token "$ARGO_TOKEN"'
fi

name=$(argo submit "$workflow" --parameter-file "$parameter" -o json | jq -r ".metadata.name")
trap 'argo terminate "$name"' INT TERM
argo logs --follow --timestamps "$name"
phase="$(argo get -o json "$name" | jq -r ".status.phase")"
if [ "$phase" = "Failed" ]; then
  exit 1
fi
