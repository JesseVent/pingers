#' Ping Server
#'
#' Ping a server to capture response details
#' @name ping_capture
#'
#' @param server IP address or URL of server
#' @param count Number of times to ping server
#'
#' @return dataframe with ping results
#' @export
#'
#' @importFrom dplyr "%>%"
#' @importFrom stringr str_replace_all
#' @importFrom tibble tibble
#'
#' @examples
#' \dontrun{
#' dest     <- get_destinations(top_n = 1)
#' ping_res <- ping_capture(dest$ip[1], 10)
#' print(ping_res)
#' }
ping_capture <- function(server, count) {
  sys_os        <- .Platform$OS.type
  if (sys_os == "unix") {
    ping_query  <- paste("ping", server, "-c", count)
  } else {
    ping_query  <- paste("ping", server, "-n", count)
  }
  d             <- system(ping_query, intern = TRUE)
  n             <- length(d) %>% as.numeric()
  ping_list     <- list(d[2:(n - 4)])
  packet_loss   <- d[n - 1]
  ping_stats    <- d[n]
  timestamp     <- Sys.time()

  ## Strip out ping statistics
  stats         <- stringr::str_replace_all(ping_stats, "[^0-9|./]", "") %>% strsplit("/")
  ping_min      <- stats[[1]][4] %>% as.numeric()
  ping_avg      <- stats[[1]][5] %>% as.numeric()
  ping_max      <- stats[[1]][6] %>% as.numeric()
  ping_stddev   <- stats[[1]][7] %>% as.numeric()

  ## Strip out packet loss
  pkt           <- stringr::str_replace_all(packet_loss, "[^0-9|,.]", "") %>% strsplit(",")
  packets_sent  <- pkt[[1]][1] %>% as.numeric()
  packets_back  <- pkt[[1]][2] %>% as.numeric()
  packet_loss   <- pkt[[1]][3] %>% as.numeric()
  packets_lost  <- packets_sent - packets_back
  loss_rate     <- ((packets_sent - packets_back) / packets_sent) * 100


  pres <-
    tibble::tibble(
      timestamp,
      server,
      packets_sent,
      packets_back,
      packet_loss,
      packets_lost,
      loss_rate,
      ping_min,
      ping_avg,
      ping_max,
      ping_stddev,
      ping_list
    )
  pres$packets_sent[is.na(pres$packets_sent)] <- 100
  pres$packets_back[is.na(pres$packets_back)] <- 0
  pres$loss_rate[is.na(pres$loss_rate)]       <- 100
  pres$packets_lost[is.na(pres$packets_lost)] <- 100
  pres$ping_stddev[is.na(pres$ping_stddev)]   <- 0
  pres$ping_min[is.na(pres$ping_min)]         <- 0
  pres$ping_max[is.na(pres$ping_max)]         <- 0
  pres$ping_avg[is.na(pres$ping_avg)]         <- 0
  pres$loss_rate <- ((pres$packets_sent - pres$packets_back) / pres$packets_sent * 100)
  pres$packet_loss[is.na(pres$packet_loss)]   <- pres$loss_rate
  pres$packets_lost <- pres$packets_sent - pres$packets_back
  return(pres)
}