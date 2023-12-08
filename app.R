# Load the required package
library(shiny)
library(tidyverse)
library(DT)
library(shinythemes)

# Load the iris data from `datasets` package
iris_data <- datasets::iris

# Modify UI version 
ui <- fluidPage(
  
  # Add theme to make the app more appealing 
  bootstrapPage(theme = shinytheme("paper")),
  
  # Add title of the app
  titlePanel("Iris Flower App"),
  
  # Add sidebarLayout
  sidebarLayout(
    
    sidebarPanel(
      
      # NEW Feature 1: Select Box to choose the x-axis variable. Version 1 only allows choosing Petal.Length and Petal. Width as x and y variables. The new version allows users to choose their own x and y variables. 
      selectInput("xVar", "Select the x-axis variable",
                  choices = setdiff(names(iris_data), "Species")), # "Species" is a categorical variable so we do not include it in the selection. 
      
      # Feature 1 -> NEW Feature 2: Sliders to choose the range of the variable. New version dynamically updated the slider range based on the selection of users' variables.
      sliderInput("xRange", "Select the range of x-axis variable ",
                  min = 0, max = 1, value = c(0, 1), step = 0.1, post = "cm"),
      
      # Similar to the y-axis variable
      selectInput("yVar", "Select the y-axis variable",
                  choices = setdiff(names(iris_data), "Species")),
      
      sliderInput("yRange", "Select the range of y-axis variable",
                  min = 0, max = 1, value = c(0, 1), step = 0.1, post = "cm"),
      
      # Feature 2 -> NEW Feature 3: Change from SelectInput (version 1) to checkboxGroupInput so users can choose 2 species or 3 species (All species) at the same time. Version 1 limits users to only select one species or all species. 
      checkboxGroupInput("species", "Filter by species",
                         choices = as.character(unique(iris_data$Species)),
                         selected = as.character(unique(iris_data$Species))),
      # Feature 3: Download button to save the table results as .csv file 
      downloadButton("downloadData", "Download table results", style = "background-color: #9ADE7B; color: white;")
    ),
    
    # Add the mainPanel
    mainPanel(
      
      # Feature 4: Show number of results
      # Users can see the total number of results found based on the selections (filters) that they choose
      h4(textOutput("Num_results")),
      
      # NEW Feature 4: Add the tabsetPanel with 4 tabs: Introduction (give users information about iris dataset and how to use the app), Scatter Plot, Table and Summary Statistics. 
      tabsetPanel(
        
        # NEW Feature 5: Add Introduction
        tabPanel("Introduction",
                 h2("Welcome to the Iris Flower App!"),
                 p("This app allows you to explore and visualize the iris dataset."),
                 # Add image of three species of iris flower in the data 
                 img(src = "irisflower.png", width = 500, height = 200), 
                 p("Use the tabs in the Main Panel  to navigate between different features, including introduction, scatter plot, table and summary statistics."),
                 p("Use the Sidebar Panel to select the variables and other filters to analyze the data"),
                 p("The 'Scatter Plot' tab provides a visualization of the selected variables, and the 'Table' and 'Summary Statistics' tabs offer additional insights based on your selections."),
                 br(),
                 h4("About the Iris Flower Dataset:"),
                 p("The iris dataset, introduced by Ronald A. Fisher in 1936, is a foundational dataset in machine learning and statistics.  With 150 observations of iris flowers categorized into three species and featuring measurements for four key attributes, the iris dataset is widely used for educational purposes and is a benchmark for practicing data analysis and classification techniques."),
                 p("The Iris dataset contains measurements of four features (sepal length, sepal width, petal length, and petal width) of three different species of Iris flowers (setosa, versicolor, and virginica)."),
                 p("For more information about the Iris dataset, visit ", tags$a(href = "https://archive.ics.uci.edu/dataset/53/iris", "UCI Machine Learning Repository"))),
                 
        #Add Scatter Plot tab 
        tabPanel("Scatter Plot", 
                 # Feature 4: Show number of results
                 # Users can see the total number of results found based on the selections (filters) that they choose
                 plotOutput("Graph"),
        ),
        # Add Table tab
        tabPanel("Table",
                 #Feature 5:  DT package to turn a static table into an interactive table
                 DT::dataTableOutput("Table"),
        ),
        # NEW Feature 5: Add Summary Statistics tab
        tabPanel("Summary Statistics",
                 verbatimTextOutput("SummaryStats"),
        )
      )
    )
  )
)

# Modify server version 
server <- function(input, output, session) {
  # Feature 2 NEW: Update dynamically the slider range. The slider range will be updated based on the selection of InputSelect
  observe({
    xRange <- range(iris_data[[input$xVar]])
    updateSliderInput(session, "xRange", 
                      min = xRange[1], 
                      max = xRange[2],
                      value = xRange)
    yRange <- range(iris_data[[input$yVar]])
    updateSliderInput(session, "yRange", 
                      min = yRange[1], 
                      max = yRange[2],
                      value = yRange)
  })
  
  # Filter data based on the selection of users in UI 
  iris_filter <- reactive({
    filtered_data <- iris_data %>%
      filter(
        iris_data[[input$xVar]] >= input$xRange[1],
        iris_data[[input$xVar]] <= input$xRange[2],
        iris_data[[input$yVar]] >= input$yRange[1],
        iris_data[[input$yVar]] <= input$yRange[2]
      )
    
    if (!is.null(input$species) && length(input$species) > 0) {
      filtered_data <- filtered_data %>%
        filter(Species %in% input$species)
    }
    
    filtered_data
  })
  
  # Number of results found by showing the number of rows in the table results
  output$Num_results <- renderText({ 
    Num_results <- nrow(iris_filter())
    paste0("We found ", Num_results, " results.")
  })
  
  # Plot the scatter plot between petal length and petal width 
  output$Graph <- renderPlot({
    if (is.null(iris_filter())) {
      return()
    }
    
    ggplot(iris_filter(), aes(x = iris_filter()[[input$xVar]], y = iris_filter()[[input$yVar]], color = Species)) +
      geom_point(size = 3.5, alpha = 0.8) +
      labs(x = input$xVar, y = input$yVar) +
      # NEW Feature 6: Assign a fixed color for each species in the scatter plot
      scale_color_manual(values = c("setosa" = "#FFC5C5", "versicolor" = "#FFEBD8", "virginica" = "#C7DCA7")) +
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
  
  # Render summary statistics
  output$SummaryStats <- renderPrint({
    summary(iris_filter()[, c(input$xVar, input$yVar)])
  })
}

shinyApp(ui = ui, server = server)
