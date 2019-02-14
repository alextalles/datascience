#Define o path do work directory
setwd("C:/Users/Ana Clara/Desktop")

#Lê o CSV do titanic
titanic <- read.csv("gender_submission.csv", header = TRUE, sep = ",")
#Lê o CSV de teste
titanic.test <- read.csv("test.csv", header = TRUE, sep = ",")
#Lê o CSV de treinamento
titanic.train <- read.csv("train.csv", header = TRUE, sep = ",")

View(titanic.train) 

#Filtra a base de dados pelo Embarked, pegango somente os que estão em branco 
# e faz um replace com 'S'.
titanic.train[titanic.train$Embarked == '', "Embarked"] <- 'S'
table(titanic.train$Embarked)
table(is.na(titanic.train$Age))
#o resultado da tabela mostra 177 passageiros sem a informação idade. 

#Como contornar esse problema?
#Pega a mediana do conjunto de dados Titanic desconsiderando, os registros sem
#essa informação e atribuindo a variável age.median.
age.mediana <- median(titanic.train$Age, na.rm = TRUE)
titanic.train[is.na(titanic.train$Age), "Age"] <- age.mediana
age.mediana

table(is.na(titanic.train$Fare))
fare.mediana <- median(titanic.train$Fare, na.rm = TRUE)
titanic.train[is.na(titanic.train$Fare), "Fare"] <- fare.mediana

#Casting Categorical
factor.survived <- as.factor(titanic.train$Survived)

#A variável equation armazena as colunas que serão consideradas.
survived.equation <- "Survived ~ PClass + Sex + Age + SibSp + Parch + Fare + Embarked"

install.packages("randomForest")
library(randomForest)

survived.formula <- survived.equation <- as.formula(survived.equation)
#Criando o modelo passando a fórmula criada com a string armazenada em survived.equation.

titanic.modelo <- randomForest(formula = survived.formula, data = titanic.train, ntree = 500, mtry = 3, nodesize = 0.01, nrow(titanic.train))

                               