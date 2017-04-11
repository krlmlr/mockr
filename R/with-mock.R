#' Mock functions in a package.
#'
#' Executes code after temporarily substituting implementations of package
#' functions.  This is useful for testing code that relies on functions that are
#' slow, have unintended side effects or access resources that may not be
#' available when testing.
#'
#' This works by adding a shadow environment as a parent of the environment
#' in which the expressions are evaluated.  Everything happens at the R level,
#' but only functions in your own package can be mocked.
#' Otherwise, the implementation is modeled after the original version in the
#' `testthat` pacakge, which is now deprecated.
#'
#' @param ... `[any]`\cr named arguments redefine mocked functions,
#'   unnamed parameters will be evaluated after mocking the functions
#' @param .env `[environment]`\cr the environment in which to patch the functions,
#'   defaults to [topenv()]. Usually doesn't need to be changed.
#' @param .parent `[environment]`\cr the environment in which to evaluate the expressions,
#'   defaults to [parent.frame()]. Usually doesn't need to be changed.
#' @return The result of the last unnamed parameter, visibility is preserved
#' @references Suraj Gupta (2012): [How R Searches And Finds Stuff](http://blog.obeautifulcode.com/R/How-R-Searches-And-Finds-Stuff/)
#' @export
#' @examples
#' some_func <- function() stop("oops")
#' some_other_func <- function() some_func()
#' tester_func <- function() {
#'   with_mock(
#'     some_func = function() 42,
#'     some_other_func()
#'   )
#' }
#' try(some_other_func())
#' tester_func()
with_mock <- function(..., .parent = parent.frame(), .env = topenv(.parent)) {
  .dots <- lazyeval::lazy_dots(...)
  with_mock_(.dots = .dots, .parent = .parent, .env = .env)
}

with_mock_ <- function(..., .dots = NULL, .parent = parent.frame(), .env = topenv(.parent)) {
  dots <- lazyeval::all_dots(.dots, ...)

  check_dots_env_(dots, .parent)

  mock_env <- create_mock_env_(.dots = get_mock_dots(dots), .env = .env, .parent = .parent)
  evaluate_with_mock_env(get_code_dots(dots), mock_env, .parent)
}

get_mock_dots <- function(dots) {
  mock_qual_names <- names2(dots)

  if (all(mock_qual_names == "")) {
    warningc("Not mocking anything. Please use named arguments to specify the functions you want to mock.")
    list()
  } else {
    dots[mock_qual_names != ""]
  }
}

get_code_dots <- function(dots) {
  mock_qual_names <- names2(dots)

  if (all(mock_qual_names != "")) {
    warningc("Not evaluating anything. Please use unnamed arguments to specify expressions you want to evaluate.")
    list()
  } else {
    dots[mock_qual_names == ""]
  }
}
