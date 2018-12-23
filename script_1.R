#TRABALHO PRÁTICO DE ANÁLISES ESTATÍSTICAS

require(ggplot2)

#DEFININDO O DIRETÓRIO
setwd("C:/Users/Alex Talles/Desktop/Lista_1_Estatistica")

#IMPORTANDO E CARREGANDO AS BASES DE DADOS. 

dadosRais <- read.table("dados_rais_2014.txt", header = TRUE, na.strings = '', encoding = "latin1")
View(dadosRais)

grandeGrupo <- read.table("CBO2002_Grande_Grupo.txt", sep = "\t", header = TRUE, na.strings = '', encoding = "latin1")
View(grandeGrupo)

familia <- read.csv("CBO2002_Familia.csv", sep = "\t", header = TRUE, na.strings = '', encoding="UTF-8")
View(familia)

#MANIPULANDO OS DADOS.

colnames(grandeGrupo) <- c("cod_grupo", "desc_grupo")
colnames(familia) <- c("cod_ocupacao", "desc_ocupacao")
colnames(dadosRais) <- c("Ano", "Região", "UF", "cod_ocupacao", "renda_mensal_total", "total_empregos", "total_estabelecimentos")

#INSERINDO NO DATA FRAME DADOSRAIS, AS DESCRIÇÕES DE FAMÍLIA E DE GRANDE GRUPO.

install.packages("stringr")
require(stringr)
substr(grandeGrupo)


#CALCULANDO A RENDA MENSAL TOTAL E NÚMERO TOTAL DE EMPREGOS POR ESTADO, POR OCUPAÇÃO E POR GRANDE GRUPO.

dataFrameGrandeGrupo <- data.frame("teste","OUTROS GRUPOS")
colnames(dataFrameGrandeGrupo) <- c("cod_grupo", "desc_grupo")
dataFrameGrandeGrupo

dataFrameOcupacao <- data.frame("teste","Outras Ocupações")
colnames(dataFrameOcupacao) <- c("cod_ocupacao", "desc_ocupacao")
dataFrameOcupacao

rm(dataFrameGrandeGrupo, dataFrameOcupacao)


totalEmpregosPorEstado <- aggregate(x = c(dadosRais["renda_mensal_total"], dadosRais["total_empregos"]), 
                         by = list(UF = dadosRais$UF), 
                         FUN = sum)
totalEmpregosPorEstado

totalEmpregosPorOcupacao <- aggregate(x = c(dadosRais["renda_mensal_total"], dadosRais["total_empregos"]), 
                           by = list(Ocupação = dadosRais$cod_ocupacao, Nome_Ocupação = dadosRais$desc_ocupacao), 
                           FUN = sum)
totalEmpregosPorOcupacao

totalEmpregosPorGrandeGrupo <- aggregate(x = c(dadosRais["renda_mensal_total"], dadosRais["total_empregos"]), 
                              by = list(Grupo = dadosRais$cod_grupo, Nome_Grupo = dadosRais$desc_grupo), 
                              FUN = sum)
totalEmpregosPorGrandeGrupo

# ORDENANDO OS ESTADOS POR ORDEM DESCRESCENTE DE NÚMERO DE EMPREGOS.

install.packages("dplyr")
require(dplyr)

totalEmpregosPorEstado <- arrange(totalEmpregosPorEstado, desc(total_empregos))
totalEmpregosPorEstado

#RETORNANDO A OCUPAÇÃO QUE POSSUI MAIOR NÚMERO DE EMPREGOS NO BRASIL.

totalEmpregosPorOcupacao <- arrange(totalEmpregosPorOcupacao, desc(total_empregos))
ocupacaoMaiorNumeroEmpregos <- totalEmpregosPorOcupacao$Nome_Ocupação[1]
ocupacaoMaiorNumeroEmpregos

#RETORNANDO A OCUPAÇÃO QUE POSSUI A MAIOR REMUNERAÇÃO MÉDIA E A MENOR.

dadosRais$renda_mensal_total=dadosRais$renda_mensal_total/dadosRais$total_empregos
totalEmpregosPorOcupacao <- aggregate(x= dadosRais["Renda_Media"], 
                           by = list(Ocupação = dadosRais$cod_ocupacao, Nome_Ocupação = dadosRais$desc_ocupacao), 
                           FUN = mean)

