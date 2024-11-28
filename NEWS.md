<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->

# mockr 0.2.1.9025 (2024-11-28)

## Continuous integration

- Ignore errors when removing pkg-config on macOS (#43).


# mockr 0.2.1.9024 (2024-11-27)

## Continuous integration

- Explicit permissions (#42).


# mockr 0.2.1.9023 (2024-11-26)

## Continuous integration

- Use styler from main branch (#41).


# mockr 0.2.1.9022 (2024-11-25)

## Continuous integration

- Need to install R on Ubuntu 24.04 (#40).

- Use Ubuntu 24.04 and styler PR (#38).

## Uncategorized

- PLACEHOLDER https://github.com/krlmlr/mockr/pull/16 (#16).


# mockr 0.2.1.9021 (2024-11-22)

## Continuous integration

  - Correctly detect branch protection (#37).


# mockr 0.2.1.9020 (2024-11-18)

## Continuous integration

  - Use stable pak (#36).


# mockr 0.2.1.9019 (2024-11-11)

## Continuous integration

  - Trigger run (#35).
    
      - ci: Trigger run
    
      - ci: Latest changes


# mockr 0.2.1.9018 (2024-10-28)

## Continuous integration

  - Use pkgdown branch (#34).
    
      - ci: Use pkgdown branch
    
      - ci: Updates from duckdb
    
      - ci: Trigger run


# mockr 0.2.1.9017 (2024-09-15)

## Continuous integration

  - Install via R CMD INSTALL ., not pak (#33).
    
      - ci: Install via R CMD INSTALL ., not pak
    
      - ci: Bump version of upload-artifact action


# mockr 0.2.1.9016 (2024-08-31)

## Continuous integration

  - Install local package for pkgdown builds.

  - Improve support for protected branches with fledge.

  - Improve support for protected branches, without fledge.


# mockr 0.2.1.9015 (2024-08-17)

## Chore

- Auto-update from GitHub Actions.

  Run: https://github.com/krlmlr/mockr/actions/runs/10425483613

## Continuous integration

- Sync with latest developments.


# mockr 0.2.1.9014 (2024-08-10)

## Continuous integration

- Use v2 instead of master.


# mockr 0.2.1.9013 (2024-08-06)

## Continuous integration

- Inline action.


# mockr 0.2.1.9012 (2024-08-02)

## Chore

- Auto-update from GitHub Actions.

  Run: https://github.com/krlmlr/mockr/actions/runs/10200110623

## Continuous integration

- Use dev roxygen2 and decor.


# mockr 0.2.1.9011 (2024-07-02)

## Continuous integration

- Fix on Windows, tweak lock workflow.


# mockr 0.2.1.9010 (2024-06-30)

## Chore

- Auto-update from GitHub Actions.

  Run: https://github.com/krlmlr/mockr/actions/runs/9727974092


# mockr 0.2.1.9009 (2024-06-28)

## Chore

- Auto-update from GitHub Actions.

  Run: https://github.com/krlmlr/mockr/actions/runs/9691618001

## Continuous integration

- Avoid checking bashisms on Windows.

- Better commit message.

- Bump versions, better default, consume custom matrix.

- Recent updates.


# mockr 0.2.1.9008 (2024-05-28)

## Chore

- Bump.


# mockr 0.2.1.9007 (2024-04-03)

- Internal changes only.


# mockr 0.2.1.9006 (2023-10-10)

## Bug fixes

- Avoid rendering vignette with usethis missing.


# mockr 0.2.1.9005 (2023-10-09)

- Internal changes only.


# mockr 0.2.1.9004 (2023-03-24)

- Internal changes only.


# mockr 0.2.1.9003 (2023-02-17)

- Internal changes only.


# mockr 0.2.1.9002 (2023-02-02)

- Merged cran-0.2.1 into main.



# mockr 0.2.1.9001 (2023-01-30)

- Same as previous version.


# mockr 0.2.1.9000 (2023-01-30)

## Bug fixes

- More careful querying of functions to be mocked, to avoid errors for `.onLoad()` when testing interactively (#29).

## Chore

- Change maintainer e-mail address.


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
