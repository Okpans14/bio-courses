# =====================================================================
# Statistics for Biologists — Part III Solutions
# Modules 6-8 · Hypothesis Testing
# =====================================================================
library(tidyverse)
data_dir <- if (dir.exists("data")) "data" else "../data"
morph <- read_csv(file.path(data_dir, "morphology.csv"))
inf   <- read_csv(file.path(data_dir, "infection.csv"))


# =====================================================================
# Module 6
# =====================================================================

## 6A.1
# (a) FALSE - p is P(data | H0), not P(H0 | data).
# (b) FALSE - a large p means "not enough evidence against H0", not
#     proof of no effect (could be low power).
# (c) FALSE - p depends on effect size AND sample size AND noise; a tiny
#     effect can give a tiny p with large n.
# (d) FALSE - with n = 10,000, a statistically significant effect can be
#     biologically trivial; judge the effect size, not p.

## 6B.1 - power / sample size
print(power.t.test(delta = 0.7, sd = 1.2, power = 0.8))   # n/group ~ 47
print(power.t.test(delta = 0.3, sd = 1.2, power = 0.8))   # n/group ~ 253
# Halving-and-more the effect (0.7 -> 0.3) multiplies the required n
# roughly 5x: detecting small effects is expensive. Plan n accordingly.


# =====================================================================
# Module 7
# =====================================================================

## 7A.1 - two-sample (Welch) t-test by sex
print(t.test(body_length_mm ~ sex, data = morph))
# Females were ~0.69 mm longer than males (meanF 13.21 vs meanM 12.52),
# 95% CI for the difference roughly [0.28, 1.10], Welch t = 3.28,
# df ~ 117, p = 0.0014. Females are larger.

## 7A.2 - check assumptions
print(ggplot(morph, aes(sex, body_length_mm)) + geom_boxplot() + theme_minimal())
print(ggplot(morph, aes(sample = body_length_mm)) +
        stat_qq() + stat_qq_line() + facet_wrap(~ sex) + theme_minimal())
# Both groups look roughly normal with similar spread and no wild
# outliers; with n ~60 per group the t-test is well justified.

## 7B.1 - one-sample
print(t.test(morph$body_length_mm, mu = 13))
# Mean ~12.88; the test of mu = 13 is borderline/non-significant - the
# data are consistent with a mean near 13.

## 7C.1 - non-parametric comparison
print(wilcox.test(body_length_mm ~ sex, data = morph))   # p ~ 0.0014
# The Mann-Whitney p (~0.0014) agrees closely with the t-test. Prefer
# wilcox if the data were badly skewed or had strong outliers at small n;
# prefer the t-test here (data ~normal) - it is more powerful and gives
# an interpretable mean difference with a CI.


# =====================================================================
# Module 8
# =====================================================================

## 8A.1 - chi-square on dose group x infected
inf <- inf |> mutate(dose_grp = ifelse(dose_mg > 5, "high", "low"))
tab <- table(inf$dose_grp, inf$infected)
print(chisq.test(tab))
# chi-square ~ 40.0, df = 1, p < 0.001: infection is strongly associated
# with dose group - high-dose hosts are infected far more often.

## 8A.2 - age group x infected
inf <- inf |> mutate(age_grp = ifelse(age_months > 6, "old", "young"))
print(chisq.test(table(inf$age_grp, inf$infected)))
# chi-square ~ 5.84, df = 1, p ~ 0.016: older hosts are infected more
# often than younger ones - a weaker but detectable association.


# =====================================================================
# Part III capstone - body length by site, done well
# =====================================================================
## 1. describe
morph |>
  group_by(site) |>
  summarise(n = n(), mean = mean(body_length_mm), sd = sd(body_length_mm)) |>
  print()
# north: n57 mean 12.66 sd 1.26 ; south: n63 mean 13.09 sd 1.11

## 2. visualise
print(
  ggplot(morph, aes(site, body_length_mm, fill = site)) +
    geom_boxplot(alpha = 0.5, outlier.shape = NA) +
    geom_jitter(width = 0.15, alpha = 0.6) +
    labs(x = NULL, y = "body length (mm)") + theme_minimal()
)

## 3. check assumptions
print(ggplot(morph, aes(sample = body_length_mm)) +
        stat_qq() + stat_qq_line() + facet_wrap(~ site) + theme_minimal())

## 4. test
print(t.test(body_length_mm ~ site, data = morph))
# Southern beetles were ~0.43 mm longer than northern ones
# (13.09 vs 12.66), 95% CI roughly [0.003, 0.86], Welch t = -1.99,
# p = 0.049.

## 5. interpretation
# The difference is just statistically detectable (p ~ 0.05), but the CI
# runs from essentially zero to ~0.9 mm - so while there may be a real
# site difference, the data cannot rule out a biologically trivial one.
# This is exactly why the effect size and CI matter more than "p < 0.05".

# ---------------------------------------------------------------------
# Part III done. Every test here is a linear model in disguise - which
# is the subject of Part IV: correlation, regression, and ANOVA.
# ---------------------------------------------------------------------
