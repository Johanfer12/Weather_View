# Cargar las librerías necesarias
library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)

# Leer el archivo CSV
data <- read.csv("city_temperature.csv")

# Crear la aplicación Shiny
ui <- fluidPage(
  titlePanel("Gráfica de Temperaturas"),
  sidebarLayout(
    sidebarPanel(
      selectInput("ciudad", "Selecciona una ciudad:",
        choices = unique(data$City),
        selected = "CiudadInicial"
      )
    ),
    mainPanel(
      plotlyOutput("grafica") # Mostrar la gráfica
    )
  )
)


server <- function(input, output) {
  # Filtrar los datos según la ciudad seleccionada
  datos_ciudad <- reactive({
    if (input$ciudad != "CiudadInicial") {
      data %>% filter(City == input$ciudad)
    } else {
      NULL
    }
  })

  # Crear la gráfica de línea
  output$grafica <- renderPlotly({
    if (!is.null(datos_ciudad())) {
      p <- ggplot(datos_ciudad(), aes(x = as.Date(paste(Year, Month, Day, sep = "-")), y = AvgTemperature)) +
        geom_line() +
        labs(x = "Fecha", y = "Temperatura Promedio") +
        theme_minimal()

      ggplotly(p, tooltip = "y")  # Convierte la gráfica de ggplot a plotly
    }
  })
}

# Ejecutar la aplicación Shiny
shinyApp(ui, server)