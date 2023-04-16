library("rstan")

# 計算の高速化
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

## ビールの売り上げのモデル化
# ref: RとStanではじめるベイズ統計モデリングによるデータ分析入門(馬場)
# ビールの売り上げを記録したデータが100個あり、売り上げデータが正規分布に従うと仮定してモデル化を行う。
# ビールの売り上げの平均値を$\mu$とし、売り上げのばらつきを$\sigma^2$とすると
# 売り上げが$sales$万円である確率密度は以下のように表される。
# $sales \sim Normal(\mu, \sigma^2)$

df <- read.csv("G:/マイドライブ/bayes/data/book-r-stan-bayesian-model-intro-master/book-data/2-4-1-beer-sales-1.csv") # nolint
head(df)

sample_size <- nrow(df)

data_list <- list(sales = df$sales, N = sample_size)

# MCMCを実行する
mcmc_result <- stan(
    file = "G:/マイドライブ/bayes/codes/simple_model/Sales_of_beer.stan",
    data = data_list,
    seed = 1,
    chains = 4,
    iter = 2000,
    warmup = 1000,
    thin = 1            # 間引き数(1なら間引き無し)
)

# 推定結果を確認する
print(
    mcmc_result,
    probs = c(0.05, 0.95, 0.975)
    )

# 収束の確認
## バーンイン期間なし
traceplot(mcmc_result)
## バーンイン期間あり# バーンイン期間なし
traceplot(mcmc_result, inc_warmup = TRUE)


# MCMCの代表値の計算方法
mcmc_sample <- rstan::extract(mcmc_result, permuted = FALSE) # permuted: 並び替え
mu_mcmc_vec <- as.vector(mcmc_sample[, , "mu"]) # ex)[1, "chain:1", "mu"]
## 事後中央値
median(mcmc_sample)
## 事後期待値
mean(mcmc_sample)
## 95%ベイズ信用区間
quantile(mcmc_sample, probs = c(0.025, 0.975))


# MCMCサンプルを用いたtraceplotの描画
library("ggfortify")
autoplot(ts(mcmc_sample[, , "mu"]),
         facets = FALSE,     # 4つのchainをまとめて1つのグラフにする
         ylab = "mu",
         main = "Traceplot")


# ggplot2による事後分布の可視化
mu_df <- data.frame(
    mu_mcmc_sample = mu_mcmc_vec
)
ggplot(data = mu_df, mapping = aes(x = mu_mcmc_sample)) +
    geom_density(size = 1.5)

# bayesplotによる事後分布の可視化
install.packages("bayesplot")
library("bayesplot")
## ヒストグラム
mcmc_hist(mcmc_sample, pars = c("mu", "sigma"))
## カーネル密度関数
mcmc_dens(mcmc_sample, pars = c("mu", "sigma"))
## トレースプロット
mcmc_trace(mcmc_sample, pars = c("mu", "sigma"))
## 事後分布とトレースプロットをまとめて表示
mcmc_combo(mcmc_sample, pars = c("mu", "sigma"))


# bayesplotによる事後分布の範囲の比較
mcmc_interval(
    mcmc_sample,
    pars = c("mu", "sigma"),
    prob = 0.8,
    prob_outer = 0.95
)
##密度もあわせると
mcmc_areas(
    mcmc_sample,
    pars = c("mu", "sigma"),
    prob = 0.8,
    prob_outer = 0.99
)


# bayesplotによるMCMCサンプルの自己相関の評価
mcmc_acf_bar(mcmc_sample, pars = c("mu", "sigma"))


# MCMCを実行する
mcmc_result <- stan(
    file = "G:/マイドライブ/bayes/codes/simple_model/Sales_of_beer_pred.stan",
    data = data_list,
    seed = 1,
    chains = 4,
    iter = 2000,
    warmup = 1000,
    thin = 1            # 間引き数(1なら間引き無し)
)

# bayesplotによる事後予測チェック
y_pred <- rstan::extract(mcmc_pred)$pred
ppc_hist(y = df$sales,
         y_rep = y_pred)