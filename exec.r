ent <- 2
if(ent == 1){
	pathglo <- "D:/github/appi001/appR"
}else {
	pathglo <- "/srv/shiny-server/appi001/appR"
}

setwd(pathglo)

library(shiny)
library(shinydashboard)

runApp("app", host="0.0.0.0", port=8051)