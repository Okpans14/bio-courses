# =====================================================================
# Statistics for Biologists — Part I Solutions
# Modules 1-3 · Data & Description
# =====================================================================

library(tidyverse)
data_dir <- if (dir.exists("data")) "data" else "../data"
morph <- read_csv(file.path(data_dir, "morphology.csv"))


# =====================================================================
# Module 1
# =====================================================================

## 1A.1 - variable types
# id            : identifier (not a statistical variable)
# site          : categorical, nominal (north/south)
# sex           : binary categorical (F/M)
# body_length_mm: continuous
# wing_length_mm: continuous
# mass_mg       : continuous
print(sapply(morph, class))

## 1A.2
# Independent replicates of TREATMENT = 3 (one tree per treatment), NOT
# 24. The 8 leaves within a tree are pseudoreplicates: they share that
# tree's genotype and environment, so they are not independent. Treating
# 24 leaves as independent inflates df and shrinks p-values wrongly.
# Fix: one value per tree (mean leaf area), or a mixed model with tree
# as a random effect (Part V).

## 1B.1
# (a) response = body_length_mm ; explanatory = sex
# (b) response = wing_length_mm ; explanatory = body_length_mm
# (c) response = infected       ; explanatory = dose_mg, age_months


# =====================================================================
# Module 2
# =====================================================================

## 2A.1
with(morph, cat(sprintf(
  "mass: mean=%.1f median=%.1f sd=%.1f IQR=%.1f\n",
  mean(mass_mg), median(mass_mg), sd(mass_mg), IQR(mass_mg))))
# mean and median are close -> mass is roughly symmetric, not strongly skewed.

## 2B.1 - SD vs SE vs CI
x  <- morph$body_length_mm
n  <- length(x)
se <- sd(x) / sqrt(n)
ci <- mean(x) + c(-1, 1) * qt(0.975, df = n - 1) * se
cat(sprintf("n=%d  sd=%.3f  se=%.3f  95%% CI=[%.2f, %.2f]\n",
            n, sd(x), se, ci[1], ci[2]))
# ~ mean 12.88, sd 1.20, se 0.109, CI about [12.67, 13.10]

## 2B.2
# With 10x more data: SE shrinks by ~sqrt(10) and the CI width with it;
# the SD stays about the same (it describes biological spread, which
# does not change just because you measured more individuals).

## 2C.1 - grouped summary
morph |>
  group_by(sex) |>
  summarise(n = n(), mean = mean(body_length_mm),
            sd = sd(body_length_mm), se = sd / sqrt(n)) |>
  print()
# Females larger: mean ~13.21 vs males ~12.52, a difference of ~0.7 mm.
# (Whether that is "real" is a test question - Part III.)


# =====================================================================
# Module 3
# =====================================================================

## 3A.1
print(ggplot(morph, aes(mass_mg)) + geom_histogram(bins = 20) + theme_minimal())
print(ggplot(morph, aes(site, mass_mg)) + geom_boxplot() + theme_minimal())
# Mass looks approximately bell-shaped; south tends slightly heavier.

## 3B.1
print(
  ggplot(morph, aes(body_length_mm, wing_length_mm)) +
    geom_point() + geom_smooth(method = "lm") + theme_minimal()
)
print(
  ggplot(morph, aes(sample = body_length_mm)) +
    stat_qq() + stat_qq_line() + theme_minimal()
)
# wing rises linearly and tightly with body (a strong positive relation);
# body_length points fall close to the QQ line -> approximately normal.


# =====================================================================
# Part I capstone
# =====================================================================
## 1. grouped summary
summ <- morph |>
  group_by(sex, site) |>
  summarise(n = n(), mean = mean(body_length_mm),
            sd = sd(body_length_mm), se = sd / sqrt(n), .groups = "drop")
print(summ)

## 2. plot: boxplot + points, faceted by site
print(
  ggplot(morph, aes(sex, body_length_mm, fill = sex)) +
    geom_boxplot(alpha = 0.5, outlier.shape = NA) +
    geom_jitter(width = 0.15, alpha = 0.6) +
    facet_wrap(~ site) +
    labs(title = "Body length by sex and site",
         x = NULL, y = "body length (mm)") +
    theme_minimal()
)

## 3. interpretation
# Descriptively, females are a little larger than males, and southern
# beetles a little larger than northern ones, consistent across panels.
# CAUTION: these are sample differences with overlapping distributions;
# whether they reflect real population differences needs a formal test
# with its assumptions checked (Part III), not eyeballing the means.

# ---------------------------------------------------------------------
# Part I done: you can frame a question as response ~ predictors,
# describe data honestly (SD vs SE vs CI), and SEE it before testing.
# Part II: probability, sampling, and confidence intervals.
# ---------------------------------------------------------------------
