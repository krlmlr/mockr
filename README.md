<!-- README.md is generated from README.Rmd. Please edit that file -->
mockr
=====

The goal of mockr is to provide a drop-in replacement for `testthat::with_mock()` which will be deprecated in the next version of `testthat`. The only exported function, `with_mock()`, is modeled closely after the original implementation, but now only allows mocking functions in the package under test, which is good practice anyway. In contrast to the original implementation, no fiddling with R's internals is needed.

-   If you need to mock an external function, write a wrapper.
-   The original implementation allowed modifying the behavior of other packages' functions. this is discouraged (and not possible with this implementation).

Example
-------

    #> Loading mockr

``` r
some_func <- function() stop("oops")
some_other_func <- function() some_func()

tester_func <- function() {
  with_mock(
    some_func = function() 42,
    some_other_func()
  )
}

try(some_other_func())
tester_func()
#> [1] 42
```
