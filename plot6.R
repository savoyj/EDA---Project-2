## EDA Course Project 2
## Plot 6
## Question 6: Compare emissions from motor vehicle sources in Baltimore City 
## with emissions from motor vehicle sources in Los Angeles County, California 
## (fips == "06037"). Which city has seen greater changes over time in motor 
## vehicle emissions?
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

# Subset NEI_vehicle data to just Baltimore and add city name.
NEI_vehicles_Baltimore <- NEI_vehicles[fips == "24510",]
NEI_vehicles_Baltimore[, city := c("Baltimore City")]

# Subset NEI_vehicle data to just Los Angeles and add city name.
NEI_vehicles_LosAngeles <- NEI_vehicles[fips == "06037",]
NEI_vehicles_LosAngeles[, city := c("Los Angeles")]

# Combine NEI_vehicles_Baltimore & NEI_vehicles_LosAngeles into one table.
NEI_vehicles_Baltimore_and_LosAngeles <- rbind(NEI_vehicles_Baltimore,NEI_vehicles_LosAngeles)

# Establish parameters and save file with appropriate title.
png("plot6.png", width=480, height=480)

# Make plot.
ggplot(NEI_vehicles_Baltimore_and_LosAngeles, aes(x=factor(year), y=Emissions, fill=city)) +
        geom_bar(aes(fill=year),stat="identity") +
        facet_grid(scales="free", space="free", .~city) +
        labs(x="Year", y=expression("Total PM Emission (10^5 Tons)")) + 
        labs(title=expression("PM Motor Vehicle Source Emissions in Baltimore & Los Angeles, 1999-2008"))

# Dev off so you can see your exhibit. 
dev.off()