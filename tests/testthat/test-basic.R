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

data_example_2 <- data.frame(group  = rep(c("A", "A", "B", "B", "A"), 2),
                             mach   = rep(c(NA, 2, 300, 200, 3), 2),
                             narc   = rep(c(2, 4, 500, 700, 10), 2),
                             psyc   = rep(c(3, 4, 1800, 2000, 5), 2),
                             des    = rep(c(100, 100, 2, 10, 1000), 2),
                             mor    = rep(c(10, 10, 500, 1000, 20), 2))

data_example_3 <- data.frame(group  = rep(c("A", "B", "C", "A", "B", "C"), 2),
                             mach   = rep(c(3, 2, 300, 200, 3, 400), 2),
                             narc   = rep(c(2, 4, 500, 700, 10, 100), 2),
                             psyc   = rep(c(3, 4, 1800, 2000, 5, 200), 2))

# create example mats
mat_a <- psych::corr.test(data_example)$p

set.seed(1)

mat_b <- psych::corr.test(matrix(rnorm(5 * 7), 
                          nrow = 7, 
                          dimnames = list(rownames(data_example), 
                                          colnames(data_example))))$p

# create example models
mod_a_example <- lm(scale1_item1 ~ scale2_item1, data = data_example)

mod_b_example <- lm(scale1_item1 ~ scale2_item1 + scale2_item2, data = data_example)

mod_c_example <- lm(scale1_item1 ~ scale2_item1 + scale2_item2 + scale1_item3, data = data_example)

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
                           return  = "logical", 
                           data    = data_example,
                           invert  = TRUE), 
               c(FALSE, FALSE, FALSE, TRUE, TRUE))
  expect_equal(column_find(pattern = "scale1", 
                           return  = "numeric", 
                           data    = data_example), 
               c(1, 2, 3))
  expect_equal(column_find(pattern = "scale1", 
                           return  = "numeric", 
                           data    = data_example,
                           invert  = TRUE), 
               c(4, 5))
  expect_equal(column_find(pattern = "scale1", 
                           return  = "character", 
                           data    = data_example), 
               c("scale1_item1", "scale1_item2", "scale1_item3"))
  expect_equal(column_find(pattern = "scale1", 
                           return  = "character", 
                           data    = data_example,
                           invert  = TRUE), 
               c("scale2_item1", "scale2_item2"))
  expect_equal(column_find(pattern = "scale1", 
                           return  = "data.frame", 
                           data    = data_example), 
               data.frame(scale1_item1 = c(6, 1, 3, 4, 5, 9, 9),
                          scale1_item2 = c(7, 2, 4, 5, 4, 8, 9),
                          scale1_item3 = c(8, 1, 5, 4, 4, 9, 8)))
  expect_equal(column_find(pattern = "scale1", 
                           return  = "data.frame", 
                           data    = data_example,
                           invert  = TRUE), 
               data.frame(scale2_item1 = c(9, 9, 9, 8, 4, 2, 2),
                          scale2_item2 = c(7, 8, 7, 9, 5, 1, 2)))
  expect_warning(column_find(pattern = "scale1", 
                             return  = "abcdefghijklmnopqrstuvwxyz", 
                             data    = data_example), 
               regexp = "abcdefghijklmnopqrstuvwxyz is not a recognized return")
expect_warning(column_find(pattern = "scale1", 
                             return  = "abcdefghijklmnopqrstuvwxyz", 
                             data    = data_example,
                           invert = TRUE), 
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
  expect_equal(column_alpha(pattern = "scale1", 
                              data    = data_example,
                              full    = TRUE,
                              message = FALSE)[[1]],
               alpha(data_example[, 1:3], warnings = FALSE)[[1]])
  expect_message(column_alpha(pattern = "scale1", 
                            data    = data_example), 
                 "scale1_item3")
  expect_message(column_alpha(pattern = "scale1", 
                              data    = data_example,
                              message = FALSE), 
                 NA)
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
  expect_equal(column_combine(pattern = "scale1", 
                              data    = data_example,
                              fun     = sd,
                              message = FALSE), 
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
  expect_message(column_combine(pattern = "scale1", 
                                data    = data_example,
                                fun     = sd,
                                message = FALSE), 
                 NA)
})

