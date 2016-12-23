#' Mock functions in a package.
#'
#' Executes code after temporarily substituting implementations of package
#' functions.  This is useful for testing code that relies on functions that are
#' slow, have unintended side effects or access resources that may not be
#' available when testing.
#'
#' This works by using some C code to temporarily modify the mocked function \emph{in place}.
#' On exit (regular or error), all functions are restored to their previous state.
#' This is somewhat abusive of R's internals, and is still experimental, so use with care.
#'
#' Primitives (such as [base::interactive()]) cannot be mocked, but this can be
#' worked around easily by defining a wrapper function with the same name.
#'
#' @param ... named parameters redefine mocked functions, unnamed parameters
#'   will be evaluated after mocking the functions
#' @param .env the environment in which to patch the functions,
#'   defaults to the top-level environment.  A character is interpreted as
#'   package name.
#' @return The result of the last unnamed parameter
#' @references Suraj Gupta (2012): \href{http://obeautifulcode.com/R/How-R-Searches-And-Finds-Stuff}{How R Searches And Finds Stuff}
#' @export
#' @examples
#' some_func <- function() stop("oops")
#' some_other_func <- function() some_func()
#' with_mock(
#'   some_func = function() 42,
#'   some_other_func()
#' )
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
  ret <- invisible(NULL)
  for (expression in code) {
    ret <- lazyeval::lazy_eval(expression)
  }
  ret
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
  new_funcs <- lapply(mocks, "[[", "new_value")

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
  pkg_rx <- ".*[^:]"
  colons_rx <- "::(?:[:]?)"
  name_rx <- ".*"
  pkg_and_name_rx <- sprintf("^(?:(%s)%s)?(%s)$", pkg_rx, colons_rx, name_rx)

  pkg_name <- gsub(pkg_and_name_rx, "\\1", qual_name)

  name <- gsub(pkg_and_name_rx, "\\2", qual_name)

  if (pkg_name != "") {
    warning("with_mock() cannot mock functions defined in other packages.",
            call. = FALSE)
  }

  orig <- mget(name, envir = env, ifnotfound = list(NULL))[[1]]
  if (is.null(orig)) {
    stop(name, " not found in environment ",
         environmentName(env), ".", call. = FALSE)
  }
  if (!is.function(orig)) {
    stop(name, " is not a function in environment ",
         environmentName(env), ".", call. = FALSE)
  }
  mock(name = name, env = env, orig = orig, new = lazyeval::lazy_eval(dot))
}

mock <- function(name, env, orig, new) {
  structure(list(
    env = env, name = as.name(name),
    orig_value = orig, new_value = new), class = "mock")
}
