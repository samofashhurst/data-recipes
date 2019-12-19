# This script creates a Sankey diagram, which can be used e.g. for seeing common paths between pages during a browser session
# install.packages("networkD3")

library(networkD3)

# Set working dir to dir of script
initial_wd = getwd()
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Add names for the pages in the flow
my_nodes <- c('Page 1','Page 2','Page 3','Drop-off')
nodes <- data.frame(node=c(0:(length(my_nodes)-1)),name=my_nodes)

# Load the page transition data: this should be a matrix of frequencies where rows represent 'from' pages
# and columns represent 'to' pages
temp = read.csv("sankey_prep.csv")
temp<-as.matrix(temp)
dimnames(temp)<-NULL

# Create empty dataframe
df<-data.frame(source=integer(),target=integer(),value=integer())

# For each combination of row and column, add one more row to the dataframe with source, target and value
for(i in 1:nrow(temp))
{
    for(j in 1:ncol(temp))
    {
        # Note that source/target must be zero-indexed for JavaScript to render the plot
        df[nrow(df)+1,] = list(i-1,j-1,temp[i,j])
    }
}

# Create Sankey diagram
n = networkD3::sankeyNetwork(Links = df, Nodes = nodes, 
                         Source = 'source', 
                         Target = 'target', 
                         Value = 'value', 
                         NodeID = 'name',
                         units = 'pageviews', fontSize = 14, nodeWidth = 20)

# Save plot as html, and render onscreen
saveNetwork(n, "sankey.html", selfcontained = TRUE)
n

# Put working directory back
setwd(initial_wd)