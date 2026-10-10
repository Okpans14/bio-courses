# =====================================================================
# Statistics for Biologists — Part III Exercises
# Modules 6-8 · Hypothesis Testing
# =====================================================================
library(tidyverse)
data_dir <- if (dir.exists("data")) "data" else "../data"
morph <- read_csv(file.path(data_dir, "morphology.csv"))
inf   <- read_csv(file.path(data_dir, "infection.csv"))


# =====================================================================
# Module 6 - the logic of testing
# =====================================================================

## 6A. Interpreting p-values --------------------------------------------
### 6A.1 (concept) - TRUE or FALSE, with a one-line reason each:
#  (a) "p = 0.03 means there is a 3% chance the null is true."
#  (b) "p = 0.30 proves there is no effect."
#  (c) "A smaller p-value means a larger effect."
#  (d) "p = 0.001 with n = 10,000 guarantees the effect is important."
# your answers here (comments)


## 6B. Power ------------------------------------------------------------
### 6B.1 (harder)
# Use power.t.test() to find the n PER GROUP needed to detect a 0.7 mm
# difference in body length, assuming sd = 1.2 and 80% power at
# alpha = 0.05. Then repeat for a 0.3 mm difference. What happens to the
# required n as the effect gets smaller?
# your code here


# =====================================================================
# Module 7 - comparing groups
# =====================================================================

## 7A. Two-sample t-test ------------------------------------------------
### Worked example
t.test(body_length_mm ~ sex, data = morph)

### 7A.1 (harder)
# Test whether body_length_mm differs by sex. Report, in a sentence:
# the mean difference, its 95% CI, and the p-value. Which sex is larger?
# (Read these off the t.test output.)
# your code here + sentence


### 7A.2 (checking assumptions)
# Before trusting the test, check it: make a boxplot of body_length_mm
# by sex and a QQ plot per sex (hint: facet_wrap(~ sex) with stat_qq).
# Comment on whether the t-test assumptions look satisfied.
# your code here


## 7B. One-sample -------------------------------------------------------
### 7B.1 (easy)
# Test whether the mean body_length_mm differs from 13 mm
# (one-sample t-test, mu = 13). What do you conclude?
# your code here


## 7C. Non-parametric ---------------------------------------------------
### 7C.1 (harder)
# Run a Mann-Whitney (wilcox.test) for body_length_mm by sex. Compare
# its p-value to the t-test. Do they agree? When would you PREFER the
# wilcox test here, and when the t-test?
# your code here + comment


# =====================================================================
# Module 8 - categorical data
# =====================================================================

## 8A. Contingency tables & chi-square ----------------------------------
### Worked example
inf <- inf |> mutate(dose_grp = ifelse(dose_mg > 5, "high", "low"))
tab <- table(inf$dose_grp, inf$infected)
print(tab)

### 8A.1 (harder)
# Run a chi-square test on `tab`. Is infection associated with dose
# group? State the chi-square statistic and p-value, and what it means
# biologically.
# your code here


### 8A.2 (easy)
# Make an age group (age_months > 6 -> "old" else "young") and build a
# 2x2 table of age_grp vs infected. Run chisq.test(). Is age associated
# with infection?
# your code here


# =====================================================================
# Part III capstone - a complete two-group comparison, done well
# =====================================================================
# For body_length_mm by SITE (north vs south):
#   1. describe: n, mean, sd per site (a grouped summary),
#   2. visualise: boxplot + jittered points,
#   3. check assumptions (QQ per site),
#   4. test: Welch t-test, and report the effect size (mean difference),
#      its 95% CI, and the p-value in ONE proper sentence,
#   5. one line: is the difference statistically detectable, and does
#      the CI suggest it is biologically large or small?
# your code here
