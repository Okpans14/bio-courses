# =====================================================================
# R for Bioinformatics — Part III Solutions
# Modules 9-12 · The Tidyverse & Data Analysis
# =====================================================================

library(tidyverse)
data_dir <- if (dir.exists("data")) "data" else "../data"
path <- function(f) file.path(data_dir, f)

gc_frac <- function(s) {
  b <- strsplit(toupper(s), "")[[1]]
  sum(b %in% c("G", "C")) / length(b)
}


# =====================================================================
# Module 9
# =====================================================================

## 9A.1 - sapply with an anonymous function
seqs <- c("ATG", "GGCC", "AATT")
print(sapply(seqs, gc_frac))                      # 0.3333 1.0000 0.0000

## 9A.2 - tapply for a grouped mean
expr <- read_csv(path("expression.csv"))
print(tapply(expr$tpm, expr$condition, mean))

## 9B.1 - same with purrr
print(map_dbl(seqs, ~ gc_frac(.x)))               # matches 9A.1


# =====================================================================
# Module 10
# =====================================================================

## 10A.1
expr |>
  filter(condition == "treated") |>
  mutate(log2_tpm = log2(tpm)) |>
  arrange(desc(log2_tpm)) |>
  head() |>
  print()

## 10B.1 - grouped summary
expr |>
  group_by(gene, condition) |>
  summarise(mean_tpm = mean(tpm), n = n(), .groups = "drop") |>
  print()

## 10C.1 - left join, then find non-matches
gc <- read_tsv(path("gc_report.tsv"))
joined <- expr |> left_join(gc, by = "gene")
joined |> filter(is.na(gc)) |> distinct(gene) |> print()   # genes lacking gc

## 10D.1 - long to wide
expr |>
  group_by(gene, condition) |>
  summarise(mean_tpm = mean(tpm), .groups = "drop") |>
  pivot_wider(names_from = condition, values_from = mean_tpm) |>
  print()


# =====================================================================
# Module 11
# =====================================================================

## 11A.1 - faceted boxplot
p1 <- ggplot(expr, aes(x = condition, y = tpm)) +
  geom_boxplot() +
  facet_wrap(~ gene) +
  labs(title = "Expression by condition", x = NULL, y = "TPM") +
  theme_minimal()
print(p1)

## 11B.1 - ordered, flipped bar chart
mean_by_gene <- expr |> group_by(gene) |> summarise(mean_tpm = mean(tpm))
p2 <- ggplot(mean_by_gene, aes(x = reorder(gene, mean_tpm), y = mean_tpm)) +
  geom_col() +
  coord_flip() +
  labs(title = "Mean expression per gene", x = "gene", y = "mean TPM") +
  theme_minimal()
print(p2)


# =====================================================================
# Part III capstone - treated vs control
# =====================================================================
summary_tbl <- expr |>
  group_by(gene, condition) |>
  summarise(mean_tpm = mean(tpm), .groups = "drop") |>
  pivot_wider(names_from = condition, values_from = mean_tpm) |>
  mutate(log2fc = log2(treated / control)) |>
  arrange(desc(abs(log2fc)))
print(summary_tbl)

p3 <- summary_tbl |>
  mutate(direction = if_else(log2fc > 0, "up", "down")) |>
  ggplot(aes(x = reorder(gene, log2fc), y = log2fc, fill = direction)) +
  geom_col() +
  coord_flip() +
  labs(title = "Treated vs control", x = "gene", y = "log2 fold change") +
  theme_minimal()
print(p3)

# ---------------------------------------------------------------------
# Part III done: load, wrangle, reshape, and plot - the everyday loop.
# Part IV: Bioconductor - Biostrings, genomic ranges, real data.
# ---------------------------------------------------------------------
