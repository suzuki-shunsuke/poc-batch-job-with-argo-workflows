#!/usr/bin/env bash

# require: $GITHUB_TOKEN
# require: $OWNER
# require: $REPO
# require: $SHA1

# require: curl
# require: jq

set -eu
set -o pipefail

cd "$(dirname "$0/")/.."

get_prs() {
  curl -H "Accept: application/vnd.github.groot-preview+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/repos/$OWNER/$REPO/commits/$SHA1/pulls"
}

get_pr_files() {
  curl -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/repos/$OWNER/$REPO/pulls/$pr_number/files" |
  jq -r ".[].filename"
}

num_pr="$(get_prs | jq ". | length")"
if [ "$num_pr" = "1" ]; then
  echo "the number of associated pull requests must be 1" >&2
  exit 1
fi

pr_number=$(get_prs | jq -r ".[0].number")

get_pr_files | grep -E "^workflow/.*/log/.*\.yaml$"
