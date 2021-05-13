#####################################################################################
#  Proyecto D365 FO                                                                 #
#  Extracción de datos Stock Insuficiente                                           #
#  Autor: Junior T. Ortiz Mejia                                                     #
#  Fecha: 08/03/2021																#
#  Modificado v.2 : 13/05/21                                                        #                                                                              
#####################################################################################

options(encoding = "utf-8")
options(shiny.maxRequestSize = 30*1024^2)
options(warn=-1)

ent <- 2
if(ent == 1){
	pathglo <- "D:/github/appi001/appR"
}else {
	pathglo <- "/srv/shiny-server/appi001/appR"
}


library(shiny)
library(shinydashboard)
library(shinythemes)
library(shinyWidgets)
library(DT)
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
	ui = fluidPage( theme = shinytheme("lumen"), useShinyjs(),useShinydashboard(),

			list(
				tags$head(HTML('<link rel="icon", href="http://181.65.149.162:4001/app014/img/cropped-fvtrujll02-32x32.png", type="image/png">')),
				tags$style(HTML("
						.navbar {left: -20px; }
						.navbar-default .navbar-brand { color: #FFF;
														front-size: 16px;
														background-color: #E1120B ;}
					"))
			),

			shinythemes::themeSelector(), #seleccionar themas libreria shinythemes
			navbarPage( "Modulo Análisis de Productos - Trujillo investment 2021",
				tabPanel("Inventario Insuficiente",
					sidebarPanel( style='margin-left:-10',

						actionButton("idBtn1","Inventario insuficiente", class = "btn-danger"),
						downloadButton('idBtn2','Download', class = "btn-success"),
						textOutput("selected_var")
					),
					fluidRow(column(6,)),
					fluidRow(column(3,),column(6,DT::dataTableOutput('table0.output'),style = 'font-size:85%'))
				),
				tabPanel("Resumen",
						valueBoxOutput("progress1",width = 2),
						valueBoxOutput("progress2",width = 2),
						valueBoxOutput("progress3",width = 2),
						valueBoxOutput("progress4",width = 2),
						valueBoxOutput("progress5",width = 2),
						hr(),
						fluidRow(column(4,),column(4,DT::dataTableOutput('table1.output'),style = 'font-size:85%'))

					)
			)
		),	
	server <- function(input, output){

		shinyjs::hide("idBtn2")

		source(paste(pathglo,"/functions/extractos.r",sep=""))
		data <- extrac()

		fechaid <- paste("Actualizado al ",Sys.Date(),sep="")

		kpi <- data[[2]]
		kpi1.1 <- nrow(subset(kpi,kpi[,1]=="MD01_LUZ"))
		kpi1.2 <- nrow(subset(kpi,kpi[,1]=="MD02_JRC"))
		kpi1.3 <- nrow(subset(kpi,kpi[,1]=="MD03_CRH"))
		kpi1.4 <- nrow(subset(kpi,kpi[,1]=="MD04_SUC"))
		kpi1.5 <- nrow(subset(kpi,kpi[,1]=="MD05_CRZ"))


		observeEvent(input$idBtn1,{


			output$table0.output <- DT::renderDataTable({DT::datatable(data[[1]],options = list(pageLength = 20,autoWidth = TRUE))}) 

			output$table1.output <- DT::renderDataTable({DT::datatable(data[[2]],rownames=FALSE,options = list(pageLength = 20,autoWidth = TRUE, order = list(list(1, 'asc'))))})

			output$progress1 <- renderValueBox({valueBox(kpi1.1,"Market Luzuriaga",icon=icon("list"),color = 'green')})
			output$progress2 <- renderValueBox({valueBox(kpi1.2,"Market Jr. Caraz",icon=icon("list"),color = 'green')})
			output$progress3 <- renderValueBox({valueBox(kpi1.3,"Market Carhuaz",icon=icon("list"),color = 'green')})
			output$progress4 <- renderValueBox({valueBox(kpi1.4,"Market Jr. Sucre",icon=icon("list"),color = 'green')})
			output$progress5 <- renderValueBox({valueBox(kpi1.5,"Market Caraz",icon=icon("list"),color = 'green')})

			output$selected_var <- renderText({fechaid})
			shinyjs::show("idBtn2")

		})

			output$idBtn2 <- downloadHandler(

				filename = function(){
					paste("Extractos-",Sys.Date(),".xlsx",sep="")
				},
				content = function(file) {
					write.xlsx(data,file,row.names=TRUE)
				})


		
 	}
)
