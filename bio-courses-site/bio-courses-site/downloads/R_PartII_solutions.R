# =====================================================================
# R for Bioinformatics — Part II Solutions
# Modules 6-8 · Real Programming
# =====================================================================

data_dir <- if (dir.exists("data")) "data" else "../data"
path <- function(f) file.path(data_dir, f)


# =====================================================================
# Module 6
# =====================================================================

## 6A.1 - count header lines
lines <- readLines(path("sample.fasta"))
cat("sequences:", sum(grepl("^>", lines)), "\n")       # 3

## 6A.2 - inspect a table
variants <- read.csv(path("variants.csv"))
str(variants)
cat("rows:", nrow(variants), "\n")
print(summary(variants$quality))

## 6B.1 - one row per sequence
parse_fasta <- function(p) {
  lines <- readLines(p)
  headers <- grep("^>", lines)
  ids <- sub("^>(\\S+).*", "\\1", lines[headers])
  starts <- headers + 1
  ends   <- c(headers[-1] - 1, length(lines))
  seqs <- mapply(function(a, b) paste(lines[a:b], collapse = ""), starts, ends)
  setNames(seqs, ids)
}
fa <- parse_fasta(path("sample.fasta"))
df <- data.frame(id = names(fa), length_bp = nchar(fa), row.names = NULL)
print(df)

## 6C.1 - FASTQ via index arithmetic
fq <- readLines(path("sample.fastq"))
ids   <- sub("^@", "", fq[seq(1, length(fq), by = 4)])
seqs  <- fq[seq(2, length(fq), by = 4)]
quals <- fq[seq(4, length(fq), by = 4)]
print(data.frame(id = ids, length = nchar(seqs)))


# =====================================================================
# Module 7
# =====================================================================

gc_content <- function(seq) {
  stopifnot(is.character(seq), length(seq) == 1, nchar(seq) > 0)
  b <- strsplit(toupper(seq), "")[[1]]
  if (!all(b %in% c("A","C","G","T"))) stop("non-ACGT character in sequence")
  sum(b %in% c("G","C")) / length(b)
}

## 7A.1 - catch and return NA
safe_gc <- function(s) {
  tryCatch(gc_content(s),
           error = function(e) { message("skipped: ", conditionMessage(e)); NA_real_ })
}
cat(safe_gc("ATGX"), safe_gc(""), "\n")                # NA NA (with messages)

## 7B.1 - safe_read
safe_read <- function(p) {
  tryCatch(read.csv(p),
           error = function(e) { message("could not read ", p, ": ",
                                          conditionMessage(e)); NULL })
}
ok  <- safe_read(path("variants.csv")); cat("ok rows:", nrow(ok), "\n")
bad <- safe_read("does_not_exist.csv"); cat("bad is NULL:", is.null(bad), "\n")

## 7C.1 - testthat
library(testthat)
test_that("gc_content is correct", {
  expect_equal(gc_content("GGCC"), 1)
  expect_equal(gc_content("ATGC"), 0.5)
  expect_error(gc_content("ATGX"))
  expect_error(gc_content(""))
})


# =====================================================================
# Module 8
# =====================================================================

new_sequence <- function(bases, id = NA_character_) {
  bases <- toupper(bases)
  stopifnot(is.character(bases), length(bases) == 1)
  structure(list(bases = bases, id = id), class = "sequence")
}
print.sequence <- function(x, ...) {
  cat("<sequence", if (!is.na(x$id)) x$id else "", ">\n")
  cat("  length:", nchar(x$bases), "bp\n")
  invisible(x)
}

## 8A.1 - generic + method
gc <- function(x, ...) UseMethod("gc")
gc.sequence <- function(x, ...) {
  b <- strsplit(x$bases, "")[[1]]
  sum(b %in% c("G","C")) / length(b)
}
s <- new_sequence("ATGCGC", id = "rpoB")
cat("gc(s):", gc(s), "\n")                             # 0.6667

## 8B.1 - inheritance
new_dna <- function(bases, id = NA_character_) {
  obj <- new_sequence(bases, id)
  class(obj) <- c("dna", "sequence")
  obj
}
revcomp <- function(x, ...) UseMethod("revcomp")
revcomp.dna <- function(x, ...) {
  comp <- c(A="T", T="A", G="C", C="G")[strsplit(x$bases, "")[[1]]]
  new_dna(paste(rev(comp), collapse = ""), id = x$id)
}
d <- new_dna("ATGC", "test")
cat("gc(d) via inheritance:", gc(d), "\n")             # 0.5
print(revcomp(d))                                       # a dna with bases GCAT


# =====================================================================
# Part II capstone - FASTA report tool
# =====================================================================
fasta_report <- function(p) {
  stopifnot(file.exists(p))
  fa <- parse_fasta(p)
  recs <- lapply(seq_along(fa), function(i) {
    d <- new_dna(fa[i], id = names(fa)[i])
    data.frame(id = d$id, length_bp = nchar(d$bases), gc = gc(d))
  })
  out <- do.call(rbind, recs)
  out[order(-out$gc), ]
}
print(fasta_report(path("sample.fasta")))

# ---------------------------------------------------------------------
# Part II done: you can read real files, fail safely, test, and design
# your own classes. Part III: the tidyverse - dplyr, tidyr, ggplot2.
# ---------------------------------------------------------------------
