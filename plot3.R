## this script assumes that the data zip file for the assignment has already been
## downloaded into the working directory

colnames <- c("date","time","active","reactive","voltage","intensity","meter1","meter2","meter3")
colclasses <- c(rep("character",2),rep("numeric",7))

## read the whole dataset
elec <- read.csv2("household_power_consumption.txt",na.strings=c("?"),dec=".",col.names=colnames,colClasses=colclasses)

## get the subset for February 1 & 2, 2007
## not the most efficient, but makes the date+time values nice and clean
day1 = strptime("2007-02-01","%Y-%m-%d")
day2 = strptime("2007-02-02","%Y-%m-%d")
day3 <- day2 + 86400 # 86,400 seconds/day
days <- c(day1,day2,day3)        # will come in handy later

## convert all of the date + time data into datetime values
datetime <- strptime(paste(elec$date,elec$time),"%d/%m/%Y %H:%M:%S")

## make a list of the ones we want
selected <- which(datetime>=day1 & datetime<day3)

## create a new dataframe with just the data we want
feb <- cbind(datetime[selected],elec[selected,3:9])

## make the column name less clunky
colnames(feb)[1] = "datetime"

plotOnCurrentDevice <- function(frame,days) {
    ## create the plot, suppressing the x-axis,
    ## which will be created in the next statement
    with(frame,
         plot(datetime,meter1,type="l",
            xlab="",ylab="Energy sub metering",
            xaxt="n"
        )
    )
    
    ## red line for the second meter
    with(frame,
        lines(datetime,meter2,col="red")
    )
    
    ## blue line for the third meter
    with(frame,
         lines(datetime,meter3,col="blue")
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
    daynames = strftime(days,"%a")
    axis(1,at=as.numeric(days),labels=daynames)
}

## show the plot on screen
plotOnCurrentDevice(feb,days)

## now create the png, in the repository for this assignment
png(file="../repos/ExData_Plotting1/plot3.png")
plotOnCurrentDevice(feb,days)
dev.off()