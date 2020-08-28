## EDA Course Project 2
## Plot 4
## Question 4: Across the United States, how have emissions from coal 
## combustion-related sources changed from 1999–2008?
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

# Subset NEI data to coal combustion-related sources.
combustion_related <- grepl("comb", SCC[, SCC.Level.One], ignore.case=TRUE)
coal_related <- grepl("coal", SCC[, SCC.Level.Four], ignore.case=TRUE) 
SCC_combustion <- SCC[combustion_related & coal_related, SCC]
NEI_combustion <- NEI[NEI[,SCC] %in% SCC_combustion]

# Establish parameters and save file with appropriate title.
png("plot4.png", width=480, height=480)

# Make plot.
ggplot(NEI_combustion,aes(x = factor(year),y = Emissions/10^5)) +
        geom_bar(stat="identity", fill ="#666699", width=0.75) +
        labs(x="Year", y=expression("Total PM 2.5 Emissions (10^5 Tons)")) + 
        labs(title=expression("PM 2.5 Coal Combustion Source Emissions in US from 1999-2008"))

# Dev off so you can see your exhibit. 
dev.off()