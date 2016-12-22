#' 
#' Kod w R, wizualizacja - Piotr Sobczyk
#' 
#' Przygotowanie danych - Bartek Kolasa, Piotr Oleszczyk
#' 
#' Wizualizacja powstała w ramach wrocławskiego datathonu
#' 

library(shiny)
library(dplyr)
library(leaflet)
library(RColorBrewer)

przystanki=read.csv("stops.txt")
arrival_delay2=read.csv("arrival_delay2.csv")
arrival_delay2=arrival_delay2 %>%
	inner_join(przystanki %>% select(kierunek=stop_name, stop_code), by=c("direction"="stop_code"))
hours=sort(unique(arrival_delay2$hour))
linie=sort(unique(arrival_delay2$lineno))
weekday=sort(unique(arrival_delay2$day))

ui <- bootstrapPage(
	tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
	leafletOutput("map", width = "100%", height = "100%"),
	absolutePanel(top = 10, right = 10,
								selectInput("linia", "Linia", choices = linie
								),
								selectInput("godzina", "Godzina", choices = hours
								),
								selectInput("weekday", "Dzień", choices = weekday)
	)
)

server <- function(input, output, session) {
	
	filteredData <- reactive({
			arrival_delay2 %>%
				filter(lineno == input$linia,
							 hour == input$godzina,
							 day == input$weekday)
		
	})
	

	
	output$map <- renderLeaflet({
		leaflet(arrival_delay2) %>% addProviderTiles("CartoDB.Positron") %>%
			fitBounds(~min(stop_lon), ~min(stop_lat), ~max(stop_lon), ~max(stop_lat))
	})
	
	observe({
		at=c(-2,2,4,6,10,20,30)
		palette_rev <- rev(brewer.pal(length(at), "RdYlGn"))
		pal=colorBin(palette_rev, bins = at, domain = at, pretty = FALSE)
		
		leafletProxy("map", data = filteredData()) %>%
			clearShapes() %>% clearMarkers() %>%
			addCircles(lng = ~stop_lon, lat = ~stop_lat, radius = 60, 
								 color = ~pal(delay_median), 
								 popup =  ~paste0("Przystanek: <b>", stop_name, "</b>", 
								 								 "<br/>Kierunek: ", kierunek,
								 								 "<br/>Przeciętne opóźnienie MPK: ", round(delay_median, 1) , " [min.]"))
	})
	
	observe({
		proxy <- leafletProxy("map", data = arrival_delay2)
		
		proxy %>% clearControls()
		at=c(-2,2,4,6,10,20,30)
		palette_rev <- rev(brewer.pal(length(at), "RdYlGn"))
		pal <- colorBin(palette_rev, bins = at, domain = at, pretty = FALSE)
		proxy %>% addLegend(title = "Opóźnienie w minutach", position = "bottomright",
												pal = pal, values = at
		)
	})
	

}

shinyApp(ui, server)