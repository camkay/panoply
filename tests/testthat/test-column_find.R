# create example data
data_example <- data.frame(scale1_item1 = c(6, 1, 3, 4, 5, 9, 9),
                           scale1_item2 = c(7, 2, 4, 5, 4, 8, 9),
                           scale1_item3 = c(8, 1, 5, 4, 4, 9, 8),
                           scale2_item1 = c(9, 9, 9, 8, 4, 2, 2),
                           scale2_item2 = c(7, 8, 7, 9, 5, 1, 2))

# test results
test_that("the correct parts of the data frame are returned", {
  expect_equal(column_find(pattern = "scale1", 
                           return  = "logical", 
                           data    = data_example), 
               c(TRUE, TRUE, TRUE, FALSE, FALSE))
  expect_equal(column_find(pattern = "scale1", 
                           return  = "numeric", 
                           data    = data_example), 
               c(1, 2, 3))
  expect_equal(column_find(pattern = "scale1", 
                           return  = "character", 
                           data    = data_example), 
               c("scale1_item1", "scale1_item2", "scale1_item3"))
  expect_equal(column_find(pattern = "scale1", 
                           return  = "data.frame", 
                           data    = data_example), 
               data.frame(scale1_item1 = c(6, 1, 3, 4, 5, 9, 9),
                          scale1_item2 = c(7, 2, 4, 5, 4, 8, 9),
                          scale1_item3 = c(8, 1, 5, 4, 4, 9, 8)))
})

# test errors
test_that("lenique results are equal to length(unique(x)) results", {
  expect_error(argument_check(300, "pattern", "character", len_check = TRUE))
  expect_error(argument_check(c(12, 10), "pattern", "character", len_check = TRUE))
  expect_error(argument_check("hello", "data", "data.frame"))
  expect_error(argument_check(12, "data", "data.frame"))
  expect_error(argument_check(12, "return", "character", len_check = TRUE))
  expect_error(argument_check(c(12,10), "return", "character", len_check = TRUE))
})
