# shiny module of shinyAce editor
# This module is used in a shiny app for real-time debug
# Usage:
# 1. source this file in app.R or server.R
# 2. add shinyAceModUI('MODULE_ID') in ui
# 3. add callModule(shinyAceMod, id = 'MODULE_ID', eval_env = pryr::where('input'))
#    in server


shinyAceModUI <- function(id) {

  ns <- NS(id)

  hotkeys <- list(
    list(win="Ctrl-Shift-Enter",
         mac="CMD-SHIFT-ENTER"),
    list(win="Ctrl-Enter",
         mac="CMD-ENTER"),
    list(win="Ctrl-L",
         mac="CMD-L")
  )

  hotkeys <- setNames(hotkeys, c(ns('shinyAce_runall'),
                      ns('shinyAce_runlines'),
                      ns('shinyAce_clear')))

  placeholder <- paste(
    "##-----------------------------------------------------",
    "##  Ctrl/CMD-Shift-Enter: Evaluate all;",
    "##  Ctrl/CMD-Enter: Evaluate current line or selected;",
    "##  Ctrl/CMD-L: Clear input;",
    "##-----------------------------------------------------\n",
    sep = '\n'
  )

  tagList(

    shinyAce::aceEditor(outputId = ns('shinyAce_code'),
                        selectionId = ns('shinyAce_selection'),
                        cursorId = ns('shinyAce_cursor'),
                        hotkeys = hotkeys,
                        value = placeholder,
                        mode = 'r',
                        debounce = 1,
                        theme = 'chrome',
                        height = '400px',
                        autoComplete = 'live'),

    verbatimTextOutput(ns('shinyAce_out'))

  )

}

shinyAceMod <- function(input, output, session, eval_env = parent.frame()) {

  shinyAce::aceAutocomplete('shinyAce_code')

  shinyAce_values <- reactiveValues(code = '')

  observeEvent(input$shinyAce_runall, {
    shinyAce_values$code <- input$shinyAce_code
  })

  observeEvent(input$shinyAce_runlines, {
    selected <- input$shinyAce_selection
    if(selected=='') {
      row <- input$shinyAce_cursor$row + 1
      shinyAce_values$code <- strsplit(input$shinyAce_code,
                                       split = '\n')[[1]][row]
    } else {
      shinyAce_values$code <- selected
    }
  })

  observeEvent(input$shinyAce_clear, {
    shinyAce::updateAceEditor(session, session$ns('shinyAce_code'), '  ')
  })

  output$shinyAce_out <- renderPrint({
    formatR::tidy_eval(text = shinyAce_values$code, envir = eval_env)
  })

}
