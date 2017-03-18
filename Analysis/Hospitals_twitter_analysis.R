####################Twitter hospitals data analysis. Spain vs USA#####################
## Extraction of two data files, representation, ANOVA analysis and comparisons.

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
library(scales)

## We save this theme to apply in the following graphs
theme_new <- theme(plot.background = element_rect(size = 1, color = muted("blue"), fill = "#B7EBD9"),
        axis.text.y = element_text(colour = muted("red")),
        axis.text.x = element_text(colour = muted("blue")),
        panel.background = element_rect(fill = "pink"),
        strip.background = element_rect(fill = "#800000"))

## Histogram of the 3 main variables: tweets, followers and following.
PlotUSA1 = ggplot(HospUSA, aes(x = Tweets)) + geom_histogram(col="#800000", fill="#CC0000") + theme_new + scale_x_continuous(name="Nº Tweets") + scale_y_continuous(name="Nº Cuentas",limits=c(0,100)) + ggtitle("USA")
PlotUSA2 = ggplot(HospUSA, aes(x = Followers)) + geom_histogram(col="#800000", fill="#CC0000") + theme_new + scale_x_continuous(name="Nº Seguidores") + scale_y_continuous(name="Nº Cuentas",limits=c(0,100)) + ggtitle("USA")
PlotUSA3 = ggplot(HospUSA, aes(x = Following)) + geom_histogram(col="#800000", fill="#CC0000") + theme_new+ scale_x_continuous(name="Nº Siguiendo") + scale_y_continuous(name="Nº Cuentas",limits=c(0,100)) + ggtitle("USA")

## We got some outliers. We discard those to analyse them afterwards and represent again.
Tweets2 = HospUSA[which(HospUSA$Tweets<20000),]
PlotUSA4 = ggplot(Tweets2, aes(x = Tweets)) + geom_histogram(col="#800000", fill="#CC0000") + theme_new + scale_x_continuous(name="Nº Tweets") + scale_y_continuous(name="Nº Cuentas",limits=c(0,100)) + ggtitle("USA")
Followers2 = HospUSA[which(HospUSA$Followers<20000),]
PlotUSA5 = ggplot(Followers2, aes(x = Followers)) + geom_histogram(col="#800000", fill="#CC0000") + theme_new + scale_x_continuous(name="Nº Seguidores") + scale_y_continuous(name="Nº Cuentas",limits=c(0,100)) + ggtitle("USA")

## We transform the time variable to years and see when they started their activity on twitter
HospUSA$CreationDate = 1900 + (HospUSA$CreationDate/365)
PlotUSA6 = ggplot(HospUSA, aes(x = HospUSA$CreationDate)) + geom_histogram(col="#800000", fill="#CC0000") + theme_new + scale_x_continuous(breaks=c(2007,2010,2013,2016), name="Fecha de creación") + scale_y_continuous(name="Nº Cuentas",limits=c(0,100)) + ggtitle("USA")

## Hospitals data SPAIN
## Data visualization
Tweets3 = HospSPAIN[which(HospSPAIN$Tweets<20000),]
Followers3 = HospSPAIN[which(HospSPAIN$Followers<20000),]

PlotSPAIN1 = ggplot(Tweets3, aes(x = Tweets)) + geom_histogram(col="#000080", fill="#0000cc") + theme_new + scale_x_continuous(name="Nº Tweets") + scale_y_continuous(name="Nº Cuentas",limits=c(0,100)) + ggtitle("España")
PlotSPAIN2 = ggplot(Followers3, aes(x = Followers)) + geom_histogram(col="#000080", fill="#0000cc") + theme_new + scale_x_continuous(name="Nº Seguidores") + scale_y_continuous(name="Nº Cuentas",limits=c(0,100)) + ggtitle("España")
PlotSPAIN3 = ggplot(HospSPAIN, aes(x = Following)) + geom_histogram(col="#000080", fill="#0000cc") + theme_new + scale_x_continuous(name="Nº Siguiendo") + scale_y_continuous(name="Nº Cuentas",limits=c(0,100)) + ggtitle("España")
HospSPAIN$CreationDate = 1900 + (HospSPAIN$CreationDate/365)
PlotSPAIN6 = ggplot(HospSPAIN, aes(x = CreationDate)) + geom_histogram(col="#000080", fill="#0000cc") + theme_new + scale_x_continuous(breaks=c(2007,2010,2013,2016), name="Fecha de creación") + scale_y_continuous(name="Nº Cuentas",limits=c(0,100)) + ggtitle("España")

