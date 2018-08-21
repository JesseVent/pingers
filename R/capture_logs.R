#' Capture ISP network logs
#'
#' Repeat capturing network logs with parameters you specify from
#' \code{\link{ping_capture}} and \code{\link{get_destinations}}. This will output a
#' csv file with your ping results displaying packet loss and average
#' ping across the defined periods.
#' @name capture_logs
#'
#' @param destinations Retrieve the first n addresses in your ISP destinations
#' @param pings Number of times to ping server
#' @param log_path Optional: The path and filename to save the result set
#' @param sleep Optional: Seconds to sleep for throughout iterations
#'
#' @note If the log_path parameter is not provided, it will default to saving
#' a csv file in the current working directory called network_logs.csv prefixed
#' with the current timestamp in the format '%Y%m%d%H%M%S_network_logs.csv'
#'
#' @importFrom data.table fwrite
#' @importFrom tictoc tic
#' @importFrom tictoc toc
#'
#' @return csv file with captured network log information
#' @export
#'
#' @examples
#' \dontrun{
#' capture_logs(destinations = 3, pings = 10, log_path = log, sleep = 20)
#' }
capture_logs <- function(destinations = 9, pings = 50, log_path = NULL, sleep = NULL) {
  if (is.null(log_path)) {
    log_path <- paste0(format(Sys.time(), "%Y%m%d%H%M%S"), "_network_logs.csv")
  }
  message("Recursively pinging different servers in your destination list.", appendLF = TRUE)
  message("Cancel with 'Ctrl + C' or interupt script.", appendLF = TRUE)
  ping_df <- tibble::tibble()
  repeat {
    tictoc::tic()
    dest          <- get_destinations(top_n = destinations)
    dest$sequence <- 1:as.numeric(nrow(dest))
    dest          <- shuffle(dest)
    for (i in 1:nrow(dest)) {
      ping        <- ping_capture(dest$ip[i], pings)
      if (nrow(ping) >= 1L) {
        ping$call_sequence <- i
        ping$original_order <- dest$sequence[i]
        ping_df <<- rbind(ping, ping_df)
        ping$ping_list <- NULL
        data.table::fwrite(ping, log_path, row.names = FALSE, append = TRUE)
      }
    }
    tictoc::toc()
    if (!is.null(sleep)) Sys.sleep(sleep)
  }
}