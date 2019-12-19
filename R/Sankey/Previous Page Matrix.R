# This script takes the output of GA.R (run that script first) and turns this into a matrix that can be used as input for Sankey diagrams.R

# Set working dir to dir of script
initial_wd = getwd()
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Add the list of pages that you want to see transitions between
pages = c("www.mysite.com/page1","www.mysite.com/page2","www.mysite.com/page3")

# Populate matrix based on ga.data
m = matrix(,nrow=length(pages),ncol=length(pages))
for(i in 1:nrow(m))
{
    for(j in 1:ncol(m))
    {
        m[i,j] = sum(ga.data[(ga.data$pagePath==pages[j]) & ga.data$previousPagePath==pages[i],"pageviews"])
    }
}

# Calculate dropoff for each page (all pageviews minus transitions to other pages)
m <- cbind(m, dropoff = NA)
for(i in 1:nrow(m))
{
  view_total = sum(ga.data[ga.data$pagePath==pages[i],"pageviews"])
  to_total = sum(ga.data[ga.data$previousPagePath==pages[i],"pageviews"])
  m[i,"dropoff"] = view_total - to_total
}

# Display final result
m

# Save result
write.csv(m, file="sankey_prep.csv", row.names=FALSE)

# Put working directory back
setwd(initial_wd)