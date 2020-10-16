############################################################################################
############################################################################################
####
#### Script name: SHARE data setup
#### Purpose of script: setup the data for the NTU analyses
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
#### Notes:
####
############################################################################################
############################################################################################

# Loading libraries -------------------------------------------------------
library(foreign)
library(reshape2)

# Loading datasets --------------------------------------------------------

#the following block contains the loading commands for my mac machine(s)
rm(list=ls())
load(file="data_wave7.activities.Rdata")
load(file="data_wave7.assets.Rdata")
load(file="data_wave7.basics.Rdata")
load(file="data_wave7.children.Rdata")
load(file="data_wave7.consumption.Rdata")
load(file="data_wave7.demo.Rdata")
load(file="data_wave7.fin.transfers.Rdata")
load(file="data_wave7.finance.Rdata")
load(file="data_wave7.gv.housing.Rdata")
load(file="data_wave7.healthcare.Rdata")
load(file="data_wave7.hh.Rdata")
load(file="data_wave7.imp.Rdata")
load(file="data_wave7.pensions.Rdata")h
load(file="data_wave7.tech.Rdata")
load(file="data_wave7.weights.Rdata")

# Looking at the data -----------------------------------------------------

#list all the available dataframes and look at the variables
ls()
names(wave7.assets)
names(wave7.basics)
names(wave7.children)
names(wave7.gv.housing)
names(wave7.hh)
names(wave7.imp)
names(wave7.pensions)
names(wave7.tech)

# Subsetting all the datasets for Switzerland  ----------------------------



# renaming the non-intuitive variable-names of the variables that  --------

#assets
wave7.hh$self.reported.hhinc <- wave7.hh$hh017e

#basics
wave7.pensions$sb.recipient <- wave7.pensions$ep671d2

#children
wave7.children$child1.where.living <- wave7.children$ch007_1
wave7.children$child2.where.living <- wave7.children$ch007_2
wave7.children$child3.where.living <- wave7.children$ch007_3
wave7.children$child4.where.living <- wave7.children$ch007_4
wave7.children$child5.where.living <- wave7.children$ch007_5

#housing

#household income

#imputed variables
wave7.imp$hhinc1 <- wave7.imp$thinc
wave7.imp$hhinc2 <- wave7.imp$thinc2

#technical variables
wave7.tech$nursinghome.interview <- wave7.tech$mn024_

#weights 
wave7.weights$cs.weights <- wave7.weights$cciw_w7_REG


# Taking appart the imputed dataset (currently all 6 simulated datasets in one gigantic dataframe --------

wave7.imp.hhinc1.wide <-
  dcast(wave7.imp, mergeid ~ implicat, value.var = "hhinc1")
head(wave7.imp.hhinc1.wide)
names(wave7.imp.hhinc1.wide) <- c(
  "mergeid",
  "hhinc1.imp1",
  "hhinc1.imp2",
  "hhinc1.imp3",
  "hhinc1.imp4",
  "hhinc1.imp5"
)
wave7.imp.hhinc2.wide <-
  dcast(wave7.imp, mergeid ~ implicat, value.var = "hhinc2")
names(wave7.imp.hhinc2.wide) <- c(
  "mergeid",
  "hhinc2.imp1",
  "hhinc2.imp2",
  "hhinc2.imp3",
  "hhinc2.imp4",
  "hhinc2.imp5"
)
wave7.imp.wide <- merge(wave7.imp.hhinc1.wide, wave7.imp.hhinc2.wide, by="mergeid")
head(wave7.imp.wide)
names(wave7.imp.wide)

#cleaning up 
rm(wave7.imp.hhinc1.wide)
rm(wave7.imp.hhinc2.wide)

#coherence check cause I've had massive problems with this merge at some point
summary(wave7.imp$hhinc1.imp1)
summary(wave7.imp$hhinc2.imp1)


# subsetting just the variables I need in each of these separate d --------

wave7.basics <-
  subset(wave7.basics,
    select = c(mergeid, country, gender, yrbirth, hhsize, age2017, partnerinhh)
  )

wave7.hh <-
  subset(wave7.hh, select = c(mergeid, self.reported.hhinc))

wave7.pensions <-
  subset(wave7.pensions, select = c(mergeid, sb.recipient))

wave7.weights <- #individual-level cross-sectional wave 7 weights
  subset(wave7.weights, select = c(mergeid, cs.weights))

wave7.tech <- #individual-level cross-sectional wave 7 weights
  subset(wave7.tech, select = c(mergeid, nursinghome.interview))

wave7.imp <-
  subset(wave7.imp, implicat==1, select = c(mergeid, hhinc1, hhinc2, thinc_f, thinc2_f))

wave7.children <-   subset(wave7.children, select = c(mergeid, child1.where.living, child2.where.living, child3.where.living, child4.where.living, child5.where.living))



# stepwise merging of the individual files using the static mergeid -------------------------------

df <- merge(wave7.basics, wave7.hh, by = "mergeid")
head(df)

df <- merge(df, wave7.weights, by = "mergeid")
head(df)

df <- merge(df, wave7.pensions, by = "mergeid")
head(df)

df <- merge(df, wave7.imp, by = "mergeid")
head(df)

df <- merge(df, wave7.imp.wide, by = "mergeid")
head(df)

df <- merge(df, wave7.tech, by = "mergeid")
head(df)

df <- merge(df, wave7.children, by = "mergeid")
head(df)
names(df)

# subset to Switzerland and only retirees aged 65 and older---------------------------------

length(which(is.na((df$age2017))))
df$age2017 <- as.character(df$age2017)
df$age2017 <- as.numeric(df$age2017)
summary(df$age2017)

df <- subset(df,
             country == "Switzerland" & age2017 >= 65)


#coherence checks 
summary(df$thinc_f)

  
  # Save the dataset  -------------------------------------------------------

save(df, file = "data_setup-out.Rdata")
