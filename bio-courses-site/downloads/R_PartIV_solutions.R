# =====================================================================
# R for Bioinformatics — Part IV Solutions
# Modules 13-15 · Bioconductor
# =====================================================================

library(Biostrings)
library(GenomicRanges)
library(SummarizedExperiment)

data_dir <- if (dir.exists("data")) "data" else "../data"
path <- function(f) file.path(data_dir, f)


# =====================================================================
# Module 13
# =====================================================================

## 13A.1 - composition and GC
d <- DNAString("ATGCGCGTAT")
print(alphabetFrequency(d, baseOnly = TRUE))
cat("GC:", letterFrequency(d, "GC", as.prob = TRUE), "\n")   # 0.5

## 13A.2 - translation; '*' is the stop codon
print(translate(DNAString("ATGAAATGGTAA")))   # MKW*  (TAA -> * stop)

## 13B.1 - read a DNAStringSet
seqs <- readDNAStringSet(path("sample.fasta"))
print(names(seqs))
print(width(seqs))
print(letterFrequency(seqs, "GC", as.prob = TRUE))


# =====================================================================
# Module 14
# =====================================================================

genes <- GRanges(
  seqnames = c("chr1", "chr1", "chr2"),
  ranges   = IRanges(start = c(100, 500, 80), end = c(400, 900, 200)),
  strand   = c("+", "-", "+"),
  gene     = c("rpoB", "katG", "gyrA")
)

## 14A.1
print(seqnames(genes))
print(width(genes))
print(genes$gene)

## 14B.1 - overlaps
variants <- GRanges(
  seqnames = c("chr1", "chr2"),
  ranges   = IRanges(start = c(150, 5000), width = 1)
)
hit_genes <- subsetByOverlaps(genes, variants)
print(hit_genes$gene)                    # "rpoB" (chr1:150 falls in 100-400)
print(findOverlaps(variants, genes))     # variant 1 -> gene 1; variant 2: none
# chr2:5000 is past gyrA (80-200), so that variant overlaps nothing.


# =====================================================================
# Part IV capstone - a SummarizedExperiment
# =====================================================================
counts <- matrix(
  c(120L, 45L, 210L,
    118L, 47L, 206L,
     95L, 88L, 199L,
     99L, 91L, 201L),
  nrow = 3,
  dimnames = list(c("rpoB", "katG", "gyrA"),
                  c("ctrl1", "ctrl2", "treat1", "treat2"))
)
coldata <- DataFrame(condition = c("control", "control", "treated", "treated"),
                     row.names = colnames(counts))
se <- SummarizedExperiment(assays = list(counts = counts), colData = coldata)

print(assay(se))
print(colData(se))

## 2. subset to treated - counts stay aligned with metadata
se_treated <- se[, se$condition == "treated"]
print(assay(se_treated))

## 3. mean count per gene per condition
ctrl  <- rowMeans(assay(se)[, se$condition == "control"])
treat <- rowMeans(assay(se)[, se$condition == "treated"])
print(data.frame(gene = rownames(counts), control = ctrl, treated = treat,
                 row.names = NULL))

# ---------------------------------------------------------------------
# Part IV done: Biostrings, GRanges, SummarizedExperiment - the shared
# objects the whole Bioconductor ecosystem speaks. Part V: reproducible
# reports and your own R package.
# ---------------------------------------------------------------------
