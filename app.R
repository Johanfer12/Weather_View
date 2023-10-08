# Load the necessary libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)

# Read the CSV file
data <- read.csv("city_temperature.csv")

# Create the Shiny application
ui <- fluidPage(
  titlePanel("Avg. Temperature Chart"),
  sidebarLayout(
    sidebarPanel(
      selectInput("city", "Select a city:",
        choices = unique(data$City),
        selected = "Bogota"
      )
    ),
    mainPanel(
      plotlyOutput("graph") # Display the graph
    )
  )
)

server <- function(input, output) {
  # Filter the data based on the selected city
  city_data <- reactive({
    if (input$city != "InitialCity") {
      data %>% filter(City == input$city)
    } else {
      NULL
    }
  })

  # Create the line graph with a trendline
  output$graph <- renderPlotly({
    if (!is.null(city_data())) {
      filtered_data <- city_data() %>%
        filter(AvgTemperature != -99)  # Filter out temperature values equal to -99

      # Function to convert Fahrenheit to Celsius
      convert_to_celsius <- function(fahrenheit) {
        celsius <- (fahrenheit - 32) * (5/9)
        return(celsius)
      }

      # Apply the conversion to the AvgTemperature column
      filtered_data$AvgTemperature <- convert_to_celsius(filtered_data$AvgTemperature)

      # Group the data by month and calculate the average temperature
      grouped_data <- filtered_data %>%
        mutate(Date = as.Date(paste(Year, Month, "01", sep = "-"))) %>%
        group_by(Date) %>%
        summarize(AvgTemp = mean(AvgTemperature))

      p <- ggplot(grouped_data, aes(x = Date, y = AvgTemp)) +
        geom_line() +
        geom_smooth(method = "lm", se = FALSE, color = "blue") +  # Add the trendline
        labs(x = "Date", y = "Average Temperature (°C)") +
        scale_x_date(date_labels = "%Y", date_breaks = "1 year") +  # Customize the x-axis scale
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Vertical orientation of labels

      ggplotly(p, tooltip = "y")  # Convert the ggplot graph to plotly
    }
  })

}

# Run the Shiny application
shinyApp(ui, server)
