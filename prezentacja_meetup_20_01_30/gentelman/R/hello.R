
#' a placeholder
#'
#' longer description bla bla bla
#'
#' @param txt character, name to say hello to
#'
#' @references
#' Very important paper, P Sobczyk, 2020
#'
hello <- function(txt = "world") {
  cat("Hello, ", txt, "\n")
}


#' new function hello
#'
#' @inheritParams hello
#'
#' @export
#'
#' @return character, hello string
#'
#' @seealso [hello()]
#'
#' @examples
#' hello_poznan("Pazur")
hello_poznan <- function(txt = "Pazur") {
  return(paste0("Hello, ", txt, ". How are you tej!"))
}
