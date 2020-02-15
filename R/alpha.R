

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Calculate the cumulative alpha as the individual alpha are combined
#'
#' Remember:
#'
#' \itemize{
#' \item{alpha is not additive}
#' \item{transmissivity = 1 - alpha}
#' \item{transmissivity is multiplicative}
#' }
#'
#' @param individual_alpha numeric vector of alpha values which will be
#'        superimposed.
#'
#' @return numeric vector of the cumulative alpha as these elements are
#'         rendered on top of each other
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
calc_cumulative_alpha <- function(individual_alpha) {
  1 - cumprod(1 - individual_alpha)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Calculate the individual alpha levels to recreate the cumulative alpha series
#'
#'
#' Remember:
#'
#' \itemize{
#' \item{alpha is not additive}
#' \item{transmissivity = 1 - alpha}
#' \item{transmissivity is multiplicative}
#' }
#'
#'
#' @param cumulative_alpha numeric vector of desired cumulative alpha as
#'        multiple objects are rendered on top of each other
#'
#' @return numeric vector of the individual alpha values of the objects to be
#'         superimposed
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
calc_individual_alpha <- function(cumulative_alpha) {
  N <- length(cumulative_alpha)
  individual_alpha    <- numeric(N)
  individual_alpha[1] <- cumulative_alpha[1]
  for (i in seq(N-1)) {
    individual_alpha[i+1] <- 1 - (1 - cumulative_alpha[i+1])/(1 - cumulative_alpha[i])
  }
  individual_alpha
}
