# =====================================================================
# R for Bioinformatics — Part V Exercises
# Modules 16-17 · Reproducible Research & Your Own Tool
# =====================================================================
# Packages:
#   install.packages(c("rmarkdown","knitr","devtools","roxygen2",
#                      "testthat","usethis"))
# Much of this module is done at the CONSOLE and in files, not by
# running one script top to bottom. Follow the steps in comments.
# =====================================================================


# =====================================================================
# Module 16 - reproducible reports
# =====================================================================

## 16A. Write a report --------------------------------------------------
# 16A.1 (easy)
# In RStudio: File -> New File -> R Markdown. Choose HTML. Knit the
# default document to confirm your toolchain works. (No code to write
# here - this is a setup check.)

# 16A.2 (harder)
# Create a report "expression_report.Rmd" that:
#   - has a YAML header with a title and output: html_document,
#   - loads the tidyverse and reads data/expression.csv in a setup chunk
#     with message=FALSE,
#   - states the number of rows using INLINE code: `r nrow(expr)`,
#   - shows a faceted boxplot of tpm by condition in a chunk with
#     echo=FALSE.
# Knit it. See example_report.Rmd in this folder for a worked version.


## 16B. Inline code -----------------------------------------------------
# 16B.1 (harder)
# Add a sentence to your report that reports the mean tpm, computed
# inline, e.g.:  "Mean expression was `r round(mean(expr$tpm), 1)` TPM."
# Re-knit and confirm the number appears in the text.


# =====================================================================
# Module 17 - writing your own R package
# =====================================================================

## 17A. Scaffold a package ----------------------------------------------
# 17A.1
# At the console, create a package skeleton:
#   library(usethis)
#   create_package("~/seqtools")
# Inspect the created files: DESCRIPTION, NAMESPACE, R/.

## 17B. Add a documented function ---------------------------------------
# 17B.1 (harder)
# Create R/gc_content.R containing gc_content() WITH roxygen2
# documentation (@param, @return, @examples, @export). Then run:
#   devtools::document()
#   devtools::load_all()
#   ?gc_content        # the help page should appear
# Write the function + roxygen below first, then move it into the file.
# your code here


## 17C. Test it ---------------------------------------------------------
# 17C.1 (harder)
# Set up testing and add a test:
#   usethis::use_testthat()
#   usethis::use_test("gc_content")
# In tests/testthat/test-gc_content.R, write expectations for
# GGCC == 1, ATGC == 0.5, and an error on "ATGX". Then:
#   devtools::test()
# Write the test block below first.
# your code here


# =====================================================================
# Course capstone - the seqtools package
# =====================================================================
# Assemble a small package `seqtools` that gathers the functions you
# wrote across the course:
#   - gc_content(seq)     (Part I)
#   - revcomp(seq)        (Part I)
#   - parse_fasta(path)   (Part II)
# For each:
#   1. put it in its own file under R/ with full roxygen docs and @export,
#   2. add a testthat test,
#   3. run devtools::document(), devtools::test(), and devtools::check().
# Then write a short reproducible report (.Rmd) that loads the package,
# parses data/sample.fasta, and tabulates id, length, and GC per
# sequence - using YOUR package functions.
#
# Draft the three function files and their roxygen below, then build the
# package. See PartV_solutions.R for a complete worked version.
# your code here
