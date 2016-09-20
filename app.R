library(shiny)

source('shinyAceMod.R')

server <- function(input, output, session) {

  callModule(shinyAceMod, id = 'test', eval_env = pryr::where('input'))

}

ui <- fluidPage(
  
  actionButton('button', 'Click!'),
  
  hr(),

  shinyAceModUI('test')

)

shinyApp(ui, server)
