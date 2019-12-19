# This script queries Salesforce for leadhistory/accounthistory changes
# Could easily be adapted for other queries

library(salesforcer)
library(dplyr)

sf_auth()

# Set OBJECT to "lead" or "account" based on which object history you're interested in
OBJECT = "lead"

# Create a list for the date range you want
NUM_DAYS = 184
dates <- seq(as.Date("2019/06/01"), by = "day", length.out = NUM_DAYS)

lead_source_changes = tibble()

# Loop through each day so each query is manageable
for(i in 1:NUM_DAYS) {
    if(i %% 5 == 0){
        cat(i)
    } else {
        cat(".")
    }
    if(i < NUM_DAYS){
        if(OBJECT == "lead") {
            str = "select leadid, createddate, field, oldvalue, newvalue, lead.createddate, lead.country
                   from leadhistory
                   where createddate >= %s and createddate < %s
                   and field = 'LeadSource'
                   order by createddate asc"
        } else {
            str = "select accountid, createddate, field, oldvalue, newvalue, account.createddate, account.billingcountry
                   from accounthistory
                   where createddate >= %s and createddate < %s
                   and field = 'Lead_Source__c'
                   order by createddate asc"
        }
    
        # Split each day into two queries to make sure they succeed
        from_date_1 <- paste(dates[i],"T00:00:00.000+0000",sep="")
        to_date_1 <- paste(dates[i],"T12:00:00.000+0000",sep="")
        query <- sprintf(str, from_date_1, to_date_1)
        results_1 <- sf_query(query)
        
        from_date_2 <- paste(dates[i],"T12:00:00.000+0000",sep="")
        to_date_2 <- paste(dates[i+1],"T00:00:00.000+0000",sep="")
        query <- sprintf(str, from_date_2, to_date_2)
        results_2 <- sf_query(query)
        
        # Concatenate results
        lead_source_changes <- bind_rows(lead_source_changes, results_1, results_2)
    }   
}

# Output changes as csv (edit filename before running)
# May want to set working directory first (?setwd)
if(OBJECT == "lead") {
    write.csv(lead_source_changes,"lead-lead_source_changes_0106-30112.csv", row.names = FALSE, na="")
} else {
    write.csv(lead_source_changes,"account-lead_source_changes_0106-3011.csv", row.names = FALSE, na="")
}