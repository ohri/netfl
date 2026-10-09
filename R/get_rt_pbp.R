#' Get real-time PBP
#' Loads current play-by-play data for a regular-season week and returns the
#' columns used by NetFL.
#' @param pSeason Season to load.
#' @param pWeek Regular-season week to load, from 1 through 18.
#' @return A data frame containing the selected play-by-play fields.
#' @export
get_rt_pbp <- function(pSeason, pWeek) {
  validate_season(pSeason)
  validate_week(pWeek)
  if (pWeek > 18) {
    stop("pWeek must be a regular-season week between 1 and 18.", call. = FALSE)
  }

  sched <- nflreadr::load_schedules(pSeason) |>
    dplyr::filter(game_type == "REG", week == pWeek) |>
    dplyr::select(game_id)

  if (nrow(sched) == 0L) {
    stop("No regular-season games found for the requested season and week.", call. = FALSE)
  }

  pbp <- nflfastR::build_nflfastR_pbp(sched)
  if (nrow(pbp) == 0L || !"game_id" %in% names(pbp)) {
    stop(
      "nflfastR loaded no play-by-play data for the requested schedule. ",
      "Verify that the data source is available.",
      call. = FALSE
    )
  }

  select_skinny_pbp(pbp)
}
