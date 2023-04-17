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
