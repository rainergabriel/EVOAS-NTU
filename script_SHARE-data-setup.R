#setting up the SHARE data

library(foreign)

wave7.hh <-
  read.spss(
    file = "/Users/rainer/Dropbox/Documents/Work/ACTIVE/ZHAW/3_Research-Projects/EVOAS-Team/2_Daten und Analysen/Other-Datasets-Raw-Data/SHARE RawData/sharew7_rel7-1-0_ALL_datasets_spss/sharew7_rel7-1-0_hh.sav",
    to.data.frame = TRUE,
    reencode = "UTF-8",
    use.missings = TRUE
  )

wave7.tech <-
  read.spss(
    file = "/Users/rainer/Dropbox/Documents/Work/ACTIVE/ZHAW/3_Research-Projects/EVOAS-Team/2_Daten und Analysen/Other-Datasets-Raw-Data/SHARE RawData/sharew7_rel7-1-0_ALL_datasets_spss/sharew7_rel7-1-0_technical_variables.sav",
    to.data.frame = TRUE,
    reencode = "UTF-8",
    use.missings = TRUE
  )

wave7.gv.housing <-
  read.spss(
    file = "/Users/rainer/Dropbox/Documents/Work/ACTIVE/ZHAW/3_Research-Projects/EVOAS-Team/2_Daten und Analysen/Other-Datasets-Raw-Data/SHARE RawData/sharew7_rel7-1-0_ALL_datasets_spss/sharew7_rel7-1-0_gv_housing.sav",
    to.data.frame = TRUE,
    reencode = "UTF-8",
    use.missings = TRUE
  )

wave7.basics <-
  read.spss(
    file = "/Users/rainer/Dropbox/Documents/Work/ACTIVE/ZHAW/3_Research-Projects/EVOAS-Team/2_Daten und Analysen/Other-Datasets-Raw-Data/SHARE RawData/sharew7_rel7-1-0_ALL_datasets_spss/sharew7_rel7-1-0_cv_r.sav",
    to.data.frame = TRUE,
    reencode = "UTF-8",
    use.missings = TRUE
  )



# Looking at the data -----------------------------------------------------

names(wave7.tech)
names(wave7.gv.housing)

# Merge -------------------------------------------------------------------

#prepare to merge by subsetting just the variables I need
wave7.basics <-
  subset(wave7.basics, select = c(mergeid, country, hhsize, age2017))
wave7.hh <- subset(wave7.hh, select = c(mergeid, hh017e))

#merging using the static mergeid
df <- merge(wave7.basics, wave7.hh, by="mergeid")


# subset to Switzerland and only retirees ---------------------------------

df$age2017 <- as.character(df$age2017)
df$age2017 <- as.numeric(df$age2017)

df <- subset(df, 
             country=="Switzerland" & age2017>=65)


# Recodings ---------------------------------------------------------------

levels(df$hh017e)
rm.dk <- function (x) {sub(pattern="Don't know",x,replacement=NA)}
rm.refusal <- function (x) {sub(pattern="Refusal",x,replacement=NA)}


df$hh017e <- sapply(df$hh017e, rm.dk)
df$hh017e <- sapply(df$hh017e, rm.refusal)


# Save the dataset  -------------------------------------------------------

save(df, file="data_NTU-analyses.Rdata")


