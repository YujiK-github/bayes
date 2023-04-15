# Bayes' theorem

ベイズ統計学のまとめ兼活用

$$
\displaystyle p(\theta|x) = \frac{p(x|\theta)p(\theta)}{p(x)} = \frac{p(x|\theta)p(\theta)}{\int p(x|\theta)p(\theta) d\mu_{\Theta}(\theta)}
$$


### reference
 * 標準ベイズ統計学(Hoff)
 * 入門ベイズ統計学(中妻)
 * RとStanではじめるベイズ統計モデリングによるデータ分析入門(馬場)
   * https://github.com/logics-of-blue/book-r-stan-bayesian-model-intro
 * 基礎からわかる時系列分析 ―Rで実践するカルマンフィルタ・MCMC・粒子フィルター(牧山, 瓜生, 萩原)
   * https://github.com/hagijyun/tsbook
 * Pythonではじめるベイズ機械学習入門(木田, 森, 須山)
   * https://github.com/sammy-suyama/PythonBayesianMLBook
 * Pythonによるベイズ統計学入門(中妻)
   * https://github.com/nakatsuma/python_for_bayes
 * 時系列分析と状態空間モデルの基礎: RとStanで学ぶ理論と実装(馬場)
   * https://github.com/logics-of-blue/book-tsa-ssm-foundation


### Memo
* pymc install  
ref: https://www.pymc.io/projects/docs/en/stable/installation.html  
1. Anaconda Powershell Promptで以下のコードを実行
    ```
    conda create -c conda-forge -n pymc_env "pymc>=4" 
    ```
2. VScodeでコードを実行するときにpymc_envを選択

* VScodeでRMarkdownを使う  
ref: 
    * https://github.com/REditorSupport/vscode-R/wiki/R-Markdown   
    * https://kazutan.github.io/kazutanR/Rmd_intro.html
    * https://github.com/jgm/pandoc/releases
