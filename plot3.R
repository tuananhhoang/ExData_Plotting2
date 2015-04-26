library(ggplot2)

# Load PM2.5 Emissions Data and unzip it if either Source_Classification_Code.rds 
# or summarySCC_PM25.rds does not exist
if (!("Source_Classification_Code.rds" %in% list.files()) |
    !("summarySCC_PM25.rds" %in% list.files())) {
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
              destfile="exdata-data-NEI_data.zip", method="curl", extra="-k")
    unzip("exdata-data-NEI_data.zip")
}

# Data loading
NEI <- readRDS("summarySCC_PM25.rds")

# Filter PM2.5 emission data for the Baltimore City, Maryland (fips == "24510")
NEI <- NEI[NEI$fips == "24510",]

#Calculate total PM2.5 emission from all sources for each of the years divided by each type
d <- aggregate(NEI$Emissions, by=list(type=NEI$type, year=NEI$year), FUN=sum, na.rm=TRUE)

# Open PNG device
png(filename = "plot3.png", width = 480, height = 480, units = "px")

# Draw the required plot
print(ggplot(data=d, aes(x=factor(year), y=x, fill=type)) 
    + geom_bar(stat="identity", position=position_dodge())
	+ labs(x = "Year")
	+ labs(y = "Tons")
	+ labs(title = "Total PM2.5 emission of the Baltimore City, Maryland, US"))

# Close PNG device
dev.off()