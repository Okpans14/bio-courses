# =====================================================================
# R for Bioinformatics — Part III Exercises
# Modules 9-12 · The Tidyverse & Data Analysis
# =====================================================================
# Needs the tidyverse:  install.packages("tidyverse")
# Uses data/expression.csv, data/variants.csv, data/gc_report.tsv
# =====================================================================

library(tidyverse)
data_dir <- if (dir.exists("data")) "data" else "../data"
path <- function(f) file.path(data_dir, f)


# =====================================================================
# Module 9 - apply family & purrr
# =====================================================================

## 9A. apply family -----------------------------------------------------
### Worked example
cat(sapply(c("AT", "ATG", "ATGC"), nchar), "\n")       # 2 3 4

### 9A.1 (easy)
# seqs <- c("ATG", "GGCC", "AATT"). Use sapply() with an anonymous
# function to compute the GC fraction of each. Print the result.
seqs <- c("ATG", "GGCC", "AATT")
# your code here


### 9A.2 (harder)
# Read expression.csv. Use tapply() to get the mean tpm per condition.
# Print it.
# your code here


## 9B. purrr ------------------------------------------------------------
### 9B.1 (harder)
# Repeat 9A.1 using purrr::map_dbl() with the ~ .x lambda syntax.
# Confirm it matches the sapply version.
# your code here


# =====================================================================
# Module 10 - dplyr & tidyr
# =====================================================================

expr <- read_csv(path("expression.csv"))

## 10A. The core verbs --------------------------------------------------
### Worked example
expr |>
  select(gene, condition, tpm) |>
  filter(tpm > 50) |>
  arrange(desc(tpm)) |>
  head()

### 10A.1 (easy)
# From expr, keep only "treated" rows, add a column log2_tpm = log2(tpm),
# and arrange by log2_tpm descending. Print the first few rows.
# your code here


## 10B. Grouped summaries -----------------------------------------------
### 10B.1 (harder)
# Compute, per gene AND condition, the mean tpm and the number of
# replicates (n()). Use .groups = "drop". Print the result.
# your code here


## 10C. Joins -----------------------------------------------------------
### 10C.1 (harder)
# Read gc_report.tsv (gene, gc). left_join it onto expr so every row
# gains a gc column. Print the rows where gc is NA (genes with no gc).
# your code here


## 10D. Reshaping -------------------------------------------------------
### 10D.1 (challenge)
# From expr, make a WIDE table: one row per gene, one column per
# condition, values = mean tpm. (hint: group_by + summarise, then
# pivot_wider). Print it.
# your code here


# =====================================================================
# Module 11 - ggplot2
# =====================================================================

## 11A. A first plot ----------------------------------------------------
### Worked example (run to see a plot)
ggplot(expr, aes(x = condition, y = tpm)) +
  geom_boxplot()

### 11A.1 (easy)
# Make a boxplot of tpm by condition, FACETED by gene (facet_wrap).
# Add a title and a y-axis label, and use theme_minimal().
# your code here


## 11B. Bars ------------------------------------------------------------
### 11B.1 (harder)
# Compute mean tpm per gene (across all rows), then make a bar chart
# (geom_col) of mean tpm by gene, bars ordered by height, flipped
# horizontal (coord_flip). Title it.
# your code here


# =====================================================================
# Part III capstone - treated vs control, end to end
# =====================================================================
# In ONE pipeline: from expr, compute mean tpm per gene per condition,
# pivot so control and treated are columns, add log2fc = log2(treated/
# control), and arrange by abs(log2fc) descending. Then plot log2fc per
# gene as horizontal bars coloured by up/down direction.
# your code here
