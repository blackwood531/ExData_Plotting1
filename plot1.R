## this script assumes that the data zip file for the assignment has already been
## downloaded into the working directory

colnames <- c("date","time","active","reactive","voltage","intensity","meter1","meter2","meter3")
colclasses <- c(rep("character",2),rep("numeric",7))

## read the whole dataset
elec <- read.csv2("household_power_consumption.txt",na.strings=c("?"),dec=".",col.names=colnames,colClasses=colclasses)

## get the subset for February 1 & 2, 2007
feb <- elec[elec$date == "1/2/2007" | elec$date == "2/2/2007",]

## plot 1
plotOnCurrentDevice <- function(frame) {
    hist(frame[!is.na(frame$active),3],
         col="red",
         xlab="Global Active Power (kilowatts)",
         main="Global Active Power"
    )
}

## show it on screen
plotOnCurrentDevice(feb)

## now create the png, in the repository for this assignment
png(file="../repos/ExData_Plotting1/plot1.png")
plotOnCurrentDevice(feb)
dev.off()