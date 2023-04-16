# GLM, General Linear Model

## GLMの構成要素
* 確率分布
* 線形予測子……説明変数の線形結合
* リンク関数

## GLMの種類
* 単回帰モデル  
リンク関数は恒等関数
$$
\begin{cases}
    g(\mu_{i}) = \beta_{0} + \beta_{1}x_{i}\\
    g(\mu) = \mu\\
    y_{i} = Normal(\mu_{i}, \sigma^2)
\end{cases}
$$


* 分散分析モデル  
説明変数として質的データをとり、確率分布に正規分布を用いるモデル

* 正規線形モデル
  1. 量的データや質的データを問わず、複数の説明変数を線形予測子に用いることができる
  2. 恒等関数がリンク関数である
  3. 正規分布を確率分布に用いる
$$
\begin{cases}
    g(\mu_{i}) = \beta_{0} + \beta_{1}x_{i1} + \beta_{2}x_{i2} + ...\\
    g(\mu) = \mu\\
    y_{i} = Normal(\mu_{i}, \sigma^2)
\end{cases}
$$
  
* ポアソン回帰モデル  
例: ある湖における魚の釣獲尾数のモデル化。湖で一時間釣りをしたときの釣獲尾数と、その日の気温と天気の関係性を表したい。釣獲尾数はポアソン分布に従い、ポアソン分布の強度$\lambda$が気温と天気によって変化すると想定する.  
  1. 量的データや質的データを問わず、複数の説明変数を線形予測子に用いることができる
  2. 対数関数がリンク関数である
  3. ポアソン分布を確率分布に用いる  

$$
\begin{cases}
    \log(\lambda_{i}) = \beta_{0} + \beta_{1}x_{i1}+\beta_{2}x_{i2} + ...\\
    y_{i} \sim Poiss(\lambda_{i})
\end{cases}\\
or
\begin{cases}
    \lambda_{i} = \beta_{0} + \beta_{1}x_{i1}+\beta_{2}x_{i2} + ...\\
    y_{i} \sim Poiss(\exp(\lambda_{i}))
\end{cases}
$$

* ロジスティック回帰モデル  
例:ある植物の種子の発芽のモデル化。植木鉢に10粒の種子をまき、そのうちの何粒が発芽したのかを調査した。発芽数は試行回数10の二項分布に従い、成功確率$p$が日照の有無と栄養素の量によって変化する。
  1. 量的データや質的データを問わず、複数の説明変数を線形予測子に用いることができる
  2. リンク関数がロジット関数である
  3. 二項分布を確率分布に用いる
$$
\begin{cases}
    logit(p_{i}) = \beta_{0} + \beta_{1}x_{i1} + \beta_{2}x_{i2} + ...\\
    y_{i} \sim Binom(10, p_{i})\\
    logit(p) = \log(\frac{p}{1-p})
\end{cases}\\
or
\begin{cases}
    p_{i} = \beta_{0} + \beta_{1}x_{i1} + \beta_{2}x_{i2} + ...\\
    y_{i} \sim Binom(10, logistic(p_{i}))\\
    logistic(x) = \frac{1}{1+\exp(-x)}
\end{cases}