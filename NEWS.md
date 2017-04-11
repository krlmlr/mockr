## mockr 0.0-3 (2017-04-12)

- `.env` now can be a character, but using this argument may lead to different results than `testthat::with_mock()`.
- Clarify caveats in README.


## mockr 0.0-2 (2016-12-24)

- Add tests.
- Fix documentation URL.


## mockr 0.0-1 (2016-12-23)

Initial release.

- `with_mock()` modeled closely after `testthat::with_mock()`, can only mock in the package under test but avoids fiddling with R's internals.
