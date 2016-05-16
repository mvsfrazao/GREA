#' Read Data Wrapper
#'
#' Reads Data of many different formats. Currently: .dta (STATA), .sav (SPSS), .mat (MATLAB), .xls/.xlsx (Excel), and .raw, .csv, .txt, .asc, .dat. Is the basis-function for the GREA add-in
#' @param filelocation A single string with the location and name of the file, e.g. "data/bla.csv"
#' @param header Should the header be read in?
#' @param sep
#' @param dec
#' @param into.dataframe
#' @param sheetIndex
#' @return A dataframe, containing the read-in data
#' @export

## Function: GREA_read
GREA_read <- function(filelocation, header = FALSE, sep = "", dec = ".",
                     into.dataframe = TRUE, sheetIndex = 1) {

  # Wrap TryCatch around to specify error messages
  tryCatch({

    if (is.null(filelocation))
      return(NULL)

    filetype <- obtain_filetype(filelocation)

    # ------ Files without any options ------ #

    # STATA: .dta
    if (filetype == "dta")
      data <- read.dta(file = filelocation)

    # MATLAB: .mat
    else if (filetype == "mat")
      data <- readMat(con = filelocation)

    # ------ Files with sep, header, dec, NA options ------ #

    # raw, csv, txt, asc, dat
    else if (any(filetype == c("raw", "csv", "txt", "asc", "dat")))
      data <- read.table(file = filelocation, header = header, sep = sep, dec = dec)

    # ------ Files with other options ------ #

    # SPSS: .sav
    else if (filetype == "sav")
      data <- read.spss(file = filelocation, to.data.frame = into.dataframe)

    # Excel: .xls, .xlsx
    else if (any(filetype == c("xls", "xlsx")))
      data <- read_excel(path = filelocation, sheet = sheetIndex)

    # Give back DF
    return(data)
  },

  # ------ Files with other options ------ #
  error = function(err) {
    message("1. Wrong options for generating df, or")
    message("2. Outcome is not a df (for Excel and SPSS reader functions)")
  },
  warning = function(war) {
    message("1. Wrong options for generating df, or")
    message("2. Outcome is not a df (for Excel and SPSS reader functions)")
  })
}