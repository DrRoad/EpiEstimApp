context("Test Suite 4 (E2E) --> Incidence")

library(RSelenium)
library(testthat)
library(EpiEstim)
source("functions.R", local=TRUE)


# ---------------------------------------------------------------------------#
# Test 1 - Default                                                           #
# ---------------------------------------------------------------------------#
drivers <- getRemDrivers("Test Suite 4 (E2E) --> Incidence (Test 1)")
rD <- drivers$rDr
remDr <- drivers$remDr

appOut <- NULL
openRemDriver(remDr)
tryCatch({
  test_that("can connect to app", {
    connectToApp(remDr)
  })

  test_that("app is ready within 30 seconds", {
    waitForAppReady(remDr)
  })

  test_that("can walk through the app to endpoint state (Test 1)", {
      # Walk the app through to endpoint state with default inputs
    click(remDr, pages$state1.1$selectors$own_data_button)
    clickNext(remDr) # Move to state 2.1
    waitForStateDisplayed(remDr, "2.1")
    if (getAttribute(remDr, pages$state2.1$selectors$incidence_data_upload_input, "value") == "") {
      # SAUCELABS gives an error about interacting with an element
      # which is not currently visible. Explicitly show the element
      # first to fix this?
      setAttribute(remDr, pages$state2.1$selectors$incidence_data_upload_input, "style", "display: block;")
      path <- getFilePath(remDr, "datasets/IncidenceData/H1N1Pennsylvania2009.csv")
      sendKeys(remDr, pages$state2.1$selectors$incidence_data_upload_input,
               path)
    }
    clickNext(remDr) # Move to state 3.1
    waitForStateDisplayed(remDr, "3.1")
    click(remDr, pages$state3.1$selectors$imported_no_button)
    clickNext(remDr) # Move to state 5.1
    waitForStateDisplayed(remDr, "5.1")
    click(remDr, pages$state5.1$selectors$exposure_data_yes_input)
    clickNext(remDr) # Move to state 6.1
    waitForStateDisplayed(remDr, "6.1")
    click(remDr, pages$state6.1$selectors$si_data_type_preloaded_button)
    clickNext(remDr) # Move to state 7.1
    waitForStateDisplayed(remDr, "7.1")
    click(remDr, pages$state7.1$selectors$dataset_option_1_input)
    clickNext(remDr) # Move to state 8.1
    waitForStateDisplayed(remDr, "8.1")
    click(remDr, pages$state8.1$selectors$distribution_option_1_input)
    sendKeys(remDr, pages$state8.1$selectors$seed_input, "1")
    clickGo(remDr)
    Sys.sleep(1)
    waitForAppReady(remDr)

    appOut <<- extractOutputFromApp(remDr)
    closeRemDrivers(remDr, rD)
  })
},
error = function(e) {
  closeRemDrivers(remDr, rD)
  stop(e)
})


test_that("Test 1 output matches", {
  # Compare the output to EpiEstim's output
  incid <- read.csv(paste(appDir, 'datasets/IncidenceData/H1N1Pennsylvania2009.csv', sep='/'), header=FALSE)
  incid <- EpiEstim:::process_I(incid)
  sample <- read.csv(paste(appDir, "datasets/SIPosteriorSamples/RotavirusEcuador2011_SISamples_G.csv", sep="/"), header=FALSE)
  sample <- EpiEstim:::process_si_sample(sample)

  epiEstimOut <- estimate_R(incid, method="si_from_sample", si_sample=sample,
                           config=list(t_start=2:26, t_end=8:32, n2=100, seed=1)
  )

  compareOutputFromApp(appOut, epiEstimOut)
})


# ---------------------------------------------------------------------------#
# Test 2 - Different Incidence Data (1)                                      #
# ---------------------------------------------------------------------------#
drivers <- getRemDrivers("Test Suite 4 (E2E) --> Incidence (Test 2)")
rD <- drivers$rDr
remDr <- drivers$remDr

