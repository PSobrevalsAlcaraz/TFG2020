#! /bin/bash/

module load plink/1.90

cd /hpc/hers_en/psobrevals/CHR/

######## QC ukbiobank chr

## - Remove Info 0.8 MAF 0.01
## - Sex discrepancy
## - Genetic missingness 0.05
## - HWE 1e-6
## - Remove duplicated snps

 
for i in {1..22}
do

/hpc/hers_en/psobrevals/plink2 --bgen /hpc/hers_en/psobrevals/CHR/ukb_imp_chr${i}_v3.bgen ref-first \
--sample /hpc/hers_en/psobrevals/CHR/ukb_chr${i}_v3.sample \
--exclude /hpc/hers_en/psobrevals/bombari/exclude_info08_maf001.txt \
--remove /hpc/hers_en/psobrevals/bombari/sex_QC.txt  \
--geno 0.05 \
--hwe 1e-6 \
--rm-dup retain-mismatch --make-pgen --out /hpc/hers_en/psobrevals/CHR/ukb_chr${i}_QC

done

## - Remove complex structures

for i in {1..22}
do

/hpc/hers_en/psobrevals/plink2 --pfile /hpc/hers_en/psobrevals/CHR/ukb_chr${i}_QC \
--exclude range /hpc/hers_en/shared/Bochao_Paula/complex_ld_structures.txt \
--export bgen-1.1  --out /hpc/hers_en/psobrevals/QC_chr/ukb_chr${i}_QC

done

## - Sex missingness
## - Bed, bim, fam files

for i in {1..22}
do

/hpc/hers_en/psobrevals/plink2 --bgen /hpc/hers_en/psobrevals/QC_chr/ukb_chr${i}_QC.bgen ref-first \
--sample /hpc/hers_en/psobrevals/QC_chr/ukb_chr${i}_QC.sample \
--threads 10 --remove-nosex --make-bed --out /hpc/hers_en/psobrevals/QC_chr/ukb_chr${i}_QC_nosex 

done 


for i in {1..22}
do

/hpc/hers_en/psobrevals/plink2 --bfile /hpc/hers_en/psobrevals/QC_chr/ukb_chr${i}_QC_QC_nosex \
--threads 10 \
--extract /hpc/hers_en/psobrevals/PRS_JAMA_new/PRSICE_SCZ_chr#.valid \
--make-bed --out /hpc/hers_en/psobrevals/QC_chr/ukb_chr${i}_QC

done

#cat-bgen -g /hpc/ukbiobank/genetic_v3/ukb_imp_chr1_v3.bgen /hpc/ukbiobank/genetic_v3/ukb_imp_chr2_v3.bgen /hpc/ukbiobank/genetic_v3/ukb_imp_chr3_v3.bgen /hpc/ukbiobank/genetic_v3/ukb_imp_chr4_v3.bgen /hpc/ukbiobank/genetic_v3/ukb_imp_chr5_v3.bgen  /hpc/ukbiobank/genetic_v3/ukb_imp_chr6_v3.bgen  -og concatenated6.bgen


--extract 
       /hpc/hers_en/psobrevals/PRS_JAMA_new/PRSICE_GWAS_med_info.valid
/hpc/hers_en/psobrevals/plink2 --bfile /hpc/hers_en/psobrevals/QC_chr/ukb_chr${i}_QC_QC_nosex \
--threads 10 \
--extract /hpc/hers_en/psobrevals/PRS_JAMA_new/PRSICE_SCZ_chr#.valid \
--make-bed --out /hpc/hers_en/psobrevals/QC_chr/ukb_chr${i}_QC
