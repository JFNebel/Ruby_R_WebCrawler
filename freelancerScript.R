#Información de la oferta del skills más  solicitado
#Abre ventana para buscar el archivo y retorna la ruta entre comillas
install.packages("dplyr")
install.packages("tidyr")
install.packages("readxl")
install.packages("data.table")
install.packages("stringr")
#file.choose()
#se copia la ruta entre comillas a un variable
#rutaF <- "C:\\Users\\allis\\OneDrive\\Escritorio\\Ruby_R_WebCrawler\\freelancer.csv"
#tabla <-read.csv(rutaF,header = FALSE, encoding="UTF-8")
#names(tabla)<- c("Titulo", "Fecha","Descripcion", "Salario", "Habilidades")

urlW <- "C:\\Users\\allis\\OneDrive\\Escritorio\\Ruby_R_WebCrawler\\workana.csv"
urlF <- "C:\\Users\\allis\\OneDrive\\Escritorio\\Ruby_R_WebCrawler\\freelancer.csv"
ofertasW <- read.csv(urlW, header = FALSE, encoding="UTF-8",sep =",")
ofertasF <- read.csv(urlF, header = FALSE, encoding="UTF-8", sep =",")
names(ofertasW)<- c("Titulo", "Fecha","Descripcion", "Salario", "Habilidades")
names(ofertasF)<- c("Titulo", "Fecha","Descripcion", "Salario", "Habilidades")
ofertasWDT <- data.table(ofertasW)
ofertasFDT <- data.table(ofertasF)
ofertasWDT <- ofertasWDT[!grepl("h", Salario, fixed = TRUE),]
ofertasFDT <- ofertasFDT[!grepl("h", Salario, fixed = TRUE),]
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
tabla <- ofertas


fila <-rbind(tabla$Habilidades)
lista<-unlist(strsplit(fila, ","))
lista<-unlist(strsplit(lista, '\\"'))
lista<-lista[lista!='[']
lista<-lista[lista!=']']
lista<-lista[lista!=' ']
f <- as.data.frame(lista)
f<-table(f)
f<-sort(f,decreasing = TRUE)
f<-as.data.frame(f)
names(f) <- c("Habilidad", "N. veces Rep")
skill<-as.character(f[2,1])
skill <- paste("\\b",skill,"\\b",sep='')
indices<- grep(skill,tabla$Habilidades,ignore.case = TRUE)
View(tabla[indices,])



#-----segundo analisis---
tablaC <-tabla
tablaC$Salario<-as.numeric(tablaC$Salario)
tablaC <- tablaC[!is.na(tablaC$Salario),]
ofertasOrdenadas <- order(tablaC$Salario,decreasing = TRUE)
salarioMin<-as.data.frame(tablaC[ofertasOrdenadas[length(ofertasOrdenadas)],])
salarioMax<-as.data.frame(tablaC[ofertasOrdenadas[1],])
#salarioMin <- tablaC[min(tablaC$Salario),]
salarioMax <- as.data.frame(salarioMax)
salarioMax <- t(salarioMax[-1])
salarioMin <- as.data.frame(salarioMin)
salarioMin <- t(salarioMin[-1])
View(salarioMax)
View(salarioMin)
