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
SCC <- readRDS("Source_Classification_Code.rds")

# Filter PM2.5 emission data for the Baltimore City, Maryland (fips == "24510")
NEI <- NEI[NEI$fips == "24510",]

# Filter motor vehicle sources which means having Data.Category = "Onroad"
SCC <- SCC[grepl("Onroad", SCC$Data.Category),]
NEI <- NEI[NEI$SCC %in% SCC$SCC,]

#Calculate total PM2.5 emission from all sources for each of the years
d <- aggregate(NEI$Emissions, by=list(year=NEI$year), FUN=sum, na.rm=TRUE)

# Open PNG device
png(filename = "plot5.png", width = 680, height = 480, units = "px")

# Draw the required plot
barplot(d$x, col="blue", names.arg=d$year,
    main="Total PM2.5 emission of motor vehicle sources across the Baltimore City, Maryland, US", 
	xlab="Year", ylab="Tons")

# Close PNG device
dev.off()