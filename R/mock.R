extract_mocks <- function(dots, env) {
  lapply(stats::setNames(nm = names(dots)),
         function(qual_name) extract_mock(qual_name, dots[[qual_name]], env))
}

extract_mock <- function(qual_name, dot, env) {
  name <- extract_mock_name(qual_name)
  check_mock(name, env)
  mock(name = name, new = eval_tidy(dot))
}

extract_mock_name <- function(qual_name) {
  pkg_rx <- ".*[^:]"
  colons_rx <- "::(?:[:]?)"
  name_rx <- ".*"
  pkg_and_name_rx <- sprintf("^(?:(%s)%s)?(%s)$", pkg_rx, colons_rx, name_rx)

  pkg_name <- gsub(pkg_and_name_rx, "\\1", qual_name)
  if (pkg_name != "") {
    warn("`with_mock()` cannot mock functions defined in other packages.")
  }

  name <- gsub(pkg_and_name_rx, "\\2", qual_name)
  name
}

check_mock <- function(name, env) {
  orig <- mget(name, envir = env, ifnotfound = list(NULL))[[1]]
  if (is.null(orig)) {
    abort(paste0(name, " not found in environment ", environmentName(env), "."))
  }
  if (!is.function(orig)) {
    abort(paste0(name, " is not a function in environment ", environmentName(env), "."))
  }
}

mock <- function(name, new) {
  structure(list(name = as.name(name), new_value = new), class = "mock")
}
