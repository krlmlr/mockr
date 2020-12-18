context("Mock")

test_that("direct mocking via with_mock()", {
  with_mock(
    mockee = function() 42,
    {
      expect_equal(mockee(), 42)
    }
  )
})

test_that("direct mocking via local_mock()", {
  local({
    local_mock(mockee = function() 42)

    expect_equal(mockee(), 42)
  })

  expect_error(mockee())
})

test_that("direct and indirect mocking, also with depth", {
  local_mock(mockee = function() 42)

  expect_equal(mockee(), 42)
  expect_equal(mocker(), 42)
  expect_equal(mockee3(), 42)
})

test_that("direct and indirect mocking with dot (#4)", {
  local_mock(.mockee = function() 42)

  expect_equal(.mockee(), 42)
  expect_equal(.mocker(), 42)
})

test_that("infinite depth", {
  call_mockee <- function() mockee()

  local_mock(mockee = function() 42)

  expect_equal(call_mockee(), 42)
})

test_that("mocked function is restored on error", {
  expect_error(
    with_mock(
      mockee = function(x, y, ...) list(equal = TRUE, message = "TRUE"),
      {
        stop("Simulated error")
      }
    ),
    "Simulated error"
  )

  expect_error(mockee())
})

test_that("non-empty mock with return value", {
  expect_true(
    with_mock(
      mockee = function(x, y, ...) list(equal = TRUE, message = "TRUE"),
      {
        TRUE
      }
    )
  )
})

test_that("nested local_mock()", {
  local({
    local_mock(mockee = function() mockee2())
    local_mock(mockee2 = function() 42)
    expect_equal(mockee(), 42)
  })

  expect_error(mockee())
  expect_error(mockee2())
})

test_that("nested with_mock()", {
  with_mock(
    mockee = function() mockee2(),
    {
      with_mock(
        mockee2 = function() 42,
        {
          expect_equal(mockee(), 42)
        }
      )
      expect_error(mockee2())
    }
  )
  expect_error(mockee())
  expect_error(mockee2())
})

test_that("qualified mock names warn", {
  expect_warning(
    local_mock("mockr::mockee" = function() 42),
    "cannot mock functions defined in other packages"
  )
})

test_that("can't mock non-existing", {
  expect_error(local_mock(..bogus.. = identity), "[.][.]bogus[.][.] not found in environment mockr")
})

test_that("can't mock non-function", {
  expect_error(local_mock(some_symbol = FALSE), "some_symbol is not a function in environment mockr")
})

test_that("empty or no-op mock", {
  expect_warning(local_mock(), "Not mocking anything")

  expect_warning(expect_null(with_mock()),
                 "Not (?:mocking|evaluating) anything", all = TRUE)
  expect_warning(expect_true(with_mock(TRUE)),
                 "Not mocking anything")
  expect_warning(expect_null(with_mock(mockee = function() {})),
                 "Not evaluating anything")
  expect_warning(expect_false(withVisible(with_mock(invisible(5)))$visible),
                 "Not mocking anything")
})

test_that("multi local_mock()", {
  local_mock(
    mockee = function() 1,
    mockee2 = function() 2
  )
  expect_equal(mockee(), 1)
  expect_equal(mockee2(), 2)
  expect_equal(mockee3(), 1)
})

test_that("multi-mock", {
  expect_equal(
    with_mock(
      mockee = function() 1,
      mockee2 = function() 2,
      {
        mockee()
      }
    ),
    1
  )
  expect_equal(
    with_mock(
      mockee = function() 1,
      mockee2 = function() 2,
      {
        mockee2()
      }
    ),
    2
  )
  expect_equal(
    with_mock(
      mockee = function() 1,
      mockee2 = function() 2,
      {
        mockee3()
      }
    ),
    1
  )
})

test_that("un-braced (#15)", {
  expect_warning(
    expect_true(with_mock(TRUE, mockee = identity)),
    "braced expression"
  )
})

test_that("multiple return values", {
  expect_warning(
    expect_true(with_mock(FALSE, TRUE, mockee = identity)),
    "multiple"
  )
  expect_warning(
    expect_equal(with_mock({ 3 }, mockee = identity, 5), { 5 }),
    "multiple"
  )
})

test_that("can access variables defined in function", {
  x <- 5
  expect_equal(with_mock({ x }, mockee = identity), 5)
})

test_that("changes to variables are preserved between calls and visible outside", {
  x <- 1
  expect_warning(with_mock(
    mockee = identity,
    x <- 3,
    expect_equal(x, 3)
  ))
  expect_equal(x, 3)
})

test_that("mocks can access local variables", {
  value <- TRUE

  with_mock(
    {
      expect_true(mockee())
    },
    mockee = function() {value}
  )
})

test_that("mocks can update local variables", {
  value <- TRUE

  with_mock(
    {
      expect_false(mockee())
    },
    mockee = function() { value <<- FALSE; value }
  )

  expect_false(value)
})

test_that("mocks are overridden by local functons", {
  mockee <- function() stop("Still not mocking")

  expect_warning(local_mock(mockee = function() TRUE), "evaluation.*mockee")

  expect_true(mockee())
})
