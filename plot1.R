library(sqldf)
graphics.off()

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




hist(df$Global_active_power, col = "red",main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.copy(png, file = 'plot1.png', width = 480, height = 480)
dev.off()

