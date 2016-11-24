library(shiny)

shinyApp(
ui = (fluidPage(
  div(id = "header",
      h1("Calculadora de Quantidade de Parcelas e Valor do Seguro Desemprego"),
      h4("A lista de regras é extensa para se calcular quanto você pode receber de seguro desemprego.
         Esta calculadora pretende auxiliar o requerente do seguro a saber quantas parcelas e qual o valor
         de cada que lhe é de direito"),
      strong( 
        span("Criado por "),
        a("Matheus Rabetti", href = "http://matheusrabetti.github.io"),
        HTML("&bull;"),
        span("Código"),
        a("no GitHub", href = "https://github.com/matheusrabetti/shiny-server/tree/master/calculadoraSD")
  ),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("numInputs", "Tempo empregado antes do requerimento (meses)", 4),
      # place to hold dynamic inputs
      uiOutput("inputGroup")
    ),
    # this is just a demo to show the input values
    mainPanel(textOutput("inputValues"))
  )
))
),

# Define server logic required to draw a histogram
server = shinyServer(function(input, output) {
  # observe changes in "numInputs", and create corresponding number of inputs
  observeEvent(input$numInputs, {
    output$inputGroup = renderUI({
      input_list <- lapply(1:input$numInputs, function(i) {
        # for each dynamically generated input, give a different name
        inputName <- paste("input", i, sep = "")
        numericInput(inputName, inputName, 1)
      })
      do.call(tagList, input_list)
    })
  })
  
  # this is just a demo to display all the input values
  output$inputValues <- renderText({
    paste(lapply(1:input$numInputs, function(i) {
      inputName <- paste("input", i, sep = "")
      input[[inputName]]
    }))
  })
  
})
)
