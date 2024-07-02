<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->

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
