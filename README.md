<!-- README.md is generated from README.Rmd. Please edit that file -->
pingers
=======

The goal of pingers is to assist you with troubleshooting ISP connection
issues and assist isolating packet loss. It does this by allowing you to
retrieve the top traceroute destinations your ISP uses, and recursively
ping each server a seres of time capturing the results. Each iteration
it then re-retrieves the destinations and shuffles the sequence to
ensure the analysis is unbiased and consistent across each trace route.

Usage
-----

The below showcases the main functions of the `pingers` package.

These functions will: - Retrieve hops between ISP destinations on your
network - Ping a destination repeatedly and calculate packet loss -
Repeat pinging the destinations to isolate and locate troublesome
destinations - Shuffle the destinations in each iteration as to not be
only testing for one path

``` r
# Install pingers from GitHub
devtools::install_github("jessevent/pinger")
library(pinger)

# Retrieve top n traceroute results in your call stack
destinations <- get_destinations(top_n = 9)

# Ping the first result of destinations 50 times
ping_results <- ping_capture(destinations$ip[1], 50)

# File and path of where to save the network log
log_path     <- "~/Desktop/netlogs/network_logs.csv"

# Start recursively capturing network logs until cancelled or interupted.
# capture_logs(destinations = 3, pings = 10, log_path = log, sleep = 20) 
```

> Use `Ctrl + C` to stop capturing logs, or the **Stop** button in
> RStudio.

Output
------

The **network\_log.csv** file will contain the following:

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 8%" />
<col style="width: 9%" />
<col style="width: 9%" />
<col style="width: 8%" />
<col style="width: 9%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 8%" />
<col style="width: 9%" />
</colgroup>
<thead>
<tr class="header">
<th>timestamp</th>
<th>server</th>
<th>packets_sent</th>
<th>packets_back</th>
<th>packet_loss</th>
<th>packets_lost</th>
<th>ping_min</th>
<th>ping_avg</th>
<th>ping_max</th>
<th>ping_stddev</th>
<th>call_sequence</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>2018-07-22T15:29:31.34Z</td>
<td>10.0.0.000</td>
<td>10</td>
<td>10</td>
<td>0</td>
<td>0</td>
<td>2.093</td>
<td>3.534</td>
<td>8.826</td>
<td>1.965</td>
<td>1</td>
</tr>
<tr class="even">
<td>2018-07-22T15:29:40.48Z</td>
<td>10.0.0.001</td>
<td>10</td>
<td>10</td>
<td>0</td>
<td>0</td>
<td>2.697</td>
<td>3.948</td>
<td>8.649</td>
<td>1.667</td>
<td>2</td>
</tr>
<tr class="odd">
<td>2018-07-22T15:29:49.50Z</td>
<td>10.0.0.002</td>
<td>10</td>
<td>9</td>
<td>10</td>
<td>11.1</td>
<td>3.366</td>
<td>5.083</td>
<td>8.163</td>
<td>1.381</td>
<td>3</td>
</tr>
<tr class="even">
<td>2018-07-22T15:29:58.53Z</td>
<td>10.0.0.003</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>7</td>
</tr>
</tbody>
</table>
