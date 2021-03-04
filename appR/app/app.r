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

shinyApp(
	ui = fluidPage( theme = shinytheme("united"), useShinyjs(),
			navbarPage( "Trujillo Home",
				tabPanel("Extractos",
					sidebarPanel( style='margin-left:-10',
						h3("Inventario insuficiente"),
						actionButton("idBtn1","Calcular", class = "btn-danger")
					),
					fluidRow(
						column(6,
							)
						),
					fluidRow(
						column(6,
							tabPanel("hola",DT::dataTableOutput('table0.output'),style = 'font-size:90%')
						)
					)
				)
			)
		),	
	server <- function(input, output){

		observeEvent(input$idBtn1,{

			source(paste(pathglo,"/upload/extractos.r",sep=""))
			data <- extrac()

			output$table0.output <- DT::renderDataTable({DT:: datatable(extrac)})

			})		
	}
)	 