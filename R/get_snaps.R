#' Get Snaps
#' Loads snap counts and generates SQL statements that call the NetFL snap
#' scoring procedure.
#' @param pSeason Season to load.
#' @param pWeek Optional week to filter, from 1 through 22. If `NULL`, all
#'   weeks in the season are returned.
#' @return A data frame with one `sql_out` column.
#' @export
get_snaps <- function(pSeason, pWeek = NULL) {
  validate_season(pSeason)
  validate_week(pWeek, allow_null = TRUE)

  snaps <- nflreadr::load_snap_counts(pSeason)
  if (!is.null(pWeek)) {
    snaps <- dplyr::filter(snaps, week == pWeek)
  }

  players <- nflreadr::load_players()
  joined <- snaps |>
    dplyr::left_join(players, by = c("pfr_player_id" = "pfr_id")) |>
    dplyr::select(
      season, week, gsis_id, offense_snaps, offense_pct, defense_snaps,
      defense_pct, st_snaps, st_pct
    )

  dplyr::transmute(
    joined,
    sql_out = paste0(
      "exec scoring.add_player_snaps(",
      sql_literal(gsis_id), ", ",
      sql_literal(season), ", ",
      sql_literal(week), ", ",
      sql_literal(offense_snaps), ", ",
      sql_literal(offense_pct), ", ",
      sql_literal(defense_snaps), ", ",
      sql_literal(defense_pct), ", ",
      sql_literal(st_snaps), ", ",
      sql_literal(st_pct),
      ");"
    )
  )
}
