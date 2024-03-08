library(terra)
library(tidyterra)
library(ggplot2)


r <- rast("/media/khufkens/T7-unencrypted/PTJPLsm/merra_forcing/merra2_forcing_9km_20160501.nc")
r_aj <- rast("/media/khufkens/T7-unencrypted/PTJPLsm_ref/merra_forcing/merra2_forcing_36km_20160501.nc")

layers <- varnames(r)

lapply(layers, function(layer){

  r_s <- subset(r, layer)
  r_aj_s <- subset(r_aj, layer)

  r_diff <- r_s - r_aj_s

  # assign the EASE-2 grid extent
  terra::ext(r_diff) <- c(-17367530.45, 17367530.45, -7314540.11, 7314540.11)

  # assign the coordinate system
  terra::crs(r_diff) <-  "epsg:6933"

  r_diff <- flip(r_diff)

  p <- ggplot() +
    geom_spatraster(data = r_diff) +
    scale_fill_gradient2(
      na.value = NA
    ) +
    theme(legend.position = "bottom") +
    #theme_minimal() +
    labs(
      title = sprintf("%s (new - references)", layer)
    )

  ggsave(filename = sprintf("~/Desktop/MERRA_comparison_%s.png", layer),
         width = 12,
         height = 7)

})
