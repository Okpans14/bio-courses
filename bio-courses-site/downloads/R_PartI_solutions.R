# =====================================================================
# R for Bioinformatics — Part I Solutions
# Modules 1-5 · Foundations
# =====================================================================
# Reference solutions with commentary. More than one correct approach
# usually exists; if yours gives the right result and reads clearly, it
# is fine. Compare APPROACH, not just output.
# =====================================================================


# =====================================================================
# Module 1
# =====================================================================

## 1A.1
gene_name <- "katG"; length_bp <- 2223L; protein_length <- 740L
cat(sprintf("%s encodes a protein of %d amino acids (%d bp).\n",
            gene_name, protein_length, length_bp))

## 1A.2 - compute, don't hard-code
length_bp <- 2223L
protein_length <- (length_bp %/% 3) - 1        # integer division with %/%
cat(sprintf("%d bp -> %d amino acids\n", length_bp, protein_length))

## 1B.1
reads_text <- "4820000"; mapped_text <- "4502300"
mapped <- as.numeric(mapped_text)
cat("Mapped reads:", mapped, "\n")

## 1B.2 - division yields a double automatically
reads <- as.numeric("4820000"); mapped <- as.numeric("4502300")
rate <- mapped / reads * 100
cat(sprintf("Mapping rate: %.2f%%\n", rate))   # 93.41%

## 1C.1
plasmid <- 4361; frag <- 750
cat(sprintf("Approx %d fragments of %d bp, plus a %d bp remainder.\n",
            plasmid %/% frag, frag, plasmid %% frag))


# =====================================================================
# Module 2
# =====================================================================

## 2A.1 - substr() is 1-based and inclusive at both ends
cds <- "ATGAAACCCGGGTAA"
cat("start:", substr(cds, 1, 3), "\n")                 # ATG
cat("stop: ", substr(cds, nchar(cds) - 2, nchar(cds)), "\n")  # TAA
cat("inner:", substr(cds, 4, nchar(cds) - 3), "\n")    # AAACCCGGG

## 2A.2 - logical mask, no loop
lengths_bp <- c(3534, 2223, 2628, 561, 1200)
print(lengths_bp[lengths_bp > 2000])                   # 3534 2223 2628

## 2B.1 - gsub replaces ALL matches
dna <- "ATGCGTACG"
cat("mRNA:", gsub("T", "U", dna), "\n")                # AUGCGUACG

## 2B.2 - one vectorised expression
dna <- "ATGCGTACG"
b <- strsplit(dna, "")[[1]]
cat(sprintf("GC: %.2f%%\n", sum(b %in% c("G", "C")) / length(b) * 100))  # 55.56%

## 2C.1 - reuse revcomp(); palindrome check
revcomp <- function(s) {
  comp <- c(A = "T", T = "A", G = "C", C = "G")[strsplit(toupper(s), "")[[1]]]
  paste(rev(comp), collapse = "")
}
s <- "GGGTTTAAACCC"
rc <- revcomp(s)
cat(rc, "\n")                      # GGGTTTAAACCC
cat("palindrome:", s == rc, "\n")  # TRUE

## 2C.2 - regexpr finds the first; gregexpr finds all
seq <- "CCATGCCCATGTAA"
cat("first ATG at:", regexpr("ATG", seq)[1], "\n")     # 3 (R is 1-based!)
all_atg <- gregexpr("ATG", seq)[[1]]
cat("all ATG starts:", as.integer(all_atg), "\n")      # 3 9
# NOTE: positions are 1-based in R, so they differ by 1 from Python's find().


# =====================================================================
# Module 3
# =====================================================================

## 3A.1
length_bp <- 1500; gc <- 0.55
print(length_bp > 1000 && gc >= 0.4 && gc <= 0.6)      # TRUE

## 3A.2 - ifelse() is vectorised; no loop
gc_values <- c(0.35, 0.55, 0.72, 0.41)
print(ifelse(gc_values > 0.6, "high", "low"))          # low low high low

## 3B.1 - loop vs vectorised, same answer
seq <- "ATGCGCGTAT"; bases <- strsplit(seq, "")[[1]]
gc <- 0
for (b in bases) if (b == "G" || b == "C") gc <- gc + 1
cat("loop:", gc, "\n")
cat("vectorised:", sum(bases %in% c("G", "C")), "\n")   # both 5

## 3C.1 - minimal ORF finder with a while loop
seq <- "CCCATGAAACCCGGGTAACC"
start <- regexpr("ATG", seq)[1]
orf <- ""; i <- start
while (i <= nchar(seq) - 2) {
  codon <- substr(seq, i, i + 2)
  orf <- paste0(orf, codon)
  if (codon %in% c("TAA", "TAG", "TGA")) break
  i <- i + 3
}
cat("ORF:", orf, "\n")                                  # ATGAAACCCGGGTAA


