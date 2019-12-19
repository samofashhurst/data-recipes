# install.packages("RGoogleAnalytics")

library(RGoogleAnalytics)

VIEW_ID = "YOUR_VIEW_ID" # based on your Google Analytics view, e.g. ga:123456789
FILTERS = "YOUR_FILTERS" # examples at https://developers.google.com/analytics/devguides/reporting/core/v3/reference

# Create authentication token
token <- Auth(client.id,client.secret)

# Save the token object for future sessions
save(token,file="./token_file")

# In future sessions it can be loaded by running load("./token_file")
ValidateToken(token)

# Build a list of all the Query Parameters
query.list <- Init(start.date = "2019-11-30",
                   end.date = "2019-12-01",
                   dimensions = "ga:pagePath,ga:previousPagePath",
                   metrics = "ga:pageviews",
                   filters = FILTERS,
                   max.results = 10000,
                   sort = "-ga:date",
                   table.id = VIEW_ID)

# Create the Query Builder object so that the query parameters are validated
ga.query <- QueryBuilder(query.list)

# Extract the data and store it in a data-frame
ga.data <- GetReportData(ga.query, token, split_daywise = T, delay = 1)
ga.data