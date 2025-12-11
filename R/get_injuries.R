#' Get Injuries
#' Loads the injury info for the current week and kicks out SQL
#' that can be run in NetFL to set player injury status.
#' @param pWeek Week to filter data for
#' @export
get_injuries <- function( pWeek )
{
  nflreadr::.clear_cache()
  inj <- nflreadr::load_injuries() |>
    dplyr::filter(week==pWeek) |>
    dplyr::filter(report_status != "NA")

  inj_sql <- inj %>%
    select( gsis_id, report_status ) %>%
    mutate(
      sql_out = paste("update tblplayers set injurystatus='",
                substr(report_status,1,1),
                "' where gsis='",
                gsis_id,
                "';",
                sep=""
                )
    )
  return(inj_sql)
#  write.csv(inj_sql, "~/Downloads/injuries.csv")
}

