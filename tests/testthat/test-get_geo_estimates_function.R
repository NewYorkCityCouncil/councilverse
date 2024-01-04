test_that("missing parameters are correctly handled", {

  ### EXPECT MESSAGE
  # no entries
  expect_message(get_geo_estimates(), "This function is missing 2 parameters", class = "simpleMessage")
  # no var_code, no geo, yes boundary_year
  expect_message(get_geo_estimates(boundary_year = "2023"), "This function is missing 2 parameters", class = "simpleMessage")
  # yes var_code, no geo, no boundary_year,
  expect_message(get_geo_estimates(var_codes = c("DP02_0113E","DP02_0115E")), "requires a 'geo' parameter", class = "simpleMessage")
  # yes var_code, no geo, yes boundary_year
  expect_message(get_geo_estimates(var_codes = c("DP02_0113E","DP02_0115E"), boundary_year = "2023"), "requires a 'geo' parameter", class = "simpleMessage")
  # no var_code, yes geo, no boundary_year
  expect_message(get_geo_estimates(geo = "borough"), "requires a 'var_codes' parameter", class = "simpleMessage")
  # no var_code, yes geo, yes boundary_year
  expect_message(get_geo_estimates(geo = "borough", boundary_year = "2023"), "requires a 'var_codes' parameter", class = "simpleMessage")

})

test_that("incorrect geo and var_codes inputs are handled appropriately", {

  ### EXPECT MESSAGE
  # invalid geo
  expect_message(get_geo_estimates(c("DP02_0113E","DP02_0115E"), "block party", "2023"), "This geography could not be found", class = "simpleMessage")
  # typo in var_codes
  expect_message(get_geo_estimates(c("0000","DP02_0115E"), "councildist", "2023"), "The following variable codes could not be found", class = "simpleMessage")

})

test_that("missing, unnecessary, and incorrect boundary_year inputs are handled appropriately", {

  ### EXPECT MESSAGE
  # council w/ no year
  expect_message(get_geo_estimates(c("DP02_0113E","DP02_0115E"), "councildist"), "Setting `boundary_year`", class = "simpleMessage")
  # council w/ incorrect year
  expect_message(get_geo_estimates(c("DP02_0113E","DP02_0115E"), "councildist", "2053"), "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # non-council with unnecessary year
  expect_message(get_geo_estimates(c("DP02_0113E","DP02_0115E"), "borough", "2023"), "`boundary_year` is only relevant for `geo = councildist`", class = "simpleMessage")
  # non-council with incorrect year
  expect_message(get_geo_estimates(c("DP02_0113E","DP02_0115E"), "borough", "2043"), "`boundary_year` is only relevant for `geo = councildist`", class = "simpleMessage")

})

test_that("correct inputs work", {

  ### EXPECT NO MESSAGE
  # council 2023
  expect_no_message(get_geo_estimates(c("DP02_0113E","DP02_0115E"), "councildist", "2023"), message = "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # council 2013
  expect_no_message(get_geo_estimates(c("DP02_0113E","DP02_0115E"), "councildist", "2013"), message = "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # non-council w/ no year
  expect_no_message(get_geo_estimates(c("DP02_0113E","DP02_0115E"), "borough"), message = "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # "all" input for var_codes
  expect_no_message(get_geo_estimates("all", "borough"), message = "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")

})
