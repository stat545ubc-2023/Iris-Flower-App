# Load the required package
library(shiny)
library(tidyverse)
library(DT)

# Load the iris data from `datasets` package
iris_data <- datasets::iris

# Modify UI version 
ui <- fluidPage(
  
  # Add title of the app
  titlePanel("Iris Flower App"),
  
  # Add image of iris flower 
  img(src = "irisflower.jpeg",width = 150, height = 150), 
  br(),br(),
  br(),br(),
  # Add sidebarLayout
  sidebarLayout(
    
    sidebarPanel(
      
      # Feature 1: Sliders to choose the range of the variables
      # The purpose of this app is to let the users visualize the relation between Petal Length and Petal Width in iris data. Users can choose the range of two variables to filter the result in the graph and table.
      sliderInput("PetalLengthInput", "Petal Length (cm)", 
                  min = 1, max = 7, value = c(4, 6), step = 0.1, post = "cm"),
      sliderInput("PetalWidthInput", "Petal Width (cm)", 
                  min = 0, max = 3, value = c(0, 2), step = 0.1, post = "cm"),
      
      # Feature 2: Select Box to filter by species 
      # Users can choose if they want to filter the data by a specific species or all species. 
      selectInput("SpeciesInput", "Filter by species",
                  choices = c("All species",unique(iris$Species))),
      
      # Feature 3: Download button to save the table results as .csv file 
      downloadButton("downloadData", "Download table results"),
     
    ),
    
    # Add the mainPanel
    mainPanel(
      # Feature 4: Show number of results
      # Users can see the total number of results found based on the selections (filters) that they choose
      h4(textOutput("Num_results")),
      
      br(), br(),
      plotOutput("Graph"), 
      br(), br(),
      
      #Feature 5:  DT package to turn a static table into an interactive table
      DT::dataTableOutput("Table")
      
      
    )
  )
)

# Modify server version 
server <- function(input, output) {
  
  # Filter data based on selection of users in UI 
  
  iris_filter <- reactive({
    filtered_1 <- iris_data %>%
      filter(Petal.Length >= input$PetalLengthInput[1],
             Petal.Length <= input$PetalLengthInput[2],
             Petal.Width >= input$PetalWidthInput[1],
             Petal.Width <= input$PetalWidthInput[2],
             )
    
    if (input$SpeciesInput != "All species") {
      filtered_1 <- filtered_1 %>%
        filter(Species == input$SpeciesInput)
    }
    else 
      filtered_1
  })
  
  # Number of results found by showing number of rows in the table results
  
  output$Num_results <- renderText({ 
    Num_results <- nrow(iris_filter())
    paste0("We found ", Num_results, " results.")
  })
  
  # Plot the scatter plot between petal length and petal width 
  
  output$Graph <- renderPlot({
    if (is.null(iris_filter())) {
      return()
    }
    ggplot(iris_filter(), aes(x = Sepal.Length, y = Sepal.Width)) +
      geom_point(aes( color = Species), size = 3.5, alpha = 0.6) +
      labs(x = "Petal Length (cm)", y = "Petal Width (cm)") +
      labs(title="Relationship between Petal Length and Petal Width of flowers in Iris data")+
      theme_minimal()
      
  })
  
  # Print the table results
  output$Table <- DT::renderDataTable({
    iris_filter()
  })
  
  # Add DownloadHandler to download the table results as a csv file
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("iris-data-results.csv")
    },
    content = function(file) {
      write.csv(iris_filter(), file)
    }
  )
}


shinyApp(ui = ui, server = server)