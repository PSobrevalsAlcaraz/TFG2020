#! /bin/bash

module load plink/1.90
module load R/3.5.1
module load rstudio/1.0.136

cd /hpc/hers_en/mbombari/ukbb_genetic/GWAS/

## --- Extract and clean GWAS summary statistics

R
# SCZ
library("SciViews")
rawS <- read.table("/hpc/hers_en/molislagers/LDSC/summary_statistics/psychiatric_diseases/SCZ/final_sumstats/clozuk_pgc2.meta.sumstats.only_rs.rs_col.header.txt",header = T)
SCZ_merge <- rawS
SCZ_merge$Beta <-  ln(SCZ_merge$OR)
#SCZ_merge <- SCZ_merge[SCZ_merge$P<=0.05,]
SCZ_merge <- SCZ_merge[SCZ_merge$Freq.A1 >= 0.1,]
SCZ_merge$A1.y <- NULL
SCZ_merge$A2.y <- NULL
SCZ_merge$SNP <- NULL
colnames(SCZ_merge)[1]<- "SNP"
colnames(SCZ_merge)[6]<- "MAF"
head(SCZ_merge)
i = "SCZ"
write.table(SCZ_merge, paste("/hpc/hers_en/psobrevals/",i,".sumstats.Transformed", sep = ""), quote=F, row.names=F)



#BIP
library("SciViews")
rawB <- read.table("/hpc/hers_en/molislagers/LDSC/summary_statistics/psychiatric_diseases/BIP/ntot_daner_PGC_BIP32b_mds7a_0416a",header = T)
i = "BIP.sumstats.gz"
BIP_merge$Beta <-  ln(BIP_merge$OR)
#BIP_merge <- BIP_merge[BIP_merge$P<=0.05,]
BIP_merge <- BIP_merge[BIP_merge$INFO >= 0.9,]
head(BIP_merge)
i = sub(".sumstats.gz", "", i)
write.table(BIP_merge, paste("/hpc/hers_en/psobrevals/",i,".sumstats.Transformed", sep = ""), quote=F, row.names=F)



#MDD
library("SciViews")
rawMD <- read.table("/hpc/hers_en/molislagers/LDSC/summary_statistics/psychiatric_diseases/MDD/DS_10283_3203/PGC_UKB_depression_genome-wide.txt",header = T)
colnames(rawMD) <- c("SNP", "A1","A2", "MAF", "Beta", "SE", "P")
rawMD[,2] <- toupper(rawMD[,2])
rawMD[,3] <- toupper(rawMD[,3])
MDD_merge <- merge(dat,rawMD, by = c("SNP","A1","A2"))
MDD_merge <- MDD_merge[MDD_merge$MAF >= 0.01,]
i= "MDD"
write.table(MDD_merge, paste("/hpc/hers_en/psobrevals/GWAS_mitchell/",i,".sumstats.Transformed", sep = ""), quote=F, row.names=F)




q()
