ent <- 1

options(encoding = "utf-8")
options(shiny.maxRequestSize = 30*1024^2)
options(warn=-1)

ent <- 1
if(ent == 1){
	pathglo <- "D:/github/appi001/appR"
}else {
	pathglo <- "/srv/shiny-server/appi001/appR"
}


library(shiny)
library(shinythemes)
library(shinyjs)


library(httr)    
library(rjson)  
library(jsonlite)
library(dplyr)
library(openxlsx)
library(data.table)
library(bit64)
library(stringr)


shinyApp(
	ui = fluidPage( theme = shinytheme("united"), useShinyjs(),
			navbarPage( "Trujillo Home",
				tabPanel("Extractos",
					sidebarPanel( style='margin-left:-10',
						actionButton("idBtn1","Inventario insuficiente", class = "btn-danger")
					),
					fluidRow(
						column(6,
							)
						),
					fluidRow(
						column(7,
							tabPanel("Tabla Inventario insuficiente",DT::dataTableOutput('table0.output'),style = 'font-size:90%')
						)
					)
				)
			)
		),	
	server <- function(input, output){

		observeEvent(input$idBtn1,{

			# a <- c("Mirana", "Slardar", "Lion")
			# b <- c("Agilidad", "Fuerza", "Inteligencia")
			# data <- rbind(a,b)
			# data <- as.data.frame(data)
			# names(data) <- c("Player1", "Player2", "Player3")
			source(paste(pathglo,"/functions/extractos.r",sep=""))
			data <- extrac()

			output$table0.output <- DT::renderDataTable({DT:: datatable(data)})
			})		
	}
)	 