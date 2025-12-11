# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`netfl` is an R package that provides tools for loading, cleaning, and analyzing NFL data from public sources. The package wraps `nflreadr` and `nflfastR` to extract specific datasets and transform them into SQL statements for insertion into a custom NetFL database.

## Package Structure

### Core Functions (R/)

All functions are in `R/` and follow a consistent pattern of loading NFL data from public sources and transforming it:

- **get_pbp(pSeason, pWeek)**: Loads play-by-play data for a specific week/season and narrows it to a "skinny" dataset with only required fields (offensive/defensive stats, tackles, fumbles, kicks, etc.)

- **get_rt_pbp(pSeason, pWeek)**: Real-time version of get_pbp that uses `nflfastR::build_nflfastR_pbp()` to scrape fresh data for the current week instead of loading cached data

- **get_injuries(pWeek)**: Loads injury reports for a specific week and generates SQL UPDATE statements to set player injury status in the NetFL database (tblplayers table)

- **get_snaps(pSeason, pWeek)**: Loads snap count data and generates SQL statements calling `scoring.add_player_snaps()` stored procedure. The pWeek parameter is optional - if NULL, returns all weeks for the season

### Key Implementation Details

- **Data Pipeline**: All functions load data from nflreadr/nflfastR, filter to requested week/season, join with additional datasets as needed, then either return a subset of columns or generate SQL statements

- **SQL Generation**: `get_injuries()` and `get_snaps()` use `mutate()` to create SQL statements. They join with the players dataset using `gsis_id` as the linking field to the NetFL database

- **Column Selection**: Both PBP functions select an identical large set of specific columns covering rushing, passing, receiving, tackles, fumbles, kicks, and special teams stats

## Development Commands

### Package Building and Checking

```r
# Generate documentation from roxygen2 comments
devtools::document()

# Build the package
devtools::build()

# Check the package (creates netfl.Rcheck/ directory)
devtools::check()

# Install the package locally
devtools::install()

# Load the package for interactive development
devtools::load_all()
```

### Testing Functions

```r
# Load the package
library(netfl)

# Test get_pbp (returns data frame)
pbp_data <- get_pbp(2024, 1)

# Test get_rt_pbp (real-time scraper)
rt_pbp_data <- get_rt_pbp(2024, 1)

# Test get_injuries (returns SQL statements)
injuries_sql <- get_injuries(1)

# Test get_snaps for single week
snaps_sql <- get_snaps(2024, 1)

# Test get_snaps for entire season
snaps_all <- get_snaps(2024)
```

## Dependencies

- **nflreadr**: Primary data source for cached NFL data
- **nflfastR**: Used for real-time play-by-play scraping
- **dplyr**: Data manipulation (filter, select, mutate, left_join, %>% pipe)

## Data Integration Context

The package is designed to feed data into a custom "NetFL" database:

- Player IDs use `gsis_id` as the primary identifier
- Injury status is stored as single character ('Q', 'D', 'O', etc.) in `tblplayers.injurystatus`
- Snap counts are inserted via stored procedure `scoring.add_player_snaps()`
- The skinny PBP dataset contains 100+ specific columns needed for the NetFL scoring system
