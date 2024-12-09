#' estimatePromoterDominance
#'
#' @param LATER
#' @param IsoformDatabase
#' @param method
#'
#' @return
#' @export estimatePromoterDominance
#' @import GenomicFeatures GenomicAlignments S4Vectors dplyr
estimatePromoterDominance <- function(LATER, IsoformDatabase, method) {
  dominance <- calculatePromoterDominance(LATER, IsoformDatabase)
  transcriptional_bias <- estimateTranscriptionalBias(dominance, method)
  dominance(LATER) <- dominance
  result(LATER) <- transcriptional_bias %>% tibble::as_tibble()
  stats(LATER) <- transcriptional_bias %>% tibble::as_tibble()
  return(LATER)
}

