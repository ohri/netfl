#' Get Injuries
#' Loads injury information for a week and generates SQL statements that can
#' update player injury status in NetFL.
#' @param pWeek Week to filter, from 1 through 22.
#' @return A data frame containing `gsis_id`, `report_status`, and `sql_out`.
#' @export
get_injuries <- function(pWeek) {
  validate_week(pWeek)

  nflreadr::load_injuries() |>
    dplyr::filter(week == pWeek, !is.na(report_status), report_status != "NA") |>
    dplyr::select(gsis_id, report_status) |>
    dplyr::mutate(
      sql_out = paste0(
        "update tblplayers set injurystatus=",
        sql_literal(substr(report_status, 1L, 1L)),
        " where gsis=",
        sql_literal(gsis_id),
        ";"
      )
    )
}
