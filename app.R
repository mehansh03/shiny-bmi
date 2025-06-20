library(shiny)
library(shinythemes)

# UI               
ui <- fluidPage(
  theme = shinytheme("yeti"),
  
  navbarPage("BMI Calculator:",
             
             tabPanel("Home",
                      
                      sidebarPanel(
                        HTML("<h3>Input parameters</h3>"),
                        sliderInput("height", 
                                    label = "Height (cm)", 
                                    value = 175, 
                                    min = 40, 
                                    max = 250),
                        sliderInput("weight", 
                                    label = "Weight (kg)", 
                                    value = 70, 
                                    min = 20, 
                                    max = 100),
                        
                        actionButton("submitbutton", 
                                     "Submit", 
                                     class = "btn btn-primary")
                      ),
                      
                      mainPanel(
                        tags$label(h3('Status/Output')), # Status/Output Text Box
                        textOutput('contents'),          
                        textOutput('bmiText'),           
                        tableOutput('tabledata')         
                      ) # mainPanel()
             ), #tabPanel Home
             
             tabPanel("About", 
                      titlePanel("About"), 
                      div(includeMarkdown("about.md"), 
                          align="justify")
             ) #tabPanel About
  ) # navbarPage
) # fluidPage


# Server                           
server <- function(input, output, session) {
  
  # Calculate BMI and return as dataframe
  datasetInput <- reactive({  
    bmi_val <- input$weight / ((input$height / 100)^2)
    data.frame(BMI = round(bmi_val, 2))
  })
  
  # Status/Output Text Box
  output$contents <- renderText({
    if (input$submitbutton > 0) { 
      "Calculation complete." 
    } else {
      "Click on Submit"
    }
  })
  
  # Display BMI 
  output$bmiText <- renderText({
    if (input$submitbutton > 0) {
      bmi_val <- input$weight / ((input$height / 100)^2)
      paste("Your BMI is:", round(bmi_val, 2))
    } else {
      ""
    }
  })
  
  # Show BMI in table
  output$tabledata <- renderTable({
    if (input$submitbutton > 0) { 
      isolate(datasetInput()) 
    } 
  })
  
}

# Run the app                 
shinyApp(ui = ui, server = server)
