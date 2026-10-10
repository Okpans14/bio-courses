# =====================================================================
# Statistics for Biologists — Part I Exercises
# Modules 1-3 · Data & Description
# =====================================================================
# Assumes basic R + tidyverse. install.packages("tidyverse")
# Uses data/morphology.csv (120 beetles, two sites, both sexes).
# =====================================================================

library(tidyverse)
data_dir <- if (dir.exists("data")) "data" else "../data"
morph <- read_csv(file.path(data_dir, "morphology.csv"))


# =====================================================================
# Module 1 - study design & types of data
# =====================================================================

## 1A. Variable types ---------------------------------------------------
### Worked example - inspect types
glimpse(morph)

### 1A.1 (easy)
# For each column of morph, state its statistical variable type
# (continuous / count / nominal / ordinal / binary). Write your answers
# as comments. Then confirm how R stores each with sapply(morph, class).
# your answer + code here


### 1A.2 (concept)
# A study measures leaf area on 8 leaves from EACH of 3 trees, one tree
# per treatment. How many independent replicates of the TREATMENT are
# there? Is analysing 24 leaves as independent valid? Name the problem.
# your answer here (comment)


## 1B. response ~ explanatory -------------------------------------------
### 1B.1 (easy)
# For each question, write the response and the explanatory variable(s):
#  (a) Does body length differ between sexes?
#  (b) Does wing length increase with body length?
#  (c) Does infection depend on dose and age?
# your answers here (comments)


# =====================================================================
# Module 2 - descriptive statistics
# =====================================================================

## 2A. Central tendency & spread ----------------------------------------
### Worked example
cat("mean:", mean(morph$body_length_mm),
    " median:", median(morph$body_length_mm), "\n")

### 2A.1 (easy)
# Compute the mean, median, SD, and IQR of mass_mg. Is mass roughly
# symmetric (mean close to median) or skewed? Comment.
# your code here


## 2B. SD vs SE vs CI ---------------------------------------------------
### 2B.1 (harder)
# For body_length_mm compute: n, sd, the standard error (sd/sqrt(n)),
# and a 95% CI for the mean using qt(0.975, df = n-1). Print all four.
# your code here


### 2B.2 (concept)
# You collect 10x more beetles. Which of {SD, SE, 95% CI width} shrink,
# and which stays about the same? Explain in one line.
# your answer here (comment)


## 2C. Grouped summaries ------------------------------------------------
### 2C.1 (harder)
# Produce a table with, FOR EACH sex: n, mean, sd, and se of
# body_length_mm. Which sex is larger on average, and by how much?
# your code here


# =====================================================================
# Module 3 - exploratory visualisation
# =====================================================================

## 3A. Distributions ----------------------------------------------------
### Worked example
ggplot(morph, aes(body_length_mm)) + geom_histogram(bins = 20)

### 3A.1 (easy)
# Make a histogram of mass_mg AND a boxplot of mass_mg by site.
# From the plots, does mass look normal? Does it differ by site?
# your code here


## 3B. Relationships & QQ -----------------------------------------------
### 3B.1 (harder)
# Scatterplot wing_length_mm (y) vs body_length_mm (x) with an lm smooth.
# Then make a QQ plot of body_length_mm. Comment on linearity and
# normality from the pictures.
# your code here


# =====================================================================
# Part I capstone - a one-page data summary
# =====================================================================
# For morphology.csv produce:
#   1. a grouped summary table (n, mean, sd, se of body_length_mm by
#      sex AND site - group_by(sex, site)),
#   2. a boxplot of body_length_mm by sex, faceted by site, with points
#      overlaid (geom_jitter) and proper labels,
#   3. two sentences: what the data show descriptively, and ONE caution
#      about reading too much into it before a formal test.
# your code here
