<!-- README.md is generated from README.Rmd. Please edit that file -->
mockr [![Travis-CI Build Status](https://travis-ci.org/krlmlr/mockr.svg?branch=master)](https://travis-ci.org/krlmlr/mockr) [![Coverage Status](https://img.shields.io/codecov/c/github/krlmlr/mockr/master.svg)](https://codecov.io/github/krlmlr/mockr?branch=master)
=======================================================================================================================================================================================================================================================================

The goal of mockr is to provide a drop-in replacement for `testthat::with_mock()` which will be deprecated in the next version of `testthat`. The only exported function, `with_mock()`, is modeled closely after the original implementation, but now only allows mocking functions in the package under test. In contrast to the original implementation, no fiddling with R's internals is needed, and the implementation plays well with byte-compiled code.

-   If you need to mock an external function, write a wrapper.
-   The original implementation allowed modifying the behavior of other packages' functions. this is discouraged (and not possible with this implementation).

Example
-------

``` r
some_func <- function() stop("oops")
some_other_func <- function() some_func()

# Calling this function gives an error
some_other_func()
#> Error in some_func(): oops

tester_func <- function() {
  # Here, we override the function that raises the error
  with_mock(
    some_func = function() 42,
    some_other_func()
  )
}

# No error raised
tester_func()
#> [1] 42

# Mocking doesn't override functions in the same environment by design
with_mock(some_func = function() 6 * 7, some_other_func())
#> Error in some_func(): oops
```

Installation
------------

Install from GitHub via

``` r
devtools::install_github("krlmlr/mockr")
```
