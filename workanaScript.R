# 1. Instalación de paquetes
# NOTA: Recuerda que para correr lineas en un script debes subrayar la 
# linea(s) y aplastar cntrl + enter; Para limpiar consola cntrl + L
install.packages("dplyr")
install.packages("tidyr")
install.packages("readxl")

# Validar si los paquetes se han instalado
library(dplyr) 
library(tidyr)
library(readxl)

# Importando el .csv a un dataset
ofertas <- read.csv("workana.csv", header = FALSE, sep =",")

# Renombrando columnas
names(ofertas)<- c("Título", "Fecha","Descripción", "Salario", "Habilidades")
                 
# Ahora desglozamos la lista de skills en una columna cada skill
freqSkillDF <- separate_rows(ofertas, Habilidades,convert = TRUE) 

# Debemos limpiar las filas con habilidades vacías
#freqSkillDF<-freqSkillDF[complete.cases(freqSkillDF),]
freqSkillDF <- freqSkillDF[!(freqSkillDF$Habilidades==""), ]


