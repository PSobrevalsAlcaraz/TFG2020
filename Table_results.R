## --- Generate a Table with the associations (.prsice files) generated of PRSice

cd /hpc/hers_en/psobrevals/Outcomes/Results/
cat /hpc/hers_en/psobrevals/PRS_bip/*yes.*PC10*prsi* > BIP_yes.prsice
cat /hpc/hers_en/psobrevals/PRS_bip/*no.*PC10*prsi* > BIP_no.prsice
cat /hpc/hers_en/psobrevals/PRS_scz/*no.*PC10*prsi* > SCZ_no.prsice
cat /hpc/hers_en/psobrevals/PRS_scz/*yes.*PC10*prsi* > SCZ_yes.prsice
cat /hpc/hers_en/psobrevals/PRS_mdd/*yes.*PC10*prsi* > MDD_yes.prsice
cat /hpc/hers_en/psobrevals/PRS_mdd/*no.*PC10*prsi* > MDD_no.prsice

edu <- read.table("/hpc/hers_en/psobrevals/Outcomes/Results/BIP_no.prsice",header=T,fill = T)
y <- which(edu[,2] == 0.01, edu,arr.ind=T)
scz_yes <- edu[y,]
scz_yes <- scz_yes[,-c(1,2,7)]
head(scz_yes)
write.table(scz_yes,"/hpc/hers_en/psobrevals/Outcomes/Results/BIP_no.results",row.names=F,quote=F)
edu <- read.table("/hpc/hers_en/psobrevals/Outcomes/Results/BIP_yes.prsice",header=T,fill = T)
y <- which(edu[,2] == 0.01, edu,arr.ind=T)
scz_yes <- edu[y,]
scz_yes <- scz_yes[,-c(1,2,7)]
head(scz_yes)
write.table(scz_yes,"/hpc/hers_en/psobrevals/Outcomes/Results/BIP_yes.results",row.names=F,quote=F)
edu <- read.table("/hpc/hers_en/psobrevals/Outcomes/Results/MDD_no.prsice",header=T,fill = T)
y <- which(edu[,2] == 0.05, edu,arr.ind=T)
scz_yes <- edu[y,]
scz_yes <- scz_yes[,-c(1,2,7)]
head(scz_yes)
write.table(scz_yes,"/hpc/hers_en/psobrevals/Outcomes/Results/MDD_no.results",row.names=F,quote=F)
edu <- read.table("/hpc/hers_en/psobrevals/Outcomes/Results/MDD_yes.prsice",header=T,fill = T)
y <- which(edu[,2] == 0.05, edu,arr.ind=T)
scz_yes <- edu[y,]
scz_yes <- scz_yes[,-c(1,2,7)]
head(scz_yes)
write.table(scz_yes,"/hpc/hers_en/psobrevals/Outcomes/Results/MDD_yes.results",row.names=F,quote=F)
edu <- read.table("/hpc/hers_en/psobrevals/Outcomes/Results/SCZ_no.prsice",header=T,fill = T)
y <- which(edu[,2] == 0.05, edu,arr.ind=T)
scz_yes <- edu[y,]
scz_yes <- scz_yes[,-c(1,2,7)]
head(scz_yes)
write.table(scz_yes,"/hpc/hers_en/psobrevals/Outcomes/Results/SCZ_no.results",row.names=F,quote=F)
edu <- read.table("/hpc/hers_en/psobrevals/Outcomes/Results/SCZ_yes.prsice",header=T,fill = T)
y <- which(edu[,2] == 0.05, edu,arr.ind=T)
scz_yes <- edu[y,]
scz_yes <- scz_yes[,-c(1,2,7)]
head(scz_yes)
write.table(scz_yes,"/hpc/hers_en/psobrevals/Outcomes/Results/SCZ_yes.results",row.names=F,quote=F)
