# mockr 0.1.0.9000 (2020-12-15)

- Functions that start with a dot can be mocked (#3, #4).
- Switch to rlang (#13).
- Switch to GitHub Actions (#10).


# mockr 0.1 (2017-04-28)

Initial CRAN release.

- `with_mock()` modeled closely after `testthat::with_mock()`, can only mock in the package under test but avoids fiddling with R's internals.
    - The `.env` argument now can be a character, but using this argument may lead to different results than `testthat::with_mock()`.
