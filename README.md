
---

# Temperature Chart App

This is a Shiny web application that allows you to visualize temperature data for different cities. The application displays a line chart with a trendline showing the average temperatures over time.

## Data Source

The temperature data used in this application is sourced from [Kaggle](https://www.kaggle.com/datasets/sudalairajkumar/daily-temperature-of-major-cities/). You can access the dataset and find more details about it on Kaggle.

## Getting Started

Follow these instructions to run the application locally on your machine.

### Prerequisites

Make sure you have the following prerequisites installed:

- R (https://www.r-project.org/)
- RStudio (https://rstudio.com/)

### Installation

1. Clone this repository to your local machine or download the ZIP file and extract it.

2. Open RStudio.

3. Set the working directory to the folder where you extracted the repository or cloned it. You can do this using the following command in RStudio:

   ```R
   setwd("path/to/your/folder")
   ```

   Replace `"path/to/your/folder"` with the actual path to the folder containing the app files.

4. Install the required R packages if you haven't already by running the following commands in RStudio:

   ```R
   install.packages("shiny")
   install.packages("ggplot2")
   install.packages("dplyr")
   install.packages("plotly")
   ```

### Usage

1. Run the Shiny application by opening the `app.R` file in RStudio and clicking the "Run App" button.

2. The application will launch in your web browser, and you can interact with it.

3. Use the dropdown menu to select a city, and the line chart will display the average temperatures for that city over time.

4. You can hover over the chart to see temperature values, and a trendline is included for reference.

## Data

The application uses temperature data from a CSV file named `city_temperature.csv`. Ensure that this file is in the same directory as the application files.

## Customization

You can customize the default city that is displayed when the application loads by modifying the `selected` parameter in the `selectInput` function in the `app.R` file:

```R
selectInput("city", "Select a city:",
  choices = unique(data$City),
  selected = "Bogota"  # Change to your desired default city
)
```

## License

This project is licensed under the MIT License.

---