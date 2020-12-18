# mockr 0.1.0.9001 (2020-12-18)

- `with_mock()` now requires braces (so that error locations can be reported more accurately) and supports only one expression (#15).
- Functions declared in evaluation environments are now also replaced, with a warning (#5).
- New `local_mock()` (#6).
- `with_mock()` works when running a `testthat::test_that()` block interactively (#7).
- New `get_mock_env()` to make the mocking environment explicit (#7).


# mockr 0.1.0.9000 (2020-12-15)

- Functions that start with a dot can be mocked (#3, #4).
- Switch to rlang (#13).
- Switch to GitHub Actions (#10).


# mockr 0.1 (2017-04-28)

Initial CRAN release.

- `with_mock()` modeled closely after `testthat::with_mock()`, can only mock in the package under test but avoids fiddling with R's internals.
    - The `.env` argument now can be a character, but using this argument may lead to different results than `testthat::with_mock()`.
