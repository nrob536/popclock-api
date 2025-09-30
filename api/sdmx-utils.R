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
