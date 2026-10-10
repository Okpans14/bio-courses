# =====================================================================
# Statistics for Biologists — Part V Solutions
# Modules 12-14 · Generalised & Mixed Models
# =====================================================================
library(tidyverse)
data_dir <- if (dir.exists("data")) "data" else "../data"
inf <- read_csv(file.path(data_dir, "infection.csv"))
par  <- read_csv(file.path(data_dir, "parasite_counts.csv"))
tad  <- read_csv(file.path(data_dir, "tadpole_repeated.csv"))


# =====================================================================
# Module 12
# =====================================================================

## 12A.1 - logistic: odds ratios and a prediction
m <- glm(infected ~ dose_mg + age_months, family = binomial, data = inf)
print(exp(cbind(OR = coef(m), confint(m))))
# dose_mg OR ~ 1.61: each extra mg of dose multiplies the ODDS of
# infection by ~1.6 (a ~60% increase per mg), holding age constant.
# age OR ~ 1.13: older hosts have somewhat higher odds too.
print(predict(m, newdata = data.frame(dose_mg = 6, age_months = 5),
              type = "response"))      # ~0.66 probability of infection

## 12B.1 - Poisson + overdispersion check
mp <- glm(parasite_count ~ site + host_mass_g, family = poisson, data = par)
print(exp(coef(mp)))                   # rate ratios
cat("dispersion:", deviance(mp) / df.residual(mp), "\n")   # ~1.04
# site(wet) rate ratio ~1.8: wet-site hosts carry ~80% more parasites at
# a given mass. Dispersion ~1.04 is close to 1 -> NOT overdispersed once
# site and mass are in the model. (The raw counts looked overdispersed
# marginally, but the predictors EXPLAIN that extra variation.) So a
# plain Poisson is adequate here; NB would give very similar estimates.
# For completeness:
# MASS::glm.nb(parasite_count ~ site + host_mass_g, data = par)


# =====================================================================
# Module 13
# =====================================================================

library(lme4)

## 13A.1
# Tank is RANDOM: the 12 tanks are a sample representing many possible
# tanks; we care that they add variation, not about each tank's value.
# Treatment is FIXED: control vs warming are the specific conditions we
# chose and want to estimate. Ignoring tank (plain lm) treats 5 tadpoles
# per tank as 5 independent replicates of the treatment, but they share
# their tank's water and history - pseudoreplication - so the treatment
# would be tested against 60 fake replicates instead of 12 real ones.

## 13A.2 - p-values via lmerTest
library(lmerTest)
m <- lmer(mass_g ~ treatment * day + (1 | tank), data = tad)
print(anova(m))
# day is strongly significant (tadpoles grow); the treatment:day
# interaction tests whether the GROWTH RATE differs between warming and
# control - inspect its p-value in the anova table to conclude.

## 13B.1 - the naive model understates uncertainty
m_mixed <- lmer(mass_g ~ treatment * day + (1 | tank), data = tad)
m_naive <- lm(mass_g ~ treatment * day, data = tad)
print(summary(m_naive)$coefficients)
print(summary(m_mixed)$coefficients)
# The naive lm gives SMALLER standard errors (and smaller p-values) for
# the treatment terms, because it wrongly counts tadpoles as independent.
# The mixed model is more conservative and HONEST: it tests the
# treatment against tank-level replication, which is the real design.


# =====================================================================
# Part V capstone - choose and check a count model
# =====================================================================
## 1. three models
m_pois  <- glm(parasite_count ~ site + host_mass_g, family = poisson, data = par)
m_quasi <- glm(parasite_count ~ site + host_mass_g, family = quasipoisson, data = par)
m_nb    <- MASS::glm.nb(parasite_count ~ site + host_mass_g, data = par)

## 2. overdispersion
cat("Poisson dispersion:", deviance(m_pois) / df.residual(m_pois), "\n")  # ~1.04

## 3. compare
cat("AIC Poisson:", AIC(m_pois), " AIC NB:", AIC(m_nb), "\n")
print(summary(m_quasi)$coefficients)   # SEs almost identical to Poisson

## 4. choice
# Dispersion is ~1, so there is no overdispersion to correct once site
# and host mass are included. Poisson is the right, simplest model;
# quasi-Poisson and NB give essentially the same estimates and SEs, which
# confirms the Poisson is adequate rather than optimistic.

## 5. effect size
print(exp(cbind(rate_ratio = coef(m_pois), confint(m_pois))))
# site(wet) rate ratio ~1.8 (CI roughly [1.54, 2.11]): wet-site hosts
# carry about 80% more parasites than dry-site hosts of the same mass.

# ---------------------------------------------------------------------
# Part V done: GLMs for non-normal responses, mixed models for grouped
# data, and the discipline of comparing and checking models. Part VI:
# multivariate methods and reproducible statistical practice.
# ---------------------------------------------------------------------
