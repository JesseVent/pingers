#' Packet Loss Heatmap
#'
#' Generates a heatmap that displays the packet loss hotspots on an hourly basis during the week.
#'
#' @param logs network_logs file
#'
#' @return highcharts heatmap
#' @export
#' @importFrom lubridate ymd_hm hour
#' @importFrom tibble tibble
#' @importFrom reshape2 dcast
#' @importFrom plotly plot_ly
#' @importFrom dplyr "%>%"
#' @importFrom dplyr group_by summarise
#' @examples
#' \dontrun{
#' pingers_heatmap(net_logs)
#' }
pingers_heatmap <- function(logs=NULL) {
  if (is.null(logs))
    stop("Provide network logs output.")
  if (is.character(logs$timestamp))
    logs$timestamp <- lubridate::ymd_hms(logs$timestamp)
  packets_lost   <- NULL
  df             <- tibble::tibble(timestamp    = logs$timestamp,
                                   packets_lost = logs$packets_lost)
  df$date        <- as.Date(df$timestamp)
  df$hour        <- lubridate::hour(df$timestamp)
  df             <- df %>% dplyr::group_by(date, hour) %>%
    dplyr::summarise(packet_loss = sum(packets_lost))
  df$weekday     <- ordered(
      weekdays(df$date, FALSE),
      levels = c(
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
      )
    )
  heatmap_data   <- df[, c("weekday","hour","packet_loss")]
  heatmap_recast <- reshape2::dcast(heatmap_data, weekday ~ hour, fill = -1)
  hm             <- as.matrix(heatmap_recast[-1])
  row.names(hm)  <- heatmap_recast$weekday
  plotly::plot_ly(
    x      = colnames(hm) ,
    y      = row.names(hm),
    z      = hm,
    type   = "heatmap",
    colors = "Blues"
  ) %>% plotly::layout(title = "Packet Loss Heatmap")
}