## Comparison graphics
library(gridExtra)
grid.arrange(PlotUSA4, PlotUSA5, PlotSPAIN1, PlotSPAIN2, nrow=2, ncol=2)
grid.arrange(PlotUSA6, PlotSPAIN6, nrow=1, ncol=2)

## BoxPlots
## Joining the tables
factorSPAIN = c(rep("SPAIN",167))
factorUSA = c(rep("USA",385))
Country = as.factor(c(factorSPAIN,factorUSA))

HospUSA2 = HospUSA[,3:6]
HospSPAIN2 = HospSPAIN[,2:5]
HospBoth = rbind(HospSPAIN2,HospUSA2)
Table1 = cbind.data.frame(HospBoth,Country)

Table2 = Table1[which(Table1$Followers<20000),]
Table3 = Table1[which(Table1$Tweets<20000),]

ggplot(Table1, aes(x = Country, y = Tweets)) + geom_boxplot() + theme_new + scale_fill_continuous(label=comma)
ggplot(Table1, aes(x = Country, y = Followers)) + geom_boxplot() + theme_new + scale_fill_continuous(label=comma)
ggplot(Table1, aes(x = Country, y = Following)) + geom_boxplot() + theme_new + scale_fill_continuous(label=comma)
ggplot(Table1, aes(x = Country, y = CreationDate)) + geom_boxplot() + theme_new + scale_fill_continuous(label=comma)

#########################ANOVA ANALYSIS#########################
## WITH OUTLIERS

anova(lm(Tweets ~ Country, data=Table1))
anova(lm(Followers ~ Country, data=Table1))
anova(lm(Following ~ Country, data=Table1))
anova(lm(CreationDate ~ Country, data=Table1))

## WITHOUT OUTLIERS

anova(lm(Tweets ~ Country, data=Table3))
anova(lm(Followers ~ Country, data=Table2))

## ADDITIONAL SCATTER PLOTS TO INVESTIGATE CREATION DATE DIFFERENCE

PlotBoth1 = ggplot(Table2, aes(x = CreationDate, y = Followers, colour = Country)) + geom_point(alpha = 0.5, size = 1.5) + theme_new + scale_x_continuous(breaks=c(2007,2010,2013,2016), limit=c(2007,2017.5), name="Fecha de creación") + scale_y_continuous(name="Nº Seguidores")  + scale_color_manual(values = c("blue", "#CC0000")) + ggtitle("Pais")
PlotBoth2 = ggplot(Table1, aes(x = CreationDate, y = Following, colour = Country)) + geom_point(alpha = 0.5, size = 1.5) + theme_new + scale_x_continuous(breaks=c(2007,2010,2013,2016), limit=c(2007,2017.5), name="Fecha de creación") + scale_y_continuous(name="Nº Siguiendo") + scale_color_manual(values = c("blue", "#CC0000")) + ggtitle("Pais")
PlotBoth3 = ggplot(Table3, aes(x = CreationDate, y = Tweets, colour = Country)) + geom_point(alpha = 0.5, size = 1.5) + theme_new + scale_x_continuous(breaks=c(2007,2010,2013,2016), limit=c(2007,2017.5), name="Fecha de creación") + scale_y_continuous(name="Nº Tweets") + scale_color_manual(values = c("blue", "#CC0000")) + ggtitle("Pais")

grid.arrange(PlotBoth1, PlotBoth2, PlotBoth3, nrow=2, ncol=2)