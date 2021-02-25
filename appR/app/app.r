ent <- 1

options(encoding = "utf-8")
options(shiny.maxRequestSize = 30*1024^2)
options(warn=-1)

library(shiny)

shinyApp(
	ui = fluidPage(
		sliderInput(inputId = "num",
			label = "Choose Number",
			value = 10, min = 1, max = 100),
		plotOutput("hist")
	),	
	server <- function(input, output){}
)	 