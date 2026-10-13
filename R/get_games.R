#' Write one play-by-play CSV per game
#'
#' Loads the same skinny play-by-play data as [get_pbp()] for a season and
#' week, then writes one CSV file for each game that appears in that data.
#'
#' @param pSeason Season to load.
#' @param pWeek Week to load, from 1 through 22.
#' @param pOutputDir Directory in which to write the game CSV files. It is
#'   created recursively if it does not exist.
#' @return Invisibly, a character vector containing the paths of the files
#'   written.
#' @export
get_games <- function(pSeason, pWeek, pOutputDir = ".") {
  validate_season(pSeason)
  validate_week(pWeek)

  if (length(pOutputDir) != 1L || is.na(pOutputDir) ||
      !is.character(pOutputDir) || !nzchar(pOutputDir)) {
    stop("pOutputDir must be one non-empty directory path.", call. = FALSE)
  }

  if (file.exists(pOutputDir) && !dir.exists(pOutputDir)) {
    stop("pOutputDir exists but is not a directory.", call. = FALSE)
  }
  if (!dir.exists(pOutputDir) &&
      !dir.create(pOutputDir, recursive = TRUE, showWarnings = FALSE)) {
    stop("Unable to create pOutputDir.", call. = FALSE)
  }

  pbp <- get_pbp(pSeason, pWeek)
  game_ids <- unique(as.character(pbp$game_id))
  game_ids <- game_ids[!is.na(game_ids) & nzchar(game_ids)]

  if (length(game_ids) == 0L) {
    stop("No games found in the play-by-play data for the requested season and week.",
      call. = FALSE
    )
  }

  output_paths <- vapply(game_ids, function(game_id) {
    game_pbp <- pbp[as.character(pbp$game_id) == game_id, , drop = FALSE]
    output_path <- file.path(
      pOutputDir,
      paste0(pSeason, "_week_", pWeek, "_", safe_game_filename(game_id), ".csv")
    )
    utils::write.csv(game_pbp, output_path, row.names = FALSE, na = "")
    output_path
  }, character(1))

  names(output_paths) <- game_ids
  invisible(output_paths)
}

safe_game_filename <- function(game_id) {
  filename <- gsub("[^A-Za-z0-9_.-]", "_", game_id)
  if (!nzchar(filename)) {
    filename <- "game"
  }
  filename
}
