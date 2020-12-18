#' Get environment for mocking
#'
#' Returns the environment where to update mocked functions.
#'
#' In testing scenarios, mocked functions must be overwritten
#' the environment returned by `asNamespace("<package>")`
#' must be rechained.
#' This is not the same environment as [topenv()].
#'
#' @inheritParams with_mock
#'
#' @param .quiet `[flag]`\cr
#'   Set to `TRUE` to skip message about mocking environment.
#'   In testthat, the message is never printed if the mocking environment
#'   is the same as [testthat::testing_package()].
#'
#' @export
get_mock_env <- function(.parent = parent.frame(), .quiet = !is_interactive()) {
  top <- topenv(.parent)
  env <- parent.env(top)

  out <- NULL
  for (i in 1:1000) {
    name <- attr(env, "name")

    if (!is.null(name)) {
      if (grepl("^package:", name)) {
        ns <- sub("^package:", "", name)
        out <- asNamespace(ns)

        if (exists(".__DEVTOOLS__", out)) {
          break
        } else {
          out <- NULL
        }
      } else if (grepl("^imports:", name)) {
        ns <- sub("^imports:", "", name)
        out <- asNamespace(ns)

        if (is_installed("testthat") && testthat::testing_package() == ns) {
          .quiet <- TRUE
        }
        break
      }
    }

    env <- parent.env(env)
    if (identical(env, empty_env())) {
      out <- top
      break
    }
  }

  if (is.null(out)) {
    warn("No suitable mocking environment found.")
    out <- top
  }

  if (!.quiet) {
    message(paste0("Mocking environment: ", format(out)))
  }

  out
}


check_dots_env_ <- function(dots, .parent) {
  same <- vlapply(dots, quo_is_env, .parent)
  if (!all(same)) {
    abort("Can only evaluate expressions in the parent environment.")
  }
}

quo_is_env <- function(quo, env) {
  quo_env <- quo_get_env(quo)
  identical(quo_env, env) || identical(quo_env, rlang::empty_env())
}

create_mock_env_ <- function(dots, .env, .parent) {
  if (is.character(.env)) .env <- asNamespace(.env)

  new_funcs <- extract_new_funcs_(dots, .env)
  mock_env <- create_mock_env_with_old_funcs(new_funcs, .env, .parent)
  populate_env(mock_env, new_funcs)
  mock_env
}

extract_new_funcs_ <- function(dots, .env) {
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
  mock_env <- new.env(parent = parent.env(.parent))
  old_funcs <- mget(names(old_funcs), .parent, inherits = TRUE)
  old_funcs <- lapply(old_funcs, `environment<-`, mock_env)

  populate_env(mock_env, old_funcs)
  mock_env
}

populate_env <- function(env, funcs) {
  lapply(names(funcs), function(x) env[[x]] <- funcs[[x]])
}
