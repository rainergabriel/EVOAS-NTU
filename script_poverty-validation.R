##########################################################################################
##########################################################################################
##
## Script name: SHARE data validation 
##
## Purpose of script: compare SHARE key variables with with BFS study (Guggisberg et al., 2014)
##   ＿＿＿＿＿＿＿__＿＿
##  |￣￣￣￣￣￣￣￣￣￣| 
##  | Created by         |
##  |  Rainer Gabriel    | 
##  | Have a             | 
##  |      nice day      | 
##  |＿＿＿＿＿＿＿__＿＿| 
##  (\__/)|| 
##  (•ㅅ•)|| 
##  / 　 づ
##
## Date Created: 2020-10-13
##
## Email: rainer.gabriel@zhaw.ch
##
## ---------------------------
##
## Notes: Link to BFS study: https://bit.ly/3lJM1wm
## 
##########################################################################################
##########################################################################################

rm(list=ls())
load(file="data_NTU-analyses.Rdata")

source(file="script_SHARE-data-setup.R", echo=TRUE)

# Looking at the data  ----------------------------------------------------

summary(df$hh017)

#equivalizing the income 

#using OECD methodology to calculate equivalized household income 

head(df)

#this is the household income variable in the dataset
wave7.gen$thinc


