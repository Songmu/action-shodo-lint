# action-template

[![Test](https://github.com/Songmu/action-shodo-lint/workflows/Test/badge.svg)](https://github.com/Songmu/action-shodo-lint/actions?query=workflow%3ATest)
[![reviewdog](https://github.com/Songmu/action-shodo-lint/workflows/reviewdog/badge.svg)](https://github.com/Songmu/action-shodo-lint/actions?query=workflow%3Areviewdog)
[![depup](https://github.com/Songmu/action-shodo-lint/workflows/depup/badge.svg)](https://github.com/Songmu/action-shodo-lint/actions?query=workflow%3Adepup)
[![release](https://github.com/Songmu/action-shodo-lint/workflows/release/badge.svg)](https://github.com/Songmu/action-shodo-lint/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Songmu/action-shodo-lint?logo=github&sort=semver)](https://github.com/Songmu/action-shodo-lint/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

## Input

```yaml
inputs:
  github_token:
    description: 'GITHUB_TOKEN'
    default: '${{ github.token }}'
  workdir:
    description: 'Working directory relative to the root directory.'
    default: '.'
  ### Flags for reviewdog ###
  level:
    description: 'Report level for reviewdog [info,warning,error]'
    default: 'error'
  reporter:
    description: 'Reporter of reviewdog command [github-pr-check,github-check,github-pr-review].'
    default: 'github-pr-check'
  filter_mode:
    description: |
      Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
      Default is added.
    default: 'added'
  fail_on_error:
    description: |
      Exit code for reviewdog when errors are found [true,false]
      Default is `false`.
    default: 'false'
  reviewdog_flags:
    description: 'Additional reviewdog flags'
    default: ''
  ### Flags for shodo ###
  api_token:
    description: 'api token'
    required: true
  api_root:
    description: 'api root'
    required: true
  base_commitish:
    description: 'base commitish'
    default: ''
  limit:
    description: 'maximum files'
    default: '10'
```

## Usage
<!-- TODO: update. replace `template` with the linter name -->

```yaml
name: reviewdog
on: [pull_request]
jobs:
  shodo:
    name: runner / shodo
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: Songmu/action-shodo-lint@v1
        with:
          github_token: ${{ secrets.github_token }}
          # Change reviewdog reporter if you need [github-pr-check,github-check,github-pr-review].
          reporter: github-pr-review
          # Change reporter level if you need.
          # GitHub Status Check won't become failure with warning.
          level: warning
```

## Development

### Release

#### [haya14busa/action-bumpr](https://github.com/haya14busa/action-bumpr)
You can bump version on merging Pull Requests with specific labels (bump:major,bump:minor,bump:patch).
Pushing tag manually by yourself also work.

#### [haya14busa/action-update-semver](https://github.com/haya14busa/action-update-semver)

This action updates major/minor release tags on a tag push. e.g. Update v1 and v1.2 tag when released v1.2.3.
ref: https://help.github.com/en/articles/about-actions#versioning-your-action

### Dependencies Update Automation
This repository uses [reviewdog/action-depup](https://github.com/reviewdog/action-depup) to update
reviewdog version.

[![reviewdog depup demo](https://user-images.githubusercontent.com/3797062/73154254-170e7500-411a-11ea-8211-912e9de7c936.png)](https://github.com/Songmu/action-shodo-lint/pull/6)
