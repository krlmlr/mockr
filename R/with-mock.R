#' Mock functions in a package
#'
#' `local_mock()` temporarily substitutes implementations of package functions.
#' This is useful for testing code that relies on functions that are
#' slow, have unintended side effects or access resources that may not be
#' available when testing.
#'
#' This works by adding a shadow environment as a parent of the environment
#' in which the expressions are evaluated.  Everything happens at the R level,
#' but only functions in your own package can be mocked.
#' Otherwise, the implementation is modeled after the original version in the
#' `testthat` package, which is now deprecated.
#'
#' @param ... `[any]`\cr Named arguments redefine mocked functions.
#'   An unnamed argument containing code in braces (`{}`) should be provided
#'   to `with_mock()`,
#'   it will be evaluated after mocking the functions.
#'   Use `:=` to mock functions that start with a dot
#'   to avoid potential collision with current or future arguments
#'   to `with_mock()` or `local_mock()`.
#'   Passing more than one unnamed argument to `with_mock()`,
#'   or code that is not inside braces, gives a warning.
#' @param .parent `[environment]`\cr the environment in which to evaluate the expressions,
#'   defaults to [parent.frame()]. Usually doesn't need to be changed.
#' @param .env `[environment]`\cr the environment in which to patch the functions,
#'   defaults to [topenv()]. Usually doesn't need to be changed.
#' @param .defer_env `[environment]`\cr
#'   Attach exit handlers to this environment.
#'   Typically, this should be either the current environment
#'   or a parent frame (accessed through [parent.frame()]).
#'   This argument is passed on as `envir` to [withr::defer()].
#' @return
#'   `local_mock()` returns `NULL`, invisibly.
#' @references Suraj Gupta (2012): [How R Searches And Finds Stuff](http://blog.obeautifulcode.com/R/How-R-Searches-And-Finds-Stuff/)
#' @export
#' @examples
#' some_func <- function() stop("oops")
#' some_other_func <- function() some_func()
#' my_env <- environment()
#'
#' tester_func <- function() {
#'   # The default for .env works well most of the time,
#'   # unfortunately not in examples
#'   local_mock(some_func = function() 42, .env = my_env)
#'   some_other_func()
#' }
#' try(some_other_func())
#' tester_func()
local_mock <- function(...,
                       .parent = parent.frame(),
                       .env = get_mock_env(.parent),
                       .defer_env = parent.frame()) {
  dots <- enquos(...)

  check_dots_env(dots, .parent)

  if (length(get_code_dots(dots, warn = FALSE)) > 0) {
    abort("All arguments to `local_mock()` must be named.")
  }

  mock_funs <- get_mock_dots(dots)
  if (length(mock_funs) == 0) {
    return()
  }

  mock_env <- create_mock_env(
    mock_funs, .env = .env, .parent = .parent, .defer_env = .defer_env
  )

  local_mock_env(mock_env, .parent, .defer_env)
  invisible()
}

#' @description
#'   `with_mock()` substitutes, runs code locally, and restores in one go.
#' @return
#'   `with_mock()` returns the result of the last unnamed argument.
#'   Visibility is preserved.
#' @rdname local_mock
#' @export
#' @examples
#'
#' tester_func_with <- function() {
#'   with_mock(
#'     some_func = function() 42,
#'     .env = my_env,
#'     {
#'       some_other_func()
#'     }
#'   )
#' }
#' tester_func_with()
with_mock <- function(...,
                      .parent = parent.frame(),
                      .env = get_mock_env(.parent)) {
  dots <- enquos(...)

  check_dots_env(dots, .parent)

  mock_funs <- get_mock_dots(dots)
  mock_env <- create_mock_env(mock_funs, .env = .env, .parent = .parent)

  local_mock_env(mock_env, .parent)
  evaluate_code(get_code_dots(dots), .parent)
}

get_mock_dots <- function(dots) {
  mock_qual_names <- names2(dots)

  if (all(mock_qual_names == "")) {
    warn("Not mocking anything. Please use named arguments to specify the functions you want to mock.")
    list()
  } else {
    dots[mock_qual_names != ""]
  }
}

get_code_dots <- function(dots, warn = TRUE) {
  mock_qual_names <- names2(dots)

  if (all(mock_qual_names != "")) {
    if (warn) {
      warn("Not evaluating anything. Please use unnamed arguments to specify expressions you want to evaluate.")
    }
    list()
  } else {
    dots[mock_qual_names == ""]
  }
}
