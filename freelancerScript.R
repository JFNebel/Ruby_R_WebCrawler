#Información de la oferta del skills más  solicitado
#Abre ventana para buscar el archivo y retorna la ruta entre comillas
file.choose()
#se copia la ruta entre comillas a un variable
rutaF <- "C:\\Users\\allis\\OneDrive\\Escritorio\\Ruby_R_WebCrawler\\freelancer.csv"
tabla <-read.csv(rutaF,header = FALSE, encoding="UTF-8")
names(tabla)<- c("Titulo", "Fecha","Descripcion", "Salario", "Habilidades")
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
skill<-as.character(f[1,1])
indices<- grep(skill,tabla$Habilidades,ignore.case = TRUE)
View(tabla[indices,])



#-----segundo analisis---
tablaC <-tabla
tablaC$Salario<-as.numeric(tablaC$Salario)
tablaC <- tablaC[!is.na(tablaC$Salario),]
ofertasOrdenadas <- order(tablaC$Salario,decreasing = TRUE)
salarioMax<-as.data.frame(tablaC[ofertasOrdenadas[length(ofertasOrdenadas)],])
salarioMin<-as.data.frame(tablaC[ofertasOrdenadas[1],])
#salarioMin <- tablaC[min(tablaC$Salario),]
salarioMax <- as.data.frame(salarioMax)
salarioMax <- t(salarioMax[-1])
salarioMin <- as.data.frame(salarioMin)
salarioMin <- t(salarioMin[-1])
View(salarioMax)
View(salarioMin)
