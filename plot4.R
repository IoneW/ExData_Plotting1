
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
png("plot4.png")

## set 2 by 2 array for plots
par(mfrow = c(2, 2))

#plot1
with(subdf, plot(DateTime, 
                 Global_active_power, 
                 type = "l", 
                 xlab = "", 
                 ylab = "Global Active Power"
)
)

#plot2
with(subdf, plot(DateTime, 
                 Voltage, 
                 type = "l", 
                 xlab = "datetime", 
                 ylab = "Voltage"
)
)

#plot3
with(subdf, plot(DateTime,
                 Sub_metering_1,
                 type = "n", 
                 xlab = "", 
                 ylab = "Energy sub metering"
)
)
lines(subdf$DateTime, subdf$Sub_metering_1)
lines(subdf$DateTime, subdf$Sub_metering_2, col = "red")
lines(subdf$DateTime, subdf$Sub_metering_3, col = "blue")
legend("topright", 
       lty = c(1,1,1), 
       col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       bty = "n")

#plot4
with(subdf, plot(DateTime, 
                 Global_reactive_power, 
                 type = "l", 
                 xlab = "datetime", 
                 ylab = "Global_reactive_power"
)
)

## close device connection
dev.off()
