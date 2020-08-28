## EDA Course Project 2
## Plot 1
## Question 1: Have total emissions from PM2.5 decreased in the United States from 1999 
## to 2008? Using the base plotting system, make a plot showing the total PM2.5 
## emission from all sources for each of the years 1999, 2002, 2005, and 2008.
################################################################################

library("data.table")

# Download, unzip, and read in Data for Peer Assignment.
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, file.path(path, "data.zip"))
unzip(zipfile = "data.zip")
data <- readRDS("summarySCC_PM25.rds")
classification <- readRDS("Source_Classification_Code.rds")

# Take a look at the data to make sure it unzipped correctly and is usable.
head(data)

# Read tables in data frame.
NEI <- data.table(data)
SCC <- data.table(classification)

# Prevents histogram from printing in scientific notation.
NEI[, Emissions := lapply(.SD, as.numeric), .SDcols = c("Emissions")]

totalNEI <- NEI[, lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]

# Establish parameters and save file with appropriate title.
png("plot1.png", width=480, height=480)

# Make plot.
barplot(totalNEI[, Emissions]
        , names = totalNEI[, year]
        , xlab = "Years", ylab = "Emissions"
        , main = "Emissions decreasing from 1999 to 2008")

# Dev off so you can see your exhibit. 
dev.off()