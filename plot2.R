## EDA Course Project 2
## Plot 2
## Question 2: Have total emissions from PM2.5 decreased in the Baltimore City, 
## Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to 
## make a plot answering this question.
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

# Subest to Baltimore
totalNEI_baltimore <- NEI[fips=='24510', lapply(.SD, sum, na.rm = TRUE)
                          , .SDcols = c("Emissions")
                          , by = year]

# Establish parameters and save file with appropriate title.
png("plot2.png", width=480, height=480)

# Make plot.
barplot(totalNEI_baltimore[, Emissions]
        , names = totalNEI[, year]
        , xlab = "Years", ylab = "Emissions"
        , main = "Emissions in Baltimore City, Maryland")

# Dev off so you can see your exhibit. 
dev.off()