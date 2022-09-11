#!/bin/bash
set -e

cd "${GITHUB_WORKSPACE}" || exit 1

if [[ -z "$INPUT_BASE_BRANCH" ]]; then
  INPUT_BASE_BRANCH=$(git remote show origin | grep 'HEAD branch:' | cut -d' ' -f5)
fi

files=$(git diff "origin/$INPUT_BASE_BRANCH" --name-only --diff-filter=ACMR --relative "$INPUT_DIR" | grep '.md$' | head -"$INPUT_LIMIT")
if [[ -z "$files" ]]; then
  exit
fi

TEMP_PATH="$(mktemp -d)"
PATH="${TEMP_PATH}:$PATH"

echo '::group::🐶 Installing reviewdog ... https://github.com/reviewdog/reviewdog'
curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b "$TEMP_PATH" "${REVIEWDOG_VERSION}" 2>&1
echo '::endgroup::'

echo '::group:: Installing goshodo ... https://github.com/Songmu/goshodo'
curl -sfL https://raw.githubusercontent.com/Songmu/goshodo/main/install.sh | sh -s -- -b "$TEMP_PATH" 2>&1
echo '::endgroup::'

export REVIEWDOG_GITHUB_API_TOKEN="${GITHUB_TOKEN}"

echo "$files" | xargs goshodo lint -f checkstyle | \
  reviewdog -f="checkstyle" \
      -name="shodo" \
      -reporter="${INPUT_REPORTER}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      -diff="git diff origin/${INPUT_BASE_BRANCH}" \
      ${INPUT_REVIEWDOG_FLAGS}
