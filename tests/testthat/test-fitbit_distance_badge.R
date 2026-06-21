# test fitbit_distance_badge
test_that("fitbit_distance_badge returns correct badges", {
  
  expect_equal(fitbit_distance_badge(1500, metric = TRUE), 
               "Italy")
  
  expect_equal(fitbit_distance_badge(1500, metric = FALSE), 
               "Pluto Width")
  
  expect_equal(fitbit_distance_badge(1500, metric = FALSE, fitbit_only = TRUE), 
               "New Zealand")
  
  expect_equal(fitbit_distance_badge(4000, metric = TRUE, fitbit_only = FALSE), 
               "Pluto Pole-to-Pole")
  
  expect_equal(fitbit_distance_badge(4000, metric = TRUE, fitbit_only = TRUE), 
               "India")
})


test_that("fitbit_distance_badge produces the correct errors", {

  expect_error(fitbit_distance_badge("1500", metric = FALSE, fitbit_only = TRUE),
               "must be of type")
  
  expect_error(fitbit_distance_badge(1500, metric = 1500, fitbit_only = TRUE),
               "must be of type")
  
  expect_error(fitbit_distance_badge(1500, metric = FALSE, fitbit_only = 1500),
               "must be of type")
  
})
  
  
