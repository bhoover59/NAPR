# About ------------------------------------------------------------------------
# Written by Bode Hoover (bodehoov@iu.edu)
# NAPR
# Packages
library(shiny)
library(shinythemes)
library(shinyjs)
library(shinyWidgets)
library(bslib)
library(plotly)
# Clear Memory -----------------------------------------------------------------
rm(list = ls())
# UI ---------------------------------------------------------------------------
ui <- fluidPage(
  # Theme -------------------------------------------------------------------
  useShinyjs(),
  theme = bs_theme(bg = "rgb(96,96,96)", bootswatch = "sandstone", fg = "rgb(255,255,255)", primary = "rgb(137,38,38)"),
  tabsetPanel(
    # NAPR UI ------------------------------------------------------------------
    tabPanel('NAPR',
             sidebarLayout(
               sidebarPanel(
                 fileInput('raw_data_file_HONO', label = 'Raw data file (csv):', multiple = FALSE, placeholder = "No file selected"),
                 strong("Remove Lock Points"),
                 fluidRow(
                   column(7, numericInput('delete_before_HONO', value = 2, min = 1, step = 1, label = "Before")),
                   column(5, numericInput('delete_after_HONO', value = 2, min = 1, step = 1, label = "After"))
                 ),
                 column(12, style = "border-top:1px solid"),
                 strong("Met Data Calibrations"),
                 numericInput('dayBLH', value = 200, min = 0.0, step = 50.0, label = "Daytime boundary layer height (m)"),
                 column(12, style = "border-top:1px solid"),
                 radioButtons("estimateOH", label = "Estimate OH",
                              choices = list("Use measured OH" = 1, "Estimate OH" = 2),
                              selected = 1),
                 radioButtons("JNO2method", label = "JNO2 method",
                              choices = list("Use measured JNO2" = 1, "Use NCAR-TUV model" = 0),
                              selected = 1),
                 radioButtons("Jcorrmethod", label = "Jcorr method",
                              choices = list("Calculate" = 1, "User input" = 0),
                              selected = 1),
                 column(12, style = "border-top:1px solid"),
                 numericInput('SoilpH', value = 6.00, min = 0.0, step = 0.1, label = "Soil pH"),
                 p("Author: Bode Hoover (bodehoov@iu.edu)"),
               ),
               mainPanel(
                 h4('About Me'),
                 column(12, style = "border-top:1px solid"),
                 p("The Nitrous Acid Program in R (NAPR) calculates the reaction rates and concentration for HONO based on input values."),
                 p("Can only upload one csv file at a time. Combine csv files first in command prompt via cd to directory"),
                 p("copy *.csv NewFileName.csv"),
                 br(),
                 actionButton('NAPRStart', 'Start NAPR', class = "btn-primary"),
                 br(), br(),
                 column(12, style = "border-top:1px solid"),
                 h4('Download NAPR Data:'),
                 fluidRow(
                   column(8, textInput('filenameHONO', label = NULL, placeholder = '.csv')),
                   column(4, downloadButton(outputId = 'downloadNAPR', label = 'Download .csv File', class = "btn-primary"))
                 ),
                 h4('Download NAPR Input Values:'),
                 fluidRow(
                   column(8, textInput('filenameNAPRInput', label = NULL, placeholder = '.csv')),
                   column(4, downloadButton(outputId = 'downloadNAPRInput', label = 'Download .csv File', class = "btn-primary"))
                 ),
                 column(12, style = "border-top:1px solid"),
                 h4("Output:"),
                 tabsetPanel(
                   tabPanel("Raw Data", dataTableOutput("table1_NAPR")),
                   tabPanel("HONO Plot", plotlyOutput("plot2_NAPR")),
                   tabPanel("View Output Data File ", dataTableOutput("table2_NAPR"))
                 )
               )
             )
    )
    ))
# Server -----------------------------------------------------------------------
server <- function(input, output) {
  options(shiny.maxRequestSize = 750 * 1024 ^ 2) # 250 MB max file size upload
  data <- reactiveValues(df = NULL)  # Store the data frame

  # Get input file and display
  observeEvent(input$file, {
    inFile <- input$file
    if (is.null(inFile))
      return()
    data$df <- read.csv(inFile$datapath, header = TRUE)
    # NAPR::check_input(data$df)
  })

  # Render input data frame
  output$inputData <- DT::renderDataTable({
    data$df
  })

  # Run model and update outputs
  observeEvent(input$runButton, {
    req(data$df)

    # Perform necessary calculations and modeling here

    # Render summary output
    output$summaryOutput <- renderPrint({
      # Print summary statistics
      summary(data$df)
    })

    # Render HONO plot
    output$honoPlot <- renderPlot({
      # Plot HONO concentration vs. time
      ggplot(data$df, aes(x = Hours, y = HONO_pss)) +
        geom_line() +
        xlab("Hour") +
        ylab("[HONO] (ppt)")
    })
  })

  # Download output CSV
  output$downloadButton <- downloadHandler(
    filename = function() {
      paste0("NAPR_output_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(data$df, file, row.names = FALSE)
    }
  )
}
# End App -----------------------------------------------------------------
shinyApp(ui = ui, server = server)