# =====================================================================
# Module 4
# =====================================================================

## 4A.1 - vectors are copied on modify (no aliasing surprise like Python lists)
genes <- c("dnaA", "gyrB")
genes <- c(genes, "recA")       # append by re-combining
genes[1] <- "dnaA_mut"          # replace first
print(genes); cat("length:", length(genes), "\n")

## 4B.1 - table() gives named counts
seq <- "AATTTGCGCGCGAT"
counts <- table(strsplit(seq, "")[[1]])
print(counts)
cat("G:", counts["G"], "\n")

## 4B.2 - translation via a named lookup vector (vectorised, no loop)
codon_table <- c(ATG="M", AAA="K", TGG="W", TAA="*", TAG="*", TGA="*")
cds <- "ATGAAATGG"
codons <- substring(cds, seq(1, nchar(cds) - 2, by = 3), seq(3, nchar(cds), by = 3))
protein <- paste(codon_table[codons], collapse = "")
cat(protein, "\n")              # MKW

## 4C.1 - data frame access
variants <- data.frame(
  gene     = c("rpoB", "katG", "gyrA", "gyrA"),
  position = c(1349, 944, 248, 259),
  quality  = c(45.2, 38.7, 52.1, 29.4)
)
print(variants$gene)                         # (a) the column
cat("rows:", nrow(variants), "\n")           # (b) row count
print(variants[variants$gene == "gyrA", ])   # (c) filtered rows

## Module 4 challenge - base-composition report
seq <- "ATGCGCGTATTACCGGGCAT"
bases <- strsplit(seq, "")[[1]]
valid <- all(bases %in% c("A", "C", "G", "T"))
gc <- sum(bases %in% c("G", "C")) / length(bases)
cat("Length:     ", nchar(seq), "\n")
cat("Valid DNA:  ", valid, "\n")
cat("Composition:\n"); print(table(bases))
cat(sprintf("GC content:  %.2f%%\n", gc * 100))   # 55.00%


# =====================================================================
# Module 5
# =====================================================================

## 5A.1
gc_content <- function(seq) {
  b <- strsplit(toupper(seq), "")[[1]]
  sum(b %in% c("G", "C")) / length(b)
}
cat(gc_content("ATGCGC"), "\n")               # 0.6667

## 5A.2 - default argument
count_base <- function(seq, base = "G") {
  b <- strsplit(toupper(seq), "")[[1]]
  sum(b == toupper(base))
}
cat(count_base("ATGCGC"), "\n")               # 2 (default G)
cat(count_base("ATGCGC", base = "A"), "\n")   # 1

## 5B.1 - return several things in a list; all()/any() for validation
analyse <- function(seq) {
  seq <- toupper(seq)
  b <- strsplit(seq, "")[[1]]
  list(
    length = nchar(seq),
    gc     = sum(b %in% c("G", "C")) / length(b),
    valid  = all(b %in% c("A", "C", "G", "T"))
  )
}
res <- analyse("ATGCGX")
print(res$valid)                              # FALSE (contains X)


# =====================================================================
# Part I capstone
# =====================================================================
revcomp <- function(seq) {
  comp <- c(A="T", T="A", G="C", C="G")[strsplit(toupper(seq), "")[[1]]]
  paste(rev(comp), collapse = "")
}
gc_content <- function(seq) {
  b <- strsplit(toupper(seq), "")[[1]]
  sum(b %in% c("G", "C")) / length(b)
}
codons_of <- function(seq) {
  substring(seq, seq(1, nchar(seq) - 2, by = 3), seq(3, nchar(seq), by = 3))
}
sequence_report <- function(seq) {
  seq <- toupper(seq)
  b <- strsplit(seq, "")[[1]]
  cat(sprintf("Length:       %d bp\n", nchar(seq)))
  cat(sprintf("Valid DNA:    %s\n", all(b %in% c("A","C","G","T"))))
  cat("Composition:  "); print(table(b))
  cat(sprintf("GC content:   %.2f%%\n", gc_content(seq) * 100))
  cat(sprintf("Rev-comp:     %s\n", revcomp(seq)))
  cat("Codons:       ", paste(codons_of(seq), collapse = " "), "\n")
}
sequence_report("ATGCGTACGGGCTAA")

# ---------------------------------------------------------------------
# You've finished the foundations. In Part II we read real FASTA/FASTQ
# files, add error handling and automated tests, and learn R's object
# systems - turning these loose functions into a proper toolkit.
# ---------------------------------------------------------------------
