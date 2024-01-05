test_that("missing parameters are correctly handled", {

  ### EXPECT MESSAGE
  # default var_codes, no geo, no boundary_year
  expect_message(get_geo_estimates(), "requires a 'geo' parameter", class = "simpleMessage")
  # default var_codes, no geo, yes boundary_year
  expect_message(get_geo_estimates(boundary_year = "2023"), "requires a 'geo' parameter", class = "simpleMessage")
  # yes var_codes, no geo, no boundary_year,
  expect_message(get_geo_estimates(var_codes = c("DP02_0113E","DP02_0115E")), "requires a 'geo' parameter", class = "simpleMessage")
  # yes var_codes, no geo, yes boundary_year
  expect_message(get_geo_estimates(var_codes = c("DP02_0113E","DP02_0115E"), boundary_year = "2023"), "requires a 'geo' parameter", class = "simpleMessage")
  # geo and boundary_year provided without parameter names
  expect_message(get_geo_estimates("councildist", "2023"), "boundary_year input used for var_codes parameter", class = "simpleMessage")

})

test_that("incorrect geo and var_codes inputs are handled appropriately", {

  ### EXPECT MESSAGE
  # invalid geo
  expect_message(get_geo_estimates("block party", c("DP02_0113E","DP02_0115E"), "2023"), "This geography could not be found", class = "simpleMessage")
  # typo in var_codes
  expect_message(get_geo_estimates("councildist", c("0000","DP02_0115E"), "2023"), "The following variable codes could not be found", class = "simpleMessage")

})

test_that("missing, unnecessary, and incorrect boundary_year inputs are handled appropriately", {

  ### EXPECT MESSAGE
  # council w/ no year
  expect_message(get_geo_estimates("councildist", c("DP02_0113E","DP02_0115E")), "Setting `boundary_year`", class = "simpleMessage")
  # council w/ incorrect year
  expect_message(get_geo_estimates("councildist", c("DP02_0113E","DP02_0115E"), "2053"), "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # non-council with incorrect year
  expect_message(get_geo_estimates("borough", c("DP02_0113E","DP02_0115E"), "2043"), "`boundary_year` is only relevant for `geo = councildist`", class = "simpleMessage")
  # non-council with unnecessary year, yes var_codes
  expect_message(get_geo_estimates("borough", c("DP02_0113E","DP02_0115E"), "2023"), "`boundary_year` is only relevant for `geo = councildist`", class = "simpleMessage")
  # non-council with unnecessary year, default var_codes
  expect_message(get_geo_estimates(geo = "borough", boundary_year = "2023"), "`boundary_year` is only relevant for `geo = councildist`", class = "simpleMessage")

})

test_that("correct inputs work", {

  ### EXPECT NO MESSAGE
  # yes var_codes, council 2023
  expect_no_message(get_geo_estimates("councildist", c("DP02_0113E","DP02_0115E"), "2023"), message = "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # yes var_codes, council 2013
  expect_no_message(get_geo_estimates("councildist", c("DP02_0113E","DP02_0115E"), "2013"), message = "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # yes var_codes, non-council w/ no year
  expect_no_message(get_geo_estimates("borough", c("DP02_0113E","DP02_0115E")), message = "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # default var_codes, non-council w/ no year
  expect_no_message(get_geo_estimates("borough"), message = "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # "all" input for var_codes, non-council w/ no year
  expect_no_message(get_geo_estimates("borough", "all"), message = "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # geo and boundary_year provided with parameter names, default var_code
  expect_no_message(get_geo_estimates(geo = "councildist", boundary_year = "2023"), message = "boundary_year input used for var_codes parameter", class = "simpleMessage")

})

