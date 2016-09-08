# shinyAceMod
A shiny module of Ace editor for real-time debug

### Introduction

When debugging a shiny app, it would be very useful to check the value of an input or reactive object while the app is runing. By loading this `shinyAce`-based shiny module, it's easy to perform this task in read-time. This shiny modlule provide an Ace editor interface and evaluate any code input in shiny environment and displace output in a `verbatimTextOutput()`. 


### Pre-request

This shiny module requires following packages. Please make sure they are installed.

```r
install.package('shinyAce')
install.package('pryr')
install.package('formatR')
```
### Usage

1. Source the module file

  ```r
  source('shinyAceMod.R')
  ```
  
2. Invoke module in server function. Make sure to set an appropriate evaluation environment.

  ```r
  server <- function(input, output, session) {

    callModule(shinyAceMod, id = 'YOU_MODULE_ID', eval_env = pryr::where('input'))
  
    # other codes

  }
  ```
  
3. Add Ace editor ui

  ```r
  ui <- fluidPage(

    shinyAceModUI('YOU_MODULE_ID')

  )
  ```

4. Run app and input code you want to run in the Ace editor


