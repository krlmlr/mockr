evaluate_in_mock_env <- function(code, mock_env, .parent) {
  if (length(code) == 0L) {
    return(invisible(NULL))
  }

  old_parent <- parent.env(.parent)
  on.exit(parent.env(.parent) <- old_parent)
  parent.env(.parent) <- mock_env

  # Evaluate the code
  for (expression in code[-length(code)]) {
    lazyeval::lazy_eval(expression)
  }
  lazyeval::lazy_eval(code[[length(code)]])
}
