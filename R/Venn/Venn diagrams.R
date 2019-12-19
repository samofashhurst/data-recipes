# Use the venn package to make up to 7-way Venn diagrams
# install.packages("venn")

library(venn)

# Get Features
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
df <- read.csv("venn template.csv", header = TRUE)

# Put in correct format
x <- data.frame(df$Group.1,df$Group.2,df$Group.3,df$Group.4,df$Group.5,df$Group.6,df$Group.7)
colnames(x) <- c("Group 1","Group 2","Group 3","Group 4","Group 5","Group 6","Group 7")

# Make diagram
venn(x, ilab=TRUE, zcolor="style", cexil = 0.8, cexsn = 1, borders = FALSE, size=3)