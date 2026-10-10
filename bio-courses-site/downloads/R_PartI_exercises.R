# =====================================================================
# R for Bioinformatics — Part I Exercises
# Modules 1-5 · Foundations
# =====================================================================
#
# Work through this script ALONGSIDE the theory document, in order.
# When the theory says "> Practise now - Module 2 -> 2A", come here and
# do section 2A before reading on.
#
# Format: each section opens with a WORKED EXAMPLE to run and study,
# then an (easy) exercise, then (harder) ones, sometimes a (challenge).
# Write your code where it says "# your code here". Run a line with
# Ctrl/Cmd+Enter. Only open the solutions script after you have tried.
#
# Everything uses a bioinformatics context. No packages are needed in
# Part I (base R only).
# =====================================================================


# ---------------------------------------------------------------------
# Exercise 0 - confirm your setup
# ---------------------------------------------------------------------
# Run these two lines. If you see your R version and "ready", you are set.
print(R.version.string)
print("ready")


# =====================================================================
# Module 1 - syntax, types, formatted output
# =====================================================================

## 1A. Formatted output -------------------------------------------------
### Worked example (run it)
gene_name  <- "rpoB"
length_bp  <- 3534L
gc_content <- 0.5237
cat(sprintf("Gene %s: %d bp, GC = %.2f%%\n", gene_name, length_bp, gc_content * 100))

### 1A.1 (easy)
# Make variables gene_name (character), length_bp (integer),
# protein_length (integer). Print one sentence with sprintf(), e.g.
#   katG encodes a protein of 740 amino acids (2223 bp).
# your code here


### 1A.2 (harder)
# For length_bp <- 2223, compute the protein length IN CODE as
# (length_bp %/% 3) - 1   (integer division; stop codon is not an aa)
# and print:  2223 bp -> 740 amino acids
# your code here


## 1B. Types and conversion ---------------------------------------------
### Worked example
count_text <- "1287"
count <- as.integer(count_text)
cat(class(count_text), "->", class(count), "\n")
cat("Doubled:", count * 2, "\n")

### 1B.1 (easy)
# reads_text <- "4820000" and mapped_text <- "4502300" are strings from
# a sequencing run. Convert both to numeric and print the mapped reads.
# your code here


### 1B.2 (harder)
# Using the two values above, compute the mapping rate as a percentage
# (mapped / reads * 100) and print it to 2 decimals with sprintf().
# your code here


## 1C. Integer division and modulo --------------------------------------
### Worked example
cat(1000 %/% 3, "complete codons,", 1000 %% 3, "leftover base(s)\n")

### 1C.1 (easy)
# A plasmid is 4361 bp, cut into 750 bp fragments. Print how many whole
# fragments you get and the remainder, e.g.
#   Approx 5 fragments of 750 bp, plus a 611 bp remainder.
# your code here


# =====================================================================
# Module 2 - vectors & strings
# =====================================================================

## 2A. Indexing and slicing ---------------------------------------------
### Worked example
genes <- c("rpoB", "katG", "gyrA", "pncA")
cat(genes[1], genes[length(genes)], genes[2:3], "\n")  # first, last, middle
cat(genes[-1], "\n")                                    # all except the first

### 2A.1 (easy)
# cds <- "ATGAAACCCGGGTAA". Using substr(), print the start codon (1-3),
# the stop codon (last 3), and the inner region (4 to nchar-3).
cds <- "ATGAAACCCGGGTAA"
# your code here


### 2A.2 (harder)
# lengths_bp <- c(3534, 2223, 2628, 561, 1200). Using a LOGICAL MASK
# (no loop), print only the lengths greater than 2000.
lengths_bp <- c(3534, 2223, 2628, 561, 1200)
# your code here


## 2B. Counting & composition -------------------------------------------
### Worked example
seq <- "ATGCGCGTAT"
bases <- strsplit(seq, "")[[1]]
print(table(bases))                         # frequency of each base
gc <- sum(bases %in% c("G", "C")) / length(bases)
cat(sprintf("GC: %.2f%%\n", gc * 100))

### 2B.1 (easy)
# dna <- "ATGCGTACG". Transcribe it to mRNA (replace T with U) using
# gsub(), and print the result.
dna <- "ATGCGTACG"
# your code here


### 2B.2 (harder)
# Write the GC calculation for dna above as a SINGLE vectorised
# expression (split -> %in% -> sum / length). Print it as a percentage.
# your code here


## 2C. Reverse complement -----------------------------------------------
### Worked example (named-vector lookup, vectorised)
revcomp <- function(s) {
  comp <- c(A = "T", T = "A", G = "C", C = "G")[strsplit(toupper(s), "")[[1]]]
  paste(rev(comp), collapse = "")
}
cat(revcomp("ATGC"), "\n")   # GCAT

### 2C.1 (harder)
# Use the revcomp() function above to print the reverse complement of
# "GGGTTTAAACCC". Is it a palindrome (equal to its own rev-comp)?
# your code here


