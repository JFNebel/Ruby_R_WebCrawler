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



# ===================== HISTOGRAMA DE SKILLS ==========================

# Desglozamos la lista de skills en una columna cada skill
freqSkillDT <- data.table(ofertas)
freqSkillDT <- freqSkillDT[ , list( Habilidades = unlist( strsplit( Habilidades , "," ) ) ) , by = Titulo ]


# Debemos limpiar las filas caracteres basura
freqSkillDT <- str_remove_all(freqSkillDT$Habilidades, "[\\[\\]\"]")
freqSkillDT <- trimws(freqSkillDT)


#Ahora debemos sacar la frecuencia:
freqSkillDT <- table(freqSkillDT)


#Ahora vamos a sacar el top 7
freqSkillDT <- sort(freqSkillDT, decreasing = TRUE)
freqSkillDT <- head(freqSkillDT,7)


#Armamos el histograma
colores <- c("#00172d","#02386e","#00498d","#1a84b8","#1a8cb8","#1a94b8","#1a9cb8")
barplot(freqSkillDT, ylab = "Frecuencia", xlab = "Habilidades", 
        ylim = c(0,50), main = "Top 7 tecnologías asociadas a la búsqueda", 
        col = colores, space= 0.7, cex.names=0.8, 
        names.arg=abbreviate(names(freqSkillDT), minlength = 20))



# ========================= DOTCHART DE SALARIOS ================================

#Desglozamos las habilidades de la lista manteniendo salario y título 
dispDT <- data.table(ofertas)
dispDT <- dispDT[ , c("Titulo", "Salario", "Habilidades")]
dispDT <- dispDT[ , list( Habilidades = unlist( strsplit( Habilidades , "," ) ) )
                  , by = c("Titulo","Salario")]


#Sacando el numero de skills por título
dispDT <- dispDT[ , .N , by = c("Titulo","Salario")]
dispDT <- dispDT[ , gsub("+[^0-9-]", "", Salario), by = c("Titulo","N")]
dispDT <- dispDT[ , mean(as.numeric(unlist(strsplit(V1, "-", 1, FALSE))), na.rm=FALSE)
                  , by = c("Titulo","N")]
names(dispDT) <- c("Titulo", "Skills", "SalarioMed")


# Generando dotchart
grps <- as.factor(dispDT$Skills)
dotchart(dispDT$SalarioMed, main = "Ofertas salariales en base a número de habilidades"
         , labels = dispDT$Titulo ,groups = grps, cex = 0.6
         , xlab = "Número de Habilidades", ylab = "Ofertas agrupadas por número de habilidades")


