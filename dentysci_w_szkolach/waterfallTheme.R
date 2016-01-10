#' 
#' Piotr Sobczyk
#' 
#' szychtawdanych.pl
#' 
#' 
background <- "white"
axis_color <- blues9[8]
grid <- "grey"
labels <- "black"
waterfallTheme <- theme(
  legend.position = "right",
  legend.title = element_text(face = "italic", colour = axis_color, size = 15),
  legend.background = element_rect(fill = background),
  legend.key = element_rect(fill = background, colour = background),
  legend.text = element_text(colour = labels, size = 14),
  plot.background = element_rect(fill = background, colour = background),
  plot.title = element_text(colour = axis_color, face = "bold.italic", size = 28, vjust = 1),
  panel.background = element_rect(fill = background, colour = background),
  panel.grid.major.y = element_line(colour = grid),
  panel.grid.minor.y = element_line(colour = grid),
  panel.grid.major.x = element_blank(),
  panel.grid.minor.x = element_blank(),
  axis.text = element_text(colour = labels, size = 12),
  axis.title = element_text(colour = axis_color, face = "italic", size = 20),
  axis.ticks = element_line(colour = labels),
  strip.text.x = element_text( face="bold", colour = axis_color, size=14),
  strip.text.y = element_text( face="bold", colour = axis_color, size=14),
  strip.background = element_rect(colour=axis_color, fill="white")
)
