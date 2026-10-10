# =====================================================================
# Statistics for Biologists — Part V Exercises
# Modules 12-14 · Generalised & Mixed Models
# =====================================================================
# Packages: install.packages(c("lme4","lmerTest","MASS"))
# Uses infection.csv, parasite_counts.csv, tadpole_repeated.csv
# =====================================================================
library(tidyverse)
data_dir <- if (dir.exists("data")) "data" else "../data"
inf <- read_csv(file.path(data_dir, "infection.csv"))
par  <- read_csv(file.path(data_dir, "parasite_counts.csv"))
tad  <- read_csv(file.path(data_dir, "tadpole_repeated.csv"))


# =====================================================================
# Module 12 - generalised linear models
# =====================================================================

## 12A. Logistic regression ---------------------------------------------
### Worked example
m <- glm(infected ~ dose_mg + age_months, family = binomial, data = inf)
summary(m)

### 12A.1 (harder)
# From model m: report the ODDS RATIOS (exp(coef)) and their CIs
# (exp(confint)) for dose_mg and age_months. Interpret the dose odds
# ratio in a sentence. Then predict the infection PROBABILITY for a host
# with dose_mg = 6, age_months = 5 (predict(..., type="response")).
# your code here


## 12B. Poisson regression & overdispersion -----------------------------
### 12B.1 (harder)
# Fit parasite_count ~ site + host_mass_g with family = poisson.
# Report the RATE RATIOS (exp(coef)). Then CHECK OVERDISPERSION:
# deviance(m)/df.residual(m). Is it near 1? If >1, refit with
# MASS::glm.nb() and compare the standard errors.
# your code here


# =====================================================================
# Module 13 - mixed-effects models
# =====================================================================

## 13A. A random-intercept model ----------------------------------------
### Worked example
library(lme4)
m <- lmer(mass_g ~ treatment * day + (1 | tank), data = tad)
summary(m)

### 13A.1 (concept)
# The design: 5 tadpoles per tank, 12 tanks, tanks assigned to control
# or warming, measured on 4 days. Why is tank a RANDOM effect and
# treatment a FIXED effect? Why would ignoring tank (a plain lm) be
# pseudoreplication?
# your answer here (comment)


### 13A.2 (harder)
# Add lmerTest to get p-values: library(lmerTest), refit the same model,
# and read anova(m). Is the treatment x day interaction significant,
# i.e. does the growth RATE differ between control and warming?
# your code here


## 13B. Comparing to the naive model ------------------------------------
### 13B.1 (challenge)
# Fit the WRONG model that ignores tank: lm(mass_g ~ treatment * day).
# Compare the treatment:day effect's standard error / p-value to the
# mixed model's. Which is more conservative, and why is it the honest
# one?
# your code here + comment


# =====================================================================
# Part V capstone - choose and check a count model
# =====================================================================
# For parasite_count ~ site + host_mass_g:
#   1. fit THREE models: Poisson, quasi-Poisson, and negative binomial
#      (MASS::glm.nb),
#   2. check overdispersion in the Poisson fit,
#   3. compare the models (AIC where defined; compare SEs/p-values),
#   4. choose one and justify it in two sentences,
#   5. report the site rate ratio with its interpretation and CI from
#      your chosen model.
# your code here
