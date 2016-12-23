some_symbol <- 42

mockee <- function() stop("Not mocking")

mockee2 <- function() stop("Not mocking (2)")

mockee3 <- function() mockee()
