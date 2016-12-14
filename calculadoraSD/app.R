library(shiny)
library(shinythemes)

shinyApp(
  ui = (fluidPage(
    theme = shinytheme("sandstone"),
    div(id = "header",
        h1("Calculadora de Quantidade de Parcelas e Valor do Seguro Desemprego - Ano 2016"),
        h4("A lista de regras é extensa para se calcular quanto você pode receber de seguro desemprego.
           Esta calculadora pretende auxiliar o requerente do seguro a saber quantas parcelas e qual o valor
           de cada lhe é de direito"),
        strong( 
          span("Criado por "),
          a("Matheus Rabetti", href = "http://matheusrabetti.github.io"),
          HTML("&bull;"),
          span("Código"),
          a("no GitHub", href = "https://github.com/matheusrabetti/shiny-server/tree/master/calculadoraSD")
        ),
        
        sidebarLayout(
          sidebarPanel(
            numericInput("inputTempo", "Meses trabalhados nos últimos 36 meses", value = 12, max = 36),
            numericInput("numInputs", "Número de empregos anteriores regidos pela CLT - máx 3", 
                         min = 1, max = 3, value = 3),
            uiOutput("inputGroup")),
          
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
          inputName <- paste("Salário", i, sep = "")
          numericInput(sprintf("inputSal_%s",i), inputName, 500)
        })
        do.call(tagList, input_list)
      })
    })
    
    output$inputValues <-
      renderText(
        sprintf("Média dos salários: R$ %s",
                format(
                  round(
                    mean(
                      unlist(
                  lapply(1:input$numInputs, function(i) {
                    input[[sprintf("inputSal_%s", i)]]
                  })
                )), 2),
                decimal.mark = ",", big.mark = ".")
        ))
  }  
  )
)
