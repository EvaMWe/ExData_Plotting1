library(sqldf)
graphics.off()
Sys.setlocale("LC_TIME", "C")

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#-----------------------------------------------
# download and unzip file using temporary storage
#-----------------------------------------------
if (!exists ("z")){
  temp <- tempfile()
  download.file(url, temp, mode ="wb")
  z <- unzip(temp)
  unlink(temp)
  rm(url, temp)
}


#----------------------------------------------
#read z filtered by SQL to reduce number of rows
#-----------------------------------------------
df <- read.csv.sql(file = z,
                      sql = "select * from file where Date ==  '2/2/2007' or Date == '1/2/2007' ", sep = ";" )
closeAllConnections()

#----------------------------------------------
#convert character strings to Date/Time classes in columns Date and Time
#-----------------------------------------------

df$Date <- as.Date (df$Date,format = "%d/%m/%Y")
df$Time <- format(strptime(df$Time, format = "%H:%M:%S"), format = "%H:%M:%S")
df$weekday <- format(df$Date, "%a")

png(file = "plot3.png")
with(df, plot(seq(1:length(df$Date)),Sub_metering_1, ylab = "Energy sub metering",  xlab = "", type = "l", xaxt="n"))
with(df, points(seq(1:length(df$Date)),Sub_metering_2,type = 'l', col = "red"))
with(df, points(seq(1:length(df$Date)),Sub_metering_3,type = 'l', col = "blue"))
axis(1, at = c(1, which(df$weekday == "Fri")[1],length(df$Date)), labels = c("Thu","Fri","Sat"))
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()




