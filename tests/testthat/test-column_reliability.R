# create example data
data_example <- data.frame(scale1_item1 = c(6, 1, 3, 4, 5, 9, 9),
                           scale1_item2 = c(7, 2, 4, 5, 4, 8, 9),
                           scale1_item3 = c(8, 1, 5, 4, 4, 9, 8),
                           scale2_item1 = c(9, 9, 9, 8, 4, 2, 2),
                           scale2_item2 = c(7, 8, 7, 9, 5, 1, 2))

# test column_reliability
test_that("column_reliability returns correct values", {
  
  # alpha
  expect_equal(column_reliability(data    = data_example,
                                  pattern = "scale1",
                                  return  = "alpha"),
               psych::alpha(column_find("scale1", 
                                        data_example, 
                                        "data.frame"))[[1]]$raw_alpha)
  
  # omega
  expect_equal(column_reliability(data    = data_example,
                                  pattern = "scale1",
                                  return  = "omega"),
               MBESS::ci.reliability(column_find("scale1", 
                                                 data_example, 
                                                 "data.frame"))$est)
  
  # rij
  expect_equal(column_reliability(data    = data_example,
                                  pattern = "scale1",
                                  return  = "rij"),
               psych::alpha(column_find("scale1", 
                                        data_example, 
                                        "data.frame"))[[1]]$average_r)
  
  # all
  expect_equal(column_reliability(data    = data_example,
                                  pattern = "scale1",
                                  return  = "all")$alpha,
               psych::alpha(column_find("scale1", 
                                        data_example, 
                                        "data.frame"))[[1]]$raw_alpha)
  
  expect_equal(column_reliability(data    = data_example,
                                  pattern = "scale1",
                                  return  = "all")$omega,
               MBESS::ci.reliability(column_find("scale1", 
                                                 data_example, 
                                                 "data.frame"))$est)
  
  expect_equal(column_reliability(data    = data_example,
                                  pattern = "scale1",
                                  return  = "all")$rij,
               psych::alpha(column_find("scale1", 
                                        data_example, 
                                        "data.frame"))[[1]]$average_r)
  
  # uses all columns if no pattern provided
  expect_equal(suppressWarnings(column_reliability(data   = data_example,
                                                   return = "all")$omega),
               suppressWarnings(MBESS::ci.reliability(data_example)$est))
})

test_that("column_reliability returns correct sprounded values", {
  
  # alpha
  expect_equal(column_reliability(data    = data_example,
                                  pattern = "scale1",
                                  return  = "alpha",
                                  spround = TRUE),
               ".97")
  
  # omega
  expect_equal(column_reliability(data    = data_example,
                                  pattern = "scale1",
                                  return  = "omega",
                                  spround = TRUE),
               ".98")
  
  # rij
  expect_equal(column_reliability(data    = data_example,
                                  pattern = "scale1",
                                  return  = "rij",
                                  spround = TRUE),
              ".93")
  
  # all
  expect_equal(column_reliability(data    = data_example,
                                  pattern = "scale1",
                                  return  = "all",
                                  spround = TRUE)$alpha,
               ".97")
  
  expect_equal(column_reliability(data    = data_example,
                                  pattern = "scale1",
                                  return  = "all",
                                  spround = TRUE)$omega,
               ".98")
  
  expect_equal(column_reliability(data    = data_example,
                                 pattern = "scale1",
                                 return  = "all",
                                 spround = TRUE)$rij,
               ".93")
  
})

test_that("column_reliability produces the correct messages", {

  expect_message(column_reliability(data    = data_example,
                                    pattern = "scale1"),
               "scale1_item3")
  
  expect_message(column_reliability(data    = data_example,
                                    pattern = "scale1",
                                    message = FALSE),
                 NA)
  
})

test_that("column_reliability produces the correct warnings", {

  expect_warning(column_reliability(data    = data_example,
                                    pattern = "scale1",
                                    return  = "huh"),
                 "used instead")
  
  expect_equal(suppressWarnings(length(column_reliability(data    = data_example,
                                                          pattern = "scale1",
                                                          return  = "huh"))),
               3)
  
})

test_that("column_reliability produces the correct errors", {

  expect_error(column_reliability(data    = 1,
                                  pattern = "scale1"),
               "must be of type")
  
})
  
  
