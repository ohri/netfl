#' Get Snaps
#' Loads the snap info for the specified week and kicks out SQL
#' that can be run in NetFL to set that data in the db.
#' @param pWeek Week to filter data for
#' @param pSeason season to filter data for
#' @export
get_snaps <- function( pSeason, pWeek = NULL )
{

  snaps <- nflreadr::load_snap_counts(pSeason)

  # Only filter if pWeek was supplied
  if (!is.null(pWeek)) {
    snaps <- snaps %>% filter(week == pWeek)
  }

  players <- nflreadr::load_players()
  joined <- snaps %>% left_join(players, by=c("pfr_player_id"="pfr_id")) %>% select(season, week, gsis_id, offense_snaps,offense_pct,defense_snaps,defense_pct,st_snaps,st_pct)

  out <- joined %>% mutate(
      sql_out= paste(
        "exec scoring.add_player_snaps('",
        gsis_id,
        "', ",
        season,
        ", ",
        week,
        ", ",
        offense_snaps,
        ", ",
        offense_pct,
        ", ",
        defense_snaps,
        ", ",
        defense_pct,
        ", ",
        st_snaps,
        ", ",
        st_pct,
        ");",
        sep=""
      )
    )

  return(out %>% select(sql_out))
}
