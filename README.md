# netfl

`netfl` provides small R helpers for loading NFL data from `nflreadr` and
`nflfastR`. It supports cached play-by-play, real-time play-by-play, injury
reports, and snap counts formatted for the NetFL database.

## Installation

```r
install.packages("pak")
pak::pak("ohri/netfl")
```

## Examples

```r
library(netfl)

pbp <- get_pbp(2024, 1)
live_pbp <- get_rt_pbp(2024, 1)
injuries <- get_injuries(1)
snaps <- get_snaps(2024, 1)
```

The injury and snap helpers return SQL strings for the NetFL database. Review
generated statements before executing them in production.

## Development

```r
devtools::document()
devtools::test()
devtools::check()
```
