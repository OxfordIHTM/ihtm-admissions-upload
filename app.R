library(shiny)
library(readxl)

# Define UI for data upload app ----
ui <- fluidPage(
  # App title ----
  titlePanel("Uploading Files"),
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    # Sidebar panel for inputs ----
    sidebarPanel(
      # Input: Select a file ----
      fileInput(
        inputId = "file1", 
        label = "Choose XLSX file to upload",
        multiple = FALSE,
        accept = ".xlsx")
    ),
    # Horizontal line ----
    tags$hr()
  ),
  # Main panel for displaying outputs ----
  mainPanel(
    # Output: Data file ----
    tableOutput("contents")
  )
)

# Define server logic to read selected file ----
server <- function(input, output) {
  output$contents <- renderTable({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    req(input$file1)

    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        df <- read_xlsx(path = input$file1$datapath, sheet = 3)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    df
  })
}

# Create Shiny app ----
shinyApp(ui, server)