# plumber.R - Population Clock API with SDMX XML and SDMX-JSON support

library(plumber)
library(jsonlite)

# ---- Synthetic Parameters ----
population_start <- 5200000  # Starting population
birth_rate_per_sec <- 1 / 360 # 1 birth every 6 minutes (synthetic)
death_rate_per_sec <- 1 / 900 # 1 death every 15 minutes (synthetic)
migration_rate_per_sec <- 1 / 1800 # 1 migrant every 30 minutes (synthetic)
clock_start <- as.POSIXct("2024-01-01 00:00:00", tz = "UTC")

# ---- Helper function ----
calculate_population <- function(now) {
  elapsed <- as.numeric(difftime(now, clock_start, units = "secs"))
  births <- elapsed * birth_rate_per_sec
  deaths <- elapsed * death_rate_per_sec
  migration <- elapsed * migration_rate_per_sec
  estimate <- round(population_start + births - deaths + migration)
  list(
    estimate = estimate,
    births = round(births),
    deaths = round(deaths),
    migration = round(migration),
    timestamp = format(now, "%Y-%m-%d %H:%M:%S", tz = "UTC")
  )
}

# ---- SDMX XML generator ----
population_sdmx_xml <- function(data) {
  # Minimal SDMX GenericData structure
  xml <- sprintf(
    '<?xml version="1.0" encoding="UTF-8"?>
    <GenericData xmlns="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/message">
      <Header>
        <ID>pop-clock-001</ID>
        <Test>false</Test>
        <Prepared>%s</Prepared>
      </Header>
      <DataSet xmlns="http://www.sdmx.org/resources/sdmxml/schemas/v2_1/data/generic">
        <Series>
          <Obs>
            <ObsDimension value="estimate"/>
            <ObsValue value="%d"/>
          </Obs>
          <Obs>
            <ObsDimension value="births"/>
            <ObsValue value="%d"/>
          </Obs>
          <Obs>
            <ObsDimension value="deaths"/>
            <ObsValue value="%d"/>
          </Obs>
          <Obs>
            <ObsDimension value="migration"/>
            <ObsValue value="%d"/>
          </Obs>
        </Series>
      </DataSet>
    </GenericData>',
    data$timestamp, data$estimate, data$births, data$deaths, data$migration
  )
  xml
}

# ---- SDMX-JSON generator ----
population_sdmx_json <- function(data) {
  # Minimal SDMX-JSON structure, version 1.0
  # Reference: https://sdmx.org/?page_id=5096
  sdmx_json <- list(
    header = list(
      id = "pop-clock-001",
      test = FALSE,
      prepared = data$timestamp
    ),
    data = list(
      dataset = list(
        series = list(
          list(
            observations = list(
              estimate = data$estimate,
              births = data$births,
              deaths = data$deaths,
              migration = data$migration
            )
          )
        )
      )
    )
  )
  sdmx_json
}

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
function() {
  list(status = "ok")
}

# Test endpoints:
# http://localhost:8000/clock/estimate?format=json
# http://localhost:8000/clock/estimate?format=sdmx
# http://localhost:8000/clock/estimate?format=sdmx-json
# http://localhost:8000/clock/parameters
# http://localhost:8000/healthz
