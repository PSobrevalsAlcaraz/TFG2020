## LINEAR REGRESSION

Outcomes <- c("Accomodation_environment","Alcohol_nonbinary","Wellbeing_nonbinary", "SES")

GWAS <- c("SCZ", "BIP","MDD")

for (outcome in Outcomes) {

files <- list.files(path="/hpc/hers_en/psobrevals/Outcomes", pattern=paste("*",outcome,"*",sep=""), full.names=TRUE, recursive=FALSE)

for (gwas in GWAS) {

yes_file <- files[endsWith(files, "_yes.txt")]
outcome_yes <- read.table(yes_file, header=T)
out <- sub("/hpc/hers_en/psobrevals/Outcomes/","",yes_file)
PRS_y <- read.table(paste("/hpc/hers_en/psobrevals/PRS_extracted/PRSICE_",gwas,"_",out,"_PC10.all.score",sep=""), header=T)
cov_y <- read.table("/hpc/hers_en/psobrevals/bombari/cov_sex_age.txt", header=T)
colnames(PRS_y)[3] <- "PRS"

fdf <- merge(outcome_yes,PRS_y, by = c("FID","IID"))
fdf <- merge(fdf,cov_y, by = c("FID","IID"))
fdf <- as.data.frame(fdf)
fdf$SEX <- factor(fdf$SEX)

model_yes <- lm(fdf$PHE ~ fdf$PRS + fdf$PC1+ fdf$PC2 + fdf$PC3 + fdf$PC4 + fdf$PC5 + fdf$PC6 + fdf$PC7 + fdf$PC8 + fdf$PC9 + fdf$PC10 + fdf$SEX + fdf$AGE)
print("PE:")
print(out)
print(gwas)

print(summary(model_yes))

no_file <- files[endsWith(files, "_no.txt")]
outcome_no <- read.table(no_file, header=T)
out_n <- sub("/hpc/hers_en/psobrevals/Outcomes/","",no_file)
PRS_n <- read.table(paste("/hpc/hers_en/psobrevals/PRS_extracted/PRSICE_",gwas,"_",out_n,"_PC10.all.score",sep=""), header=T)
cov_n <- read.table("/hpc/hers_en/psobrevals/bombari/cov_sex_age_no.txt", header=T)
colnames(PRS_n)[3] <- "PRS"

fnf <- merge(outcome_no,PRS_n, by = c("FID","IID"))
fnf <- merge(fnf,cov_n, by = c("FID","IID"))
fnf <- as.data.frame(fnf)
fnf$SEX <- factor(fnf$SEX)

model_no <- lm(fnf$PHE ~ fnf$PRS + fnf$PC1+ fnf$PC2 + fnf$PC3 + fnf$PC4 + fnf$PC5 + fnf$PC6 + fnf$PC7 + fnf$PC8 + fnf$PC9 + fnf$PC10 + fnf$SEX + fnf$AGE)
print("nonPE:")
print(out_n)
print(gwas)
print(summary(model_no))

}
}


## LOGISTIC REGRESSION
library(sizeMat)

Outcomes <- c( "Accomodation_type","Cannabis", "Confide", "Depression", "Education", "Employment", "GAD", "Leisure", "SelfHarmed",
"Smoking", "Visit", "Worthliving")

GWAS <- c("SCZ", "BIP","MDD")

for (outcome in Outcomes) {

files <- list.files(path="/hpc/hers_en/psobrevals/Outcomes", pattern=paste("*",outcome,"*",sep=""), full.names=TRUE, recursive=FALSE)

for (gwas in GWAS) {

yes_file <- files[endsWith(files, "_yes.txt")]
outcome_yes <- read.table(yes_file, header=T)
out <- sub("/hpc/hers_en/psobrevals/Outcomes/","",yes_file)
PRS_y <- read.table(paste("/hpc/hers_en/psobrevals/PRS_extracted/PRSICE_",gwas,"_",out,"_PC10.all.score",sep=""), header=T)
cov_y <- read.table("/hpc/hers_en/psobrevals/bombari/cov_sex_age.txt", header=T)
colnames(PRS_y)[3] <- "PRS"
outcome_yes[,3] <- outcome_yes[,3] - 1
#outcome_yes <- na.omit(outcome_yes)
#outcome_yes[,3] <- as.logical(outcome_yes[,3])

fdf <- merge(outcome_yes,PRS_y, by = c("FID","IID"))
fdf <- merge(fdf,cov_y, by = c("FID","IID"))
fdf <- as.data.frame(fdf)

model_yes <- glm(fdf$PHE ~ fdf$PRS + fdf$PC1+ fdf$PC2 + fdf$PC3 + fdf$PC4 + fdf$PC5 + fdf$PC6 + fdf$PC7 + fdf$PC8 + fdf$PC9 + fdf$PC10 + fdf$SEX + fdf$AGE,family = 'binomial')
print("PE:")
print(out)
print(gwas)

print(summary(model_yes))
print(nagelkerkeR2(model_yes))
model_null <- glm(fdf$PHE~1, family = 'binomial') 
print(anova(model_null, model_yes, test = 'Chisq'))


no_file <- files[endsWith(files, "_no.txt")]
outcome_no <- read.table(no_file, header=T)
out_n <- sub("/hpc/hers_en/psobrevals/Outcomes/","",no_file)
PRS_n <- read.table(paste("/hpc/hers_en/psobrevals/PRS_extracted/PRSICE_",gwas,"_",out_n,"_PC10.all.score",sep=""), header=T)
cov_n <- read.table("/hpc/hers_en/psobrevals/bombari/cov_sex_age_no.txt", header=T)
colnames(PRS_n)[3] <- "PRS"
outcome_no[,3] <- outcome_no[,3] - 1
#outcome_no <- na.omit(outcome_no)
#outcome_no[,3] <- as.logical(outcome_no[,3])

fnf <- merge(outcome_no,PRS_n, by = c("FID","IID"))
fnf <- merge(fnf,cov_n, by = c("FID","IID"))
fnf <- as.data.frame(fnf)

model_no <- glm(fnf$PHE ~ fnf$PRS + fnf$PC1+ fnf$PC2 + fnf$PC3 + fnf$PC4 + fnf$PC5 + fnf$PC6 + fnf$PC7 + fnf$PC8 + fnf$PC9 + fnf$PC10 + fnf$SEX + fnf$AGE, family='binomial')
print("nonPE:")
print(out_n)
print(gwas)
print(summary(model_no))

print(nagelkerkeR2(model_no))
model_nullo <- glm(fnf$PHE~1, family = 'binomial')
print(anova(model_nullo, model_no, test = 'Chisq'))


}
}


