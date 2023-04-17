library("rstan")
library("bayesplot")

# 計算の高速化
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# データの読み込み
df <- read.csv("G:/マイドライブ/bayes/data/book-r-stan-bayesian-model-intro-master/book-data/3-2-1-beer-sales-2.csv") # nolint
head(df)

sample_size <- nrow(df)
sample_size

# モデルの構造
# \mu_{i} = \beta_{0} + \beta_{1}x_{i}
# y_{i} \sim Normal(\mu_{i}, \sigma^2)
#                 or
# sales_{i} \sim Normal(Intercept+\beta*temperature_{i}, \sigma^2)

# ================================================
#  Stanを利用する場合
# ================================================

# MCMCの実行
data_list <- list(
    N = sample_size,
    sales = df$sales,
    temperature = df$temperature
)

mcmc_result <- stan(
    file = "G:/マイドライブ/bayes/codes/GLM/simple_linear_model.stan",
    data = data_list,
    seed = 1
)

print(mcmc_result, probs = c(0.025, 0.5, 0.975))

mcmc_sample <- rstan::extract(mcmc_result, permuted = FALSE)

mcmc_combo(
    mcmc_sample,
    pars = c("Intercept", "beta", "sigma")
)

# 予測
temperature_pred <- 11:30
temperature_pred

data_list_pred <- list(
    N = sample_size,
    sales = df$sales,
    temperature = df$temperature,
    N_pred = length(temperature_pred),
    temperature_pred = temperature_pred
)

mcmc_result_pred <- stan(
    file = "G:/マイドライブ/bayes/codes/GLM/simple_linear_model_pred.stan",
    data = data_list_pred,
    seed = 1
)

print(mcmc_result_pred)

# 予測分布の可視化
mcmc_sample_pred <- rstan::extract(mcmc_result_pred, permuted = FALSE)

mcmc_intervals(
    mcmc_sample_pred,
    regex_pars = c("sales_pred."), #"正規表現"
    prob = 0.8,
    prob_outer = 0.95
)

mcmc_intervals(
    mcmc_sample_pred,
    pars = c("mu_pred[1]", "sales_pred[1]"),
    prob = 0.8,
    prob_outer = 0.96
)

## 予測分布の表示
mcmc_areas(
    mcmc_sample_pred,
    pars = c("sales_pred[1]", "sales_pred[20]"),
    prob = 0.6,
    prob_outer = 0.99
)

# ================================================
#  Stanとデザイン行列を利用する場合
# ================================================
formula_lm <- formula(sales ~ temperature)
X <- model.matrix(formula_lm, df)

# MCMCの実行
N <- nrow(df)
K <- 2          # 説明変数の数 + 1

Y <- df$pred
data_list_design <- list(N = N, K = K, Y = Y, X = X)

mcmc_result_design <- stan(
    file = "G:/マイドライブ/bayes/codes/GLM/simple_linear_model_design.stan",
    data = data_list_design,
    seed = 1
)

# ================================================
#  brmsを利用する場合
# ================================================
library("brms")

# 推定
simple_lm_brms <- brm(
    formula = sales ~ temperature,
    family = gaussian(link = "identity"), # 確率分布とリンク関数
    data = df,
    seed = 1,
    chains = 4,
    iter = 2000,
    warmup = 1000,
    thin = 1
)

print(simple_lm_brms)

# MCMCサンプルの取得
as.mcmc(simple_lm_brms, combine_chains = TRUE)

# 事後分布の図示
plot(simple_lm_brms)

# 事前分布の変更
## 事前分布の表示
prior_summary(simple_lm_brms)

## 事前分布を無情報事前分布にする
simple_lm_brms_ <- brms(
    formula = sales ~ temperature,
    family = gaussian(),
    data = df,
    seed = 1,
    prior = c(set_prior("", class = "Intercept"),   # ""はstanのデフォルトの幅広い一様分布
              set_prior("", class = "sigma"))
)

## モデルの推定前に事前分布を確認する
get_prior(
    formula = sales ~ temperature,
    family = gaussian(),
    data = df
)

# stanコードの抽出
stancode(simple_lm_brms_)

# stanに渡すデータの抽出
get_stancode(simple_lm_brms_)

# brmsによる事後分布の可視化
stanplot(
    simple_lm_brms,
    type = "intervals",
    pars = "^b_",
    prob = 0.8,
    prob_outer = 0.95)

# brmsによる予測
new_data <- data.frame(temperature = 20)

## 回帰直線(ここでは気温によって変化するビールの売り上げの平均値)の信用区間付きの予測
fitted(simple_lm_brms, new_data)

## 予測期間付きの予測値
set_seed(1)
predict(simple_lm_brms, new_data)

# 回帰曲線の図示
## 回帰直線の95%ベイズ信用区間付きのグラフ
eff <- marginal_effects(simple_lm_brms)
plot(eff, points = TRUE)

## 95%予測区間付きのグラフ
set_seed(1)
eff_pre <- marginal_effects(simple_lm_brms, method = "predict")
plot(eff_pre, points = TRUE)

## 複数の説明変数があるときに特定の要素だけを切り出す
marginal_effects(simple_lm_brms, effects = "temperature")