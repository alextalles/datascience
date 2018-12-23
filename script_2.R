rm(list=ls(all=TRUE))

install.packages("dplyr")
require(dplyr)

install.packages("stringr")
require(stringr)

install.packages("ggplot2")
require(ggplot2)

#Carregando bibliotecas:
library(foreign)
library(gmodels)
library(dplyr)

#Carregando o Data Frame
setwd("C:/Users/Alex Talles/Desktop")
dadosDest <- read.table("dados_dest.txt", header = TRUE, sep = "\t")
View(dadosDest)
summary(dadosDest)

#Grá???co de Dispersão
par(mfrow=c(1,2))
with(dadosDest,plot(x,y, xlab = "Nível de Hidrocarboneto", ylab="Pureza do Oxigênio"))

with(dadosDest, cor(x, y))

#Modelo linear
modelo1 <- lm(y ~ x, data = dadosDest)
summary(modelo1)
#Gráfico de pontos e da reta de regressão
plot(modelo1)

residuos1 <- modelo1$residuals
residuos1
#Gráfico com os valores observados conectados a reta de regressão.
segments(y, fitted(modelo1), y, x)
hist(residuos1)

predict(object = modelo1, newdata = data.frame(x = c(1.08)))

#Carregando o Data Frame

setwd("C:/Users/Ana Clara/Desktop/Lista_1_Estatistica")
dadosSalario <- read.table("dados_salario.txt", header = TRUE, sep = '\t', na.strings = '', encoding = 'latin1')

View(dadosSalario)
par(mfrow=c(1,3))
#Gráfico de Dispersão
with(dadosSalario, plot(salario, educacao, idade))


salarioPorSexo <- aggregate(x = c(dadosSalario["salario"], dadosSalario["genero"]), 
                                    by = list(Genero =dadosSalario$genero), 
                                    FUN = sum)
 
salarioPorIdioma <- aggregate(x = c(dadosSalario["salario"], dadosSalario["idioma"]), 
                            by = list(Idioma =dadosSalario$idioma), 
                            FUN = sum)

barplot(salarioPorSexo, main = "Salários por Sexo", col = topo.colors())
barplot(salarioPorIdioma, main = "Salários por Idioma", col = topo.colors())


#Ajustando o modelo de regressão linear múltipla
modelo2 <- lm(salario ~ educacao+genero+idade+Class, data = dadosSalario, family = binomial)
summary(modelo2)


residuos2 <- modelo2$residuals
residuos2


salarioMedioTrabalhador = sum(dadosSalario$salario[dadosSalario$genero == "male" & dadosSalario$idade > 35 & dadosSalario$educacao > 10])
salarioMedioTrabalhador

salarioMedioTrabalhadora = sum(dadosSalario$salario[dadosSalario$genero == "female" & dadosSalario$idade > 35 & dadosSalario$educacao > 10])
salarioMedioTrabalhadora

