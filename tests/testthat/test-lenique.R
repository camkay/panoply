# create example data
char_example <- c("cat", "dog", "cat", "dog", "giraffe")

# test
test_that("lenique results are equal to length(unique(x)) results", {
  expect_equal(lenique(char_example), length(unique(char_example)))
})