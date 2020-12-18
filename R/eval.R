evaluate_code <- function(code, .parent) {
  # Special treatment of last element, shortcut is important!
  if (length(code) == 0L) {
    return(invisible(NULL))
  }

  if (length(code) > 1) {
    warn("Passing multiple pieces of code to `with_mock()` is discouraged, use a braced expression instead.")
  } else if (!is_call(quo_get_expr(code[[1]]), quote(`{`))) {
    warn("The code passed to `with_mock()` must be a braced expression to get accurate file-line information for failures.")
  }

  # Evaluate the code
  for (expression in code[-length(code)]) {
    # Can't use eval_tidy(), otherwise changes to variables
    # are not visible outside
    # https://github.com/r-lib/rlang/issues/1077
    eval(quo_get_expr(expression), .parent)
  }
  eval(quo_get_expr(code[[length(code)]]), .parent)
}
