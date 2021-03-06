% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/destinations.R
\name{get_destinations}
\alias{get_destinations}
\title{Get ISP destinations}
\usage{
get_destinations(keyword = NULL, top_n = NULL,
  site = "google.com.au")
}
\arguments{
\item{keyword}{Keyword to search for i.e. 'AAT'}

\item{top_n}{Retrieve the first n addresses}

\item{site}{Defaults to 'google.com.au' to trace route against}
}
\value{
dataframe with server and IP range
}
\description{
Trace route and grab the top n servers
to assist isolating issues with individual
nodes for your ISP.
}
\examples{
\dontrun{
dest <- get_destinations(top_n = 3)
print(dest)
}
}
