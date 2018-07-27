# Load lubridate package

library(lubridate)

# Download data from the source and unzip files 

URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(URL, destfile = "./Householdpowerconsumption.zip")
unzip("Householdpowerconsumption.zip", overwrite = TRUE)


housepower <- read.csv2("household_power_consumption.txt", header = TRUE, nrows = 1, stringsAsFactors = FALSE)
start <- dmy_hms(paste(housepower$Date, housepower$Time))
end <- dmy_hms(paste("1/2/2007", "00:01:00"))

# calculate date difference until 01/02/2007

where_to_start <- as.period(interval(start, end), unit = "minute")
where_to_start <- as.numeric(where_to_start, "minutes") 

# Read data from the dates2007-02-01 and 2007-02-02 

housepower <- read.csv2("household_power_consumption.txt", header = FALSE, skip = where_to_start, dec = ".",
                        nrows = (2 * 24 * 60) + 1, stringsAsFactors = FALSE, na.strings = "?", 
                        colClasses = c(rep("character",2), rep("numeric", 7)),
                        col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power",
                                      "Voltage", "Global_intensity", "Sub_metering_1", 
                                      "Sub_metering_2", "Sub_metering_3"))

# Convert character dates to date types

dates <- housepower$Date
times <- housepower$Time
x <- paste (dates,times)
housepower$Date <- as.POSIXct(strptime(x, "%d/%m/%Y %H:%M:%S"))

png(filename = "plot4.png", width = 480, height = 480)
par(mfcol = c(2, 2))

#plot graph2

with(housepower, plot(Date, Global_active_power, type = "l", xlab = "", ylab ="Global Active Power"))

#plot graph3

with(housepower, plot(Date, Sub_metering_1, type = "l", col = "black", xlab ="", ylab="Energy sub metering"))
with(housepower, lines(Date, Sub_metering_2, type = "l", col = "red"))
with(housepower, lines(Date, Sub_metering_3, type = "l", col = "blue"))
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"), bty = "n",  lty = 1, cex = 0.6)

#plot Voltage graph 
with(housepower, plot(Date, Voltage, type = "l", xlab = "datetime", ylab ="Voltage"))

#plot Reactive power graph
with(housepower, plot(Date, Global_reactive_power, type = "l", xlab = "datetime", ylab ="Global_reactive_power"))
dev.off()
