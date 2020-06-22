#! /bash/bin/

module load plink/1.90

cd /hpc/hers_en/psobrevals/

### falta conspiracy al primer for

for j in comunication voice 
do 

 for i in {1..22}
 do

 plink --bfile QC_chr/ukb_chr${i}_QC --pheno bombari/healthy_${j}_ind.txt --keep bombari/yes_ind_keep.txt --assoc --out GWAS_PE/GWAS_${j}_chr${i}

 done

 cat GWAS_PE/GWAS_${j}_chr1.assoc  > bombari/GWAS_${j}.assoc

 for i in {2..22}
 do

 cat GWAS_PE/GWAS_${j}_chr${i}.assoc  >> bombari/GWAS_${j}.assoc

 done


done

######### GWAS half vision

for j in vision
do

for i in {1..22}
 do

 plink --bfile QC_chr/ukb_chr${i}_QC --pheno bombari/healthy_${j}_ind.txt --keep bombari/yes_ind_3034_2.txt --assoc --out GWAS_PE/GWAS_${j}_half_chr${i}

 done

 cat GWAS_PE/GWAS_${j}_half_chr1.assoc  > bombari/GWAS_half_${j}.assoc

 for i in {2..22}
 do

 cat GWAS_PE/GWAS_${j}_half_chr${i}.assoc  >> bombari/GWAS_half_${j}.assoc

 done

done


########## GWAS all PE


cd /hpc/hers_en/psobrevals

 for i in {1..22}
 do

 plink --bfile QC_chr/ukb_chr${i}_QC --pheno bombari/phe_PE_yn.txt  --keep bombari/PE_yn.txt --assoc --out GWAS_PE/GWAS_PE_chr${i}

 done

 cat GWAS_PE/GWAS_PE_chr${i}.assoc  > bombari/GWAS_PE.assoc

 for i in {2..22}
 do

 cat GWAS_PE/GWAS_PE_chr${i}.assoc  >> bombari/GWAS_PE.assoc

 done




R

vis <- read.table("/hpc/hers_en/psobrevals/bombari/GWAS_half_vision.assoc", header=T)
a <- which(vis[,1] == "CHR", vis, arr.ind=T)
via <- vis[-a,]
write.table(via,"/hpc/hers_en/psobrevals/GWAS_PE/GWAS_half_vision.assoc", row.names=F)

q()

cat /hpc/hers_en/psobrevals/GWAS_PE/GWAS_half_vision.assoc | tr -d '"' > /hpc/hers_en/psobrevals/GWAS_PE/GWAS_half_vision
rm /hpc/hers_en/psobrevals/GWAS_PE/GWAS_half_vision.assoc

