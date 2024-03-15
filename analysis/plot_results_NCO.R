#!/usr/bin/env Rscript

library(terra)
library(tidyterra)
library(ggplot2)
library(patchwork)

layers = c(
  "soil_evaporation",
  "potential_evapotranspiration",
  "evapotranspiration",
  "canopy_transpiration",
  "interception_evaporation",
  "potential_transpiration"
  #"SMAPsoil_evaporation",
  #"SMAPcanopy_transpiration",
  #"SMAPevapotranspiration"
)

prefix <- "default_AJ_"

file <- "./data/test_data_AJ/results/test/PTJPL_SMAP_ET_201606_mean_9km.nc"
path <- "./data/test_data_AJ/"

lapply(layers, function(layer){
  
  r <- rast(file, subds = layer) |>
    flip()
  
  reference <- rast(
    file.path(path, "reference/PTJPL_SMAP_ET_201606_mean.nc"),
    subds = layer) |> flip()
  
  # assign the EASE-2 grid extent
  terra::ext(r) <- c(-17367530.45, 17367530.45, -7314540.11, 7314540.11)
  
  # assign the coordinate system
  terra::crs(r) <-  "epsg:6933"
  
  diff <- reference - r
  diff[diff < -20] <- -20
  diff[diff > 20] <- 20
  
  reference <- project(reference, "epsg:4326")
  r <- project(r, "epsg:4326")
  diff <- project(diff, "epsg:4326")
  
  p <- ggplot() +
    geom_spatraster(data = r) +
    scale_fill_viridis_c(
      na.value = NA,
      limits = c(min(c(values(r), values(reference)), na.rm = TRUE),
                 max(c(values(r), values(reference)), na.rm = TRUE))
    ) +
    theme_minimal() +
    labs(
      title = sprintf("%s (new run)", layer)
    )
  
  p_ref <- ggplot() +
    geom_spatraster(data = reference) +
    scale_fill_viridis_c(
      limits = c(min(c(values(r), values(reference)), na.rm = TRUE),
                 max(c(values(r), values(reference)), na.rm = TRUE)),
      na.value = NA) +
    theme_minimal() +
    labs(
      title = sprintf("%s (reference)", layer)
    )
  
  p_diff <- ggplot() +
    geom_spatraster(data = diff) +
    scale_fill_gradient2(
      low = "blue",
      mid = "white",
      high = "red"
    ) +
    labs(
      title = "reference - new"
    ) +
    theme_minimal()
  
  p_final <- (p / p_ref / p_diff)
  
  ggsave(
    plot = p_final,
    filename = file.path("./figures/", sprintf("%s%s.png",prefix, layer)),
    width = 9,
    height = 12
  )
  gc()
})
