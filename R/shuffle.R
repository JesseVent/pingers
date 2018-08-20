#' Shuffle dataframe rows randomely
#'
#' Randomly reorder the rows of a dataframe
#' @name shuffle
#'
#' @param data dataframe to shuffle
#' @return reordered dataframe
#' @export
#' @examples {
#' ordered_df <- tibble::tibble(V1=1:26,V2=letters)
#' shuffled_df <- shuffle(ordered_df)
#' }
shuffle <- function(data){
  return(data[sample(nrow(data)),])
}