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


# Importando los .csv a un dataset
ofertasW <- read.csv("workana.csv", header = FALSE, encoding="UTF-8",sep =",")
ofertasF <- read.csv("freelancer.csv", header = FALSE, encoding="UTF-8", sep =",")
names(ofertasW)<- c("Titulo", "Fecha","Descripcion", "Salario", "Habilidades")
names(ofertasF)<- c("Titulo", "Fecha","Descripcion", "Salario", "Habilidades")


# ================= PRE-PROCESAMIENTO PARA CONCATENAR TABLAS ==================

ofertasWDT <- data.table(ofertasW)
ofertasFDT <- data.table(ofertasF)

#Sacamos las comisiones por hora
ofertasWDT <- ofertasWDT[!grepl("h", Salario, fixed = TRUE),]
ofertasFDT <- ofertasFDT[!grepl("h", Salario, fixed = TRUE),]

#Colocamos las columnas de Salarios en un solo formato para un buen binding
ofertasWDT[, Salario:= gsub("+[^0-9-]", "", Salario)
           , by = c("Titulo", "Fecha", "Descripcion", "Salario", "Habilidades")]  

ofertasWDT[, Salario:= mean(as.numeric(unlist(strsplit(Salario, "-", 1, FALSE)))
           , na.rm=FALSE), by = "Titulo"]



ofertasFDT[, Salario:= mean(as.numeric(unlist(strsplit(Salario, "-", 1, FALSE)))
                            , na.rm=FALSE), by = "Titulo"]
ofertasFDT[, Salario:= sapply(ofertasFDT[,Salario],as.numeric)]
ofertasFDT[, Salario:= round(ofertasFDT[,Salario])]




# Realizamos el binding para tener las ofertas GLOBALES y quitamos duplicados
ofertas <- rbind(ofertasWDT, ofertasFDT)
ofertas <- ofertas[!duplicated(ofertas$Titulo),]

# Renombrando columnas ya no es necesario
# names(ofertas)<- c("Titulo", "Fecha","Descripcion", "Salario", "Habilidades")



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
        ylim = c(0,60), main = "Top 7 tecnologías asociadas a la búsqueda", 
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
names(dispDT) <- c("Titulo", "SalarioMed", "Skills")
dispDT[, SalarioMed:= sapply(dispDT[,SalarioMed],as.numeric)]

#dispDT <- dispDT[order(-SalarioMed),]
#dispDT <- head(dispDT,40)
dispDT <- sample_n(dispDT,40)


# Generando dotchart
grps <- as.factor(dispDT$Skills)
dotchart(dispDT$SalarioMed, main = "Ofertas salariales en base a número de habilidades"
         , labels = str_trunc(dispDT$Titulo, 40, side = c("right"), ellipsis = "...") 
         , groups = grps, cex = 0.6, xlim = c(0,4000)
         , xlab = "Salario medio", ylab = "Ofertas agrupadas por número de habilidades")


