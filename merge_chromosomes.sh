#! /bin/bash

module load plink/1.90
cd /hpc/hers_en/psobrevals/CHR

let j=2

for i in {1..21}
do
plink --bfile /hpc/hers_en/psobrevals/CHR/ukb_chr${i}_v3 --bmerge /hpc/hers_en/psobrevals/CHR/ukb_chr${j}_v3 --make-bed --out /hpc/hers_en/psobrevals/CHR/ukb_chr${i}_half
plink --bfile /hpc/hers_en/psobrevals/CHR/ukb_chr${i}_v3 --flip /hpc/hers_en/psobrevals/CHR/ukb_chr${i}_half-merge.missnp --make-bed --out /hpc/hers_en/psobrevals/CHR/ukb_chr${i}_half
plink --bfile /hpc/hers_en/psobrevals/CHR/ukb_chr${i}_half --bmerge /hpc/hers_en/psobrevals/CHR/ukb_chr${j}_v3 --make-bed --out /hpc/hers_en/psobrevals/CHR/ukb_chr${j}_half
let j=$i+1
done




plink --bfile /hpc/hers_en/psobrevals/CHR/ukb_chr2_v3 --merge-list  /hpc/hers_en/psobrevals/scripts/mergelist --make-bed --out /hpc/hers_en/psobrevals/CHR/ukb_chr_half

'''
plink --bfile /hpc/hers_en/mbombari/ukbb_genetic/ukbiobank_genetic_data/ukb_chr1_v2 \
--bmerge /hpc/ukbiobank/genetic_v3/ukb_cal_chr2_v2.bed /hpc/ukbiobank/genetic_v3/ukb_snp_chr2_v2.bim /hpc/hers_en/psobrevals/CHR/ukb55392_cal_chr2_v2_s488264.fam \
--threads 3 \
--make-bed --out /hpc/hers_en/psobrevals/QC_JAMA_new/chr_ball_v2


let j=2

for i in {3..8}
do
plink --bfile /hpc/hers_en/psobrevals/QC_JAMA_new/chr_ball_v${j} \
--bmerge /hpc/ukbiobank/genetic_v3/ukb_cal_chr${i}_v2.bed /hpc/ukbiobank/genetic_v3/ukb_snp_chr${i}_v2.bim  /hpc/hers_en/psobrevals/CHR/ukb55392_cal_chr${i}_v2_s488264.fam \
--threads 5 \
--make-bed --out /hpc/hers_en/psobrevals/QC_JAMA_new/chr_ball_v${i}

let j=$i
done

plink --bfile /hpc/hers_en/psobrevals/QC_JAMA_new/chr_ball_v8 \
--bmerge /hpc/ukbiobank/genetic_v3/ukb_cal_chr9_v2.bed /hpc/ukbiobank/genetic_v3/ukb_snp_chr9_v2.bim /hpc/hers_en/psobrevals/CHR/ukb55392_cal_chr9_v2_s488264.fam \
--threads 5 \
--make-bed --out /hpc/hers_en/psobrevals/QC_JAMA_new/chr_ball_v9

let j=9

for i in {10..22}
do
plink --bfile /hpc/hers_en/psobrevals/QC_JAMA_new/chr_ball_v${j} \
--bmerge /hpc/ukbiobank/genetic_v3/ukb_cal_chr${i}_v2.bed /hpc/ukbiobank/genetic_v3/ukb_snp_chr${i}_v2.bim /hpc/hers_en/psobrevals/CHR/ukb55392_cal_chr${i}_v2_s488264.fam \
--threads 5 \
--make-bed --out /hpc/hers_en/psobrevals/QC_JAMA_new/chr_ball_v${i}

let j=$i
done

plink --bfile /hpc/hers_en/psobrevals/QC_JAMA_new/chr_ball_v21 \
--bmerge /hpc/ukbiobank/genetic_v3/ukb_cal_chr22_v2.bed /hpc/ukbiobank/genetic_v3/ukb_snp_chr22_v2.bim  /hpc/hers_en/psobrevals/CHR/ukb55392_cal_chr22_v2_s488264.fam \
--threads 5 \
--make-bed --out /hpc/hers_en/psobrevals/QC_JAMA_new/chr_nsex_all
'''
