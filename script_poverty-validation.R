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
library(stargazer)
library(questionr)

# Loading data ------------------------------------------------------------
rm(list = ls())
load(file = "data_recoding-creating-vars-OUT.Rdata")

# Looking at the data  ----------------------------------------------------




prop.table(table(df$el.dummy))
prop.table(wtd.table(x = df$el.dummy, weights = df$cciw_w7_REG))


prop.table(table(df$ep671d2, df$poverty.bn))

#brutal dirty recode
levels(df$ep671d2)
df$el.dummy <- ifelse(df$ep671d2 == "Selected", 1, 0)

m1 <- glm(poverty.bn ~ el.dummy, family = "binomial", data = df)
summary(m1)
stargazer(m1, type = "text")
#using OECD methodology to calculate equivalized household income

head(df)

#this is the household income variable in the dataset
wave7.gen$thinc
