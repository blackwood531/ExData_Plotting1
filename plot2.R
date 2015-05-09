## this script assumes that the data zip file for the assignment has already been
## downloaded into the working directory

colnames <- c("date","time","active","reactive","voltage","intensity","meter1","meter2","meter3")
colclasses <- c(rep("character",2),rep("numeric",7))

## read the whole dataset
elec <- read.csv2("household_power_consumption.txt",na.strings=c("?"),dec=".",col.names=colnames,colClasses=colclasses)

## get the subset for February 1 & 2, 2007
feb <- elec[elec$date %in% c("1/2/2007","2/2/2007"),]

## convert the date and time strings to actual dates
feb <- transform(feb,dt=strptime(paste(date,time),"%d/%m/%Y %H:%M:%S"))

## create the plot, suppressing the x-axis,
## which will be created in the next statement
with(feb,plot(1:nrow(feb),active,type="l",
        xlab="",ylab="Global Active Power (kilowatts)",
        xaxt="n"
        ))

## create an x-axis with three tick marks (at midnight)
## the labels are computed from the timestamps
## that way this script could work with other date ranges
## besides Feb 1-2, 2007
ticks <- which(sapply(1:(nrow(feb)+1),function(x)(x %% 1440)==1))
axis(1,at=ticks,labels=strftime(feb$dt[1]+(ticks-1)*60+1,"%a"))

## copy to png, in the repository for this assignment
dev.copy(png,file="../repos/ExData_Plotting1/plot2.png")
dev.off()