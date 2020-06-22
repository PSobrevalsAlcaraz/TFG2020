for i in {1..22}
do

./gcta64 --bfile /hpc/hers_en/psobrevals/QC_chr/ukb_chr${i}_QC --chr ${i}  \
--pheno ../bombari/healthy_voice_ind.txt --keep ../bombari/yes_ind_keep.txt  \
--make-grm-part 3 1 --out /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice


cat /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.part_3_1.grm.id > /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.grm.id
cat /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.part_3_2.grm.id >> /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.grm.id
cat /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.part_3_3.grm.id >> /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.grm.id

cat /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.part_3_1.grm.N.bin > /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.grm.N.bin
cat /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.part_3_2.grm.N.bin >> /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.grm.N.bin
cat /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.part_3_3.grm.N.bin >> /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.grm.N.bin

cat /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.part_3_1.grm.bin > /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.grm.bin
cat /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.part_3_2.grm.bin >> /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.grm.bin
cat /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.part_3_3.grm.bin >> /hpc/hers_en/psobrevals/GCTA/ukb_chr${i}_QC_GRM1_voice.grm.bin

done

cat /hpc/hers_en/psobrevals/GWAS_PE/GRM_chr${i}.grm.id  > /hpc/hers_en/psobrevals/GCTA/GRM_chrall.grm.id
cat /hpc/hers_en/psobrevals/GWAS_PE/GRM_chr${i}.grm.N.bin > /hpc/hers_en/psobrevals/GCTA/GRM_chrall.grm.N.bin
cat /hpc/hers_en/psobrevals/GWAS_PE/GRM_chr${i}.grm.bin > /hpc/hers_en/psobrevals/GCTA/GRM_chrall.grm.bin


for i in {2..22}
do
cat /hpc/hers_en/psobrevals/GWAS_PE/GRM_chr${i}.grm.id  >> /hpc/hers_en/psobrevals/GCTA/GRM_chrall.grm.id
cat /hpc/hers_en/psobrevals/GWAS_PE/GRM_chr${i}.grm.N.bin >> /hpc/hers_en/psobrevals/GCTA/GRM_chrall.grm.N.bin
cat /hpc/hers_en/psobrevals/GWAS_PE/GRM_chr${i}.grm.bin >> /hpc/hers_en/psobrevals/GCTA/GRM_chrall.grm.bin
done


./gcta64 --reml-bivar --grm ../GCTA/GRM_chrall --pheno ../bombari/voi_vis_ind.txt --out ../GCTA/voi_vis_try




#### GRML for all yes PE

for i in {1..22}
do

./gcta64 --bfile /hpc/hers_en/psobrevals/QC_chr/ukb_chr${i}_QC --chr ${i}  \
--keep ../bombari/yes_ind_QC.txt  \
--make-grm-part 3 1 --out /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}

./gcta64 --bfile /hpc/hers_en/psobrevals/QC_chr/ukb_chr${i}_QC --chr ${i}  \
--keep ../bombari/yes_ind_QC.txt  \
--make-grm-part 3 2 --out /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}

./gcta64 --bfile /hpc/hers_en/psobrevals/QC_chr/ukb_chr${i}_QC --chr ${i}  \
--keep ../bombari/yes_ind_QC.txt  \
--make-grm-part 3 3 --out /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}


cat /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.part_3_1.grm.id  > /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.grm.id
cat /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.part_3_1.grm.N.bin > /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.grm.N.bin
cat /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.part_3_1.grm.bin > /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.grm.bin


cat /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.part_3_2.grm.id  >> /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.grm.id
cat /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.part_3_2.grm.N.bin >> /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.grm.N.bin
cat /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.part_3_2.grm.bin >> /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.grm.bin


cat /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.part_3_3.grm.id  >> /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.grm.id
cat /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.part_3_3.grm.N.bin >> /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.grm.N.bin
cat /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.part_3_3.grm.bin >> /hpc/hers_en/psobrevals/GWAS_PE/GRM1_chr${i}.grm.bin

done

# Merge the 1..22 chr:

./gcta64  --mgrm ../GCTA/multi_grm.txt  --make-grm  --out ../GCTA/GRM_chrall_y

# Extract related ind:
./gcta64 --grm ../GCTA/GRM_chrall_y --grm-cutoff 0.05 --make-grm --out ../GCTA/GRM_chrall_r

# Perform bivariate analysis:
./gcta64 --reml-bivar --grm ../GCTA/GRM_chrall_y --pheno ../bombari/voi_vis_ind.txt --out ../GCTA/voi_vis_try

# Perform HE biv analysis:
./gcta64 --HEreg-bivar 1 2 --grm ../GCTA/GRM_chrall_y  --pheno ../bombari/voi_vis_ind.txt  --out ../GCTA/voi_vis_HEregBiv

