# =====================================================================
# Statistics for Biologists — Part IV Exercises
# Modules 9-11 · Relationships & Linear Models
# =====================================================================
library(tidyverse)
data_dir <- if (dir.exists("data")) "data" else "../data"
morph <- read_csv(file.path(data_dir, "morphology.csv"))
plant <- read_csv(file.path(data_dir, "plant_growth.csv"))


# =====================================================================
# Module 9 - correlation
# =====================================================================

## 9A. Pearson ----------------------------------------------------------
### Worked example
print(cor.test(morph$body_length_mm, morph$wing_length_mm))

### 9A.1 (easy)
# Scatterplot wing vs body length (add geom_smooth(method="lm")), then
# report Pearson's r and its 95% CI from cor.test(). Describe the
# relationship in one sentence.
# your code here


## 9B. Spearman & cautions ----------------------------------------------
### 9B.1 (harder)
# Compute Spearman's rho for body vs wing. Does it differ much from
# Pearson's r? What would it take for them to disagree strongly?
# your code here + comment


### 9B.2 (concept)
# "Body length and wing length are correlated, so longer bodies CAUSE
# longer wings." What is wrong with this statement? One line.
# your answer here


# =====================================================================
# Module 10 - linear regression
# =====================================================================

## 10A. Simple regression -----------------------------------------------
### Worked example
m <- lm(wing_length_mm ~ body_length_mm, data = morph)
summary(m)

### 10A.1 (harder)
# From model m: report the slope and its interpretation (mm wing per mm
# body), the R^2, and the 95% CI for the slope (confint). Predict wing
# length for a 13 mm beetle (predict()).
# your code here


### 10A.2 (checking the model)
# Produce the four diagnostic plots: par(mfrow=c(2,2)); plot(m).
# Comment on linearity, constant variance, and residual normality.
# your code here


## 10B. Multiple regression ---------------------------------------------
### 10B.1 (harder)
# Fit mass_mg ~ body_length_mm + sex. Interpret BOTH coefficients:
# the effect of body length (holding sex constant) and the sex
# difference (holding body length constant).
# your code here


## 10C. Interactions ----------------------------------------------------
### 10C.1 (challenge)
# Fit mass_mg ~ body_length_mm * sex. Is the interaction significant,
# i.e. does the body->mass slope differ between sexes? Plot the data
# coloured by sex with separate lm lines to see it.
# your code here


# =====================================================================
# Module 11 - ANOVA
# =====================================================================

## 11A. One-way ANOVA ---------------------------------------------------
### Worked example
summary(aov(height_cm ~ treatment, data = plant))

### 11A.1 (harder)
# Fit height_cm ~ treatment as a LINEAR MODEL and get the ANOVA table
# with anova(). Is treatment significant? Report F and p. Then run
# TukeyHSD to find WHICH treatment pairs differ.
# your code here


## 11B. Two-way ANOVA ---------------------------------------------------
### 11B.1 (challenge)
# Fit height_cm ~ treatment * genotype and get anova(). For each term
# (treatment, genotype, interaction) state whether it is significant
# and what it means. Make an interaction plot to interpret.
# your code here


# =====================================================================
# Part IV capstone - a full regression analysis
# =====================================================================
# Model mass_mg as a function of body_length_mm, sex, and site:
#   1. plot the data sensibly first,
#   2. fit mass_mg ~ body_length_mm + sex + site,
#   3. check the residual diagnostics (plot(model)),
#   4. report each coefficient with its interpretation and 95% CI,
#   5. one paragraph: what predicts mass, how well (R^2), and any
#      assumption you would flag.
# your code here
