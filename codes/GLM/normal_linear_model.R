# 正規線形モデル
library("rstan")
library("brms")

rstan_options(auto_write = TRUE)
options(mc.core = parallel::detectCores())

# read csv
df <- read_csv("G:/マイドライブ/bayes/data/book-r-stan-bayesian-model-intro-master/book-data/3-7-1-beer-sales-4.csv")
head(df)

summary(df)

# plot
ggplot(data = df, mapping = aes(x = temperature, y = sales)) +
    geom_point(aes(color = weather)) +
    labs(title = "ビールの売り上げと気温・天気の関係")

# モデルの推定
lm_brms <- brm(
    formula = sales ~ weather + temperature,
    family = gaussian(),
    data = df,
    seed = 1,
    prior = c(set_prior("", class = "Intercept"),
              set_prior("", class = "sigma"))
)
lm_brms

# 回帰直線
eff <- marginal_effects(lm_brms, effects = "temperature:weather")
plot(eff, points = TRUE)


# デザイン行列
formula_lm <- formula(sales ~ weather + temperature)
design_mat <- model.matrix(formula_lm, df)
design_mat