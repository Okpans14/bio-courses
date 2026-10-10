# =====================================================================
# Statistics for Biologists — Part VI Exercises
# Modules 15-16 · Multivariate & Reproducible Statistics
# =====================================================================
library(tidyverse)
data_dir <- if (dir.exists("data")) "data" else "../data"
flow <- read_csv(file.path(data_dir, "flower_traits.csv"))


# =====================================================================
# Module 15 - multivariate methods
# =====================================================================

traits <- c("petal_length_cm","petal_width_cm","sepal_length_cm","sepal_width_cm")

## 15A. PCA -------------------------------------------------------------
### Worked example
pca <- prcomp(flow[, traits], scale. = TRUE)
summary(pca)

### 15A.1 (harder)
# From the PCA: (a) how much variance do PC1 and PC2 together explain?
# (b) make a PC1-vs-PC2 scatterplot coloured by species - do the species
# separate? (c) look at pca$rotation - which traits load most strongly
# on PC1?
# your code here


### 15A.2 (concept)
# Why did we use scale. = TRUE? What could go wrong if one trait were
# measured in millimetres and another in metres and we did NOT scale?
# your answer here (comment)


## 15B. Clustering ------------------------------------------------------
### 15B.1 (challenge)
# Hierarchically cluster the scaled traits (dist -> hclust, ward.D2).
# Plot the dendrogram, cut into k = 4 groups (cutree), and cross-
# tabulate the clusters against the true species (table()). How well do
# the clusters recover the species?
# your code here


# =====================================================================
# Module 16 - reproducible practice
# =====================================================================

## 16A. Power analysis --------------------------------------------------
### 16A.1 (easy)
# You expect a treatment to raise growth by 5 cm with sd = 4. How many
# samples PER GROUP do you need for 80% power at alpha = 0.05?
# (power.t.test). What if you only care about a 2 cm effect?
# your code here


## 16B. Multiple testing ------------------------------------------------
### 16B.1 (harder)
# You ran 6 tests with these raw p-values:
p <- c(0.001, 0.008, 0.02, 0.03, 0.04, 0.21)
# Apply Bonferroni and BH (FDR) correction with p.adjust(). Which stay
# "significant" (< 0.05) under each? Which method is appropriate for a
# genome-wide screen of 20,000 genes, and why?
# your code here + comment


## 16B.2 (concept)
# Explain in two or three lines why reporting only the significant
# results from 50 exploratory tests (p-hacking) produces false
# positives, and what pre-specification does about it.
# your answer here


# =====================================================================
# Course capstone - a complete, reproducible mini-analysis
# =====================================================================
# Pick ANY dataset from the course and carry out a full analysis that
# demonstrates the whole arc:
#   1. state the biological question as response ~ predictors,
#   2. describe + visualise the data (and note the design / any
#      pseudoreplication),
#   3. fit an appropriate model (lm / glm / lmer - justify the choice),
#   4. check its assumptions with residual diagnostics,
#   5. report the effect size(s) with 95% CI and interpret biologically
#      (NOT just a p-value),
#   6. set.seed() for anything random and end with sessionInfo() so the
#      analysis is reproducible.
# Write it so someone else could re-run it and get your numbers.
# your code here
