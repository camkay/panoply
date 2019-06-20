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

# create example mats
mat_a <- psych::corr.test(data_example)$p

set.seed(1)

mat_b <- psych::corr.test(matrix(rnorm(5 * 7), 
                          nrow = 7, 
                          dimnames = list(rownames(data_example), 
                                          colnames(data_example))))$p

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

# test column_alpha
test_that("column_alpha returns correct values", {
  expect_equal(column_alpha(pattern = "scale1", 
                            data    = data_example), 
               0.974039829302987)
  expect_equal(column_alpha(pattern = "scale1", 
                              data    = data_example,
                              full    = TRUE)[[1]],
               alpha(data_example[, 1:3], warnings = FALSE)[[1]])
  expect_message(column_alpha(pattern = "scale1", 
                            data    = data_example), 
                 "scale1_item3")
})

# test column_combine
test_that("column_combine returns correct values", {
  expect_equal(column_combine(pattern = "scale1", 
                              data    = data_example), 
               c(7, 1.33333333333333, 
                 4, 
                 4.33333333333333, 
                 4.33333333333333, 
                 8.66666666666667, 
                 8.66666666666667))
  expect_equal(column_combine(pattern = "scale1", 
                              data    = data_example,
                              fun     = sum), 
             c(21, 4, 12, 13, 13, 26, 26))
  expect_equal(column_combine(pattern = "scale1", 
                              data    = data_example,
                              fun     = sd), 
             c(1, 
               0.577350269189626, 
               1, 0.577350269189626, 
               0.577350269189626, 
               0.577350269189626, 
               0.577350269189626))
  expect_message(column_combine(pattern = "scale1", 
                              data    = data_example,
                              fun     = sd), 
                 "A composite column was calculated using 3 columns: scale1_")
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

# test paste_paren
test_that("check paste_paren is combining the values correctly", {
  expect_equal(paste_paren(5, 10),
               "5(10)")
  expect_equal(paste_paren(20.19, 2.20),
               "20.19(2.2)")
  expect_equal(paste_paren("20.19", "2.20"),
               "20.19(2.20)")
  expect_warning(paste_paren("20.19", c("2.20", "10.10")),
                 "The x value")
  expect_warning(paste_paren(c("2.20", "10.10"), "20.19"),
                 regexp = "The y value")
})

# test perble
test_that("check paste_paren is combining the values correctly", {
  expect_equal(perble(char_example),
               structure(list(group = c("cat", "dog", "giraffe"), 
                              count = c(2, 2, 1), 
                              proportion = c(0.4, 0.4, 0.2), 
                              percent = c(40, 40, 20)), 
                         class     = "data.frame", 
                         row.names = c(NA, -3L)))
  expect_equal(perble(char_example, tidy = FALSE),
               structure(c(2, 0.4, 40, 2, 0.4, 40, 1, 0.2, 20), 
                         .Dim = c(3L, 3L), 
                         .Dimnames = list(c("count", "proportion", "percent"), 
                                          c("cat", "dog", "giraffe"))))
})

# test get_paste
test_that("check that get_paste is working properly", {
  expect_equal(get0("me", "an")(c(10, 20, 30, 44)), 26)
  expect_equal(get0("s", "d")(c(10, 20, 30, 44)), 14.5143607047182)
})

# test mat_merge
test_that("check that mat_merge is working properly", {
  expect_equal(mat_merge(mat_a, 
                         mat_b, 
                         x_from = "lower", 
                         y_from = "lower", 
                         x_to   = "lower", 
                         y_to   = "upper"),
               matrix(c(0, 0.000816982970622438, 0.00454442781824798, 
                        0.0224521374608249, 0.0121453149631062, 
                        0.524317457207586, 0, 0.00162131724305212, 
                        0.115015191468429, 0.0646228152839355, 
                        0.459483927231542, 0.947112709264432, 
                        0, 0.203212111846573, 0.0747737723517703, 
                        0.508791133749554, 0.059078101909081, 0.293710028165101, 
                        0, 0.00288053250708112, 0.486228731120195, 
                        0.352390494682801, 0.063056705312586, 0.668811955414348, 
                        0), nrow = 5))
  expect_equal(mat_merge(mat_a, 
                       mat_b, 
                       x_from = "lower", 
                       y_from = "lower", 
                       x_to   = "lower", 
                       y_to   = "upper"),
             matrix(c(0, 0.000816982970622438, 0.00454442781824798, 
                      0.0224521374608249, 0.0121453149631062, 0.524317457207586, 
                      0, 0.00162131724305212, 0.115015191468429, 
                      0.0646228152839355, 0.459483927231542, 0.947112709264432, 
                      0, 0.203212111846573, 0.0747737723517703, 
                      0.508791133749554, 0.059078101909081, 0.293710028165101, 
                      0, 0.00288053250708112, 0.486228731120195, 
                      0.352390494682801, 0.063056705312586, 0.668811955414348, 
                      0), nrow = 5))
  expect_equal(mat_merge(mat_a, 
                         mat_b, 
                         x_from = "upper", 
                         y_from = "lower", 
                         x_to   = "lower", 
                         y_to   = "upper"),
             matrix(c(0, 0.00816982970622438, 0.0318109947277359, 
                      0.112260687304124, 0.072871889778637, 0.524317457207586, 
                      0, 0.014591855187469, 0.258491261135742, 
                      0.258491261135742, 0.459483927231542, 0.947112709264432, 
                      0, 0.258491261135742, 0.258491261135742, 
                      0.508791133749554, 0.059078101909081, 0.293710028165101, 
                      0, 0.023044260056649, 0.486228731120195, 
                      0.352390494682801, 0.063056705312586, 0.668811955414348, 
                      0), nrow = 5))
  expect_error(mat_merge(mat_a, 
                         mat_b, 
                         x_from = "lower", 
                         y_from = "lower", 
                         x_to   = "lower", 
                         y_to   = "lower"),
               "quadrant")
  expect_error(mat_merge(mat_a, 
                         mat_b, 
                         x_from = "lower", 
                         y_from = "lower", 
                         x_to   = "upper", 
                         y_to   = "upper"),
               "quadrant")
  expect_error(mat_merge(mat_a, 
                         mat_b, 
                         x_from = "hello", 
                         y_from = "lower", 
                         x_to   = "upper", 
                         y_to   = "upper"),
               "x_from")
  expect_error(mat_merge(mat_a, 
                         mat_b, 
                         x_from = "lower", 
                         y_from = "hello", 
                         x_to   = "upper", 
                         y_to   = "upper"),
               "y_from")
  expect_error(mat_merge(mat_a, 
                         mat_b, 
                         x_from = "lower", 
                         y_from = "lower", 
                         x_to   = "hello", 
                         y_to   = "upper"),
               "x_to")
  expect_error(mat_merge(mat_a, 
                         mat_b, 
                         x_from = "lower", 
                         y_from = "lower", 
                         x_to   = "upper", 
                         y_to   = "hello"),
               "y_to")
})

# test column_message
test_that("check column_message is producing correct messages", {
  expect_message(column_message(data_example, "test"),
                 "test was calculated")
  expect_message(column_message(data_example, "test2"),
                 "test2 was calculated")
  expect_message(column_message(data_example, "test", verbose = FALSE),
                 "and 2 more.")
  expect_message(column_message(data_example, "test", verbose = TRUE),
                 "scale2_item2")
  expect_message(column_message(data_example, "test", verbose = TRUE),
                 "scale2_item2")
  expect_error(column_message(column_find("huh", 
                                          data_example, 
                                          return = "data.frame"), 
                              "test"),
               "No columns matched the provided string.")
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
