library(shiny)
library(shinydashboard)
ui<-(pageWithSidebar(
  # title
  headerPanel("Select Options"),
  
  #input
  sidebarPanel
  (
    # Input: Select a file ----
    
    fileInput("file1", "Choose CSV File",
              multiple = TRUE,
              accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")),
    # Input: Checkbox if file has header ----
    #checkboxInput("header", "Header", TRUE),
    
    # Input: Select separator ----
    radioButtons("sep", "Separator",
                 choices = c(Semicolon = ";",
                             Comma = ",",
                             Tab = "\t"),
                 selected = ","),
    sliderInput("bins","Number of Breaks",1,100,50),
    
    #tags$hr(),
    
    
    # Input: Select what to display
    selectInput("dataset","Data:",
                choices =list(c_data="clinical_data",
                              uploaded_file = "inFile"), selected=NULL),
    selectInput("variable","Variable:", choices = NULL),
    selectInput("group","Group:", choices = NULL),
    selectInput("plot.type","Plot Type:",
                list(boxplot = "boxplot", histogram = "histogram",density = "density", bar = "bar")
    ),
    #checkboxInput("show.points", "show points", TRUE)
  ),
  
  # output
  mainPanel(
    h3(textOutput("caption")),
    #h3(htmlOutput("caption")),
    uiOutput("plot") # depends on input
  )
))

server<-(function(input, output, session){
  
  #update group and
  #variables based on the data
  observe({
    #browser()
    if(!exists(input$dataset)) return() #make sure upload exists
    var.opts<-colnames(get(input$dataset))
    updateSelectInput(session, "variable", choices = var.opts)
    updateSelectInput(session, "group", choices = var.opts)
  })
  
  output$caption<-renderText({
    switch(input$plot.type,
           "boxplot" 	= 	"Boxplot",
           "histogram" =	"Histogram",
           "density" 	=	"Density plot",
           "bar" 		=	"Bar graph")
  })
  
  
  output$plot <- renderUI({
    plotOutput("p")
  })
}
)
  shinyApp(ui, server)
  
  