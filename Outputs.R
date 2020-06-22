## To create the output files:
data_y <- read.csv("/hpc/hers_en/shared/Paula_Carina2/data_y.csv",header=T)
library("plyr")
yes <- read.table("/hpc/hers_en/psobrevals/bombari/yes_ind_QC.txt",header=T)

## Use Carina_Make_output file
i = #Outcome variable
out <- cbind(data_y[,2],data_y[,2],i)
colnames(out) <- c("FID","IID","PHE")
head(out)
table(out[,3])

out[,3] <- out[,3] + 1

write.table(out, paste("/hpc/hers_en/psobrevals/Outcomes/",i,"_no.txt", sep=""),quote=F, row.names=F)

out <- as.data.frame(out)
out[is.na(out)] <- 0




## TO OPERATE ON ALL OUTPUT FILES AT ONCE:

files <- list.files(path="/hpc/hers_en/psobrevals/Outcomes", pattern="*no.txt", full.names=TRUE, recursive=FALSE)
 no <- read.table("/hpc/hers_en/psobrevals/bombari/no_ind.txt",header=T)
 lapply(files, function(x) {
 t <- read.table(x, header=TRUE) 
 f <- cbind(no[,1:2],t[,3])
 colnames(f) <- c("FID","IID","PHE")
 write.table(f,x, quote=FALSE, row.names=FALSE, col.names=TRUE)
 })

files <- list.files(path="/hpc/hers_en/psobrevals/Outcomes", pattern="*yes.txt", full.names=TRUE, recursive=FALSE)
 yes <- read.table("/hpc/hers_en/psobrevals/bombari/yes_ind_QC.txt",header=T)
 lapply(files, function(x) {
 t <- read.table(x, header=TRUE)
 f <- cbind(yes[,1:2],t[,3])
 colnames(f) <- c("FID","IID","PHE")
 write.table(f,x, quote=FALSE, row.names=FALSE, col.names=TRUE)
 })
