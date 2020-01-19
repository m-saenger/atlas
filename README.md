
## Idea
Plot project map in R which covers the full paper size. Ideal for printing (PDF).

## Example 1: A4 Portrait with title, caption and axis 

![](https://myweather.ch/media/test1.png)

## Example 2: 1920x1080 plain

![](https://myweather.ch/media/test2.png)

Dependecies: 
fct.R
lib.R

## Example code

``` r
suppressPackageStartupMessages({
  # library(reprex)
  library(tidyverse)
  library(sf)
  library(cowplot)
  library(rnaturalearth) # Map data
  library(lwgeom) # Repair invalid polygons
})

source("lib.R")
source("fct.R")

# Map Definition
def <- list(
  id.paper = "a4p", # Paper size: DIN A4 portrait
  id.plot = "default", # Plot definitions
  id.margin = "full", # Paper margins
  id.ctry = "DEU",
  buffer.pct = .01
)

# Load country shapes from Natural Earth
sf.map <- ne_countries(scale = 'large', type = 'map_units', returnclass = 'sf')

# Filter country shapes
sf.ctry <- sf.map %>% filter(adm0_a3 %in% def$id.ctry)

# Process map definitions
def <- process_map(dat = sf.ctry, def, verbose = T)

# Transform to target projection and crop to extent
sf.ctry.out <- sf.map %>%
  st_transform(crs = st_crs(def$ext)) %>%
  sf::st_crop(def$ext)

pl <- ggplot(sf.ctry.out) +
  geom_sf(fill = "white") +
  geom_sf(data = sf.ctry.out %>% filter(adm0_a3 %in% def$id.ctry), fill = "grey70") +
  coord_sf(xlim = def$ext[c(1, 3)], ylim = def$ext[c(2, 4)], expand = F) +
  labs(
    title = "Seamless Maps Produced with R",
    subtitle = NULL,
    caption = "Author: M. Sänger | Projection: Lambert azimuthal equal-area | R Libraries: tidyverse, cowplot, rnaturalearth"
  ) +
  theme_bw(base_size = def$text.size) + #cowplot::theme_nothing() +
  theme(
    plot.title = element_text(vjust = .5, margin = margin(0, 0, 0, 0, unit = "mm")),
    plot.caption = element_text(vjust = .5, margin = margin(0, 0, 0, 0, unit = "mm")),
    aspect.ratio = def$asp,
    plot.background = element_rect(fill = "lightgreen", colour = NA, size = NA),
    panel.background = element_rect(fill = "lightblue"),
    panel.border = element_rect(colour = "black", size = def$border, fill = NA),
    panel.ontop = F,
    plot.margin = margin(0, 0, 0, 0, unit = "pt"),
    axis.text = element_text(margin = margin(0, 0, 0, 0, unit = "mm")),
    axis.title = element_text(margin = margin(0, 0, 0, 0, unit = "mm"))
  )

pl.final <- adjust_plot(pl, def, verbose = F) %>% cowplot::ggdraw()
print(pl.final)
```
