local_mock_env <- function(mock_env, .parent, env = parent.frame()) {
  old_parent <- parent.env(.parent)
  withr::defer(parent.env(.parent) <- old_parent, env)
  parent.env(.parent) <- mock_env

  invisible()
}
