# Libraries
library(ggplot2)
library(dplyr)
library(zoo)

df <- readRDS("data/flux_data.rds") |>
  mutate(
    date = as.Date(as.character(TIMESTAMP), "%Y%m%d"),
    year = as.numeric(format(date, "%Y"))
  ) |>
  mutate(
    ET_roll_mean = rollmean(
      ET,
      k = 3,
      fill = NA,
      align = 'center'
      )
  ) |>
  filter(
    (date <= "2016-04-01" & date >= "2015-04-01")
  )

p <- ggplot(df) +
  geom_line(
    aes(
      date,
      ET_roll_mean
      #LE_F_MDS
    )
  ) +
  ylim(0, 150) +
  facet_wrap(
    ~sitename
  )

print(p)
