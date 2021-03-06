extrac <- function (){
############################################   EXTRACTOS      ##############################################################################################
#Fijar el la ruta de trabajo
	setwd("D:/github/appi001/appR/functions")

#Blibliotecas requeridas
	library(httr)    
	library(rjson)  
	library(jsonlite)
	library(dplyr)
	library(openxlsx)
	library(data.table)
	library(bit64)
	library(stringr)

#Conexion a D365FO TRUJILLO INVESTMENT
	body <- list(grant_type = "client_credentials", client_id = "7cb678f1-2bc4-4456-a590-f7216b23dd88",
	client_secret = "~9X1PR2etZ1sHw1tsv-15Y.pD3F_RaTCxG", resource = "https://mistr.operations.dynamics.com")

	response <-POST("https://login.microsoftonline.com/ceb88b8e-4e6a-4561-a112-5cf771712517/oauth2/token",add_headers("Cookie: x-ms-gateway-slice=prod; stsservicecookie=ests; fpc=AqQZzzXZjstDgAtb0IfeeFZVotOLAQAAANAmrtYOAAAA"), body=body,encode = "form")

	datatoken <-fromJSON(content(response,type="text")) %>% as.data.frame
	tok_type<-as.character(datatoken[1,1])
	tok<-as.character(datatoken[1,7])
	token <- paste(tok_type," ",tok,"",sep="")

#Uso de la funcion para extraer datos con el Entity proporcionado
	source("function_get_collect.r")
	data1f_collect <- get_records_url("https://mistr.operations.dynamics.com//data/RetailEodStatementAggregations?$filter=ErrorMessage%20ne%20%27null%27",token)
	#head(data1f_collect)

#Extrae todos los pedidos de ventas 
	salesid <- data1f_collect$SalesId
	
#Extraer datos de los pedidos de venta en status "Backorder"
	source("function_get_collect.r")
	data2f_collect <- get_records_url("https://mistr.operations.dynamics.com/data/SalesOrderHeadersV2?$filter=SalesOrderStatus%20eq%20Microsoft.Dynamics.DataEntities.SalesStatus%27Backorder%27&$select=SalesOrderNumber,RequestedReceiptDate",token)
	sales_rec <- data2f_collect

	sales_rec[,2]<-as.character(as.POSIXct(sales_rec[,2], format="%Y-%m-%d",tz="UTC"))


#Extrae todos los numeros de la calumna mensaje
	dat2 <- as.data.frame(cbind(data1f_collect[,2], data1f_collect[,5], data1f_collect[,7]))
	names(dat2) <- c("StatementId", "SalesOrderNumber", "StoreNumber")
	prt <- as.data.frame(data1f_collect$ErrorMessage)
	dat<- str_extract_all(prt, "\\d+.\\d+\\S")

##Busqueda de datos cod productos
	product <- NULL
	k = seq(3,length(dat[[1]]), by=9)

	for(i in k){
		product = rbind(product, dat[[1]][i])
	}
	names(product) <- "productos"

##Busqueda de datos cantidad faltante
	c_req <- NULL
	t = seq(5,length(dat[[1]]), by=9)
	for(i in t){
		c_req = rbind(c_req, dat[[1]][i])
	}
	c_req <- as.numeric(c_req)

##Busqueda de datos Stock
	stock <- NULL
	h = seq(6,length(dat[[1]]), by=9)
	for(i in h){
		stock = rbind(stock, dat[[1]][i])
	}
	stock <- as.numeric(stock)


#Busqueda  de productos y  nombres de Entity All Products
	prod_length <- length(product)
	prod_rec = NULL
	for (i in 1:prod_length) {

		pdt <- product[i]
	source("function_get_collect.r")
			vec_consulta <- paste("https://mistr.operations.dynamics.com/data/AllProducts?$filter=ProductNumber%20eq%20%27",pdt,"%27&$select=ProductNumber,ProductName",sep="")
			pdt_con <- get_records_url(vec_consulta,token)
		prod_rec <- rbind(prod_rec,pdt_con)
	}


#Unir columnas
	f1 <- cbind(dat2,product,c_req,stock)

#Unir con el dataframe prod (contiene el nombre del producto Left Join)
	c1 <- merge(f1,prod_rec,by.x="product",by.y="ProductNumber", all.x = TRUE)
	c2 <- merge(c1,sales_rec,"SalesOrderNumber", all.x = TRUE)

#Agrupar por columnas tienda y productos, nommbre de producto y Fecha
f2<- c2 %>% 
		group_by(StoreNumber,product,ProductName,RequestedReceiptDate) %>%
		summarise(c_req = sum(c_req),stock = sum(stock))

		k1 <- f2$StoreNumber
		k2 <- f2$product
		k3 <- f2$ProductName
		k4 <- f2$RequestedReceiptDate
		k5 <- f2$c_req
		k6 <- f2$stock

#funciÃ³n para asignar nombres a las tiendas
source("nametienda.r")
	k1 <- nametienda(k1)

#Ordenar columnas del dataframe 
	f4 <- as.data.frame(cbind(k1,k2,k3,k4,k5,k6))
	names(f4) <- c("Tienda", "CodPro", "Descripcion","Fecha","Requerido", "Stock")

	return(f4)
}