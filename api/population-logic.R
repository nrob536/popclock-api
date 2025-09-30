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

