## EDA Course Project 2
## Plot 3
## Question 3: Of the four types of sources indicated by the type (point, 
## nonpoint, onroad, nonroad) variable, which of these four sources have seen 
## decreases in emissions from 1999–2008 for Baltimore City? Which have seen 
## increases in emissions from 1999–2008? Use the ggplot2 plotting system to 
## make a plot answer this question.
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

# Subset NEI data to just Baltimore.
NEI_baltimore <- NEI[fips=="24510",]

# Establish parameters and save file with appropriate title.
png("plot3.png", width=480, height=480)

# Make plot.
ggplot(NEI_baltimore,aes(factor(year),Emissions,fill=type)) +
        geom_bar(stat="identity") +
        theme_bw() + guides(fill=FALSE) +
        facet_grid(.~type,scales = "free",space="free") + 
        labs(x="Year", y=expression("Total PM 2.5 Emissions (Tons)")) + 
        labs(title=expression("PM 2.5 Emissions, Baltimore City 1999-2008 by Source Type"))

# Dev off so you can see your exhibit. 
dev.off()