<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->

# mockr 0.2.2.9017 (2026-08-08)

## Continuous integration

- Wrap the commit status update into an action.

- Route ccache through one-word compiler wrappers on Unix.

- Name every step and restore the log entry `setup-pandoc` swallows.


# mockr 0.2.2.9016 (2026-08-06)

## Continuous integration

- Add sharded `revdep2` workflow.

## Uncategorized

- Ci: Harden `workflow_run` workflows against untrusted pull requests (#106).

- Ci: Pin third-party actions to commits and let Renovate keep them pinned (#105).


# mockr 0.2.2.9015 (2026-08-05)

## Chore

- Auto-update from GitHub Actions (#95).

## Continuous integration

- Remove unused pr-commands workflow.

## Uncategorized

- Ci: Give every workflow and job an explicit `permissions` block (#103).

- Ci: Pass workflow context through the environment, not into script text (#102).

- Ci: Add a Windows arm64 (`windows-11-arm`) check on R-release (#99).


# mockr 0.2.2.9014 (2026-07-28)

- Ci: Run all smoke-test checks even when one fails (#97).

- Ci: Apply matrix `env` vars in the workflow, not in custom actions (#95).

- Ci: Link the responsible workflow run in snapshot update PRs (#96).


# mockr 0.2.2.9013 (2026-07-25)

## Continuous integration

- Lock down `format-suggest` egress (audit → block).


# mockr 0.2.2.9012 (2026-07-24)

## Bug fixes

### ci

- Emit empty package matrix when there are no (rev)deps.

## Uncategorized

- Ci: Harden `format-suggest` against `pull_request_target` pwn requests (#93).


# mockr 0.2.2.9011 (2026-07-22)

## Continuous integration

- Run on Ubuntu 26.04.

- Align workflows with template.


# mockr 0.2.2.9010 (2026-05-24)

## Continuous integration

- Update ccache-action reference.

- Bump action version.


# mockr 0.2.2.9009 (2026-05-16)

## fledge

- Bump version to 0.2.2.9008 (#86).


# mockr 0.2.2.9008 (2026-05-14)

## Chore

- Add ccache to `.gitignore` and `.Rbuildignore`.

## Continuous integration

- Create snapshot update PR against correct branch.

- Add reference to `/apply-patch` workflow in commit message.

- Clarify rationale for not deploying on schedule.

- Only run fledge on pushes to main.

- Tweak fledge workflow and ccache action.


# mockr 0.2.2.9007 (2026-05-06)

## Continuous integration

- Cosmetics.

- Bump action versions.

- Install clang-format-21.

- Align fledge workflow.

- Harmonize.


# mockr 0.2.2.9006 (2026-05-04)

## Chore

- Auto-update from GitHub Actions (#80).


# mockr 0.2.2.9005 (2026-03-12)

## Chore

- Auto-update from GitHub Actions (#78).


# mockr 0.2.2.9004 (2026-03-08)

## Chore

- Auto-update from GitHub Actions (#76).


# mockr 0.2.2.9003 (2026-01-14)

## Continuous integration

- Fix comment (#74).

- Tweaks (#73).

- Test all R versions on branches that start with cran- (#72).


# mockr 0.2.2.9002 (2025-11-17)

## Continuous integration

- Install binaries from r-universe for dev workflow (#70).


# mockr 0.2.2.9001 (2025-11-12)

## Continuous integration

- Fix reviewdog and add commenting workflow (#68).


# mockr 0.2.2.9000 (2025-11-10)

## Chore

- Auto-update from GitHub Actions (#63).

## Continuous integration

- Use workflows for fledge (#66).

- Sync (#65).

- Use reviewdog for external PRs (#64).

- Cleanup and fix macOS (#62).

- Format with air, check detritus, better handling of `extra-packages` (#61).

- Enhance permissions for workflow (#60).


# mockr 0.2.2 (2025-05-01)

## License

- Relicense as MIT.

## Bug fixes

- Avoid rendering vignette with usethis missing.

- More careful querying of functions to be mocked, to avoid errors for `.onLoad()` when testing interactively (#29).


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
