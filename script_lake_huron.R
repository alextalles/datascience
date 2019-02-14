# Instalando os pacotes (matriz + time)
install.packages("xts")
install.packages("forecast")

# Inicializando as bibliotecas necessárias
library(xts)
library(forecast)

rm(list=ls(all=TRUE))

setwd("C:/Users/Alex/Desktop")

# Questão 1 - Carregando a base de dados Lago Huron
dados_lago <- read.table("lake_huron.txt", header = TRUE, sep = "")
View(dados_lago)

# Mostrando a estrutura do banco de dados
str(dados_lago)

# Questão 2 - Transformando a série de dados em uma série temporal
tsdados_lago <- ts(dados_lago$nivel, frequency = 12, start = c(1875)) # 12 para mensal
tsdados_lago <- ts(dados_lago$nivel, frequency = 6, start = c(1875)) # 6 para semestral
tsdados_lago

# Questão 3 - Gráfico de Séries Temporais
plot(tsdados_lago, type= "b", pch = "19", main="Nível do lago ao longo dos anos", xlab="Ano", ylab="Nível")

# Questão 4 - Gráficos: ACF e PACF
par(mfrow=c(1,2))
# Gráfico ACF - Mostrando a função de autocorrelação dos resíduos ajuda descobrir 
acf(tsdados_lago, plot = FALSE)
acf(tsdados_lago)
#Intepretgação: No gráfico, existe uma correlação significativa no lag 1 que decresce depois de alguns lags.

# Gráfico PACF - Mostrando a função autocorrelação parcial dos resíduos ajuda a verificar alguns padrões
pacf(tsdados_lago, plot=FALSE)
pacf(tsdados_lago)
# Intepretação: Neste gráfico, existe uma correlação significativa no lag 1, seguido por correlações que não são significativas.

# Verificando a sanzonalidade
# Observei que houve um pico em Abril, descreve suvamente até Junho e depois cresce até Setembro. O gráfico não revela padrão de sazonalidade.
seasonplot(tsdados_lago)

# Questão 5 - Ajustando O Modelo ARIMA aos dados.
modelo_ARIMA <- arima0(tsdados_lago, order = c(2,1,0))
modelo_ARIMA
# Coeficiente AR1 é 0.1728 e o erro padrão 0.1012
# Coeficiente AR2 é -0.2233 e o erro padrão 0.1015

#Questão 6 - Avaliando se o modelo é adequado: Análise de Resíduos
residuos <- modelo_ARIMA$residuals 
#Observei que os resíduos não revelam um padrão e nem autocorrelação.
ts.plot(residuos, ylab="Resíduos", main="Análise de Resíduos")
abline(h=0, col=2)

# QUestão 7 - Verificando as normalidades dos resíduos.

#Gráfico de Probailidade Normal
qqnorm(residuos)
qqline(residuos, col=2)

# Teste de Normalidade para os resíduos
shapiro.test(residuos) # não rejeita a hipótese de normalidade
# W = 0.98645, p-value = 0.4239

# Efetuando previsões para 3 meses adiante
previsao <- forecast(residuos, h = 3)
previsao

# Retornando a previsão pontual e os intervalos de 80% a 95% de confiança

# Point Forecast      Lo 80     Hi 80     Lo 95    Hi 95
# Mar 1883    -0.00568271 -0.9384475 0.9270821 -1.432223 1.420858
# Apr 1883    -0.00568271 -0.9384475 0.9270821 -1.432223 1.420858
# May 1883    -0.00568271 -0.9384475 0.9270821 -1.432223 1.420858

# Mostrando as previsões pontuais. Em cinza escuro o intervalo de 80% e em cinza claro de 90% 
plot(previsao)
