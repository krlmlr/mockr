some_symbol <- 42

mocker <- function() mockee()

.mocker <- function() .mockee()

mockee <- function() stop("Not mocking")

mockee2 <- function() stop("Not mocking (2)")

mockee3 <- function() mockee()

.mockee <- function() stop("Not mocking (3)")
