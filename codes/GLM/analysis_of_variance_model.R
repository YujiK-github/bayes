# 分散分析モデル
library("rstan")
library("brms")

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# read_data
df <- read_csv("G:/マイドライブ/bayes/data/book-r-stan-bayesian-model-intro-master/book-data/3-6-1-beer-sales-3.csv")
head(df)

summary(df)

# データの可視化
ggplot(data = df, mapping = aes(x = weather, y = sales)) +
    geom_violin() + # バイオリンプロット
    geom_point(aes(color = weather)) +
    labs(titles = "ビールの売り上げ")


# brmsによるモデルの推定
anova_brms <- brm(
    formula = sales ~ weather,
    family = gaussian(),
    data = df,
    seed = 1,
    prior = c(set_prior("", class = "Intercept"),
              set_prior("", class = "sigma"))
)
anova_brms

# 推定された天気別の平均売り上げのグラフ
eff <- marginal_effects(anova_brms)
plot(eff, points = FALSE)


# 補足
## 分散分析モデルのデザイン行列
formula_anova <- formula(sales ~ weather)
design_mat <- model.matrix(formula_anova, df)

data_list <- list(
    N = nrow(df),
    K = 3,
    Y = df$sales,
    X = design_mat
)

anova_stan <- stan(
    file = "G:/マイドライブ/bayes/codes/GLM/simple_linear_model_design.stan",
    data = data_list,
    seed = 1
)