context("Mock")

test_that("direct mocking", {
  with_mock(
    mockee = function() 42,
    expect_equal(mockee(), 42)
  )
})

test_that("infinite depth", {
  skip("NYI")
  call_mockee <- function() mockee()
  with_mock(
    mockee = function() 42,
    expect_equal(call_mockee(), 42)
  )
})

test_that("mocked function is restored on error", {
  expect_error(
    with_mock(
      mockee = function(x, y, ...) list(equal = TRUE, message = "TRUE"),
      stop("Simulated error")
    ),
    "Simulated error"
  )
})

test_that("non-empty mock with return value", {
  expect_true(with_mock(
    mockee = function(x, y, ...) list(equal = TRUE, message = "TRUE"),
    TRUE
  ))
})

test_that("nested mock", {
  skip("NYI")
  with_mock(
    all.equal = function(x, y, ...) TRUE,
    {
      with_mock(
        expect_warning = expect_error,
        {
          expect_warning(stopifnot(!compare(3, "a")$equal))
        }
      )
    },
    .env = asNamespace("base")
  )
  expect_false(isTRUE(all.equal(3, 5)))
  expect_warning(warning("test"))
})

test_that("qualified mock names", {
  skip("NYI")
  with_mock(
    expect_warning = expect_error,
    `base::all.equal` = function(x, y, ...) TRUE,
    {
      expect_warning(stopifnot(!compare(3, "a")$equal))
    }
  )
  with_mock(
    `testthat::expect_warning` = expect_error,
    all.equal = function(x, y, ...) TRUE,
    {
      expect_warning(stopifnot(!compare(3, "a")$equal))
    },
    .env = asNamespace("base")
  )
  expect_false(isTRUE(all.equal(3, 5)))
  expect_warning(warning("test"))
})

test_that("can't mock non-existing", {
  expect_error(with_mock(..bogus.. = identity, TRUE), "[.][.]bogus[.][.] not found in environment mockr")
})

test_that("can't mock non-function", {
  expect_error(with_mock(some_symbol = FALSE, TRUE), "some_symbol is not a function in environment mockr")
})

test_that("empty or no-op mock", {
  skip("NYI")

  expect_warning(expect_null(with_mock()),
                 "Not mocking anything")
  expect_warning(expect_true(with_mock(TRUE)),
                 "Not mocking anything")
  expect_warning(expect_false(withVisible(with_mock(invisible(5))$visible)),
                 "Not mocking anything")
})

test_that("multiple return values", {
  expect_true(with_mock(FALSE, TRUE, mockee = identity))
  expect_equal(with_mock(3, mockee = identity, 5), 5)
})

test_that("can access variables defined in function", {
  skip("NYI")
  x <- 5
  expect_equal(with_mock(x, mockee = identity), 5)
})

test_that("changes to variables are preserved between calls and visible outside", {
  skip("NYI")
  x <- 1
  with_mock(
    mockee = identity,
    x <- 3,
    expect_equal(x, 3)
  )
  expect_equal(x, 3)
})

test_that("mocks can access local variables", {
  skip("NYI")
  value <- TRUE

  with_mock(
    expect_true(mockee()),
    mockee = function() {value}
  )
})
