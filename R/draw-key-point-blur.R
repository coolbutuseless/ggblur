

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Key glyphs for legends
#'
#' Each geom has an associated function that draws the key when the geom needs
#' to be displayed in a legend. These functions are called `draw_key_*()`, where
#' `*` stands for the name of the respective key glyph. The key glyphs can be
#' customized for individual geoms by providing a geom with the `key_glyph`
#' argument (see [`layer()`] or examples below.)
#'
#' @param data A single row data frame containing the scaled aesthetics to
#'   display in this key
#' @param params A list of additional parameters supplied to the geom.
#' @param size Width and height of key in mm.
#'
#' @return A grid grob.
#'
#' @import grid
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
draw_key_point_blur <- function(data, params, size) {
  if (is.null(data$shape)) {
    data$shape <- 19
  } else if (is.character(data$shape)) {
    data$shape <- translate_shape_string(data$shape)
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Just rename the 'data' variable to 'coords' so the code is then
  # pretty much identical to that in the 'geom'
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  coords <- data

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # How many steps in the blur process?
  # What should be the alpha of an individual step?
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  blur_steps <- coords$blur_steps[1]
  blur_alpha <- coords$blur_alpha/blur_steps

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Create a blur grob somewhere between [0,1] * blur_size.
  # Ensure lwd = 0 so that no outer stroke is included.
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  create_blur_grob <- function(fraction) {
    grid::pointsGrob(
      x = 0.5, y = 0.5,
      pch = coords$shape,
      gp = grid::gpar(
        col      = alpha(coords$colour, blur_alpha),
        fill     = alpha(coords$fill  , blur_alpha),
        fontsize = (coords$size + coords$blur_size * fraction) * .pt +
          coords$stroke * .stroke / 2,
        lwd      = 0
      )
    )
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Gaussian-ish sequence of blurring steps
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  fractions <- qnorm(seq(0.95, 0.5, length.out = blur_steps + 1))
  fractions <- fractions/max(fractions)
  fractions <- head(fractions, -1)

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Create a sequence of blur steps as grobs and package as a grobTree
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  blur_grobs <- lapply(fractions, create_blur_grob)
  blur_grobs <- do.call(grid::grobTree, blur_grobs)



  grid::grobTree(
    blur_grobs,
    grid::pointsGrob(
      x = 0.5, y = 0.5,
      pch = data$shape,
      gp = grid::gpar(
        col      = alpha(data$colour %||% "black", data$alpha),
        fill     = alpha(data$fill   %||% "black", data$alpha),
        fontsize = (data$size %||% 1.5) * .pt + (data$stroke %||% 0.5) * .stroke / 2,
        lwd      = (data$stroke %||% 0.5) * .stroke / 2
      )
    )
  )
}
