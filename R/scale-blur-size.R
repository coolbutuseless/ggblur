

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Scale blur size
#'
#' @param guide default: FALSE i.e. don't draw guide for blur.
#' @param name,breaks,labels,limits,range,trans,values,... see \code{?ggplot2::scale_size()}
#'
#' @rdname scale_blur_size
#'
#' @import ggplot2
#' @import scales
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
scale_blur_size_continuous <- function(name = waiver(), breaks = waiver(), labels = waiver(),
                         limits = NULL, range = c(3, 9),
                         trans = "identity", guide = FALSE) {
  ggplot2::continuous_scale(
    aesthetics = "blur_size",
    scale_name = "blur_size",
    palette    = scales::rescale_pal(range), name = name,
    breaks = breaks, labels = labels, limits = limits, trans = trans,
    guide = guide)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname scale_blur_size
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
scale_blur_size <- scale_blur_size_continuous


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname scale_blur_size
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
scale_blur_size_discrete <- function(..., range = c(4, 9), guide=FALSE) {
  force(range)

  ggplot2::discrete_scale(
    aesthetics = "blur_size",
    scale_name = "blur_size_d",
    palette    = function(n) {
      seq(range[1], range[2], length.out = n)
    },
    guide = FALSE,
    ...
  )
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname scale_blur_size
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
scale_blur_size_manual <- function(..., values) {
  manual_scale('blur_size', values, ...)
}





