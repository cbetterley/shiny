library(shiny)

shinyUI(fluidPage(
    titlePanel("USA 2020 Presidential Candidate Campaign Finance Summary (as of 2019 Q2)"),
    
    sidebarLayout(
        sidebarPanel(
            radioButtons('party', label='Select Party', choices=c('Democrat'='DEM',
                                                                  'Republican'='REP',
                                                                  'American Party'='AMP',
                                                                  'Green'='GRE',
                                                                  'Libertarian'='LIB',
                                                                  'Independent'='IND',
                                                                  'None'='NNE',
                                                                  'No Party Affiliation'='NPA',
                                                                  'Non-Party'='NON',
                                                                  'Other'='OTH',
                                                                  'Unaffiliated'='UN',
                                                                  'Unknown'='UNK'), 
                         selected='DEM'),
            
            br(),  # whitespace
            
            sliderInput('raisedMin', label='Filter by minimum funds raised', min=0, max=100000000, value=0),
            
            sliderInput('raisedMax', label='Filter by maximum funds raised', min=0, max=100000000, value=100000000)
            
        ),
        
        # Tabbed:
        mainPanel(
            tabsetPanel(
                tabPanel('Data Table',tableOutput('dataTable')),
                tabPanel('Income vs Expense',plotOutput('dataPlotIncome')),
                tabPanel('Cash vs Expense',plotOutput('dataPlotCash'))
            )
        )
        
    )
))