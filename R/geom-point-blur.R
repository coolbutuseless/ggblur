
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Draw Blurry Points
#'
#' @param blur_size ow far the blur extends from the edge of the drawn point.
#'        Default: 3
#' @param blur_steps Number of point repetitions to create blur. Default: 20
#' @param blur_alpha The alpha for the inner-most part of the blur. Note: this
#' is only approximate as the actual rendering of multiple layers with small alpha
#' does not always result in the expected alpha.  Values above 1 are allowed
#' here. Please experiment to achieve the desired results. Default: 1
#' @param mapping,data,stat,position,...,na.rm,show.legend,inherit.aes See
#' documentation for \code{ggplot2::geom_point()}
#'
#' @import ggplot2
#' @export
#'
#' @examples
#' \dontrun{
#' ggplot(mtcars) +
#' geom_point_blur(aes(mpg, wt, blur_size = disp), blur_alpha = 0.3, blur_steps = 2) +
#'   scale_blur_size_continuous(range = c(1, 15)) +
#'   theme_bw() +
#'   labs(title = "Larger blur indicates larger engine displacement")
#' }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
geom_point_blur <- function(mapping = NULL, data = NULL,
                            stat = "identity", position = "identity",
                            ...,
                            blur_size   = 3,
                            blur_steps  = 20,
                            blur_alpha  = 1,
                            na.rm       = FALSE,
                            show.legend = NA,
                            inherit.aes = TRUE) {
  ggplot2::layer(
    data = data,
    mapping     = mapping,
    stat        = stat,
    geom        = GeomPointBlur,
    position    = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params      = list(
      na.rm      = na.rm,
      blur_steps = blur_steps,
      blur_alpha = blur_alpha,
      ...
    )
  )
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' GeomPointBlur
#'
#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#'
#' @import grid
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GeomPointBlur <- ggproto(
  "GeomPointBlur", Geom,
  required_aes = c("x", "y"),
  non_missing_aes = c("size", "shape", "colour"),
  default_aes = ggplot2::aes(
    shape      = 19,
    colour     = "black",
    size       = 1.5,
    fill       = NA,
    alpha      = NA,
    stroke     = 0.5,
    blur_size  = 3,
    blur_steps = 20,
    blur_alpha = 1
  ),

  draw_panel = function(data, panel_params, coord, na.rm = FALSE) {
    if (is.character(data$shape)) {
      data$shape <- translate_shape_string(data$shape)
    }
    coords <- coord$transform(data, panel_params)

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
        coords$x, coords$y,
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

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # the returned grob is now a grob tree with the blur steps behind the
    # final drawn points.
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ggname(
      "geom_point",
      grid::grobTree(
        blur_grobs,
        grid::pointsGrob(
          coords$x, coords$y,
          pch = coords$shape,
          gp = grid::gpar(
            # Stroke is added around the outside of the point
            col      = alpha(coords$colour, coords$alpha),
            fill     = alpha(coords$fill, coords$alpha),
            fontsize = coords$size * .pt + coords$stroke * .stroke / 2,
            lwd      = coords$stroke * .stroke / 2
          )
        )
      )
    )
  },

  draw_key = ggplot2::draw_key_point
)




if (FALSE) {

  library(ggplot2)

  (p <- ggplot(mtcars) +
      geom_point_blur(aes(mpg, wt, blur_size = disp), blur_alpha = 0.5, blur_steps = 20) +
      scale_blur_size_continuous(range = c(0, 10)) +
      theme_bw()
  )

  pdf("working/test.pdf")
  p
  dev.off()

}









