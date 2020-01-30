
test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})


test_that("hello_poznan works", {
  testthat::expect_true(grepl(pattern = "tej", x = hello_poznan("Pazur")))
})
