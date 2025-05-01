<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->

# mockr 0.2.1.9900 (2025-05-01)

## Bug fixes

- Avoid rendering vignette with usethis missing.

- More careful querying of functions to be mocked, to avoid errors for `.onLoad()` when testing interactively (#29).

## Chore

- IDE.

- Auto-update from GitHub Actions.

  Run: https://github.com/krlmlr/mockr/actions/runs/14636209657

  Run: https://github.com/krlmlr/mockr/actions/runs/10425483613

  Run: https://github.com/krlmlr/mockr/actions/runs/10200110623

  Run: https://github.com/krlmlr/mockr/actions/runs/9727974092

  Run: https://github.com/krlmlr/mockr/actions/runs/9691618001

- Bump.

- Change maintainer e-mail address.

## Continuous integration

- Permissions, better tests for missing suggests, lints (#54).

- Only fail covr builds if token is given (#53).

- Always use `_R_CHECK_FORCE_SUGGESTS_=false` (#52).

- Correct installation of xml2 (#51).

- Explain (#50).

- Add xml2 for covr, print testthat results (#49).

- Fix (#48).

- Sync (#47).

- Avoid failure in fledge workflow if no changes (#46).

- Fetch tags for fledge workflow to avoid unnecessary NEWS entries (#45).

- Use larger retry count for lock-threads workflow (#44).

- Ignore errors when removing pkg-config on macOS (#43).

- Explicit permissions (#42).

- Use styler from main branch (#41).

- Need to install R on Ubuntu 24.04 (#40).

- Use Ubuntu 24.04 and styler PR (#38).

- Correctly detect branch protection (#37).

- Use stable pak (#36).

- Trigger run (#35).

  - ci: Trigger run

  - ci: Latest changes

- Use pkgdown branch (#34).

  - ci: Use pkgdown branch

  - ci: Updates from duckdb

- Install via R CMD INSTALL ., not pak (#33).

  - ci: Install via R CMD INSTALL ., not pak

  - ci: Bump version of upload-artifact action

- Install local package for pkgdown builds.

- Improve support for protected branches with fledge.

- Improve support for protected branches, without fledge.

- Sync with latest developments.

- Use v2 instead of master.

- Inline action.

- Use dev roxygen2 and decor.

- Fix on Windows, tweak lock workflow.

- Avoid checking bashisms on Windows.

- Better commit message.

- Bump versions, better default, consume custom matrix.

- Recent updates.

## Documentation

- Relicense as MIT.

## Uncategorized

- PLACEHOLDER https://github.com/krlmlr/mockr/pull/16 (#16).

- Internal changes only.

- Merged cran-0.2.1 into main.

- Same as previous version.


# mockr 0.2.1 (2023-01-30)

## Bug fixes

- More careful querying of functions to be mocked, to avoid errors for `.onLoad()` when testing interactively (#29).

## Chore

- Change maintainer e-mail address.


# mockr 0.2.0 (2022-04-02)

## Breaking changes

- `with_mock()` now requires braces (so that error locations can be reported more accurately) and supports only one expression (#15).

## Features

- Functions declared in evaluation environments are now also replaced, with a warning (#5).
- New `local_mock()` (#6).
- `with_mock()` works when running a `testthat::test_that()` block interactively (#7).
- New `get_mock_env()` to make the mocking environment explicit (#7).
- Functions that start with a dot can be mocked (#3, #4).


## Documentation

- Add "Getting started" vignette (#22).

## Internal

- Switch to rlang (#13).
- Switch to GitHub Actions (#10).


# mockr 0.1 (2017-04-28)

Initial CRAN release.

- `with_mock()` modeled closely after `testthat::with_mock()`, can only mock in the package under test but avoids fiddling with R's internals.
    - The `.env` argument now can be a character, but using this argument may lead to different results than `testthat::with_mock()`.
