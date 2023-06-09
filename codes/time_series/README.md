# Time Series
## 状態空間モデル(State Space Model: SSM)  
時点$t$での状態を$\alpha_{t}$、時点$t$での観測値を$y_{t}$としたとき、状態空間モデルは以下のように表される。ただし$f$と$g$は、条件付き確率密度関数(離散型の時は確率質量関数)。

$$
\begin{align}
    \alpha_{t} \sim f(\alpha_{t}|\alpha_{t-1})\\
    y_{t} \sim g(y_{t}|\alpha_{t})
\end{align}
$$

これは**一般化状態空間モデル**とよばれる。(1)式は状態の変化を表すので状態モデルあるいはシステムモデルとよぶ。(2)式は観測値から得られるプロセスを表すので観測モデルという。状態の変化を表す方程式は**状態方程式**、観測値のが得られるプロセスを表す方程式は**観測方程式**という。

## 状態空間モデルの種類
 * 動的線形モデル(線形ガウス状態空間モデル)(Dynamic Linear Model: DLM)  
  状態方程式、観測方程式ともに、確率密度として正規分布が用いられ、線形な構造のみを認めたもの

  $$
  \begin{cases}
    \alpha_{t} = T_{t}\alpha_{t-1} + R_{t}\xi_{t}, &  \xi_{t} \sim Normal(0, Q_{t})\\
    y_{t} = Z_{t}\alpha_{t} + \epsilon_{t}, & \epsilon_{t} \sim Normal(0, H_{t})
  \end{cases}
  $$


* 動的一般化線形モデル(線形非ガウス状態空間モデル)(Dynamic General Linear Model: DGLM)  
観測値$y_{t}$が正規分布以外の確率分布に従うことも認めたモデル

## 状態空間モデルの推定
+ カルマンフィルタ
+ 散漫カルマンフィルタ
+ 重点サンプリング
+ 粒子フィルタ