### 2C.2 (challenge)
# Find the start position of the FIRST "ATG" in "CCATGCCCATGTAA" using
# a base-R function (hint: regexpr), then find ALL ATG start positions
# (hint: gregexpr). Print both.
# your code here


# =====================================================================
# Module 3 - control flow & vectorised thinking
# =====================================================================

## 3A. Conditionals -----------------------------------------------------
### Worked example
gc <- 0.35
if (gc > 0.6) print("GC-rich") else if (gc < 0.4) print("AT-rich") else print("balanced")

### 3A.1 (easy)
# length_bp <- 1500, gc <- 0.55. Print TRUE if the sequence is longer
# than 1000 AND gc is between 0.4 and 0.6 (inclusive). Use && and single
# comparisons.
# your code here


### 3A.2 (harder)
# gc_values <- c(0.35, 0.55, 0.72, 0.41). WITHOUT a loop, label each as
# "high" (>0.6) or "low" using ifelse(). Print the labels.
gc_values <- c(0.35, 0.55, 0.72, 0.41)
# your code here


## 3B. Loops ------------------------------------------------------------
### Worked example - codon walker
cds <- "ATGAAACCCGGGTAA"
for (i in seq(1, nchar(cds) - 2, by = 3)) {
  cat(i, ":", substr(cds, i, i + 2), "\n")
}

### 3B.1 (harder)
# Count G+C in "ATGCGCGTAT" by LOOPING over each base with a counter,
# then print the same count as ONE vectorised line. Confirm they match.
# your code here


## 3C. while loops ------------------------------------------------------
### 3C.1 (challenge) - minimal ORF finder
# seq <- "CCCATGAAACCCGGGTAACC". Find the first ATG, then walk forward in
# steps of 3 collecting codons until you hit a stop (TAA/TAG/TGA).
# Print the ORF including the stop codon. Expected: ATGAAACCCGGGTAA
seq <- "CCCATGAAACCCGGGTAACC"
# your code here


# =====================================================================
# Module 4 - data structures
# =====================================================================

## 4A. Vectors & lists --------------------------------------------------
### Worked example
record <- list(gene = "rpoB", length = 3534L, exons = c(1, 2, 3))
cat(record$gene, record[["length"]], "\n")

### 4A.1 (easy)
# Make a character vector `genes` of c("dnaA", "gyrB"). Append "recA"
# (hint: c(genes, "recA")), then change the first element to "dnaA_mut".
# Print the vector and its length.
# your code here


## 4B. Named vectors & tables -------------------------------------------
### 4B.1 (harder) - base-frequency counter
# seq <- "AATTTGCGCGCGAT". Produce a named count of each base using
# table(), and print it. Then print just the count of "G".
seq <- "AATTTGCGCGCGAT"
# your code here


### 4B.2 (harder) - codon translation with a lookup vector
# Build a named vector codon_table with at least:
#   ATG=M, AAA=K, TGG=W, TAA=*, TAG=*, TGA=*
# For cds <- "ATGAAATGG", split into codons and translate to "MKW".
cds <- "ATGAAATGG"
# your code here


## 4C. Data frames ------------------------------------------------------
### Worked example
variants <- data.frame(
  gene     = c("rpoB", "katG", "gyrA", "gyrA"),
  position = c(1349, 944, 248, 259),
  quality  = c(45.2, 38.7, 52.1, 29.4)
)
print(variants)
print(variants[variants$quality > 40, ])   # rows passing a filter

### 4C.1 (harder)
# From `variants` above: (a) print just the `gene` column, (b) print the
# number of rows, (c) print only the rows where gene == "gyrA".
# your code here


### Module 4 challenge - base-composition report
# For seq <- "ATGCGCGTATTACCGGGCAT" print: length, whether it is valid
# DNA (only ACGT), the base composition (table), and GC% to 2 dp.
seq <- "ATGCGCGTATTACCGGGCAT"
# your code here


# =====================================================================
# Module 5 - functions, scope & scripts
# =====================================================================

## 5A. Writing functions ------------------------------------------------
### Worked example
seq_length <- function(s) nchar(s)
cat(seq_length("ATGCGT"), "\n")

### 5A.1 (easy)
# Write gc_content(seq) that returns the GC FRACTION of a DNA string
# (upper-case it first). Test on "ATGCGC" (expect 0.6667).
# your code here


### 5A.2 (harder)
# Write count_base(seq, base = "G") with a default, returning the count
# of `base` in `seq` (case-insensitive). Test the default and base = "A".
# your code here


## 5B. Multiple return values -------------------------------------------
### 5B.1 (harder)
# Write analyse(seq) that returns a LIST with: length, gc (fraction),
# and valid (TRUE if only ACGT). Test on "ATGCGX" and print res$valid.
# your code here


# =====================================================================
# Part I capstone - a full sequence report from your own functions
# =====================================================================
# Write sequence_report(seq) that prints, for an upper-cased sequence:
#   Length, Valid DNA (only ACGT), Composition (table), GC% (2 dp),
#   Reverse complement, and the list of codons.
# Reuse gc_content() and revcomp(). Test on "ATGCGTACGGGCTAA".
# your code here
