
############################################################################################
############################################################################################
####
#### Script name: recoding creating vars
#### Purpose of script: setting up all the variables for the following analyses
#### Date Created: 2020-10-15
#### ---------------------------------------------------------------------------------------
####   ＿＿＿＿＿＿＿__＿＿
####  |￣￣￣￣￣￣￣￣￣￣|
####  | Created by         |
####  |  Rainer Gabriel    |
####  | Have a             |
####  |      nice day      |
####  |＿＿＿＿＿＿＿__＿＿|
####  (\__/)||
####  (•ㅅ•)||
####  / 　 づ
#### Email: rainer.gabriel@zhaw.ch
#### --------------------------------
####
#### Notes: 
####
############################################################################################
############################################################################################

# Loading libraries -------------------------------------------------------
library(foreign)
library(stargazer)
library(questionr)


# Loading data ------------------------------------------------------------
rm(list = ls())
load(file = "data_setup-out.Rdata")


# Setting up variables  ---------------------------------------------------

#Creating a dummy variable whether a child lives at home 
levels(df$child1.where.living)  

df$child1.inhh <- ifelse(is.na(df$child1.where.living),0,ifelse(as.factor(df$child1.where.living)=="In the same household",1,0))
table(df$child1.inhh)

df$child2.inhh <- ifelse(is.na(df$child2.where.living),0,ifelse(as.factor(df$child2.where.living)=="In the same household",1,0))
table(df$child2.inhh)

df$child3.inhh <- ifelse(is.na(df$child3.where.living),0,ifelse(as.factor(df$child3.where.living)=="In the same household",1,0))
table(df$child3.inhh)

df$child4.inhh <- ifelse(is.na(df$child4.where.living),0,ifelse(as.factor(df$child4.where.living)=="In the same household",1,0))
table(df$child4.inhh)

df$child5.inhh <- ifelse(is.na(df$child5.where.living),0,ifelse(as.factor(df$child5.where.living)=="In the same household",1,0))
table(df$child5.inhh)

#how many children live in hh
df$number.children1to4.inhh <- df$child1.inhh+df$child2.inhh+df$child3.inhh+df$child4.inhh+df$child5.inhh
table(df$number.children1to4.inhh)


# creating the factor for the OECD equivalization  ------------------------

df$equivalization.factor <- 1

x <- which(df$nursinghome.interview=="Nursing home" & df$partnerinhh=="No")
length(x)
df$equivalization.factor[x]<- 1

x <- which(df$nursinghome.interview=="Nursing home" & df$partnerinhh=="Yes")
length(x)
df$equivalization.factor[x]<- 1.5

x <- which(df$hhsize==1)
length(x)
df$equivalization.factor[x]<-1

x2 <- which(df$hhsize==2 & df$partnerinhh=="Yes") 
length(x2)
df$equivalization.factor[x2]<-1.5

x3 <- which(df$hhsize==3 & df$partnerinhh=="Yes" & df$number.children1to4.inhh==1) 
length(x3)
x3 <- which(df$hhsize==3 & df$partnerinhh=="No" & df$number.children1to4.inhh==2) 
length(x3)
x3 <- which(df$hhsize==4 & df$number.children1to4.inhh==3) 
length(x3)

summary(df$equivalization.factor)

z <- which(is.na(df$equivalization.factor))
table(df$hhsize[z])

names(df)
table(df$hhsize)
table(df$hhsize,df$partnerinhh)
table(df$hhsize, df$nursinghome.interview)
table(df$hhsize, df$number.children.inhh)

# levels(df$hh017e)
# rm.dk <- function (x) {
#   sub(pattern = "Don't know", x, replacement = NA)
# }
# rm.refusal <- function (x) {
#   sub(pattern = "Refusal", x, replacement = NA)
# }
#
# df <- lapply(df, rm.dk)
# df$hh017e <- sapply(df$hh017e, rm.refusal)
# df$hh017e <- as.numeric(df$hh017e)
# ## => THIS BIT DOESN`T WORK YET `


#### Calculating Equivalized Household Income 

#



df$equiv.hhinc <- df$hhinc2.imp1/df$equivalization.factor
summary(df$equiv.hhinc)

hist(df$equiv.hhinc)

df$equiv.hhinc.month <- df$equiv.hhinc/12 
summary(df$equiv.hhinc.month)

prop.table( wtd.table(x = df$equiv.hhinc.month, weights = df$cs.weights, na.rm = TRUE))



df$poverty.bn <- ifelse(df$equiv.hhinc.month < 2400, 1, 0)
prop.table(table(df$poverty.bn))



df$self.reported.hhinc


rm.dk <- function (x) {
  sub(pattern = "Don't know", x, replacement = NA)
}
rm.refusal <- function (x) {
  sub(pattern = "Refusal", x, replacement = NA)
}

df <- lapply(df, rm.dk)
df <- lapply(df, rm.refusal)

df$self.reported.hhinc <- as.numeric(df$self.reported.hhinc)
## => THIS BIT DOESN`T WORK YET `
summary(df$self.reported.hhinc)

df$poverty.bn.self <- ifelse(df$self.reported.hhinc < 2400, 1, 0)


prop.table(table(df$poverty.bn.self))


# Saving ------------------------------------------------------------------

save(df, file="data_recoding-creating-vars-OUT.Rdata")
