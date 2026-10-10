# =====================================================================
# Statistics for Biologists — Part IV Solutions
# Modules 9-11 · Relationships & Linear Models
# =====================================================================
library(tidyverse)
data_dir <- if (dir.exists("data")) "data" else "../data"
morph <- read_csv(file.path(data_dir, "morphology.csv"))
plant <- read_csv(file.path(data_dir, "plant_growth.csv"))


# =====================================================================
# Module 9
# =====================================================================

## 9A.1 - Pearson + plot
print(
  ggplot(morph, aes(body_length_mm, wing_length_mm)) +
    geom_point() + geom_smooth(method = "lm") + theme_minimal()
)
print(cor.test(morph$body_length_mm, morph$wing_length_mm))
# r ~ 0.83, 95% CI about [0.77, 0.88], p < 2e-16: a strong, positive,
# linear relationship - larger bodies have longer wings.

## 9B.1 - Spearman
cat("Spearman rho:",
    cor(morph$body_length_mm, morph$wing_length_mm, method = "spearman"), "\n")
# ~0.84, essentially the same as Pearson - expected when the relationship
# is linear with no strong outliers. They diverge when the relation is
# monotonic-but-curved, or when outliers distort Pearson.

## 9B.2
# Correlation is not causation: both traits could be driven by a third
# factor (overall body size, age, nutrition). An association alone does
# not establish that body length causes wing length.


# =====================================================================
# Module 10
# =====================================================================

## 10A.1 - interpret the regression
m <- lm(wing_length_mm ~ body_length_mm, data = morph)
print(summary(m)); print(confint(m))
# Slope ~0.52: each extra mm of body length adds ~0.52 mm of wing
# (95% CI roughly [0.46, 0.57]). R^2 ~0.70: body length explains ~70%
# of wing-length variance.
print(predict(m, newdata = data.frame(body_length_mm = 13)))   # ~8.4 mm

## 10A.2 - diagnostics
op <- par(mfrow = c(2, 2)); plot(m); par(op)
# Residuals vs Fitted flat (linear ok), Q-Q close to the line (normal
# residuals), Scale-Location flat (constant variance), no high-leverage
# outliers - assumptions look well met.

## 10B.1 - multiple regression
m2 <- lm(mass_mg ~ body_length_mm + sex, data = morph)
print(summary(m2))
# body_length_mm ~20.1: at a FIXED sex, each mm of body adds ~20 mg mass.
# sexM ~ -10.9: at a FIXED body length, males are ~11 mg lighter than
# females. R^2 ~0.83.

## 10C.1 - interaction
m3 <- lm(mass_mg ~ body_length_mm * sex, data = morph)
print(summary(m3))
# The body:sex interaction is borderline (p ~ 0.05): weak evidence that
# the body->mass slope differs by sex. Visualise:
print(
  ggplot(morph, aes(body_length_mm, mass_mg, colour = sex)) +
    geom_point() + geom_smooth(method = "lm", se = FALSE) + theme_minimal()
)


# =====================================================================
# Module 11
# =====================================================================

## 11A.1 - one-way ANOVA + Tukey
m <- lm(height_cm ~ treatment, data = plant)
print(anova(m))                 # treatment F ~66, p < 0.001
print(TukeyHSD(aov(height_cm ~ treatment, data = plant)))
# Treatment strongly affects height. Tukey: high > low > control, all
# pairwise differences significant (adjusted p small).

## 11B.1 - two-way ANOVA
m2 <- lm(height_cm ~ treatment * genotype, data = plant)
print(anova(m2))
# treatment: F ~66, p < 0.001  -> fertiliser level matters a lot.
# genotype : F ~6.6, p ~0.012  -> mutant differs from wild overall.
# interaction: F ~2.1, p ~0.13 -> NOT significant: the fertiliser effect
#   is similar in both genotypes.
print(with(plant, interaction.plot(treatment, genotype, height_cm)))


# =====================================================================
# Part IV capstone - mass ~ body + sex + site
# =====================================================================
## 1-2. plot + fit
print(
  ggplot(morph, aes(body_length_mm, mass_mg, colour = sex)) +
    geom_point() + facet_wrap(~ site) + geom_smooth(method = "lm", se = FALSE) +
    theme_minimal()
)
mod <- lm(mass_mg ~ body_length_mm + sex + site, data = morph)
print(summary(mod)); print(confint(mod))

## 3. diagnostics
op <- par(mfrow = c(2, 2)); plot(mod); par(op)

## 4-5. interpretation
# body_length_mm ~19.8 mg/mm (95% CI ~[17.8, 21.7]) - the dominant
# predictor of mass. sexM ~ -11.8 mg (CI ~[-16.4, -7.1]): males lighter
# at a given length. site(south) ~ +3.1 mg but its CI (~[-1.5, 7.6])
# spans zero - no clear site effect once length and sex are accounted
# for. R^2 ~0.83: the model explains most of the variation in mass.
# Residual plots look acceptable; the only thing to watch is the weak
# body x sex interaction seen in Module 10, omitted here for simplicity.

# ---------------------------------------------------------------------
# Part IV done: one framework - the linear model - behind regression,
# t-tests, and ANOVA. Part V generalises it: GLMs for non-normal
# responses, mixed models for grouped data.
# ---------------------------------------------------------------------