appOut <- NULL
openRemDriver(remDr)
tryCatch({
  test_that("can connect to app", {
    connectToApp(remDr)
  })

  test_that("app is ready within 30 seconds", {
    waitForAppReady(remDr)
  })

  test_that("can walk through the app to endpoint state (Test 2)", {
      # Walk the app through to endpoint state with default inputs
    click(remDr, pages$state1.1$selectors$own_data_button)
    clickNext(remDr) # Move to state 2.1
    waitForStateDisplayed(remDr, "2.1")
    if (getAttribute(remDr, pages$state2.1$selectors$incidence_data_upload_input, "value") == "") {
      # SAUCELABS gives an error about interacting with an element
      # which is not currently visible. Explicitly show the element
      # first to fix this?
      setAttribute(remDr, pages$state2.1$selectors$incidence_data_upload_input, "style", "display: block;")
      path <- getFilePath(remDr, "datasets/IncidenceData/RotavirusKiribati2013.csv") # <---
      sendKeys(remDr, pages$state2.1$selectors$incidence_data_upload_input,
               path)
    }
    clickNext(remDr) # Move to state 3.1
    waitForStateDisplayed(remDr, "3.1")
    click(remDr, pages$state3.1$selectors$imported_no_button)
    clickNext(remDr) # Move to state 5.1
    waitForStateDisplayed(remDr, "5.1")
    click(remDr, pages$state5.1$selectors$exposure_data_yes_input)
    clickNext(remDr) # Move to state 6.1
    waitForStateDisplayed(remDr, "6.1")
    click(remDr, pages$state6.1$selectors$si_data_type_preloaded_button)
    clickNext(remDr) # Move to state 7.1
    waitForStateDisplayed(remDr, "7.1")
    click(remDr, pages$state7.1$selectors$dataset_option_1_input)
    clickNext(remDr) # Move to state 8.1
    waitForStateDisplayed(remDr, "8.1")
    click(remDr, pages$state8.1$selectors$distribution_option_1_input)
    sendKeys(remDr, pages$state8.1$selectors$seed_input, "1")
    clickGo(remDr)
    Sys.sleep(1)
    waitForAppReady(remDr)

    appOut <<- extractOutputFromApp(remDr)
    closeRemDrivers(remDr, rD)
  })
},
error = function(e) {
  closeRemDrivers(remDr, rD)
  stop(e)
})


test_that("Test 2 output matches", {
  # Compare the output to EpiEstim's output
  incid <- read.csv(paste(appDir, 'datasets/IncidenceData/RotavirusKiribati2013.csv', sep='/'), header=FALSE)
  incid <- EpiEstim:::process_I(incid)
  sample <- read.csv(paste(appDir, "datasets/SIPosteriorSamples/RotavirusEcuador2011_SISamples_G.csv", sep="/"), header=FALSE)
  sample <- EpiEstim:::process_si_sample(sample)

  epiEstimOut <- estimate_R(incid, method="si_from_sample", si_sample=sample,
                           config=list(t_start=2:17, t_end=8:23, n2=100, seed=1)
  )

  compareOutputFromApp(appOut, epiEstimOut)
})


# ---------------------------------------------------------------------------#
# Test 3 - Different Incidence Data (2)                                      #
# ---------------------------------------------------------------------------#
drivers <- getRemDrivers("Test Suite 4 (E2E) --> Incidence (Test 3)")
rD <- drivers$rDr
remDr <- drivers$remDr

appOut <- NULL
openRemDriver(remDr)
tryCatch({
  test_that("can connect to app", {
    connectToApp(remDr)
  })

  test_that("app is ready within 30 seconds", {
    waitForAppReady(remDr)
  })

  test_that("can walk through the app to endpoint state (Test 3)", {
      # Walk the app through to endpoint state with default inputs
    click(remDr, pages$state1.1$selectors$own_data_button)
    clickNext(remDr) # Move to state 2.1
    waitForStateDisplayed(remDr, "2.1")
    if (getAttribute(remDr, pages$state2.1$selectors$incidence_data_upload_input, "value") == "") {
      # SAUCELABS gives an error about interacting with an element
      # which is not currently visible. Explicitly show the element
      # first to fix this?
      setAttribute(remDr, pages$state2.1$selectors$incidence_data_upload_input, "style", "display: block;")
      path <- getFilePath(remDr, "datasets/IncidenceData/H1N1NewYork2009.csv") # <---
      sendKeys(remDr, pages$state2.1$selectors$incidence_data_upload_input,
               path)
    }
    clickNext(remDr) # Move to state 3.1
    waitForStateDisplayed(remDr, "3.1")
    click(remDr, pages$state3.1$selectors$imported_no_button)
    clickNext(remDr) # Move to state 5.1
    waitForStateDisplayed(remDr, "5.1")
    click(remDr, pages$state5.1$selectors$exposure_data_yes_input)
    clickNext(remDr) # Move to state 6.1
    waitForStateDisplayed(remDr, "6.1")
    click(remDr, pages$state6.1$selectors$si_data_type_preloaded_button)
    clickNext(remDr) # Move to state 7.1
    waitForStateDisplayed(remDr, "7.1")
    click(remDr, pages$state7.1$selectors$dataset_option_1_input)
    clickNext(remDr) # Move to state 8.1
    waitForStateDisplayed(remDr, "8.1")
    click(remDr, pages$state8.1$selectors$distribution_option_1_input)
    sendKeys(remDr, pages$state8.1$selectors$seed_input, "1")
    clickGo(remDr)
    Sys.sleep(1)
    waitForAppReady(remDr)

    appOut <<- extractOutputFromApp(remDr)
    closeRemDrivers(remDr, rD)
  })
},
error = function(e) {
  closeRemDrivers(remDr, rD)
  stop(e)
})


