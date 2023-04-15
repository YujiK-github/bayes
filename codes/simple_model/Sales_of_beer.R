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

df <- read.csv("G:/マイドライブ/bayes/data/book-r-stan-bayesian-model-intro-master/book-data/2-4-1-beer-sales-1.csv")
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