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
#' `testthat` pacakge, which is now deprecated
#'
#' @param ... `[any]`\cr named parameters redefine mocked functions,
#'   unnamed parameters will be evaluated after mocking the functions
#' @param .env the environment in which to patch the functions,
#'   defaults to [topenv()]. Usually doesn't need to be changed.
#' @param .parent the environment in which to evaluate the expressions,
#'   defaults to [parent.frame()]. Usually doesn't need to be changed.
#' @return The result of the last unnamed parameter, visibility is preserved
#' @references Suraj Gupta (2012): \href{http://obeautifulcode.com/R/How-R-Searches-And-Finds-Stuff}{How R Searches And Finds Stuff}
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

  check_dots_env(dots, .parent)

  mock_qual_names <- names(dots)

  if (all(mock_qual_names == "")) {
    warning("Not mocking anything. Please use named parameters to specify the functions you want to mock.",
            call. = FALSE)
    code_pos <- rep(TRUE, length(mock_qual_names))
  } else {
    code_pos <- (mock_qual_names == "")
  }

  mock_env <- create_mock_env_(.dots = dots[!code_pos], .env = .env, .parent = .parent)
  code <- dots[code_pos]

  old_parent <- parent.env(.parent)
  on.exit(parent.env(.parent) <- old_parent)
  parent.env(.parent) <- mock_env

  # Evaluate the code
  if (length(code) == 0L) {
    return(invisible(NULL))
  }

  for (expression in code[-length(code)]) {
    lazyeval::lazy_eval(expression)
  }
  lazyeval::lazy_eval(code[[length(code)]])
}

check_dots_env <- function(dots, .parent) {
  envs <- lapply(dots, "[[", "env")
  same <- vlapply(envs, identical, .parent)
  if (!all(same)) {
    stop("Can only evaluate expressions in the parent environment.",
         call. = FALSE)
  }
}

create_mock_env_ <- function(..., .dots = NULL, .env, .parent) {
  dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)

  mocks <- extract_mocks(dots = dots, env = .env)
  new_func_names <- lapply(mocks, "[[", "name")
  new_funcs <- lapply(mocks, "[[", "new_value")
  names(new_funcs) <- new_func_names

  old_funcs <- as.list(.env)
  old_funcs <- old_funcs[vlapply(old_funcs, is.function)]
  old_funcs <- old_funcs[!(names(old_funcs) %in% names(new_funcs))]

  # query value visible from .parent to support nesting
  mock_env <- new.env(parent = parent.env(.parent))
  old_funcs <- mget(names(old_funcs), .parent, inherits = TRUE)
  old_funcs <- lapply(old_funcs, `environment<-`, mock_env)

  all_funcs <- c(new_funcs, old_funcs)

  lapply(names(all_funcs), function(x) mock_env[[x]] <- all_funcs[[x]])
  mock_env
}

extract_mocks <- function(dots, env) {
  lapply(stats::setNames(nm = names(dots)),
         function(qual_name) extract_mock(qual_name, dots[[qual_name]], env))
}

extract_mock <- function(qual_name, dot, env) {
  name <- extract_mock_name(qual_name)
  check_mock(name, env)
  mock(name = name, new = lazyeval::lazy_eval(dot))
}

extract_mock_name <- function(qual_name) {
  pkg_rx <- ".*[^:]"
  colons_rx <- "::(?:[:]?)"
  name_rx <- ".*"
  pkg_and_name_rx <- sprintf("^(?:(%s)%s)?(%s)$", pkg_rx, colons_rx, name_rx)

  pkg_name <- gsub(pkg_and_name_rx, "\\1", qual_name)
  if (pkg_name != "") {
    warning("with_mock() cannot mock functions defined in other packages.",
            call. = FALSE)
  }

  name <- gsub(pkg_and_name_rx, "\\2", qual_name)
  name
}

check_mock <- function(name, env) {
  orig <- mget(name, envir = env, ifnotfound = list(NULL))[[1]]
  if (is.null(orig)) {
    stop(name, " not found in environment ",
         environmentName(env), ".", call. = FALSE)
  }
  if (!is.function(orig)) {
    stop(name, " is not a function in environment ",
         environmentName(env), ".", call. = FALSE)
  }
}

mock <- function(name, env, orig, new) {
  structure(list(name = as.name(name), new_value = new), class = "mock")
}
