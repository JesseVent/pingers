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

This is a basic example which shows you how to solve a common problem:

> Use `Ctrl + C` to stop capturing logs, or the **Stop** button in
> RStudio.
