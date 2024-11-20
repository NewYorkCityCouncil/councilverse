test_that("missing parameters are correctly handled", {

  ### EXPECT MESSAGE
  # no inputs
  expect_message(get_geo_estimates(), "requires an `acs_year` parameter", class = "simpleMessage")
  # no `acs_year`, default `var_codes`, yes `geo`, no `boundary_year`
  expect_message(get_geo_estimates(geo="borough"), "requires an `acs_year` parameter", class = "simpleMessage")
  # yes `acs_year`, default `var_codes`, no `geo`, no `boundary_year`
  expect_message(get_geo_estimates(acs_year="2022"), "requires a `geo` parameter", class = "simpleMessage")
  # no `acs_year`, default `var_codes`, no `geo`, yes `boundary_year`
  expect_message(get_geo_estimates(boundary_year="2023"), "requires an `acs_year` parameter", class = "simpleMessage")
  # no `acs_year`, yes `var_codes`, no `geo`, no `boundary_year`,
  expect_message(get_geo_estimates(var_codes=c("DP02_0113E","DP02_0115E")), "requires an `acs_year` parameter", class = "simpleMessage")
  # yes `acs_year`, yes `var_codes`, no `geo`, yes `boundary_year`
  expect_message(get_geo_estimates(acs_year="2022", var_codes=c("DP02_0113E","DP02_0115E"), boundary_year="2023"), "requires a `geo` parameter", class = "simpleMessage")

})

test_that("incorrect inputs are handled appropriately", {

  ### EXPECT MESSAGE OR ERROR
  # invalid `acs_year`
  expect_message(get_geo_estimates("202", "borough", c("DP02_0113E","DP02_0115E"), "2023"), 'The ACS year "202" could not be found', class = "simpleMessage")
  # invalid `geo`
  expect_message(get_geo_estimates("2022", "block party", c("DP02_0113E","DP02_0115E"), "2023"), 'The geography "block party" could not be found', class = "simpleMessage")
  # typo in `var_codes`
  expect_error(get_geo_estimates("2022", "councildist", c("0000", "DP02_0115E"), "2023"), "Estimates for the variable code 0000 are not available", class = "simpleError")
  # invalid `boundary_year`
  expect_message(get_geo_estimates("2022", "councildist", c("DP02_0113E","DP02_0115E"), "2024"), "Overriding `boundary_year` input to 2023", class = "simpleMessage")
  # inputs provided without parameter names + default `var_codes`
  expect_error(get_geo_estimates("2022", "councildist", "2023"), "Estimates for the variable code 2023 are not available", class = "simpleError")

})

test_that("missing or unnecessary `boundary_year` inputs are handled appropriately", {

  ### EXPECT MESSAGE
  # councildist w/ no year
  expect_message(get_geo_estimates("2022", "councildist", c("DP02_0113E","DP02_0115E")), "Overriding `boundary_year` input to 2023", class = "simpleMessage")
  # non-councildist with incorrect year
  expect_message(get_geo_estimates("2022", "borough", c("DP02_0113E","DP02_0115E"), "2043"), "Overriding `boundary_year` input to NULL", class = "simpleMessage")
  # non-councildist with unnecessary (but correct) `boundary_year`, yes `var_codes`
  expect_message(get_geo_estimates("2022", "borough", c("DP02_0113E","DP02_0115E"), "2023"), "Overriding `boundary_year` input to NULL", class = "simpleMessage")
  # non-councildist with unnecessary (but correct) `boundary_year`, default var_codes
  expect_message(get_geo_estimates("2022", geo = "borough", boundary_year = "2023"), "Overriding `boundary_year` input to NULL", class = "simpleMessage")

})

test_that("correct inputs work", {

  ### EXPECT NO MESSAGE
  # 'councildist' chosen, `boundary_year` included
  expect_no_message(get_geo_estimates("2022" ,"councildist", c("DP02_0113E","DP02_0115E"), "2023"), message = "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # non-councildist w/ no `boundary_year`
  expect_no_message(get_geo_estimates("2022", "borough", c("DP02_0113E","DP02_0115E")), message = "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # default `var_codes`, non-councildist w/ no `boundary_year`
  expect_no_message(get_geo_estimates("2022", "borough"), message = "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # "all" input for `var_codes`, non-councildist w/ no year
  expect_no_message(get_geo_estimates("2022", "borough", "all"), message = "`boundary_year` must be '2013' or '2023'", class = "simpleMessage")
  # `acs_year`, `geo`, and `boundary_year` provided with parameter names, default `var_codes`
  expect_no_message(get_geo_estimates(acs_year="2022", geo="councildist", boundary_year="2023"), message = "boundary_year input used for var_codes parameter", class = "simpleMessage")

})

