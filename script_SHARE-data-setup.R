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

# Loading datasets --------------------------------------------------------

#the following block contains the loading commands for my mac machine(s)

wave7.basics <-
  #basic information on participants (share calls this "coverscreen")
  read.spss(
    file = "/Users/rainer/Dropbox/Documents/Work/ACTIVE/ZHAW/3_Research-Projects/EVOAS-Team/2_Daten und Analysen/Other-Datasets-Raw-Data/SHARE RawData/sharew7_rel7-1-0_ALL_datasets_spss/sharew7_rel7-1-0_cv_r.sav",
    to.data.frame = TRUE,
    reencode = "UTF-8",
    use.missings = TRUE
  )

wave7.tech <- #technical variables
  read.spss(
    file = "/Users/rainer/Dropbox/Documents/Work/ACTIVE/ZHAW/3_Research-Projects/EVOAS-Team/2_Daten und Analysen/Other-Datasets-Raw-Data/SHARE RawData/sharew7_rel7-1-0_ALL_datasets_spss/sharew7_rel7-1-0_technical_variables.sav",
    to.data.frame = TRUE,
    reencode = "UTF-8",
    use.missings = TRUE
  )

wave7.weights <- #cross-sectional weights
  read.spss(
    file = "/Users/rainer/Dropbox/Documents/Work/ACTIVE/ZHAW/3_Research-Projects/EVOAS-Team/2_Daten und Analysen/Other-Datasets-Raw-Data/SHARE RawData/sharew7_rel7-1-0_ALL_datasets_spss/sharew7_rel7-1-0_gv_weights.sav",
    to.data.frame = TRUE,
    reencode = "UTF-8",
    use.missings = TRUE
  )

wave7.hh <- #household incomes
  read.spss(
    file = "/Users/rainer/Dropbox/Documents/Work/ACTIVE/ZHAW/3_Research-Projects/EVOAS-Team/2_Daten und Analysen/Other-Datasets-Raw-Data/SHARE RawData/sharew7_rel7-1-0_ALL_datasets_spss/sharew7_rel7-1-0_hh.sav",
    to.data.frame = TRUE,
    reencode = "UTF-8",
    use.missings = TRUE
  )

wave7.gv.housing <- #generated variables housing
  read.spss(
    file = "/Users/rainer/Dropbox/Documents/Work/ACTIVE/ZHAW/3_Research-Projects/EVOAS-Team/2_Daten und Analysen/Other-Datasets-Raw-Data/SHARE RawData/sharew7_rel7-1-0_ALL_datasets_spss/sharew7_rel7-1-0_gv_housing.sav",
    to.data.frame = TRUE,
    reencode = "UTF-8",
    use.missings = TRUE
  )

wave7.imp <- #all imputed variables
  read.spss(
    file = "/Users/rainer/Dropbox/Documents/Work/ACTIVE/ZHAW/3_Research-Projects/EVOAS-Team/2_Daten und Analysen/Other-Datasets-Raw-Data/SHARE RawData/sharew7_rel7-1-0_ALL_datasets_spss/sharew7_rel7-1-0_gv_imputations.sav",
    to.data.frame = TRUE,
    reencode = "UTF-8",
    use.missings = TRUE
  )


# Looking at the data -----------------------------------------------------

names(wave7.imp)
names(wave7.tech)
names(wave7.gv.housing)

# Pre-Merge manipulations -------------------------------------------------

#Taking appart the imputed dataset (all 6 simulated datasets are in one df)
wave7.imp1 <- subset(wave7.imp, implicat==1)
wave7.imp2 <- subset(wave7.imp, implicat==2)
wave7.imp3 <- subset(wave7.imp, implicat==3)
wave7.imp4 <- subset(wave7.imp, implicat==4)
wave7.imp5 <- subset(wave7.imp, implicat==5)
wave7.imp6 <- subset(wave7.imp, implicat==6)

#subsetting just the variables I need in each of the separate frames
wave7.basics <-
  subset(wave7.basics, select = c(mergeid, country, hhsize, age2017, partnerinhh))

wave7.hh <- subset(wave7.hh, select = c(mergeid, hh017e))

wave7.weights <- #individual-level cross-sectional wave 7 weights
  subset(wave7.weights, select = c(mergeid, cciw_w7_REG))

wave7.imp1 <- subset(wave7.imp1, select = c(mergeid, thinc, thinc2))
wave7.imp2 <- subset(wave7.imp2, select = c(mergeid, thinc, thinc2))
wave7.imp3 <- subset(wave7.imp3, select = c(mergeid, thinc, thinc2))
wave7.imp4 <- subset(wave7.imp4, select = c(mergeid, thinc, thinc2))
wave7.imp5 <- subset(wave7.imp5, select = c(mergeid, thinc, thinc2))
wave7.imp6 <- subset(wave7.imp6, select = c(mergeid, thinc, thinc2))


#stepwise merging using the static mergeid
df <- merge(wave7.basics, wave7.hh, by = "mergeid")
head(df)

df <- merge(df, wave7.weights, by = "mergeid")
head(df)

df <- merge(df, wave7.imp1, by = "mergeid")
names(df)[ncol(df):(ncol(df)-1)] <- c("hhinc.imp1","hhinc2.imp1")
head(df)

df <- merge(df, wave7.imp2, by = "mergeid")
names(df)[ncol(df):(ncol(df)-1)] <- c("hhinc.imp2","hhinc2.imp2")
head(df)

# subset to Switzerland and only retirees aged 65 and older---------------------------------

df$age2017 <- as.character(df$age2017)
df$age2017 <- as.numeric(df$age2017)
summary(df$age2017)

df <- subset(df,
             country == "Switzerland" & age2017 >= 65)

# Recodings ---------------------------------------------------------------

levels(df$hh017e)
rm.dk <- function (x) {
  sub(pattern = "Don't know", x, replacement = NA)
}
rm.refusal <- function (x) {
  sub(pattern = "Refusal", x, replacement = NA)
}

df <- lapply(df, rm.dk)
df$hh017e <- sapply(df$hh017e, rm.refusal)
df$hh017e <- as.numeric(df$hh017e)


# Save the dataset  -------------------------------------------------------

save(df, file = "data_NTU-analyses.Rdata")
