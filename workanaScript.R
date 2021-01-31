# 1. Instalación de paquetes
install.packages("dplyr")
install.packages("tidyr")
install.packages("readxl")

install.packages("data.table")
install.packages("stringr")


# Validar si los paquetes se han instalado
library(dplyr) 
library(tidyr)
library(readxl)
library(data.table)
library(stringr)


# Importando el .csv a un dataset
ofertas <- read.csv("workana.csv", header = FALSE, sep =",")

# Renombrando columnas
names(ofertas)<- c("Titulo", "Fecha","Descripcion", "Salario", "Habilidades")
                 
# Ahora desglozamos la lista de skills en una columna cada skill
#freqSkillDF <- separate_rows(ofertas, Habilidades,convert = TRUE) 
freqSkillDT <- data.table(ofertas)
freqSkillDT <- freqSkillDT[ , list( Habilidades = unlist( strsplit( Habilidades , "," ) ) ) , by = Titulo ]

# Debemos limpiar las filas caracteres basura
#freqSkillDF<-freqSkillDF[complete.cases(freqSkillDF),]
#freqSkillDF <- freqSkillDF[!(freqSkillDF$Habilidades==""), ]
freqSkillDT <- str_remove_all(freqSkillDT$Habilidades, "[\\[\\]\"]")
freqSkillDT <- trimws(freqSkillDT)

#Ahora debemos sacar la frecuencia:
freqSkillDT <- table(freqSkillDT)

#Ahora vamos a sacar el top 10
#class(freqSkillDT)
#freqSkillDT <- data.table(freqSkillDT)
#freqSkillDT <- order(freqSkillDT$N)
freqSkillDT <- sort(freqSkillDT, decreasing = TRUE)
freqSkillDT <- head(freqSkillDT,7)

#Armamos el histograma
barplot(freqSkillDT, ylab = "Frecuencia", xlab = "Habilidades", 
        ylim = c(0,50), main = "Top 7 tecnologías asociadas a la búsqueda", 
        col = rainbow(15), space= 0.5, cex.names=0.8, 
        names.arg=abbreviate(names(freqSkillDT)))
