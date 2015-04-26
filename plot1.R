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

#Calculate total PM2.5 emission from all sources for each of the years
d <- aggregate(NEI$Emissions, by=list(year=NEI$year), FUN=sum, na.rm=TRUE)

# Open PNG device
png(filename = "plot1.png", width = 480, height = 480, units = "px")

# Draw bar chart of the total PM2.5 emission from all sources per each year
barplot(d$x / 1000, col="blue", names.arg=d$year,
    main="Total PM2.5 emission of United States", xlab="Year", ylab="kilotons")

# Close PNG device
dev.off()