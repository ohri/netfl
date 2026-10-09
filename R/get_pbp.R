#' Get PBP
#' Loads play-by-play data for a season and week and returns the columns used
#' by NetFL.
#' @param pSeason Season to load.
#' @param pWeek Week to load, from 1 through 22.
#' @return A data frame containing the selected play-by-play fields.
#' @export
get_pbp <- function(pSeason, pWeek) {
  validate_season(pSeason)
  validate_week(pWeek)

  pbp <- nflreadr::load_pbp(pSeason) |>
    dplyr::filter(week == pWeek)

  select_skinny_pbp(pbp)
}