# test group_compare
test_that("group_compare returns correct values", {
  expect_equal(group_compare(data_example_2, 
                             cols  = c("mach", "narc"), 
                             split = "group"),
               structure(list(overall_m = c(126.25, 243.2), 
                              overall_sd = c(137.588153559818, 
                                             314.250006629541), 
                              overall_n = c(8, 10), 
                              group1_m = c(2.5, 5.33333333333333), 
                              group1_sd = c(0.577350269189626, 
                                            3.72379734500505), 
                              group1_n = c(4, 6), 
                              group2_m = c(250, 600), 
                              group2_sd = c(57.7350269189626, 
                                            115.470053837925), 
                              group2_n = c(4, 4), 
                              t = c(-8.57322284703958, -10.2963600160198), 
                              df = c(3.000599999994, 3.00416057565331), 
                              p = c(0.00333298849657998, 
                                    0.00194201346275585), 
                              d = c(-6.06218401176513, -6.64627181143344)), 
                         class = "data.frame", 
                         row.names = c("mach", "narc")))
  expect_equal(group_compare(data_example_2, 
                             cols  = c("mach", "narc"), 
                             split = "group",
                             spround = TRUE),
               structure(list(overall_m = c("126.25", "243.20"), 
                              overall_sd = c("137.59", "314.25"), 
                              overall_n = c("8.00", "10.00"), 
                              group1_m = c("2.50", "5.33"), 
                              group1_sd = c("0.58", "3.72"), 
                              group1_n = c("4.00", "6.00"), 
                              group2_m = c("250.00", "600.00"), 
                              group2_sd = c("57.74", "115.47"), 
                              group2_n = c("4.00", "4.00"), 
                              t = c("-8.57", "-10.30"), 
                              df = c("3", "3"), 
                              p = c(".003", ".002"), 
                              d = c("-6.06", "-6.65")),
                         class = "data.frame", 
                         row.names = c("mach", "narc")))
  expect_equal(group_compare(data_example_2, 
                             cols  = c("mach", "narc"), 
                             split = "group",
                             spround = TRUE,
                             collapse = TRUE),
               structure(list(overall_msd = c("126.25 (137.59)", 
                                              "243.20 (314.25)"),
                              overall_n = c("8.00", "10.00"),
                              group1_msd = c("2.50 (0.58)", "5.33 (3.72)"), 
                              group1_n = c("4.00", "6.00"), 
                              group2_msd = c("250.00 (57.74)", 
                                             "600.00 (115.47)"), 
                              group2_n = c("4.00", "4.00"), 
                              t = c("-8.57", "-10.30"), 
                              df = c("3", "3"), 
                              p = c(".003", ".002"), 
                              d = c("-6.06", "-6.65")),
                         class = "data.frame", 
                         row.names = c("mach", "narc")))
  expect_equal(group_compare(data_example_2, 
                             cols = c("mach", "narc"), 
                             split = "group")["mach", "df"],
               unname(t.test(subset(data_example_2, 
                                    group == "A")$mach,
                             subset(data_example_2, 
                                    group == "B")$mach)$parameter))
  expect_equal(group_compare(data_example_2, 
                             cols = c("mach", "narc"), 
                             split = "group")["mach", "p"],
               unname(t.test(subset(data_example_2, 
                                    group == "A")$mach,
                             subset(data_example_2, 
                                    group == "B")$mach)$p.value))
  expect_equal(group_compare(data_example_2, 
                             cols = c("mach", "narc"), 
                             split = "group")["mach", "t"],
               unname(t.test(subset(data_example_2, 
                                    group == "A")$mach,
                             subset(data_example_2, 
                                    group == "B")$mach)$statistic))
  expect_equal(group_compare(data_example_2, 
                             cols = c("mach", "narc"), 
                             split = "group")["mach", "group1_m"],
               unname(t.test(subset(data_example_2, 
                                    group == "A")$mach,
                             subset(data_example_2, 
                                    group == "B")$mach)$estimate[1]))
  expect_equal(group_compare(data_example_2, 
                             cols = c("mach", "narc"), 
                             split = "group")["mach", "group2_m"],
               unname(t.test(subset(data_example_2, 
                                    group == "A")$mach,
                             subset(data_example_2, 
                                    group == "B")$mach)$estimate[2]))
  expect_equal(group_compare(data_example_2, 
                             cols = c("mach", "narc", "psyc"), 
                             split = "group",
                             adjust = "holm")[, "p"],
               p.adjust(group_compare(data_example_2, 
                             cols = c("mach", "narc", "psyc"), 
                             split = "group")[, "p"],
                        method = "holm",
                        n      = 3))
  expect_equal(group_compare(data_example_2, 
                             cols = c("mach", "narc", "psyc"), 
                             split = "group",
              adjust = "bonferroni")["mach", "p"],
              p.adjust(unname(t.test(subset(data_example_2, 
                          group == "A")$mach,
                             subset(data_example_2, 
                                    group == "B")$mach)$p.value), 
         method = "bonferroni", n = 3))
  expect_equal(group_compare(data_example_2, 
                             cols = c("mach", "narc"), 
                             split = "group",
                             var.equal = TRUE)["mach", "df"],
               unname(t.test(subset(data_example_2, 
                                    group == "A")$mach,
                             subset(data_example_2, 
                                    group == "B")$mach,
                             var.equal = TRUE)$parameter))
  expect_equal(group_compare(data_example_2, 
                             cols = c("mach", "narc"), 
                             split = "group",
                             var.equal = TRUE)["mach", "p"],
               unname(t.test(subset(data_example_2, 
                                    group == "A")$mach,
                             subset(data_example_2, 
                                    group == "B")$mach,
                             var.equal = TRUE)$p.value))
  expect_equal(group_compare(data_example_2, 
                             cols = c("mach", "narc"), 
                             split = "group",
                             var.equal = TRUE)["mach", "t"],
               unname(t.test(subset(data_example_2, 
                                    group == "A")$mach,
                             subset(data_example_2, 
                                    group == "B")$mach,
                             var.equal = TRUE)$statistic))
  expect_error(group_compare(data_example_3, 
                             cols = c("mach", "narc"), 
                             split = "group"),
               "group_compare is only able to compare two groups.")
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
               "5 (10)")
  expect_equal(paste_paren(20.19, 2.20),
               "20.19 (2.2)")
  expect_equal(paste_paren("20.19", "2.20"),
               "20.19 (2.20)")
  expect_warning(paste_paren("20.19", c("2.20", "10.10")),
                 "The x value")
  expect_warning(paste_paren(c("2.20", "10.10"), "20.19"),
                 regexp = "The y value")
})

