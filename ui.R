ui <- fluidPage(titlePanel("Clinical Data"),
                sidebarLayout(
                  sidebarPanel(
                     selectInput("variable","Variables:", choices = colnames(dataSet))),
                  mainPanel(
                    plotOutput("barplot1"),
                    plotOutput("barplot2"),
                    plotOutput("plot"))
                ))