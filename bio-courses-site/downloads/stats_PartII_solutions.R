# =====================================================================
# Statistics for Biologists — Part II Solutions
# Modules 4-5 · Probability & Inference Foundations
# =====================================================================
library(tidyverse)
data_dir <- if (dir.exists("data")) "data" else "../data"
morph <- read_csv(file.path(data_dir, "morphology.csv"))
par    <- read_csv(file.path(data_dir, "parasite_counts.csv"))


# =====================================================================
# Module 4
# =====================================================================

## 4A.1
cat("P(len > 14):", 1 - pnorm(14, 12.9, 1.2), "\n")     # ~0.178
cat("10th percentile:", qnorm(0.10, 12.9, 1.2), "\n")   # ~11.36

## 4A.2
# qnorm(0.975) = 1.959964. It is the z-value leaving 2.5% in the upper
# tail; a central 95% interval runs from -1.96 to +1.96 SE, hence the
# "+/- 1.96 SE" rule for large-sample 95% intervals.

## 4B.1
cat("P(exactly 8):", dbinom(8, 20, 0.3), "\n")          # ~0.114
cat("P(<= 8):", pbinom(8, 20, 0.3), "\n")               # ~0.887

## 4B.2 - mean vs variance of counts
cat(sprintf("mean=%.2f  var=%.2f  ratio=%.2f\n",
    mean(par$parasite_count), var(par$parasite_count),
    var(par$parasite_count) / mean(par$parasite_count)))
# Variance exceeds the mean (ratio > 1) -> the counts are OVERDISPERSED
# relative to a Poisson, partly because they depend on site and host
# mass. A plain Poisson may understate uncertainty; negative binomial or
# a model with those predictors is better (Part V).


# =====================================================================
# Module 5
# =====================================================================

## 5A.1 - CLT with skewed data
set.seed(2)
pop <- rpois(100000, 3)
means <- replicate(2000, mean(sample(pop, 40)))
print(ggplot(data.frame(means), aes(means)) +
        geom_histogram(bins = 30) + theme_minimal() +
        labs(title = "Sample means of Poisson(3), n=40"))
# Individual counts are right-skewed, but the MEANS are close to normal
# and centred near 3 - the Central Limit Theorem in action.

## 5B.1 - CI by hand vs t.test
x  <- morph$body_length_mm
n  <- length(x); se <- sd(x) / sqrt(n)
ci <- mean(x) + c(-1, 1) * qt(0.975, df = n - 1) * se
cat(sprintf("hand CI: [%.3f, %.3f]\n", ci[1], ci[2]))
print(t.test(x)$conf.int)      # matches to rounding (~[12.67, 13.10])

## 5B.2
# A 95% CI is about the PROCEDURE: across many repeated studies, 95% of
# such intervals would contain the fixed true mean. For this one
# interval the true mean is either in it or not - there is no 95%
# probability attached to this particular interval.


# =====================================================================
# Part II capstone - bootstrap CI for a median
# =====================================================================
set.seed(3)
x <- morph$mass_mg
boot <- replicate(2000, median(sample(x, replace = TRUE)))
ci <- quantile(boot, c(0.025, 0.975))
cat(sprintf("median mass = %.1f mg, 95%% bootstrap CI = [%.1f, %.1f]\n",
            median(x), ci[1], ci[2]))
# The median has no simple closed-form standard error, so we approximate
# its sampling distribution by resampling. The MEAN does have SE =
# sd/sqrt(n), so a t-based CI works directly for it.

# ---------------------------------------------------------------------
# Part II done: distributions model data and test statistics; the
# sampling distribution (and the CLT) is why a sample tells us about a
# population. Part III: hypothesis testing - t-tests, non-parametrics,
# and categorical data.
# ---------------------------------------------------------------------
