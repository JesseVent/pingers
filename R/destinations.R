#' Get ISP destinations
#'
#' Trace route and grab the top n servers
#' to assist isolating issues with individual
#' nodes for your ISP.
#' @name get_destinations
#'
#' @param keyword Keyword to search for i.e. 'AAT'
#' @param top_n Retrieve the first n addresses
#' @param site Defaults to 'google.com.au' to trace route against
#'
#' @return dataframe with server and IP range
#'
#' @importFrom tidyselect vars_select
#' @importFrom tidyselect contains
#' @importFrom stringr str_extract_all
#' @export
#'
#' @examples
#' \dontrun{
#' dest <- get_destinations(top_n = 3)
#' print(dest)
#' }
get_destinations <- function(keyword = NULL,
                             top_n   = NULL,
                             site    = "google.com.au") {
  sys_os <- .Platform$OS.type
  if (sys_os == "unix") {
    trace_command <- paste("traceroute", site)
  } else {
    trace_command <- paste("tracert", site)
  }
  if (site != "google.com.au") {
    warning(
    "The recommendation is not to change this value as the trace route could take a very long time or make your session unresponsive.",
    call.      = TRUE,
    immediate. = TRUE
    )
    }
  if (is.null(top_n)) {
    trace_route <-  system(trace_command, intern = TRUE) %>%
      tidyselect::vars_select(tidyselect::contains(keyword)) %>%
      as.character()
  } else {
    trace_route <- system(trace_command, intern = TRUE)[1:top_n] %>%
      as.data.frame(stringsAsFactors = FALSE)
  }
  names(trace_route) <- "server"
  trace_route$ip     <-
    c(stringr::str_extract_all(trace_route$server, "\\([^()]+\\)"))
  trace_route$ip     <-
    substring(trace_route$ip, 2, nchar(trace_route$ip) - 1)
  if (!(nchar(trace_route$server[1]) >= 3L)) {
    warning(
      "No servers found, reverting to test mode.",
      call.      = TRUE,
      immediate. = TRUE
    )
    server      <- "syd09s14-in-f14.1e100.net (216.58.200.110)"
    ip          <- "216.58.200.110"
    trace_route <- tibble::tibble(server = server, ip = ip)
  }
  ifelse(!(nrow(trace_route) >= 1L), warning(
    paste(
      "The keyword",
      toupper(keyword),
      "does not exist in the traceroute."
    ),
    call.      = TRUE,
    immediate. = TRUE
  ),
  return(trace_route))
}