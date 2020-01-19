## ------------------------------------- Libraries --------------------------------------

lib.paper <- list(
  a4p = list(w = 210, h = 297, dpi = 200), # A4 Portrait
  a4l = list(w = 297, h = 210, dpi = 200), # A4 Landscape
  a5p = list(w = 148, h = 210, dpi = 200), # A5 Portrait
  a5l = list(w = 210, h = 148, dpi = 200), # A5 Landscape
  lp = list(w = 215.9, h = 279.4, dpi = 200),  # Letter Portrait
  ll = list(w = 279.4, h = 215.9, dpi = 200),  # Letter Landscape
  hdl = list(w = 1920/72*25.4, h = 1080/72*25.4, dpi = 72), # 1920x1080 px
  hdp = list(w = 1080/72*25.4, h = 1920/72*25.4, dpi = 72) # 1920x1080 px
)

lib.paper.margin <- list(
  full = list(t = 0, r = 0, b = 0, l = 0),
  narrow = list(t = 15, r = 15, b = 15, l = 15)
)

lib.plot <- list(
  default = list(
    buffer.pct = .03, # Buffer around selected shape (%)
    axis.margin = list(t = 1.2, r = 1.2, b = 7, l = 14, title = 8, subtitle = 0, caption = 6), # mm 
    text.size = 14,
    panel.border = .5, # panel border size
    crs.src.str = "+proj=longlat +datum=WGS84 +no_defs", # Source CRS string
    crs.target.str = "+proj=laea +lon_0=%f +lat_0=%f" # Target CRS string (Lambert azimuthal)
  ),
  fullscreen = list(
    buffer.pct = .03, # Buffer around selected shape (%)
    axis.margin = list(t = 1.2, r = 1.2, b = 1.2, l = 1.2, title = 0, subtitle = 0, caption = 0), # mm 
    text.size = 14,
    panel.border = .5, # panel border size
    crs.src.str = "+proj=longlat +datum=WGS84 +no_defs", # Source CRS string
    crs.target.str = "+proj=laea +lon_0=%f +lat_0=%f" # Target CRS string (Lambert azimuthal)
  )
)

lib.proj <- list(
  lae = list(name = "Lambert azimuthal equal-area projection", crs.target.str = "+proj=laea +lon_0=%f +lat_0=%f"),
  moll = list(name = "Mollweide", crs.target.str = '+proj=moll +lon_0=%f +x_0=0 +y_0=0 +ellps=WGS84 +units=m +no_defs')
)