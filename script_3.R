######################################
## Implementando Modelo Logístico

# Removendo todas as variáveis no workspace
rm(list=ls(all=TRUE))
setwd("C:/Users/Alex Talles/Desktop")

# Instalando e importando pacotes

install.packages("dplyr")
require(dplyr)

install.packages("stringr")
require(stringr)

library(foreign)
library(gmodels)

dadosTitanic <- read.table("titanic.txt", header = TRUE, sep = "\t")
View(dadosTitanic)

dadosTitanic$Survived2 <- ifelse(dadosTitanic$Survived == "No", 0, 1)
head(dadosTitanic)

# Análise Descritiva:
summary(dadosTitanic)

tabClass <- with(dadosTitanic, CrossTable(Class, Survived, format ="SAS", prop.r = TRUE))
tabClass


#############################################################
# Porque não utilizar o modelo de regressão linear?
model <- lm(Survived2~Class, data=dadosTitanic)

summary(model)

# Valores preditos
ypred <- model$fitted.values
summary(ypred)

# Não normalidade dos resíduos: 
r <- model$residuals
hist(r)

qqnorm(r)
qqline(r,col="red")

# Modelo logístico
modClass <- glm(Survived2~Class,family=binomial,data=dados)
summary(modClass)

# Análise dos coeficientes: 
# As probabilidades de pessoas da primeira e segunda classe sobreviverem ao naufrágio 
# são significativamente diferentes da chance de pessoas da terceira classe sobreviverem (p-valor < 0,05)
# A probabilidade de uma pessoa da tripulação sobreviver ao naufrágio não é significativamente diferente
# da probabilidade de uma pessoa da terceira classe sobreviver ao naufrágio (p-valor > 0,05)

# Mudando a classe de referência:
dados$Class <- relevel(dados$Class,ref="3rd")
modClass <- glm(Survived2~Class,family=binomial,data=dados)
summary(modClass)

# Razão de chances:
cbind(modClass$coefficients,
      razao_chances=exp(coef(modClass))) # coef(fitlog) reporta só coef

# Interpretação dos coeficientes: 
# A chance de uma pessoa da primeira classe sobreviver ao naufrágio do 
# Titanic é 4,93 vezes maior do que a chance de uma pessoa da terceira classe sobreviver.

# A chance de uma pessoa da tripulação sobreviver ao naufrágio do Titanic é 
# 0,93 vezes maior do que a chance de uma pessoa da terceira classe sobreviver.
0.9344041^(-1)
# A chance de uma pessoa da tripulação sobreviver ao naufrágio do titanic é 7% menor do que a chance 
# de uma pessoa da terceira classe sobreviver.. MAS A DIFERENÇA ENTRE A TRIPULAÇÃO E A TERCEIRA CLASSE NÃO É SIGNIFICATIVA!!!

#############################################################
# Ajustando o modelo logístico completo
mod_logistico <- glm(Survived~Age+Sex+Class,data=dados,family=binomial)
summary(mod_logistico)

# Razão de chances:
cbind(mod_logistico$coefficients, # Coefficients reporta coef, ep, z e p-value
      razao_chances=exp(coef(mod_logistico))) # coef(fitlog) reporta só coef

#====================================================
# Modelo logístico:
# Probabilidades preditas:

probs_preditas <- mod_logistico$fitted.values
summary(probs_preditas)

dados_predito <- data.frame(dados,yhat)

# Ordenando os resultados:
arrange(unique(dados_predito[,-c(4,5)]),yhat)

#Predições:
predict(mod_logistico,newdata = data.frame(Sex="Female",Age="Child",Class="1st"),type="response") # probabilidade predita

predict(mod_logistico,newdata = data.frame(Sex="Female",Age="Child",Class="1st"),type="link") # NÃO É PROBABILIDADE!!!


#######################################################################################################
### Classificação:

dados_predito$survived_predito <- ifelse(dados_predito$yhat>0.5,1,0)

### Erros de classificação:
with(dados_predito,table(Survived2,survived_predito))



