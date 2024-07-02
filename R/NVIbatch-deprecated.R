#' @title Deprecated Functions in Package NVIbatch
#' @description These functions are provided for compatibility with older
#'     versions of NVIbatch only, and may be defunct as soon as the next release.
#'     When possible, alternative functions are mentioned. Help pages for
#'     deprecated functions are available at \code{help("<function>-deprecated")}.
#' @details The argument \code{additional_info} in \code{save_log} was
#'     deprecated from v0.6.0 released 2024-##-##. The argument was renamed to
#'     the more meaningful \code{include_text}. If using the old argument,
#'     the input will be transferred to the new argument.
#'
#' @param \dots (arguments)
#' @return (results)
#' @name NVIbatch-deprecated
#' @keywords internal
#'
#' @author Petter Hopp Petter.Hopp@@vetinst.no
#'
#' @examples
#' \dontrun{
#' save_log(...) ### -- use argument \code{include_text} instead of \code{additional_info}.
#' }
NULL
