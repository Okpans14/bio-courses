# =====================================================================
# R for Bioinformatics — Part IV Exercises
# Modules 13-15 · Bioconductor
# =====================================================================
# Install Bioconductor packages first:
#   install.packages("BiocManager")
#   BiocManager::install(c("Biostrings", "GenomicRanges",
#                          "SummarizedExperiment"))
# Uses data/sample.fasta.
# =====================================================================

library(Biostrings)
library(GenomicRanges)
library(SummarizedExperiment)

data_dir <- if (dir.exists("data")) "data" else "../data"
path <- function(f) file.path(data_dir, f)


# =====================================================================
# Module 13 - Biostrings
# =====================================================================

## 13A. DNAString -------------------------------------------------------
### Worked example
d <- DNAString("ATGCGTACG")
cat("length:", length(d), "\n")
print(reverseComplement(d))

### 13A.1 (easy)
# For d <- DNAString("ATGCGCGTAT"): print the A/C/G/T counts with
# alphabetFrequency(d, baseOnly = TRUE) and the GC fraction with
# letterFrequency(d, "GC", as.prob = TRUE).
# your code here


### 13A.2 (harder)
# Translate DNAString("ATGAAATGGTAA") with translate(). What protein do
# you get, and what does the final character represent?
# your code here


## 13B. Reading FASTA ---------------------------------------------------
### 13B.1 (harder)
# Read sample.fasta with readDNAStringSet(). Print the names, the width
# (length) of each sequence, and the GC fraction of each
# (letterFrequency(..., "GC", as.prob = TRUE)).
# your code here


# =====================================================================
# Module 14 - genomic ranges
# =====================================================================

## 14A. GRanges ---------------------------------------------------------
### Worked example
genes <- GRanges(
  seqnames = c("chr1", "chr1", "chr2"),
  ranges   = IRanges(start = c(100, 500, 80), end = c(400, 900, 200)),
  strand   = c("+", "-", "+"),
  gene     = c("rpoB", "katG", "gyrA")
)
print(genes)

### 14A.1 (easy)
# From `genes`: print the seqnames, the widths, and the `gene` metadata
# column.
# your code here


## 14B. Overlaps --------------------------------------------------------
### 14B.1 (challenge)
# Make a GRanges `variants` with two 1-bp variants: one at chr1:150 and
# one at chr2:5000. Use subsetByOverlaps(genes, variants) to find which
# genes contain a variant, and findOverlaps(variants, genes) to see the
# hit pairs. Which gene is hit? Which variant hits nothing?
# your code here


# =====================================================================
# Part IV capstone - a SummarizedExperiment from scratch
# =====================================================================
# Build a SummarizedExperiment for 3 genes x 4 samples:
#   - counts: a 3x4 integer matrix (make up plausible numbers),
#     rownames = gene names, colnames = sample names
#   - colData: a DataFrame with a `condition` column
#     (2 control, 2 treated)
# Then:
#   1. print assay() and colData(),
#   2. subset to just the treated samples and show the counts stay
#      aligned,
#   3. compute the mean count per gene in each condition
#      (hint: rowMeans on the two column subsets).
# your code here
