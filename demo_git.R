
dir.plot <- ""

## ------------------------------------- R Libraries --------------------------------------
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

## ------------------------------------- Example 1 A4 Portrait --------------------------------------
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

#' Find and repair polygons if necessary:
#'   lwgeom::st_make_valid() %>%
#'   filter(st_is_valid({.})) %>%

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

ggsave(file.path(dir.plot, "test1.pdf"), plot = pl.final, width = def$paper$w, height = def$paper$h, scale = 1, units = "mm", dpi = def$paper$dpi)
ggsave(file.path(dir.plot, "test1.png"), plot = pl.final, width = def$paper$w, height = def$paper$h, scale = 1, units = "mm", dpi = def$paper$dpi)

## ------------------------------------- Example 2 1920x1080 plain --------------------------------------
# Map Definition

def <- list(
  id.paper = "hdl", # Paper size: DIN A4 landscape
  id.plot = "fullscreen", # Plot definitions
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

#' Find and repair polygons if necessary:
#'   lwgeom::st_make_valid() %>%
#'   filter(st_is_valid({.})) %>%

pl <- ggplot(sf.ctry.out) +
  geom_sf(fill = "white") +
  geom_sf(data = sf.ctry.out %>% filter(adm0_a3 %in% def$id.ctry), fill = "grey70") +
  coord_sf(xlim = def$ext[c(1, 3)], ylim = def$ext[c(2, 4)], expand = F) +
  theme_bw(base_size = def$text.size) + 
  theme(
    plot.title = element_text(vjust = .5, margin = margin(0, 0, 0, 0, unit = "mm")),
    plot.caption = element_text(vjust = .5, margin = margin(0, 0, 0, 0, unit = "mm")),
    aspect.ratio = def$asp,
    plot.background = element_rect(fill = "lightgreen", colour = NA, size = NA),
    panel.background = element_rect(fill = "lightblue"),
    panel.border = element_rect(colour = "black", size = def$border, fill = NA),
    panel.ontop = F,
    plot.margin = margin(0, 0, 0, 0, unit = "pt"),
    axis.text = element_blank(),
    axis.title = element_blank(),
    axis.ticks = element_blank()
  )

pl.final <- adjust_plot(pl, def, verbose = F) %>% cowplot::ggdraw()
print(pl.final)

ggsave(file.path(dir.plot, "test2.pdf"), plot = pl.final, width = def$paper$w, height = def$paper$h, scale = 1, units = "mm", dpi = def$paper$dpi)
ggsave(file.path(dir.plot, "test2.png"), plot = pl.final, width = def$paper$w, height = def$paper$h, scale = 1, units = "mm", dpi = def$paper$dpi)

