## EDA Course Project 2
## Plot 5
## Question 5: How have emissions from motor vehicle sources changed from 
## 1999–2008 in Baltimore City?
################################################################################

library("data.table")
library("ggplot2")

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

# Subset NEI data to just motor vehicle sources.
SCC_vehicles <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case=TRUE)
NEI_vehicles <- NEI[NEI[, SCC] %in% SCC_vehicles]

# Identify records with vehicles and subset.
vehicles <- grepl(pattern = "vehicle",x = SCC$SCC.Level.Two,ignore.case = TRUE)
SCC_vehicles <- SCC[vehicles,]$SCC
NEI_vehicles <- NEI[NEI$SCC %in% SCC_vehicles,]

# Subset NEI_vehicle data to just Baltimore.
NEI_vehicles_Baltimore <- NEI_vehicles[fips=="24510",]

# Establish parameters and save file with appropriate title.
png("plot5.png", width=480, height=480)

# Make plot.
ggplot(NEI_vehicles_Baltimore,aes(factor(year),Emissions)) +
        geom_bar(stat="identity", fill ="#666699" ,width=0.75) +
        labs(x="Year", y=expression("Total PM Emission (10^5 Tons)")) + 
        labs(title=expression("PM 2.5 Motor Vehicle Source Emissions in Baltimore from 1999-2008"))

# Dev off so you can see your exhibit. 
dev.off()