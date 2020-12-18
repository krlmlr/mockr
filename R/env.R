#' Get environment for mocking
#'
#' Called by default from [with_mock()] to determine
#' the environment where to update mocked functions.
#' This function is exported to help troubleshooting.
#'
#' This function works differently depending on
#' [testthat::is_testing()].
#'
#' Outside testthat, `topenv(.parent)` is returned.
#' This was the default for mockr < 0.1.0 and works for many cases.
#'
#' In testthat, `asNamespace("<package>")` for the tested package is returned.
#' The tested package is determined via [testthat::testing_package()].
#' If this is empty (e.g. if a `test_that()` block is run in interactive mode),
#' this function looks in the search path for packages loaded by
#' [pkgload::load_all()].
#'
#' @inheritParams with_mock
#'
#' @export
get_mock_env <- function(.parent = parent.frame()) {
  top <- topenv(.parent)

  testing <- is_installed("testthat") && testthat::is_testing()
  if (!testing) {
    return(top)
  }

  pkg <- testthat::testing_package()
  if (pkg != "") {
    return(asNamespace(pkg))
  }

  env <- parent.env(top)

  for (i in 1:1000) {
    name <- attr(env, "name")

    if (!is.null(name)) {
      if (grepl("^package:", name)) {
        ns <- sub("^package:", "", name)
        ns_env <- asNamespace(ns)

        if (exists(".__DEVTOOLS__", ns_env)) {
          return(ns_env)
        }
      }
    }

    env <- parent.env(env)
    if (identical(env, empty_env())) {
      break
    }
  }

  warn("No package loaded, using `topenv()` as mocking environment.")
  top
}

check_dots_env <- function(dots, .parent) {
  same <- vlapply(dots, quo_is_env, .parent)
  if (!all(same)) {
    abort("Can only evaluate expressions in the parent environment.")
  }
}

quo_is_env <- function(quo, env) {
  quo_env <- quo_get_env(quo)
  identical(quo_env, env) || identical(quo_env, rlang::empty_env())
}

create_mock_env <- function(dots, .env, .parent, .defer_env = parent.frame()) {
  if (is.character(.env)) .env <- asNamespace(.env)

  new_funcs <- extract_new_funcs(dots, .env)

  # check if functions exist in parent environment, replace those instead
  eval_env_funcs <- mget(names(new_funcs), .parent, mode = "function", ifnotfound = list(NULL))
  eval_env_funcs <- eval_env_funcs[!vlapply(eval_env_funcs, is.null)]

  if (length(eval_env_funcs) > 0) {
    warn(paste0(
      "Replacing functions in evaluation environment: ",
      paste0("`", names(eval_env_funcs), "()`", collapse = ", ")
    ))

    withr::defer(populate_env(.parent, eval_env_funcs), envir = .defer_env)
    populate_env(.parent, new_funcs[names(eval_env_funcs)])

    new_funcs <- new_funcs[!(names(new_funcs) %in% names(eval_env_funcs))]
  }

  mock_env <- create_mock_env_with_old_funcs(new_funcs, .env, .parent)
  populate_env(mock_env, new_funcs)
  mock_env
}

extract_new_funcs <- function(dots, .env) {
  mocks <- extract_mocks(dots = dots, env = .env)
  new_func_names <- lapply(mocks, "[[", "name")
  new_funcs <- lapply(mocks, "[[", "new_value")
  names(new_funcs) <- new_func_names
  new_funcs
}

create_mock_env_with_old_funcs <- function(new_funcs, .env, .parent) {
  # retrieve all functions not mocked
  old_funcs <- as.list(.env, all.names = TRUE)
  old_funcs <- old_funcs[vlapply(old_funcs, is.function)]
  old_funcs <- old_funcs[!(names(old_funcs) %in% names(new_funcs))]

  # query value visible from .parent to support nesting
  old_funcs <- mget(names(old_funcs), .parent, inherits = TRUE)

  # create and populate mocking environment
  mock_env <- new.env(parent = parent.env(.parent))
  old_funcs <- lapply(old_funcs, `environment<-`, mock_env)
  populate_env(mock_env, old_funcs)

  mock_env
}

populate_env <- function(env, funcs) {
  lapply(names(funcs), function(x) env[[x]] <- funcs[[x]])
}
