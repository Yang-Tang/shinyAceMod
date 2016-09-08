library(shiny)

source('shinyAceMod.R')

server <- function(input, output, session) {

  callModule(shinyAceMod, id = 'test', eval_env = pryr::where('input'))

}

ui <- fluidPage(

  shinyAceModUI('test')

)

shinyApp(ui, server)