# test perble
test_that("check perble is counting correctly", {
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
  expect_equal(perble(char_example, spround = TRUE),
               structure(list(group = c("cat", "dog", "giraffe"), 
                              count = c("2", "2", "1"), 
                              proportion = c(".40", ".40", ".20"), 
                              percent = c("40.00", "40.00", "20.00")), 
                         class     = "data.frame", 
                         row.names = c(NA, -3L)))
  expect_equal(perble(char_example, tidy = FALSE, spround = TRUE),
               structure(c("2", ".40", "40.00", "2", ".40", 
                           "40.00", "1", ".20", "20.00"), 
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

# test center
test_that("check that center is producing the correct results", {
  expect_equal(scale(num_example, scale = FALSE, center = TRUE),
               center(num_example))
  expect_false(isTRUE(all.equal(scale(num_example, scale = TRUE, center = TRUE), 
                                center(num_example))))
  expect_false(isTRUE(all.equal(scale(num_example, scale = TRUE, center = TRUE), 
                                centre(num_example))))
  expect_equal(centre(num_example),
               center(num_example))
  
})

# test delta_rsq, delta_aic, and delta_bic
test_that("check that delta_rsq is working properly", {
  expect_equal(delta_rsq(list(mod_a_example, 
                              mod_b_example, 
                              mod_c_example)),
               structure(list(model = structure(1:3, 
                                                .Label = c("mod_a_example", 
                                                           "mod_b_example", 
                                                           "mod_c_example"), 
                                                class = "factor"), 
                              delta_rsq = c(NA, 
                                            0.0711523789754419, 
                                            0.238642252570856)), 
                         class = "data.frame", 
                         row.names = c(NA, -3L)))
  expect_equal(delta_rsq(list(mod_a_example, 
                              mod_b_example, 
                              mod_c_example), adjusted = TRUE),
               structure(list(model = structure(1:3, 
                                                .Label = c("mod_a_example", 
                                                           "mod_b_example", 
                                                           "mod_c_example"), 
                                                class = "factor"), 
                             delta_rsq_adj = c(NA, 
                                               0.0107341217334221, 
                                               0.352869950079865)), 
                         class = "data.frame", row.names = c(NA, -3L)))
  expect_error(delta_rsq(list(mod_a_example, "mod_b_example", mod_c_example)),
               "All models must be of class lm")
  expect_error(delta_rsq(list(mod_a_example)),
               "More than one model must be provided.")
  expect_error(delta_rsq(list(mod_a_example, 
                              mod_b_example, 
                              mod_c_example), 
                         adjusted = "hello"),
               "adjusted must be of type logical.")
  expect_error(delta_rsq(list(mod_a_example, 
                              mod_b_example, 
                              mod_c_example), 
                         adjusted = c(TRUE, TRUE)),
               "adjusted must be of length 1. adjusted is of length 2.")
})

test_that("check that delta_aic is working properly", {
  expect_equal(delta_aic(list(mod_a_example, 
                              mod_b_example, 
                              mod_c_example)),
               structure(list(model = structure(1:3, 
                                                .Label = c("mod_a_example", 
                                                           "mod_b_example", 
                                                           "mod_c_example"), 
                                                class = "factor"), 
                              delta_aic = c(NA, 
                                            0.239522459992067, 
                                            -20.3696755929175)), 
                         class = "data.frame", 
                         row.names = c(NA, -3L)))
  expect_error(delta_aic(list(mod_a_example, "mod_b_example", mod_c_example)),
               "All models must be of class lm")
  expect_error(delta_aic(list(mod_a_example)),
               "More than one model must be provided.")
})

test_that("check that delta_bic is working properly", {
  expect_equal(delta_bic(list(mod_a_example, 
                              mod_b_example, 
                              mod_c_example)),
               structure(list(model = structure(1:3, 
                                                .Label = c("mod_a_example", 
                                                           "mod_b_example", 
                                                           "mod_c_example"), 
                                                class = "factor"), 
                              delta_bic = c(NA, 
                                            0.185432609047382, 
                                            -20.4237654438622)), 
                         class = "data.frame", 
                         row.names = c(NA, -3L)))
  expect_error(delta_bic(list(mod_a_example, "mod_b_example", mod_c_example)),
               "All models must be of class lm")
  expect_error(delta_bic(list(mod_a_example)),
               "More than one model must be provided.")
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
