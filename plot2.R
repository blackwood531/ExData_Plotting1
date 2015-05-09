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
    with(frame,plot(datetime,active,type="l",
            xlab="",ylab="Global Active Power (kilowatts)",
            xaxt="n"
        )
    )
    
    ## create an x-axis with three tick marks (at midnight)
    ## the labels are computed from the timestamps
    daynames = strftime(days,"%a")
    axis(1,at=as.numeric(days),labels=daynames)
}

## show it on screen
plotOnCurrentDevice(feb,days)

## now create the png, in the repository for this assignment
png(file="../repos/ExData_Plotting1/plot2.png")
plotOnCurrentDevice(feb,days)
dev.off()