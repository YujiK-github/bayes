library("rstan")
install.packages("brms")
library("brms")

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# load data
df <- read.csv("data/book-r-stan-bayesian-model-intro-master/book-data/3-8-1-fish-num-1.csv")
head(df)

summary(df)

ggplot(data = df, mapping = aes(x = temperature, y = fish_num)) +
    geom_point(aes(color = weather)) +
    labs(title = "釣獲尾数と気温・天気の関係")

# brmsによるポアソン回帰モデルの推定
glm_pois_brms <- brm(
    formula = fish_num ~ weather + temperature,
    family = gaussian(),
    data = df,
    seed = 1,
    prior = c(set_prior("", class = "Intercept"))
)

glm_pois_brms

# 解釈
# weatherの点推定量が-0.59のとき、「天気が晴れになると、釣獲尾数はexp(-0.59)になると解釈される」

# 95％ベイズ信用区間付きのグラフ
#eff <- marginal_effects(glm_pois_brms, effects = "temperature::weather")

# 分からない
#eff <- conditional_effects(
#    glm_pois_brms,
#    effects = "temperature::weather",
#    conditions = list(weather = c("sunny", "cloudy")))
# Error: To display interactions of order higher than 2 please use the 'conditions' argument.?
#plot(eff, points = TRUE)

set.seed(1)
# 分からない
#eff_pre <- conditional_effects(
#    glm_pois_brms,
#    method = "predict",
#    effects = "temperature::weather")
#plot(eff_pre, points = FALSE)
