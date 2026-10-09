utils::globalVariables(c(
  "week", "report_status", "gsis_id", "game_type", "game_id", "season",
  "offense_snaps", "offense_pct", "defense_snaps", "defense_pct",
  "st_snaps", "st_pct"
))

skinny_pbp_columns <- function() {
  c(
    "game_id", "play_id", "week", "play_type_nfl", "play_type",
    "rush_attempt", "pass", "fumble", "rusher_player_id",
    "rusher_player_name", "posteam", "rush_touchdown", "rushing_yards",
    "run_location", "pass_attempt", "sack", "sack_player_id",
    "sack_player_name", "half_sack_1_player_id", "half_sack_1_player_name",
    "half_sack_2_player_id", "half_sack_2_player_name", "passer_player_id",
    "passer_player_name", "complete_pass", "receiver_player_id",
    "receiver_player_name", "receiving_yards", "passing_yards",
    "pass_touchdown", "interception", "interception_player_id",
    "interception_player_name", "return_yards", "return_touchdown",
    "pass_defense_1_player_id", "pass_defense_1_player_name",
    "pass_defense_2_player_id", "pass_defense_2_player_name",
    "qb_hit_1_player_id", "qb_hit_1_player_name", "qb_hit_2_player_id",
    "qb_hit_2_player_name", "tackled_for_loss", "yards_gained",
    "solo_tackle", "solo_tackle_1_player_id", "solo_tackle_1_player_name",
    "solo_tackle_2_player_id", "solo_tackle_2_player_name", "solo_tackle_2_team",
    "assist_tackle", "assist_tackle_1_player_id", "assist_tackle_1_player_name",
    "assist_tackle_2_player_id", "assist_tackle_2_player_name",
    "assist_tackle_3_player_id", "assist_tackle_3_player_name",
    "assist_tackle_4_player_id", "assist_tackle_4_player_name",
    "assist_tackle_2_team", "assist_tackle_3_team", "assist_tackle_4_team",
    "tackle_with_assist", "tackle_with_assist_1_player_id",
    "tackle_with_assist_1_player_name", "tackle_with_assist_2_player_id",
    "tackle_with_assist_2_player_name", "forced_fumble_player_1_player_id",
    "forced_fumble_player_1_player_name", "forced_fumble_player_2_player_id",
    "forced_fumble_player_2_player_name", "fumble_lost", "fumbled_1_player_id",
    "fumbled_1_player_name", "fumbled_2_player_id", "fumbled_2_player_name",
    "fumble_recovery_1_player_id", "fumble_recovery_1_player_name",
    "fumble_recovery_2_player_id", "fumble_recovery_2_player_name",
    "fumble_recovery_1_yards", "fumble_recovery_2_yards", "kicker_player_id",
    "kicker_player_name", "extra_point_attempt", "extra_point_result",
    "blocked_player_id", "blocked_player_name", "touchback",
    "kickoff_out_of_bounds", "kickoff_returner_player_id",
    "kickoff_returner_player_name", "kick_distance", "field_goal_result",
    "punter_player_id", "punter_player_name", "punt_inside_twenty",
    "yardline_100", "punt_returner_player_id", "punt_returner_player_name",
    "punt_blocked", "two_point_conv_result", "td_player_id", "td_player_name",
    "safety_player_name", "safety_player_id"
  )
}

validate_season <- function(pSeason) {
  if (length(pSeason) != 1L || is.na(pSeason) ||
      !is.numeric(pSeason) || pSeason != as.integer(pSeason) || pSeason < 1999) {
    stop("pSeason must be one integer season (1999 or later).", call. = FALSE)
  }
  invisible(pSeason)
}

validate_week <- function(pWeek, allow_null = FALSE) {
  if (allow_null && is.null(pWeek)) {
    return(invisible(pWeek))
  }
  if (length(pWeek) != 1L || is.na(pWeek) ||
      !is.numeric(pWeek) || pWeek != as.integer(pWeek) || pWeek < 1 || pWeek > 22) {
    stop("pWeek must be one integer week between 1 and 22.", call. = FALSE)
  }
  invisible(pWeek)
}

select_skinny_pbp <- function(pbp) {
  columns <- skinny_pbp_columns()
  missing_columns <- setdiff(columns, names(pbp))
  if (length(missing_columns) > 0L) {
    for (column in missing_columns) {
      pbp[[column]] <- NA
    }
  }
  pbp[columns]
}

sql_literal <- function(value) {
  unname(vapply(value, function(item) {
    if (length(item) == 0L || is.na(item)) {
      return("NULL")
    }
    if (is.character(item)) {
      return(paste0("'", gsub("'", "''", item, fixed = TRUE), "'"))
    }
    as.character(item)
  }, character(1)))
}
