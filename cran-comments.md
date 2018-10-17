## Latest CRAN submission comments

### pingers 0.1.1 - Updated functionality
- Took onboard feedback from Uwe in original commit and made package cross-platform supporting both Windows and Unix systems.
- Added additional sanity checks to handle different results being returned by trace route
- Created heatmap visualisation function to visualise hotspots of network issues

** @Uwe - Sanity checks and code changes can be found at below commit  https://github.com/JesseVent/pingers/commit/711395bcf184dd02f3e5b88fd529c25506c728fc **

### pingers 0.1.0 - New Submission

#### Test environments
* local OS X install, R 3.5.1
* ubuntu 12.04 (on travis-ci), R 3.5.1
* win-builder (devel and release)

#### R CMD check results

```
0 errors | 0 warnings | 1 note
  **This is a new release.**
```

---

#### Additional Information 

This package does a trace route to google.com and pings each server.

**Please let me know**

- If it breaches any CRAN security policies by doing so.
- If I need to add `\dontrun` to the examples to prevent the below.

**Examples with CPU or elapsed time > 5s**

```
                  user system elapsed
ping_capture     0.015  0.010   6.857
get_destinations 0.010  0.008   7.736
```

#### Reverse dependencies

This is a new release, so there are no reverse dependencies.
