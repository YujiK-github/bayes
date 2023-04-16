data {
  int N;                  // サンプルサイズ
  vector[N] sales;        // データ
}

parameters {
  real mu;                // 平均
  real<lower=0> sigma;    // 標準偏差
}

model {
  // 平均\mu、標準偏差\sigmaの正規分布に従ってデータが得られたと仮定
  for (i in 1:N) {
    sales[i] ~ normal(mu, sigma);
  }
}

/*
ベクトル化すると

model {
  sales ~ normal(mu, sigma);
}

*/

// 事後予測
generated quantities {
   //事後予測分布を得る
   vector[N] pred;
   for (i in 1:N){
    pred[i] = normal_rng(mu, sigma);
   }
}
