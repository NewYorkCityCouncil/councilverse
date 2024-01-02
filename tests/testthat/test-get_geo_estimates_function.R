test_that("missing and incorrect geo inputs are handled appropriately", {

  ### EXPECT MESSAGE
  # no geo w/ no year
  expect_message(get_geo_estimates(), "requires a 'geo' parameter", class = "simpleMessage")
  # no geo w/ year
  expect_message(get_geo_estimates(boundary_year = "2023"), "requires a 'geo' parameter", class = "simpleMessage")
  # invalid geo
  expect_message(get_geo_estimates("block party", "2023"), "This geography could not be found", class = "simpleMessage")

})

test_that("missing, unnecessary, and incorrect boundary_year inputs are handled appropriately", {

  ### EXPECT MESSAGE
  # council w/ no year
  expect_message(get_geo_estimates("council"), "Setting `boundary_year`", class = "simpleMessage")
  # council w/ incorrect year
  expect_message(get_geo_estimates("council", "2053"), "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # non-council with unnecessary year
  expect_message(get_geo_estimates("borough", "2023"), "`boundary_year` is only relevant for `geo = council`", class = "simpleMessage")
  # non-council with incorrect year
  expect_message(get_geo_estimates("borough", "2043"), "`boundary_year` is only relevant for `geo = council`", class = "simpleMessage")

})

test_that("correct geo and boundary_year inputs work", {

  ### EXPECT NO MESSAGE
  # council 2023
  expect_no_message(get_geo_estimates("council", "2023"), message = "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # council 2013
  expect_no_message(get_geo_estimates("council", "2013"), message = "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # non-council w/ no year
  expect_no_message(get_geo_estimates("borough"), message = "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")

})
