# plumber.R - Population Clock API with SDMX XML and SDMX-JSON support

library(plumber)
library(jsonlite)

source("sdmx-utils.R")
source("population-logic.R")
source("helpers.R")

#* @apiTitle Population Clock API

#* Get current population estimate (SDMX XML, SDMX-JSON, or regular JSON)
#* @get /clock/estimate
#* @param format:character Output format: 'json' (default), 'sdmx' (SDMX-XML), 'sdmx-json' (SDMX-JSON)
function(format = "json", res) {
  now <- Sys.time()
  result <- calculate_population(now)
  fmt <- tolower(format)
  if (fmt == "sdmx") {
    res$body <- population_sdmx_xml(result)
    res$setHeader("Content-Type", "application/xml")
    return(res)
  } else if (fmt == "sdmx-json") {
    res$body <- toJSON(population_sdmx_json(result), auto_unbox = TRUE, pretty = TRUE)
    res$setHeader("Content-Type", "application/json")
    return(res)
  } else {
    # Default: regular JSON
    result
  }
}

#* Get synthetic parameters used for calculation
#* @get /clock/parameters
function() {
  list(
    population_start = population_start,
    birth_rate_per_sec = birth_rate_per_sec,
    death_rate_per_sec = death_rate_per_sec,
    migration_rate_per_sec = migration_rate_per_sec,
    clock_start = format(clock_start, "%Y-%m-%d %H:%M:%S", tz = "UTC")
  )
}

#* Health check endpoint
#* @get /healthz
function () {
  list(status = "API is up and running")
}

# Test endpoints:
# http://localhost:8000/clock/estimate?format=json
# http://localhost:8000/clock/estimate?format=sdmx
# http://localhost:8000/clock/estimate?format=sdmx-json
# http://localhost:8000/clock/parameters
# http://localhost:8000/healthz