############################################################################################
############################################################################################
####
#### Script name: SHARE data validation 
#### Purpose of script: compare SHARE variables with BFS study (Guggisberg et al., 2014)
#### Date Created: 2020-10-13
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
#### Notes: Link to BFS study: https://bit.ly/3lJM1wm
#### 
############################################################################################
############################################################################################

# Loading libraries -------------------------------------------------------
library(foreign)

# Loading data ------------------------------------------------------------
rm(list=ls())
load(file="data_NTU-analyses.Rdata")

# Looking at the data  ----------------------------------------------------

names(df)
table(df$hhinc.imp1)


# Calculating Equivalized Household Income --------------------------------

#defining a function that calculates the hhincome based on hhsize
equivalizing.income <- function (hhincome, hhsize) {
  #x is unequalized household income 
  #y is household size 
  if (hhsize==1) {print(hhincome)} else {
   numer.of.other.hh.members <- (hhsize-1)
    equiv.hhincome <- hhincome/(numer.of.other.hh.members * 0.7)
    print(equiv.hhincome)}
}


df$equiv.hhinc <- ifelse(df$hhsize==1, df$hhinc.imp1, df$hhinc.imp1/((df$hhsize-1) * 0.7))
df$equiv.hhinc.month <- df$equiv.hhinc/12

df$poverty.bn <- ifelse(df$equiv.hhinc.month<2400,1,0)
prop.table(table(df$poverty.bn))

#using OECD methodology to calculate equivalized household income 

head(df)

#this is the household income variable in the dataset
wave7.gen$thinc


