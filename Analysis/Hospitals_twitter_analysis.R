## Twitter hospitals data analysis. Spain vs USA
## Extraction of two data files, representation and comparison. Simple and advanced techniques.

## Data extraction
file.choose()
HospUSA = read.csv2("C:\\Users\\nacho\\Desktop\\Twitter analysis\\Tweets_USA.csv")
HospSPAIN = read.csv2("C:\\Users\\nacho\\Desktop\\Twitter analysis\\Tweets_SPAIN.csv")

## We can check the data is extracted correctly
rbind(head(HospUSA), tail(HospUSA))
rbind(head(HospSPAIN), tail(HospSPAIN))

## Hospitals data USA
## Data visualization
library(ggplot2)
## Histogram of the 3 main variables: tweets, followers and following.
PlotUSA1 = ggplot(HospUSA, aes(x = Tweets)) + geom_histogram()
PlotUSA2 = ggplot(HospUSA, aes(x = Followers)) + geom_histogram()
PlotUSA3 = ggplot(HospUSA, aes(x = Following)) + geom_histogram()

## We got some outliers. We discard those to analyse them afterwards and represent again.
Tweets2 = HospUSA[which(HospUSA$Tweets<20000),]
PlotUSA4 = ggplot(Tweets2, aes(x = Tweets)) + geom_histogram()
Followers2 = HospUSA[which(HospUSA$Followers<20000),]
PlotUSA5 = ggplot(Followers2, aes(x = Followers)) + geom_histogram()

## We transform the time variable to years and see when they started their activity on twitter
Hosp.years = 1900 + (HospUSA[6]/365)
PlotUSA6 = ggplot(Hosp.years, aes(x = Hosp.years)) + geom_histogram() + scale_x_continuous(breaks=c(2007,2010,2013,2016))

## Hospitals data SPAIN
## Data visualization
Tweets3 = HospSPAIN[which(HospSPAIN$Tweets<20000),]
Followers3 = HospSPAIN[which(HospSPAIN$Followers<20000),]

PlotSPAIN1 = ggplot(Tweets3, aes(x = Tweets)) + geom_histogram()
PlotSPAIN2 = ggplot(Followers3, aes(x = Followers)) + geom_histogram()
PlotSPAIN3 = ggplot(HospSPAIN, aes(x = Following)) + geom_histogram()


## Graphics comparison
##More than 1 plot in a window
library(gridExtra)
grid.arrange(PlotUSA4, PlotUSA5, PlotSPAIN1, PlotSPAIN2, nrow=2, ncol=2)
