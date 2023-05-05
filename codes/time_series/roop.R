# 2. データの下調べ
## 横軸時間のプロット
### 描画の前処理
oldpar <- par(no.readonly = TRUE)
par(mfrow = c(2, 2))
par(oma = c(0, 0, 0, 0))
par(mar = c(4, 4, 2, 1))

### Nile
plot(Nile, main = "(a)")

### CO2
Ryori <- read.csv("data/tsbook-master/CO2.csv")
y_all <- ts(data = Ryori$CO2, start = c(1987, 1), frequency = 12)
y_CO2 <- window(y_all, end = c(2014, 12))
plot(y_CO2, main = "(b)")

### Gas
plot(UKgas, main = "(c)")

### artificial data
load("data/tsbook-master/BenchmarkNonLinearModel.RData")
y_nonlinear <- ts(y)
plot(y_nonlinear, main = "(d)")

### 描画の後処理
par(oldpar)

## ヒストグラムと五数要約
### 描画の前処理
oldpar <- par(no.readonly = TRUE)
par(mfrow = c(2, 2))
par(oma = c(0, 0, 0, 0))
par(mar = c(4, 4, 2, 1))

### Nile
hist(Nile, main = "(a)", xlab = "データの値")
summary(Nile)

### CO2
hist(y_CO2, main = "(b)", xlab = "データの値")
summary(y_CO2)

### Gas
UKgas_log <- log(UKgas) # データの変化が急激な場合は対数を取ると変化が線形になって扱いやすくなる
hist(UKgas_log, main = "(c)", xlab = "データの値")
summary(UKgas_log)

### artificial data
hist(y_nonlinear, main = "(d)", xlab = "データの値")
summary(y_nonlinear)

### 描画の後処理
par(oldpar)

###NAの補填
#### (b)
#### NAの位置を特定
NA.point <- which(is.na(y_CO2))

#### NAの補填：前後の算術平均
y_CO2[NA.point] <- (y_CO2[NA.point - 1] + y_CO2[NA.point + 1]) / 2


## 自己相関係数
### 描画の前処理
oldpar <- par(no.readonly = TRUE)
par(mfrow = c(2, 2))
par(oma = c(0, 0, 0, 0))
par(mar = c(4, 4, 2, 1))

### (a)
acf(Nile, main = "(a)")

### (b)
acf(y_CO2, main = "(b)")

### (c)
acf(UKgas_log, main = "(c)")

### (d)
acf(y_nonlinear, main = "(d)")

### 描画の後処理
par(oldpar)

## 周波数スペクトル
plot.spectrum <- function(dat, lab = "", main = "",
                          y_max = 1, tick = c(8, 4), unit = 1){
  # データの周波数領域変換
  dat_FFT <- abs(fft(as.vector(dat)))

  # グラフ横軸（周波数）の表示に関する準備
  data_len  <- length(dat_FFT)
  freq_tick <- c(data_len, tick, 2)

  # 周波数領域でのデータをプロット
  plot(dat_FFT/max(dat_FFT), type = "l", main = main,
       ylab = "|規格化後の周波数スペクトル|", ylim = c(0, y_max),
       xlab = sprintf("周波数[1/%s]", lab), xlim = c(1, data_len/2), xaxt = "n")
  axis(side = 1, at = data_len/freq_tick * unit + 1, 
       labels = sprintf("1/%d", freq_tick), cex.axis = 0.7)
}

### 描画の前処理
oldpar <- par(no.readonly = TRUE)
par(mfrow = c(2, 2))
par(oma = c(0, 0, 0, 0))
par(mar = c(4, 4, 2, 1))

### (a)
plot.spectrum(Nile, lab = "年", main = "(a)")

### (b)
plot.spectrum(y_CO2, lab = "月", main = "(b)")

### (c)
plot.spectrum(UKgas_log, lab = "月", main = "(c)")

### (d)
plot.spectrum(y_nonlinear, lab = "月", main = "(d)")

# 縦軸のスケールを変えて再描画

# (a) ナイル川における年間流量
plot.spectrum(       Nile, lab =   "年", main = "(a)", y_max = 0.02)

# (b) 大気中の二酸化炭素濃度
plot.spectrum(      y_CO2, lab =   "月", main = "(b)", y_max = 0.02,
              tick = c(12, 6))

# (c) 英国における四半期毎のガス消費量
plot.spectrum(  UKgas_log, lab =   "月", main = "(c)", y_max = 0.2 ,
              tick = c(12, 6), unit = 3)

# (d) 非線形なモデルから生成した人工的なデータ
plot.spectrum(y_nonlinear, lab = "時点", main = "(d)", y_max = 0.2 )

# 描画に関する後処理
par(oldpar)