totalEmpregosPorOcupacao <- arrange(totalEmpregosPorOcupacao, desc(Renda_Media))
ocupacaoMaiorRemuneracaoMedia <- totalEmpregosPorOcupacao$Nome_Ocupação[1]
ocupacaoMaiorRemuneracaoMedia

totalEmpregosPorOcupacao <- arrange(totalEmpregosPorOcupacao, Renda_Media)
ocupacaoMenorRemuneracaoMedia <- totalEmpregosPorOcupacao$Nome_Ocupação[1]
ocupacaoMenorRemuneracaoMedia

#RETORNA O NÚMERO DE OCUPAÇÕES QUE POSSUEM REMUNERAÇÃO MÉDIA MENOR QUE R$ 2.000,00.


numeroOcupacoes <- count(subset(totalEmpregosPorOcupacao, renda_mensal_total < 2000, select = Ocupação:Renda_Média))
numeroOcupacoes

#DENTRE OS TÉCNICOS DE NÍVEL MÉDIO DE MINAS GERAIS, QUAL OCUPAÇÃO POSSUI A MAIOR RENUMERAÇÃO MÉDIA?

ocupacaoMaiorRemuneracaoMediaMG <- arrange(subset(dadosRais, UF == 'MG' & Cod_Grupo == 3, 
                                            select=Cod_Grupo:Renda_Media), desc(Renda_Media))$Desc_Ocupacao[1]
ocupacaoMaiorRemuneracaoMediaMG


#GRÁFICO DE BARRAS REPRESENTANDO O NÚMERO DE EMPREGOS POR GRANDE GRUPO.

barplot(totalEmpregosPorEstado, main = "Número de Empregos por Grande Grupo", col = topo.colors())

# CALCULANDO O % DE EMPREGOS POR REGIÃO E REPRESENTE EM UM GRÁFICO DE PIZZA REPRESENTANDO TAIS VALORES.

numeroEmpregosPorRegiao <- table(dadosRais[, 2])
numeroEmpregosPorRegiao

pie(numeroEmpregosPorRegiao, main = "Total de Empregos por Região", labels = c("15,2%", "33,5%", "24,2%", "15,4", "11,5%"), col = c (1, 2, 3, 4, 5))
legend("topright", fill = c(1, 2, 3, 4, 5), legend = c( "Centro-Oeste", "Nordeste", "Norte", "Sudeste", "Sul" ))

#CONSTRUINDO UMA TABELA CRUZADA COM O NÚMERO DE EMPREGOS POR GRANDE GRUPO (LINHAS) E POR REGIÃO (COLUNAS).

install.packages("questionr")
require(questionr)


percentualEmpregosPorGrandeGrupo_E_PorRegiao <- aggregate(x = c(dadosRais["Total_Empregos"]), 
                                           by = list(Grupo = dadosRais$Cod_Grupo, UF = dadosRais$Regiao), 
                                           FUN = sum)

names(percentualEmpregosPorGrandeGrupo_E_PorRegiao) <- c("Grupo", "Região", "Total_Empregos")

wtd.table(percentualEmpregosPorGrandeGrupo_E_PorRegiao$Grupo, percentualEmpregosPorGrandeGrupo_E_PorRegiao$Região, weights = percentualEmpregosPorGrandeGrupo_E_PorRegiao$Total_Empregos, digits = 4, normwt = FALSE, na.rm = TRUE, na.show = FALSE)

# CALCULANDO O TOTAL DE ABORTOS (INDUZIDOS E ESPONTÂNEOS)

totalAbortosInduzidos <- sum(infert$induced)
totalAbortosInduzidos

totalAbortosEspontaneos <- sum(infert$spontaneous)
totalAbortosEspontaneos

totalAbortos <- totalAbortosEspontaneos + totalAbortosInduzidos
totalAbortos  

# CONSTRUINDO UMA TABELA DE FREQUÊNCIA CRUZADA 
#ENTRE O NÚMERO TOTAL DE ABORTOS E A ESCOLARIDADE DAS MULHERES.

install.packages("gmodels")
require(gmodels)


totalAbortos <- aggregate(x = c(infert["spontaneous"], infert["induced"]), 
                                 by = list(Education_Level = infert$education),
                                 FUN = sum)
totalAbortos$total_abortation = totalAbortos$spontaneous + totalAbortos$induced
totalAbortos

CrossTable(x=totalAbortos$Education_Level,y=totalAbortos$total_abortation, format="SAS", prop.t = TRUE, missing.include = FALSE)

