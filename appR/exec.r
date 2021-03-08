ent <- 1
if(ent == 1){
	pathglo <- "D:/github/appi001/appR"
}else {
	pathglo <- "/srv/shiny-server/appi001/appR"
}

setwd(pathglo)

library(shiny)

runApp("app", host="0.0.0.0", port=8000)