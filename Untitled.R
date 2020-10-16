rm(list=ls())
load(file="data_wave7.imp.Rdata")

wave7.imp <- subset(wave7.imp, implicat==1)

names(wave7.imp)

wave7.imp <- subset(wave7.imp,
             country == "Switzerland" )

summary(wave7.imp$thinc2)
 wave7.imp$month <- wave7.imp$thinc2/12
x 
summary(x)

wave7.imp$poverty.bn <- ifelse(wave7.imp$month < 2400, 1, 0)
prop.table(table(wave7.imp$poverty.bn))
