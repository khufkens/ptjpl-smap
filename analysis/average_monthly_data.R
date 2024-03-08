# libraries
library(terra)
library(dplyr)

output_path <- "/media/khufkens/T7-unencrypted/PTJPLsm_results_monthly/"

files <- list.files(
  "/media/khufkens/T7-unencrypted/PTJPLsm_results/",
  "*.nc",
  full.names = TRUE
)

files <- data.frame(file = files) |>
  mutate(
    date = substr(basename(file),15,22),
    date = as.Date(date, "%Y%m%d"),
    year = as.numeric(format(date, "%Y")),
    month = as.numeric(format(date, "%m"))
  ) |>
  filter(
    year == 2016,
    month <= 1
  )

files |>
  group_by(year, month) |>
  do({
    r <- rast(.$file)
    r_mean <- tapp(
      r,
      index = varnames(r),
      fun = "mean",
      na.rm = TRUE
      )

   names(r_mean) <- unique(varnames(r))
   r_mean_flip <- flip(r_mean)

   # assign the EASE-2 grid extent
   terra::ext(r_mean_flip) <- c(-17367530.45, 17367530.45, -7314540.11, 7314540.11)

   # assign the coordinate system
   terra::crs(r_mean_flip) <-  "epsg:6933"

   plot(r_mean_flip)

    filename <- file.path(
      output_path,
      sprintf("test_%s%s_mean.nc", .$year[1], .$month[1])
    )

    writeCDF(
      r_mean_flip,
      filename = filename,
      overwrite = TRUE
    )

  })
