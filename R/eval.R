evaluate_with_mock_env <- function(code, mock_env, .parent) {
  # Special treatment of last element, shortcut is important!
  if (length(code) == 0L) {
    return(invisible(NULL))
  }

  old_parent <- parent.env(.parent)
  on.exit(parent.env(.parent) <- old_parent)
  parent.env(.parent) <- mock_env

  # Evaluate the code
  for (expression in code[-length(code)]) {
    # Can't use eval_tidy(), otherwise changes to variables
    # are not visible outside
    # https://github.com/r-lib/rlang/issues/1077
    eval(quo_get_expr(expression), .parent)
  }
  eval(quo_get_expr(code[[length(code)]]), .parent)
}