test_that("Test 3 output matches", {
  # Compare the output to EpiEstim's output
  incid <- read.csv(paste(appDir, 'datasets/IncidenceData/H1N1NewYork2009.csv', sep='/'), header=FALSE)
  incid <- EpiEstim:::process_I(incid)
  sample <- read.csv(paste(appDir, "datasets/SIPosteriorSamples/RotavirusEcuador2011_SISamples_G.csv", sep="/"), header=FALSE)
  sample <- EpiEstim:::process_si_sample(sample)

  epiEstimOut <- estimate_R(incid, method="si_from_sample",si_sample=sample,
                           config=list(t_start=2:8, t_end=8:14, n2=100, seed=1)
  )

  compareOutputFromApp(appOut, epiEstimOut)
})


# ---------------------------------------------------------------------------#
# Test 4 - Different mean_prior                                              #
# ---------------------------------------------------------------------------#
drivers <- getRemDrivers("Test Suite 4 (E2E) --> Incidence (Test 4)")
rD <- drivers$rDr
remDr <- drivers$remDr

appOut <- NULL
openRemDriver(remDr)
tryCatch({
  test_that("can connect to app", {
    connectToApp(remDr)
  })

  test_that("app is ready within 30 seconds", {
    waitForAppReady(remDr)
  })

  test_that("can walk through the app to endpoint state (Test 4)", {
      # Walk the app through to endpoint state with default inputs
    click(remDr, pages$state1.1$selectors$own_data_button)
    clickNext(remDr) # Move to state 2.1
    waitForStateDisplayed(remDr, "2.1")
    if (getAttribute(remDr, pages$state2.1$selectors$incidence_data_upload_input, "value") == "") {
      # SAUCELABS gives an error about interacting with an element
      # which is not currently visible. Explicitly show the element
      # first to fix this?
      setAttribute(remDr, pages$state2.1$selectors$incidence_data_upload_input, "style", "display: block;")
      path <- getFilePath(remDr, "datasets/IncidenceData/H1N1Pennsylvania2009.csv")
      sendKeys(remDr, pages$state2.1$selectors$incidence_data_upload_input,
               path)
    }
    clear(remDr, pages$state2.1$selectors$mean_prior_input) # <---
    sendKeys(remDr, pages$state2.1$selectors$mean_prior_input, "6") # <---
    clickNext(remDr) # Move to state 3.1
    waitForStateDisplayed(remDr, "3.1")
    click(remDr, pages$state3.1$selectors$imported_no_button)
    clickNext(remDr) # Move to state 5.1
    waitForStateDisplayed(remDr, "5.1")
    click(remDr, pages$state5.1$selectors$exposure_data_yes_input)
    clickNext(remDr) # Move to state 6.1
    waitForStateDisplayed(remDr, "6.1")
    click(remDr, pages$state6.1$selectors$si_data_type_preloaded_button)
    clickNext(remDr) # Move to state 7.1
    waitForStateDisplayed(remDr, "7.1")
    click(remDr, pages$state7.1$selectors$dataset_option_1_input)
    clickNext(remDr) # Move to state 8.1
    waitForStateDisplayed(remDr, "8.1")
    click(remDr, pages$state8.1$selectors$distribution_option_1_input)
    sendKeys(remDr, pages$state8.1$selectors$seed_input, "1")
    clickGo(remDr)
    Sys.sleep(1)
    waitForAppReady(remDr)

    appOut <<- extractOutputFromApp(remDr)
    closeRemDrivers(remDr, rD)
  })
},
error = function(e) {
  closeRemDrivers(remDr, rD)
  stop(e)
})


