library(terra)
library(tidyterra)
library(ggplot2)
library(patchwork)

layers = c(
  "evapotranspiration",
  "SMAPevapotranspiration"
  )

data_layers <- lapply(layers, function(layer){

  #files <- list.files("~/Desktop/test_data/results/","*.nc", full.names = TRUE)
  files <- list.files("/media/khufkens/data/datasets/PTJPLsm/test_data_AJ/results/","*.nc", full.names = TRUE)
  files <- files[grepl("201606", files)]

  r <- rast(files, subds = layer)
  r <- mean(r, na.rm = TRUE) |> flip()

  # assign the EASE-2 grid extent
  terra::ext(r) <- c(-17367530.45, 17367530.45, -7314540.11, 7314540.11)

  # assign the coordinate system
  terra::crs(r) <-  "epsg:6933"

  r <- project(r, "epsg:4326")

  gc()
  return(r)
})

diff <- data_layers[[2]] - data_layers[[1]]

p <- ggplot() +
  geom_spatraster(data = data_layers[[2]]) +
  scale_fill_viridis_c(
    na.value = NA
  ) +
  theme_minimal() +
  labs(
    title = "PT-JPLsm"
  )

p_ref <- ggplot() +
  geom_spatraster(data = data_layers[[1]]) +
  scale_fill_viridis_c(
    na.value = NA) +
  theme_minimal() +
  labs(title = "PT-JPL")

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

plot(p_final)

ggsave(
  plot = p_final,
  filename = sprintf("~/Desktop/%s.png", "overview"),
  width = 12,
  height = 9
)
