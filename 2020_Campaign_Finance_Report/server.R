library(shiny)
library(ggplot2)
library(dplyr)

shinyServer(function(input, output) {
    
    # ETL:
        # main data set: campaign finance summary by candidate:
        df_origin <- tbl_df(read.delim("http://s3.amazonaws.com/cbetterley/gwsb-msba/shiny-project/weball20_withHeaders_thruQ2.txt",
                                header=TRUE, sep='|', stringsAsFactors = FALSE))
        
        # secondary data set: linkage between candidates and committees (for filtering):
        linkage_origin <- tbl_df(read.delim("http://s3.amazonaws.com/cbetterley/gwsb-msba/shiny-project/ccl_withHeaders.txt",
                                     header=TRUE, sep='|', stringsAsFactors = FALSE))
        
        # use the linkage file to identify 2020 presidential candidates:
        linkage_filtered <- filter(linkage_origin, 
                                   CMTE_TP == 'P',                # committees for presidential candidates
                                   CMTE_DSGN == 'P',              # principal campaign committees only
                                   CAND_ELECTION_YR == 2020) %>%  # 2020 election committees only
            
                            transmute(CAND_ID) %>% distinct()     # dedupe candidate IDs
        
        # inner join to apply the filters:
        df <- inner_join(df_origin, linkage_filtered, by='CAND_ID')
        
        df <- filter(df, CAND_ID != 'P80003205')                  # Lee Mercer is a distracting outlier that is no longer in the race. Numbers are rolled over from previous campaigns.
        
    # Render:
    output$dataTable <- renderTable({    
        
        t <- filter(df, CAND_PTY_AFFILIATION == input$party & TTL_RECEIPTS >= input$raisedMin & TTL_RECEIPTS <= input$raisedMax) %>%
            transmute(Candidate=CAND_NAME, 
                   Income_million=round(TTL_RECEIPTS*1.0/1000000,2), 
                   Disbursements_million=round(TTL_DISB*1.0/1000000,2), 
                   Cash_million=round(COH_COP*1.0/1000000,2)) %>%
            arrange(desc(Income_million))
        
        print(t)
        
    })
    
    output$dataPlotIncome <- renderPlot({    
        
        t <- filter(df, CAND_PTY_AFFILIATION == input$party & TTL_RECEIPTS >= input$raisedMin & TTL_RECEIPTS <= input$raisedMax) %>%
            transmute(Candidate=CAND_NAME, 
                      Income_million=round(TTL_RECEIPTS*1.0/1000000,2), 
                      Disbursements_million=round(TTL_DISB*1.0/1000000,2), 
                      Cash_million=round(COH_COP*1.0/1000000,2)) 
        
        ggplot(t, aes(x=Income_million, y=Disbursements_million)) +
            xlab('Income ($ million)') + ylab('Expenses ($ million)') + ggtitle('Presidential Candidate Expenditures vs Income)') +
            theme_light() +
            geom_point() +
            geom_label(aes(label=Candidate))
        
    })
    
    output$dataPlotCash <- renderPlot({    
        
        t <- filter(df, CAND_PTY_AFFILIATION == input$party & TTL_RECEIPTS >= input$raisedMin & TTL_RECEIPTS <= input$raisedMax) %>%
            transmute(Candidate=CAND_NAME, 
                      Income_million=round(TTL_RECEIPTS*1.0/1000000,2), 
                      Disbursements_million=round(TTL_DISB*1.0/1000000,2), 
                      Cash_million=round(COH_COP*1.0/1000000,2)) 
        
        ggplot(t, aes(x=Cash_million, y=Disbursements_million)) +
            xlab('Ending Cash on Hand ($ million)') + ylab('Expenses ($ million)') + ggtitle('Presidential Candidate Expenditures vs Cash on Hand)') +
            theme_light() +
            geom_point() +
            geom_label(aes(label=Candidate))
        
    })
    
})