# create example character vector
char_example <- c("cat", "dog", "cat", "dog", "giraffe")

# create example numeric vector
num_example  <- c(5, 0, .5, .1, .05, .01, .005, .001, .0005)

# create example data
data_example <- data.frame(scale1_item1 = c(6, 1, 3, 4, 5, 9, 9),
                           scale1_item2 = c(7, 2, 4, 5, 4, 8, 9),
                           scale1_item3 = c(8, 1, 5, 4, 4, 9, 8),
                           scale2_item1 = c(9, 9, 9, 8, 4, 2, 2),
                           scale2_item2 = c(7, 8, 7, 9, 5, 1, 2))

# test lenique
test_that("lenique results are equal to length(unique(x)) results", {
  expect_equal(lenique(char_example), length(unique(char_example)))
})

# test column_find
test_that("column_find returns the correct parts of the data frame", {
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
  expect_warning(column_find(pattern = "scale1", 
                             return  = "abcdefghijklmnopqrstuvwxyz", 
                             data    = data_example), 
               regexp = "abcdefghijklmnopqrstuvwxyz is not a recognized return")
})

# test spround
test_that("spround returns correct values", {
  expect_equal(spround(x = 0.001, digits = 2, leading0 = TRUE), "0.00")
  expect_equal(spround(x = 0.001, digits = 3, leading0 = TRUE), "0.001")
  expect_equal(spround(x = 0.001, digits = 3, leading0 = FALSE), ".001")
  expect_equal(spround(x = 10, digits = 2, leading0 = FALSE), "10.00")
  expect_equal(spround(x = num_example, digits = 2, leading0 = FALSE),
               c("5.00", ".00", ".50", ".10", ".05", 
                 ".01", ".00", ".00", ".00"))
})

# test pasterisk
test_that("pasterisk returns correct values", {
  expect_equal(pasterisk(num_example), 
               c("", "***", "", "", "", "*", "**", "**", "***"))
  expect_equal(pasterisk(num_example, sig_symbol = "+"), 
               c("", "+++", "", "", "", "+", "++", "++", "+++"))
  expect_equal(pasterisk(num_example, 
                         sig_symbol = "+",
                         thresholds = c(.03, 3)), 
               c("", "++", "+", "+", "+", "++", "++", "++", "++"))
})

# test scuttle
test_that("scuttle returns correct values", {
  expect_equal(scuttle(num_example, split = "quantile"),
               factor(c(3L, 1L, 3L, 3L, 2L, 2L, 2L, 1L, 1L), 
                      labels = c("Low", "Mid", "High")))
  expect_equal(scuttle(num_example, split = "sd"),
               structure(c(3L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L), 
                         .Label = c("Low", "Mid", "High"), 
                         class = "factor"))
  expect_equal(scuttle(num_example, split = "sd1"),
               structure(c(3L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L), 
                         .Label = c("Low", "Mid", "High"), 
                         class = "factor"))
  expect_equal(scuttle(num_example, split = "sd2"),
               structure(c(3L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L),
                         .Label = c("Low", "Mid", "High"), 
                         class = "factor"))
  expect_equal(scuttle(num_example, split = "sd3"),
               structure(c(2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L), 
                         .Label = c("Low", "Mid", "High"), 
                         class = "factor"))
  expect_equal(scuttle(num_example, split = "se"),
               structure(c(3L, 1L, 2L, 2L, 1L, 1L, 1L, 1L, 1L), 
                         .Label = c("Low", "Mid", "High"), 
                         class = "factor"))
  expect_equal(scuttle(num_example, split = "se1"),
               structure(c(3L, 1L, 2L, 2L, 1L, 1L, 1L, 1L, 1L), 
                         .Label = c("Low", "Mid", "High"), 
                         class = "factor"))
  expect_equal(scuttle(num_example, split = "se2"),
               structure(c(3L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L),
                         .Label = c("Low", "Mid", "High"), 
                         class = "factor"))
  expect_equal(scuttle(num_example, split = "se3"),
               structure(c(3L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L), 
                         .Label = c("Low", "Mid", "High"), 
                         class = "factor"))
  expect_equal(scuttle(num_example, 
                       split = "quantile", 
                       greedy_extremes = FALSE),
             factor(c(3L, 1L, 3L, 2L, 2L, 2L, 2L, 2L, 1L), 
                    labels = c("Low", "Mid", "High")))
  expect_equal(scuttle(num_example, split = "quantile", as.factor = FALSE),
               c("High", "Low", "High", "High", "Mid", 
                 "Mid", "Mid", "Low", "Low"))
  expect_warning(scuttle(num_example, split = "hello"), "split options")
})

# test argument_check
test_that("check errors is producing errors", {
  expect_error(argument_check(300, "x", "character", len_check = TRUE))
  expect_error(argument_check(c("h", "i"), "x", "character", len_check = TRUE))
  expect_error(argument_check("hello", "x", "data.frame"))
  expect_error(argument_check(12, "x", "data.frame"))
  expect_error(argument_check(12, "x", "character", len_check = TRUE))
  expect_error(argument_check(c(12, 10), "x", "numeric", len_check = TRUE))
})