test_that("Test 4 output matches", {
  # Compare the output to EpiEstim's output
  incid <- read.csv(paste(appDir, 'datasets/IncidenceData/H1N1Pennsylvania2009.csv', sep='/'), header=FALSE)
  incid <- EpiEstim:::process_I(incid)
  sample <- read.csv(paste(appDir, "datasets/SIPosteriorSamples/RotavirusEcuador2011_SISamples_G.csv", sep="/"), header=FALSE)
  sample <- EpiEstim:::process_si_sample(sample)

  epiEstimOut <- estimate_R(incid, method="si_from_sample", si_sample=sample,
                           config=list(n2=100, seed=1, mean_prior=6,
                                       t_start=2:26, t_end=8:32)
  )

  compareOutputFromApp(appOut, epiEstimOut)
})


# ---------------------------------------------------------------------------#
# Test 5 - Different std_prior                                               #
# ---------------------------------------------------------------------------#
drivers <- getRemDrivers("Test Suite 4 (E2E) --> Incidence (Test 5)")
rD <- drivers$rDr
remDr <- drivers$remDr

appOut <- NULL
openRemDriver(remDr)
tryCatch({
  test_that("can connect to app", {
    connectToApp(remDr)
  })

  test_that("app is ready within 30 seconds", {
    waitForAppReady(remDr)
  })

  test_that("can walk through the app to endpoint state (Test 5)", {
      # Walk the app through to endpoint state with default inputs
    click(remDr, pages$state1.1$selectors$own_data_button)
    clickNext(remDr) # Move to state 2.1
    waitForStateDisplayed(remDr, "2.1")
    if (getAttribute(remDr, pages$state2.1$selectors$incidence_data_upload_input, "value") == "") {
      # SAUCELABS gives an error about interacting with an element
      # which is not currently visible. Explicitly show the element
      # first to fix this?
      setAttribute(remDr, pages$state2.1$selectors$incidence_data_upload_input, "style", "display: block;")
      path <- getFilePath(remDr, "datasets/IncidenceData/H1N1Pennsylvania2009.csv")
      sendKeys(remDr, pages$state2.1$selectors$incidence_data_upload_input,
               path)
    }
    clear(remDr, pages$state2.1$selectors$std_prior_input) # <---
    sendKeys(remDr, pages$state2.1$selectors$std_prior_input, "6") # <---
    clickNext(remDr) # Move to state 3.1
    waitForStateDisplayed(remDr, "3.1")
    click(remDr, pages$state3.1$selectors$imported_no_button)
    clickNext(remDr) # Move to state 5.1
    waitForStateDisplayed(remDr, "5.1")
    click(remDr, pages$state5.1$selectors$exposure_data_yes_input)
    clickNext(remDr) # Move to state 6.1
    waitForStateDisplayed(remDr, "6.1")
    click(remDr, pages$state6.1$selectors$si_data_type_preloaded_button)
    clickNext(remDr) # Move to state 7.1
    waitForStateDisplayed(remDr, "7.1")
    click(remDr, pages$state7.1$selectors$dataset_option_1_input)
    clickNext(remDr) # Move to state 8.1
    waitForStateDisplayed(remDr, "8.1")
    click(remDr, pages$state8.1$selectors$distribution_option_1_input)
    sendKeys(remDr, pages$state8.1$selectors$seed_input, "1")
    clickGo(remDr)
    Sys.sleep(1)
    waitForAppReady(remDr)

    appOut <<- extractOutputFromApp(remDr)
    closeRemDrivers(remDr, rD)
  })
},
error = function(e) {
  closeRemDrivers(remDr, rD)
  stop(e)
})


test_that("Test 5 output matches", {
  # Compare the output to EpiEstim's output
  incid <- read.csv(paste(appDir, 'datasets/IncidenceData/H1N1Pennsylvania2009.csv', sep='/'), header=FALSE)
  incid <- EpiEstim:::process_I(incid)
  sample <- read.csv(paste(appDir, "datasets/SIPosteriorSamples/RotavirusEcuador2011_SISamples_G.csv", sep="/"), header=FALSE)
  sample <- EpiEstim:::process_si_sample(sample)

  epiEstimOut <- estimate_R(incid, method="si_from_sample", si_sample=sample,
                           config=list(n2=100, seed=1, std_prior=6,
                                       t_start=2:26, t_end=8:32)
  )

  compareOutputFromApp(appOut, epiEstimOut)
})


