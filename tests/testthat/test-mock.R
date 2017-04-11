context("Mock")

test_that("direct mocking", {
  with_mock(
    mockee = function() 42,
    expect_equal(mockee(), 42)
  )
})

test_that("infinite depth", {
  call_mockee <- function() mockee()
  with_mock(
    mockee = function() 42,
    expect_equal(call_mockee(), 42)
  )
})

test_that("infinite depth in package", {
  with_mock(
    mockee = function() 42,
    expect_equal(mockee3(), 42)
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
  with_mock(
    mockee = function() mockee2(),
    {
      with_mock(
        mockee2 = function() 42,
        {
          expect_equal(mockee(), 42)
        }
      )
    }
  )
  expect_error(mockee())
  expect_error(mockee2())
})

test_that("qualified mock names warn", {
  expect_warning(with_mock("mockr::mockee" = function() 42, mockee()),
                 "cannot mock functions defined in other packages")
})

test_that("can't mock non-existing", {
  expect_error(with_mock(..bogus.. = identity, TRUE), "[.][.]bogus[.][.] not found in environment mockr")
})

test_that("can't mock non-function", {
  expect_error(with_mock(some_symbol = FALSE, TRUE), "some_symbol is not a function in environment mockr")
})

test_that("empty or no-op mock", {
  expect_warning(expect_null(with_mock()),
                 "Not (?:mocking|evaluating) anything", all = TRUE)
  expect_warning(expect_true(with_mock(TRUE)),
                 "Not mocking anything")
  expect_warning(expect_null(with_mock(mockee = function() {})),
                 "Not evaluating anything")
  expect_warning(expect_false(withVisible(with_mock(invisible(5)))$visible),
                 "Not mocking anything")
})

test_that("multi-mock", {
  expect_equal(
    with_mock(
      mockee = function() 1,
      mockee2 = function() 2,
      mockee()
    ),
    1
  )
  expect_equal(
    with_mock(
      mockee = function() 1,
      mockee2 = function() 2,
      mockee2()
    ),
    2
  )
  expect_equal(
    with_mock(
      mockee = function() 1,
      mockee2 = function() 2,
      mockee3()
    ),
    1
  )
})

test_that("multiple return values", {
  expect_true(with_mock(FALSE, TRUE, mockee = identity))
  expect_equal(with_mock(3, mockee = identity, 5), 5)
})

test_that("can access variables defined in function", {
  x <- 5
  expect_equal(with_mock(x, mockee = identity), 5)
})

test_that("changes to variables are preserved between calls and visible outside", {
  x <- 1
  with_mock(
    mockee = identity,
    x <- 3,
    expect_equal(x, 3)
  )
  expect_equal(x, 3)
})

test_that("mocks can access local variables", {
  value <- TRUE

  with_mock(
    expect_true(mockee()),
    mockee = function() {value}
  )
})

test_that("mocks can update local variables", {
  value <- TRUE

  with_mock(
    expect_false(mockee()),
    mockee = function() { value <<- FALSE; value }
  )

  expect_false(value)
})

test_that("mocks are overridden by local functons", {
  mockee <- function() stop("Still not mocking")

  with_mock(
    expect_error(mockee(), "Still not mocking"),
    mockee = function() TRUE
  )
})
