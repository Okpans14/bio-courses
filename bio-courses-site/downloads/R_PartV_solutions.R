# =====================================================================
# R for Bioinformatics — Part V Solutions
# Modules 16-17 · Reproducible Research & Your Own Tool
# =====================================================================
# These solutions show the FILE CONTENTS and the CONSOLE COMMANDS you
# would use. Package work happens across files, not in one script.
# =====================================================================


# =====================================================================
# Module 16 - a worked report
# =====================================================================
# See example_report.Rmd in this folder for the full document. The key
# pieces:
#   - YAML header with title + output: html_document
#   - setup chunk: ```{r setup, message=FALSE} library(tidyverse);
#       expr <- read_csv("data/expression.csv") ```
#   - inline: The dataset has `r nrow(expr)` rows.
#   - figure chunk: ```{r, echo=FALSE} ggplot(expr, aes(condition, tpm))
#       + geom_boxplot() + facet_wrap(~ gene) ```
# Render with: rmarkdown::render("example_report.Rmd")


# =====================================================================
# Module 17 - the seqtools package
# =====================================================================
# Console steps:
#   library(usethis)
#   create_package("~/seqtools")
#   use_mit_license()
#   use_testthat()

# ---- R/gc_content.R ---------------------------------------------------
#' GC content of a DNA sequence
#'
#' @param seq A character string of DNA (A/C/G/T, any case).
#' @return The GC fraction, a number between 0 and 1.
#' @examples
#' gc_content("ATGCGC")
#' @export
gc_content <- function(seq) {
  b <- strsplit(toupper(seq), "")[[1]]
  if (!all(b %in% c("A", "C", "G", "T"))) stop("non-ACGT character in sequence")
  sum(b %in% c("G", "C")) / length(b)
}

# ---- R/revcomp.R ------------------------------------------------------
#' Reverse complement of a DNA sequence
#'
#' @param seq A character string of DNA (A/C/G/T, any case).
#' @return The reverse-complement sequence, a character string.
#' @examples
#' revcomp("ATGC")
#' @export
revcomp <- function(seq) {
  comp <- c(A = "T", T = "A", G = "C", C = "G")[strsplit(toupper(seq), "")[[1]]]
  if (anyNA(comp)) stop("non-ACGT character in sequence")
  paste(rev(comp), collapse = "")
}

# ---- R/parse_fasta.R --------------------------------------------------
#' Parse a FASTA file into a named character vector
#'
#' @param path Path to a FASTA file.
#' @return A named character vector: names are sequence IDs, values are
#'   the sequences.
#' @examples
#' \dontrun{parse_fasta("data/sample.fasta")}
#' @export
parse_fasta <- function(path) {
  stopifnot(file.exists(path))
  lines <- readLines(path)
  headers <- grep("^>", lines)
  if (length(headers) == 0) stop("no FASTA headers found in ", path)
  ids <- sub("^>(\\S+).*", "\\1", lines[headers])
  starts <- headers + 1
  ends   <- c(headers[-1] - 1, length(lines))
  seqs <- mapply(function(a, b) paste(lines[a:b], collapse = ""), starts, ends)
  setNames(seqs, ids)
}

# ---- tests/testthat/test-gc_content.R --------------------------------
# library(testthat)
# test_that("gc_content works", {
#   expect_equal(gc_content("GGCC"), 1)
#   expect_equal(gc_content("ATGC"), 0.5)
#   expect_error(gc_content("ATGX"))
# })
#
# test_that("revcomp works", {
#   expect_equal(revcomp("ATGC"), "GCAT")
#   expect_error(revcomp("ATGX"))
# })

# ---- build & check (console) -----------------------------------------
#   devtools::document()   # roxygen -> man/ + NAMESPACE
#   devtools::load_all()   # load for interactive use
#   devtools::test()       # run the suite
#   devtools::check()      # full R CMD check - aim for 0 errors/warnings


# =====================================================================
# Capstone report - using YOUR package functions
# =====================================================================
# A minimal analysis that proves the package works end to end. If the
# package is installed/loaded, this runs as-is:
if (exists("parse_fasta") && exists("gc_content")) {
  data_dir <- if (dir.exists("data")) "data" else "../data"
  fa <- parse_fasta(file.path(data_dir, "sample.fasta"))
  report <- data.frame(
    id        = names(fa),
    length_bp = nchar(fa),
    gc        = vapply(fa, gc_content, numeric(1)),
    row.names = NULL
  )
  report <- report[order(-report$gc), ]
  print(report)
}

# ---------------------------------------------------------------------
# Course complete. You began unable to write a line of R and now build
# documented, tested, installable bioinformatics tools with reproducible
# reports. From first principles to writing your own tools - done.
# ---------------------------------------------------------------------
