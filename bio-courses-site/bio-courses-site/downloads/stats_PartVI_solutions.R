# =====================================================================
# Statistics for Biologists — Part VI Solutions
# Modules 15-16 · Multivariate & Reproducible Statistics
# =====================================================================
library(tidyverse)
data_dir <- if (dir.exists("data")) "data" else "../data"
flow <- read_csv(file.path(data_dir, "flower_traits.csv"))
traits <- c("petal_length_cm","petal_width_cm","sepal_length_cm","sepal_width_cm")


# =====================================================================
# Module 15
# =====================================================================

## 15A.1 - PCA
pca <- prcomp(flow[, traits], scale. = TRUE)
print(summary(pca))
# (a) PC1 ~51% + PC2 ~36% = ~87% of variance in two axes.
scores <- as.data.frame(pca$x); scores$species <- flow$species
print(
  ggplot(scores, aes(PC1, PC2, colour = species)) +
    geom_point(size = 2) + theme_minimal() +
    labs(title = "Flower traits PCA")
)
# (b) species separate clearly along PC1 (and PC2).
print(round(pca$rotation[, 1:2], 2))
# (c) petal_length and petal_width load most strongly on PC1 - PC1 is
#     essentially an overall "flower size / petal" axis.

## 15A.2
# scale. = TRUE puts every trait on the same (unit-variance) footing.
# Without scaling, a variable with a larger numeric range (metres vs
# millimetres) would dominate the variance and hijack PC1 purely because
# of its units, not its biological importance.

## 15B.1 - clustering vs species
d  <- dist(scale(flow[, traits]))
hc <- hclust(d, method = "ward.D2")
plot(hc, labels = FALSE, main = "Flower traits dendrogram")
groups <- cutree(hc, k = 4)
print(table(cluster = groups, species = flow$species))
# The four clusters recover the species well - most species map cleanly
# to one cluster, with a little overlap between the most similar species.
# (Clustering found the groups; we VALIDATED them against known species.)


# =====================================================================
# Module 16
# =====================================================================

## 16A.1 - power
print(power.t.test(delta = 5, sd = 4, power = 0.8))   # n/group ~ 11
print(power.t.test(delta = 2, sd = 4, power = 0.8))   # n/group ~ 64
# Detecting the smaller (2 cm) effect needs ~6x the sample size.

## 16B.1 - multiple testing
p <- c(0.001, 0.008, 0.02, 0.03, 0.04, 0.21)
print(round(p.adjust(p, "bonferroni"), 3))  # 0.006 0.048 0.120 0.180 0.240 1.000
print(round(p.adjust(p, "BH"), 3))          # 0.006 0.024 0.040 0.045 0.048 0.210
# Bonferroni: only the first two stay < 0.05. BH: the first FIVE stay
# < 0.05. For a 20,000-gene screen use BH (FDR): Bonferroni is far too
# strict at that scale and would miss almost everything real; FDR
# controls the PROPORTION of false positives among discoveries, which is
# the sensible target for large screens.

## 16B.2
# Running 50 tests at alpha = 0.05 yields ~2-3 "significant" results by
# chance even if nothing is real; reporting only those manufactures false
# positives and inflates effect sizes. Pre-specifying the main hypothesis,
# analysis, and sample size BEFORE seeing the data (and labelling the
# rest exploratory) removes that freedom and keeps the error rate honest.


# =====================================================================
# Course capstone - a worked reproducible mini-analysis
# =====================================================================
# Question: does fertiliser treatment affect plant height, and does the
# effect depend on genotype?  (height_cm ~ treatment * genotype)
set.seed(42)
plant <- read_csv(file.path(data_dir, "plant_growth.csv"))

## describe + visualise (balanced design: 12 reps per treatment x genotype)
plant |> group_by(treatment, genotype) |>
  summarise(n = n(), mean = mean(height_cm), sd = sd(height_cm), .groups = "drop") |>
  print()
print(
  ggplot(plant, aes(treatment, height_cm, fill = genotype)) +
    geom_boxplot(alpha = 0.6) + theme_minimal() +
    labs(title = "Height by treatment and genotype")
)

## model: a linear model is appropriate (continuous response, balanced,
## independent plants - no grouping/pseudoreplication here)
mod <- lm(height_cm ~ treatment * genotype, data = plant)

## check assumptions
op <- par(mfrow = c(2, 2)); plot(mod); par(op)

## report effect sizes with CIs (not just p)
print(anova(mod))
print(confint(mod))
# Fertiliser raises height substantially: high vs control ~ +7.6 cm
# (treatment F ~66, p < 0.001); mutant is a little shorter overall
# (genotype p ~0.012); the treatment x genotype interaction is NOT
# significant (p ~0.13), so the fertiliser effect is similar in both
# genotypes. Residual plots look acceptable.

## reproducibility
sessionInfo()

# ---------------------------------------------------------------------
# Course complete. From study design to multivariate methods, done
# reproducibly and reported as effect sizes with uncertainty - the full
# arc of applied biostatistics in R.
# ---------------------------------------------------------------------
