
# Get Data

## if data directory doesn´t exist, create
if (!file.exists("data")) {
        dir.create("data")
}

## if data doesn´t exist, download and unzip
if (!file.exists("data/EPC.zip")) {
        fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        zipfile <- "data/EPC.zip"
        download.file(fileURL, destfile = zipfile)
        unzip(zipfile, exdir = "data")
}

## read data
df <- read.table("data/household_power_consumption.txt", header = TRUE, 
                 sep = ";", na.strings = c("?"), colClasses = c("character", 
                                                                "character", 
                                                                "numeric", 
                                                                "numeric",
                                                                "numeric",
                                                                "numeric",
                                                                "numeric",
                                                                "numeric",
                                                                "numeric"))
## subset data
subdf <- df[grep("^[1,2]/2/2007", df$Date),]

## create new variable combining date and time
subdf$DateTime <- as.POSIXct(paste(subdf$Date, subdf$Time), 
                             format="%d/%m/%Y %H:%M:%S")

## open png device
png("plot2.png")

## create plot
with(subdf, plot(DateTime, 
                 Global_active_power, 
                 type = "l", 
                 xlab = "", 
                 ylab = "Global Active Power (kilowatts)"
                 )
     )

## close device connection
dev.off()
