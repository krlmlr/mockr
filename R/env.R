check_dots_env_ <- function(dots, .parent) {
  envs <- lapply(dots, "[[", "env")
  same <- vlapply(envs, identical, .parent)
  if (!all(same)) {
    stopc("Can only evaluate expressions in the parent environment.")
  }
}

create_mock_env_ <- function(..., .dots = NULL, .env, .parent) {
  dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)

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
  old_funcs <- as.list(.env)
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
