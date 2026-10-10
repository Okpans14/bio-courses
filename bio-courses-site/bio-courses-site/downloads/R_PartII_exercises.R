# =====================================================================
# R for Bioinformatics — Part II Exercises
# Modules 6-8 · Real Programming
# =====================================================================
# Uses the shared data/ folder: sample.fasta, sample.fastq,
# variants.csv, gc_report.tsv. Keep it in your RStudio project so the
# paths below resolve. readr and testthat are used in places:
#   install.packages(c("readr", "testthat"))
# =====================================================================

# If running from this Part's folder, the data is one level up:
data_dir <- if (dir.exists("data")) "data" else "../data"
path <- function(f) file.path(data_dir, f)


# =====================================================================
# Module 6 - reading & writing files
# =====================================================================

## 6A. readLines --------------------------------------------------------
### Worked example
lines <- readLines(path("sample.fasta"))
cat("lines:", length(lines), "\n")
print(lines[1])

### 6A.1 (easy)
# Read sample.fasta and print how many lines START with ">" (hint:
# grepl("^>", lines) gives a logical vector; sum() counts the TRUEs).
# your code here


### 6A.2 (harder)
# Read variants.csv with read.csv() (or readr::read_csv) and print its
# structure with str(), the number of rows, and summary() of quality.
# your code here


## 6B. Parsing FASTA by hand --------------------------------------------
### Worked example
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
print(names(fa))
cat("rpoB length:", nchar(fa["rpoB"]), "\n")

### 6B.1 (harder)
# Using fa from the worked example, build a data.frame with columns
# `id` and `length_bp` (one row per sequence). Print it.
# your code here


## 6C. FASTQ ------------------------------------------------------------
### 6C.1 (challenge)
# Read sample.fastq. Using seq(..., by = 4) index arithmetic, extract
# the read ids (strip the leading '@'), the sequences, and the quality
# strings. Build a data.frame of id and read length and print it.
# your code here


# =====================================================================
# Module 7 - errors, debugging & testing
# =====================================================================

## 7A. Signalling -------------------------------------------------------
### Worked example
gc_content <- function(seq) {
  stopifnot(is.character(seq), length(seq) == 1, nchar(seq) > 0)
  b <- strsplit(toupper(seq), "")[[1]]
  if (!all(b %in% c("A","C","G","T"))) stop("non-ACGT character in sequence")
  sum(b %in% c("G","C")) / length(b)
}
cat(gc_content("GGCC"), "\n")   # 1

### 7A.1 (easy)
# Call gc_content("ATGX") and gc_content("") inside tryCatch() so that
# instead of crashing, each prints a message and returns NA. Print the
# two returned values.
# your code here


## 7B. tryCatch --------------------------------------------------------
### 7B.1 (harder)
# Write safe_read(p) that returns read.csv(p) or, if the file is
# missing, prints a message and returns NULL. Test it on a real path
# and on "does_not_exist.csv".
# your code here


## 7C. Testing with testthat --------------------------------------------
### 7C.1 (harder)
# Using library(testthat), write a test_that() block for gc_content()
# with at least: GGCC == 1, ATGC == 0.5, an expect_error on "ATGX",
# and an expect_error on "". Run it.
# your code here


# =====================================================================
# Module 8 - object systems (S3)
# =====================================================================

## 8A. An S3 class ------------------------------------------------------
### Worked example - constructor + print method
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
s <- new_sequence("ATGCGC", id = "rpoB")
print(s)

### 8A.1 (harder)
# Declare a generic gc() with UseMethod("gc"), and a method gc.sequence
# that returns the GC fraction of x$bases. Test gc(s) (expect 0.6667).
# NOTE: base R has a gc() for garbage collection; defining your own in
# the global environment for practice is fine here.
# your code here


## 8B. Inheritance ------------------------------------------------------
### 8B.1 (challenge)
# Write new_dna(bases, id) that builds on new_sequence() but sets
# class = c("dna", "sequence"). Declare a generic revcomp() and a
# method revcomp.dna() returning a NEW dna object with the reverse
# complement. Confirm gc() still works on a dna via inheritance.
# your code here


# =====================================================================
# Part II capstone - a FASTA report tool
# =====================================================================
# Write fasta_report(path) that:
#   1. parses the FASTA (reuse parse_fasta),
#   2. for each sequence builds a 'dna' S3 object,
#   3. returns a data.frame with id, length_bp, and gc (fraction),
#      sorted by gc descending.
# Validate the path with stopifnot(file.exists(path)). Run it on
# data/sample.fasta and print the result.
# your code here
