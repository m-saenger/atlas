## ------------------------------------- Functions --------------------------------------

calc_extent <- function(dat, width, height, crs.target.str, buffer.pct = 0.02, verbose = F){
  #' @description Calculates extent on target CRS for given shape
  
  # Convex hull (summarise required to aggregate areas)
  sf.ch <- dat %>% 
    summarise %>% 
    st_geometry %>% 
    st_convex_hull
  
  if(verbose) ggplot() + geom_sf(data = dat) + geom_sf(data = sf.ch, fill = NA)
    
  # Centroid (approximate, ignore warnings)
  centroid <- sf.ch %>% 
    st_centroid %>% 
    st_coordinates %>% 
    as.vector

  crs.target <- sprintf(crs.target.str, centroid[1], centroid[2])
  
  out.ch <- sf.ch %>% st_transform(crs.target)
  out.bbox <- out.ch %>% st_bbox
  
  # Add buffer
  buffer.dist <- buffer.pct * mean(c(diff(out.bbox[c(1, 3)]), diff(out.bbox[c(2, 4)])))
  out.ch.buffer <- out.ch %>% st_buffer(dist = buffer.dist, endCapStyle = "SQUARE")
  
  # Buffered bbox
  out.bbox.buffer <- out.ch.buffer %>% st_bbox
  out.bbox.buffer.vec <- as.vector(out.bbox.buffer)
  
  asp.geo <- diff(out.bbox.buffer.vec[c(2, 4)])/diff(out.bbox.buffer.vec[c(1, 3)])
  asp.paper <- height/width
  asp.ratio <- asp.paper/asp.geo
  
  # Adjust extent
  if(asp.ratio > 1){ # Expand height
    print("Expand height")
    bbox.target <- c(out.bbox.buffer.vec) + c(0, asp.ratio - 1, 0, asp.ratio - 1) * c(out.bbox.buffer.vec)  
  } else {
    print("Expand width")
    bbox.target <- c(out.bbox.buffer.vec) + c(1/asp.ratio - 1, 0, 1/asp.ratio - 1, 0) * c(out.bbox.buffer.vec)
  }
  bbox.adj <- st_bbox(setNames(bbox.target, c("xmin", "ymin", "xmax", "ymax")), crs = crs.target)
  
  if(verbose) {
    ggplot() + 
      geom_sf(data = st_as_sfc(bbox.adj), fill = NA) + 
      geom_sf(data = out.ch.buffer, colour = "blue", fill = NA) + 
      geom_sf(data = out.ch, colour = "red", fill = NA)
  }
  # Return adjusted bbox
  bbox.adj
}

process_map <- function(dat, def, verbose = F){
  #' @description Process map definitions, calculate extent for target CRS

  def <- modifyList(lib.plot[[def$id.plot]], def)
  def$paper <- lib.paper[[def$id.paper]]
  def$paper.margin <- lib.paper.margin[[def$id.margin]]
  
  # Substract axis margins
  def$paper$w_i <- def$paper$w - def$axis.margin$l - def$axis.margin$r
  def$paper$h_i <- def$paper$h - def$axis.margin$t - def$axis.margin$b 
  
  # Substract plot elements
  def$paper$h_i <- def$paper$h_i - def$axis.margin$title - def$axis.margin$subtitle - def$axis.margin$caption
  
  # Substract paper margin
  def$paper$h_i <- def$paper$h_i - def$paper.margin$t - def$paper.margin$b
  def$paper$w_i <- def$paper$w_i - def$paper.margin$l - def$paper.margin$r
  
  def$asp <- def$paper$h_i / def$paper$w_i
  
  def$ext <- calc_extent(dat, width = def$paper$w_i, height = def$paper$h_i, crs.target.str = def$crs.target.str, def$buffer.pct, verbose)
  def
}

adjust_plot <- function(pl, def, verbose = F){
  #' @description Adjust size of plot elements (fixed widths/heights)
  
  pl.grob <- ggplotGrob(pl)
  if(verbose) print(pl.grob$layout)
  
  # Look-up table required to modify grob layout
  dt.margin <- tibble(
    name = c("t", "r", "b", "l", "title", "subtitle", "caption"),
    grob = c("axis-t", "axis-r", "axis-b", "axis-l", "title", "subtitle", "caption"),
    pos = c("t", "r", "b", "l", "t", "t", "b"),
    axis = c("heights", "widths", "heights", "widths", "heights", "heights", "heights")
  )
  # Filter look-up table, add margin size according to definition
  dt.margin <- dt.margin %>% 
    filter(name %in% names(def$axis.margin)) %>% 
    mutate(size = unlist(unname(def$axis.margin))) %>%
    filter(size > 0)
  
  # Adjust grob layout 
  dt.margin %>% 
    pmap(function(grob, pos, size, axis, ...){
      ind <- pl.grob$layout[pl.grob$layout$name == grob, pos]
      pl.grob[[axis]][ind] <<- unit(size, "mm")
    })
  pl.grob
}