library(ggplot2)
library(plyr)

## EXTRACT THE pT
# Choose the GWAS and the p-Threshold
# if gwas = BIP --> Select column 0.005 from "full" file (pT = 0.01)
# if gwas = SCZ --> Select column 0.05 from "full" file (pT = 0.05)
# if gwas = MDD --> Select column 0.05 from "full" file (pT = 0.05)

gwas <- "MDD"

files <- list.files(path="/hpc/hers_en/psobrevals/PRS_signif", pattern=paste("*",gwas,"*",sep=""), full.names=TRUE, recursive=FALSE)
lapply(files, function(x) {
    full <- read.table(x, header=TRUE) # load file
    extract2 <-	cbind(full$FID,full$IID,full$X0.05)
    colnames(extract2) <- c("FID","IID","0.05")
    y <- sub("/hpc/hers_en/psobrevals/PRS_signif/", "", x)
    # write to file
    write.table(extract2, paste("/hpc/hers_en/psobrevals/PRS_extracted/",y,sep=""), sep="\t", quote=FALSE, row.names=FALSE, col.names=TRUE)
})


## Outcomes list

# Full list:       Outcomes <- c("Accomodation_environment", "Accomodation_type","Alcohol_nonbinary", "Cannabis", "Confide", "Depression", "Education", "Employment", "GAD", "Leisure", "SelfHarmed", 
"SES", "Smoking", "Visit", "Wellbeing_nonbinary","Worthliving")

# Choose outcome:
Outcome <- "Cannabis"

# Call next function:
Create_error_plots(Outcome)

## FUNCTION TO COMPUTE BARPLOTS

Create_error_plots <- function(Outcomes) {

library(ggplot2)
library(plyr)

for(outc in Outcomes){

files <- list.files(path="/hpc/hers_en/psobrevals/Outcomes", pattern=paste("*",outc,"*",sep=""), full.names=TRUE, recursive=FALSE)

## Yes files

yes_file <- files[endsWith(files, "_yes.txt")]
outcome_yes <- read.table(yes_file, header=T)
out <- sub("/hpc/hers_en/psobrevals/Outcomes/","",yes_file)
PRS_y <- read.table(paste("/hpc/hers_en/psobrevals/PRS_extracted/PRSICE_",gwas,"_",out,"_PC10.all.score",sep=""), header=T)
final_yes <- merge(PRS_y, outcome_yes, by = c("FID","IID"))
colnames(final_yes)[3] <- "PRS"

cc = quantile(final_yes$PRS, c(.25, .75))
cc <- as.matrix(cc)
final_yes <- cbind(final_yes,rep(0,nrow(final_yes)))
colnames(final_yes)[5] <- "QQ"
cc25 <- which(final_yes$PRS <= cc[1,1],final_yes, arr.ind=T)
final_yes[cc25,5] <- "Low"
cc75 <- which(final_yes$PRS >= cc[2,1],final_yes, arr.ind=T)
final_yes[cc75,5] <- "High"
cci <- which(final_yes[,5] == "0",final_yes, arr.ind=T)
final_yes[cci,5] <- "Intermediate"
final_yes <- cbind(rep("PE",nrow(final_yes)), final_yes)
colnames(final_yes)[1] <- "GROUP"


## No files

no_file <- files[endsWith(files, "_no.txt")]
outcome_no <- read.table(no_file, header=T)
outn <- sub("/hpc/hers_en/psobrevals/Outcomes/","",no_file)
PRS_n <- read.table(paste("/hpc/hers_en/psobrevals/PRS_extracted/PRSICE_",gwas,"_",outn,"_PC10.all.score",sep=""), header=T)
final_no <- merge(PRS_n, outcome_no, by = c("FID","IID"))
colnames(final_no)[3] <- "PRS"

qq = quantile(final_no$PRS, c(.25, .75))
qq <- as.matrix(qq)
final_no <- cbind(final_no,rep(0,nrow(final_no)))
colnames(final_no)[5] <- "QQ"
qq25 <- which(final_no$PRS <= qq[1,1],final_no, arr.ind=T)
final_no[qq25,5] <- "Low"
qq75 <- which(final_no$PRS >= qq[2,1],final_no, arr.ind=T)
final_no[qq75,5] <- "High"
qqi <- which(final_no[,5] == "0",final_no, arr.ind=T)
final_no[qqi,5] <- "Intermediate"
final_no <- cbind(rep("noPE",nrow(final_no)), final_no)
colnames(final_no)[1] <- "GROUP"

## Join files

final_all <- rbind(final_no,final_yes)
final_all$PHE[final_all$PHE == "-9"] <- "NA"
final_all <- final_all[complete.cases(final_all), ]
if (typeof(final_all$PHE) == "character") {
   options(digits=4)
   final_all$PHE <- as.double(final_all$PHE)
}

data_summary <- function(data, varname, groupnames){
  require(plyr)
  summary_func <- function(x, col){
    c(mean = mean(x[[col]], na.rm=TRUE),
      sd = sd(x[[col]], na.rm=TRUE))
  }
  data_sum<-ddply(data, groupnames, .fun=summary_func,
                  varname)
  data_sum <- rename(data_sum, c("mean" = varname))
 return(data_sum)
}

to_plot <- data_summary(na.omit(final_all), varname="PHE",
                    groupnames=c("GROUP", "QQ"))
to_plot$QQ=as.factor(to_plot$QQ)

## Error plots
y_lab_name <- sub("_yes.txt","",out)
y_lab_name <- sub("_nonbinary","",y_lab_name)

p<- ggplot(na.omit(to_plot), aes(x=QQ, y=PHE, group=GROUP, color=GROUP)) +
 geom_errorbar(aes(ymin=PHE-sd, ymax=PHE+sd),width=.2,position=position_dodge(0.5)) +
 geom_line(position=position_dodge(0.5)) +
 geom_point(position=position_dodge(0.5)) +
 labs(title=paste("PRS ",gwas,sep=""), x="Polygenetic risk", y = y_lab_name)+
 theme_classic() +
 scale_x_discrete(limits=c("Low","Intermediate","High")) +
 scale_color_manual(values=c('darkblue','green'))

print(p)


}
}



