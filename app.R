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
        selected = "Bogota"
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

  # Crear la gráfica de línea con línea de tendencia
  output$grafica <- renderPlotly({
    if (!is.null(datos_ciudad())) {
      datos_filtrados <- datos_ciudad() %>%
        filter(AvgTemperature != -99)  # Filtra los valores de temperatura igual a -99

      # Función para convertir Fahrenheit a Celsius
      convertir_a_celsius <- function(fahrenheit) {
        celsius <- (fahrenheit - 32) * (5/9)
        return(celsius)
      }

      # Aplicar la conversión a la columna AvgTemperature
      datos_filtrados$AvgTemperature <- convertir_a_celsius(datos_filtrados$AvgTemperature)

      # Agrupar los datos por mes y calcular la temperatura promedio
      datos_agrupados <- datos_filtrados %>%
        mutate(Fecha = as.Date(paste(Year, Month, "01", sep = "-"))) %>%
        group_by(Fecha) %>%
        summarize(TempPromedio = mean(AvgTemperature))

      p <- ggplot(datos_agrupados, aes(x = Fecha, y = TempPromedio)) +
        geom_line() +
        geom_smooth(method = "lm", se = FALSE, color = "blue") +  # Agrega la línea de tendencia
        labs(x = "Fecha", y = "Temperatura Promedio (°C)") +
        scale_x_date(date_labels = "%Y", date_breaks = "1 year") +  # Personaliza la escala del eje x
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Orientación vertical de las etiquetas

      ggplotly(p, tooltip = "y")  # Convierte la gráfica de ggplot a plotly
    }
  })

}

# Ejecutar la aplicación Shiny
shinyApp(ui, server)