#! /bin/bash/

module load plink/1.90
module load R/3.5.1
module load rstudio/1.0.136


R

library(robustbase)

yes.ind <- read.csv("/hpc/hers_en/shared/Bombari_Paula/ukbb/data/Real_data/yes_ind.csv", header = T)[,-1]
data.i <- read.csv("/hpc/hers_en/shared/Bombari_Paula/ukbb/data/Generated_data/data_y.csv", header = T)
data.y <- as.matrix(data.i)
col.names <- colnames(data.y)

######  COVariates file

# 1 PCA 5
pc <- grep("22009",col.names)[1:5]
pca <- as.matrix(yes.ind)
data.1 <- data.y[,2]
data.1 <- cbind(data.y[,2],data.1)
data.1 <- cbind(data.1, data.i[,pc])
colnames(data.1) <- c("FID", "IID", "PC1","PC2","PC3","PC4","PC5")
ind_qc <- read.table("/hpc/hers_en/psobrevals/bombari/yes_ind_QC.txt",header= T)
cov_qc <- merge(ind_qc,data.1, by = c("FID","IID"))
write.table(cov_qc,file = "/hpc/hers_en/psobrevals/bombari/ind_qc_cov.txt",row.names = F)



###### SEX CHECK
p_sex <- grep("f31_",col.names)[1]
g_sex <- grep("22001",col.names)

sex <- as.matrix(yes.ind)
sex_check <- data.y[,2]
sex_check <- cbind(data.y[,2],sex_check)
sex_check <- cbind(sex_check, data.i[,p_sex])
sex_check <- cbind(sex_check, data.i[,g_sex])
colnames(sex_check) <- c("FID", "IID", "pheno_sex","geno_sex")
miss <- as.numeric(sex_check[,3] == sex_check[,4])
sex_check <- cbind(sex_check,miss)
sex_check <- sex_check[sex_check[,5]=="0", ]
sex_check <- na.omit(sex_check)
sex_check <- sex_check[,1:2]
ind_qc <- read.table("/hpc/hers_en/psobrevals/bombari/yes_ind_QC.txt",header= T)
sex_qc <- merge(ind_qc,sex_check, by = c("FID","IID"))
write.table(sex_qc,file = "/hpc/hers_en/psobrevals/bombari/sex_qc.txt",row.names = F)

######  INFO SCORE > 0.8 MAF score > 0.01

chr <- seq(1,22,1)
for (c in chr){
  mfi <- read.table(paste("/hpc/ukbiobank/genetic_v3/ukb_mfi_chr",c,"_v3.txt",sep= ""),  header = F)
  INFO_0.8 <- which(mfi$V8 <= 0.8, arr.ind = T)
  snps_info <- as.matrix(mfi[INFO_0.8,2])
  MAF_0.01 <- which(mfi$V6 <= 0.01, arr.ind = T)
  snps_maf <- as.matrix(mfi[MAF_0.01,2])
  info_maf_merge <- rbind(snps_info,snps_maf)
  info_maf_merge <- unique(info_maf_merge)
  write.table(info_maf_merge, paste("/hpc/hers_en/psobrevals/bombari/exclude_chr",c,"_info_maf.txt",sep=""),row.names=F,col.names=F)
}
q()

cd /hpc/hers_en/psobrevals/bombari/

rm exclude_info_maf.txt

for i in {1..22}
do
cat exclude_chr${i}_info_maf.txt >> exclude_info_maf.txt
done


rm -r exclude_chr*

R
ex <- read.table("/hpc/hers_en/psobrevals/bombari/exclude_info_maf.txt",  header = F)
ex <- cbind(ex,ex)
colnames(ex) <- c("FID","IID")
write.table(ex, "/hpc/hers_en/psobrevals/bombari/exclude_info_maf.txt",row.names=F)
q()

rm exclude_info08_maf001.txt
cat exclude_info_maf.txt | tr -d '"' > exclude_info08_maf001.txt
