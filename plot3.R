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

plotOnCurrentDevice <- function(frame) {
    ## create the plot, suppressing the x-axis,
    ## which will be created in the next statement
    with(frame,
         plot(1:nrow(feb),meter1,type="l",
            xlab="",ylab="Energy sub metering",
            xaxt="n"
        )
    )
    
    ## red line for the second meter
    with(frame,
        lines(1:nrow(feb),meter2,col="red")
    )
    
    ## blue line for the third meter
    with(frame,
         lines(1:nrow(feb),meter3,col="blue")
    )

    ## now the legend - boosting the line width seemed to make
    ## make the legend a little easier to read
    legend("topright",
           c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
           lty="solid",
           lwd=2,
           col=c("black","red","blue")
    )
    
    ## create an x-axis with three tick marks (at midnight)
    ## the labels are computed from the timestamps
    ## that way this script could work with other date ranges
    ## besides Feb 1-2, 2007, provided there are a full 1,440 
    ## points per day and we always start at midnight
    ticks <- which(sapply(1:(nrow(frame)+1),function(x)(x %% 1440)==1))
    axis(1,at=ticks,labels=strftime(frame$dt[1]+(ticks-1)*60+1,"%a"))

}

## show the plot on screen
plotOnCurrentDevice(feb)

## now create the png, in the repository for this assignment
png(file="../repos/ExData_Plotting1/plot3.png")
plotOnCurrentDevice(feb)
dev.off()