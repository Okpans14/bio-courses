# =====================================================================
# Statistics for Biologists — Part II Exercises
# Modules 4-5 · Probability & Inference Foundations
# =====================================================================
library(tidyverse)
data_dir <- if (dir.exists("data")) "data" else "../data"
morph <- read_csv(file.path(data_dir, "morphology.csv"))
par    <- read_csv(file.path(data_dir, "parasite_counts.csv"))


# =====================================================================
# Module 4 - probability distributions
# =====================================================================

## 4A. The normal d/p/q/r family ----------------------------------------
### Worked example - body length ~ Normal(12.9, 1.2)
cat("P(len < 15):", pnorm(15, 12.9, 1.2), "\n")
cat("97.5th percentile:", qnorm(0.975, 12.9, 1.2), "\n")

### 4A.1 (easy)
# Using Normal(mean = 12.9, sd = 1.2):
#  (a) P(a beetle is LONGER than 14 mm)
#  (b) the body length below which 10% of beetles fall (a quantile)
# your code here


### 4A.2 (concept)
# What value does qnorm(0.975) return, and where does the "1.96" in
# "mean +/- 1.96 SE" come from? Answer in a comment.
# your answer here


## 4B. Binomial & Poisson -----------------------------------------------
### 4B.1 (easy)
# 20 hosts are exposed; each is infected with probability 0.3.
#  (a) P(exactly 8 are infected)   (b) P(8 or fewer are infected)
# your code here


### 4B.2 (harder)
# For parasite_counts.csv: compute the mean and variance of
# parasite_count. For a Poisson these should be about EQUAL. Are they?
# What does the comparison suggest about overdispersion?
# your code here


# =====================================================================
# Module 5 - sampling, CLT & confidence intervals
# =====================================================================

## 5A. The sampling distribution ----------------------------------------
### Worked example - SE by simulation vs formula
set.seed(1)
pop <- rnorm(100000, 12.9, 1.2)
means <- replicate(2000, mean(sample(pop, 30)))
cat("empirical SE:", sd(means), " formula SE:", 1.2 / sqrt(30), "\n")

### 5A.1 (harder)
# Demonstrate the CLT with SKEWED data: draw 2000 sample means of size
# 40 from a Poisson population (rpois(100000, 3)) and plot a histogram
# of the means. Do the means look bell-shaped even though counts are
# skewed? Comment.
# your code here


## 5B. Confidence intervals ---------------------------------------------
### 5B.1 (harder)
# For morph$body_length_mm compute a 95% CI for the MEAN using the
# t-distribution (qt). Then check your answer against t.test(x)$conf.int.
# your code here


### 5B.2 (concept)
# A colleague says "there is a 95% probability the true mean is inside
# my 95% CI." Why is that the wrong interpretation? Give the correct one
# in one or two lines.
# your answer here


# =====================================================================
# Part II capstone - estimate with uncertainty, two ways
# =====================================================================
# For the MEDIAN mass_mg of the beetles:
#   1. there is no simple SE formula for a median, so build a 95%
#      bootstrap CI by resampling with replacement (>= 2000 resamples),
#   2. report the median and its bootstrap CI,
#   3. in one sentence, say why you used the bootstrap here but could
#      use the t-based CI for the MEAN.
# your code here
