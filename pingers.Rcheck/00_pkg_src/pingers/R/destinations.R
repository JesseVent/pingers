#' Get ISP destinations
#'
#' Traceroute google and grab the top n servers
#' to assist isolating issues with individual
#' nodes for your ISP.
#' @name get_destinations
#'
#' @param keyword Keyword to search for i.e. 'AAT'
#' @param top_n Retrieve the first n addresses
#'
#' @return dataframe with server and IP range
#'
#' @importFrom tidyselect vars_select
#' @importFrom tidyselect contains
#' @importFrom stringr str_extract_all
#' @export
#'
#' @examples
#' {
#' dest <- get_destinations(top_n = 1)
#' }
get_destinations <- function(keyword = NULL, top_n = NULL) {
  if (is.null(top_n)) {
    trace <- system("traceroute google.com", intern = TRUE) %>%
      tidyselect::vars_select(tidyselect::contains(keyword)) %>%
      as.character()
  } else {
    trace <-
      system("traceroute google.com", intern = TRUE)[3:top_n] %>% as.data.frame(stringsAsFactors = FALSE)
  }
  names(trace) <- "server"
  trace$ip     <- c(stringr::str_extract_all(trace$server, "\\([^()]+\\)"))
  trace$ip     <- substring(trace$ip, 2, nchar(trace$ip) - 1)
  ifelse(!(nrow(trace) >= 1L), warning(
    paste(
      "The keyword",
      toupper(keyword),
      "does not exist in the traceroute."
    ),
    call. = FALSE
  ),
  return(trace))
}