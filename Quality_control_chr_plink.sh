#! /bin/bash

module load plink/1.90
module load R/3.5.1
module load rstudio/1.0.136

chr=/hpc/hers_en/psobrevals/CHR/ukb_chr#_QC
gwas=/hpc/hers_en/psobrevals/GWAS/SCZ.sumstats.Transformedr
phe=/hpc/hers_en/psobrevals/bombari/yes_distressing_qc.txt
inds=/hpc/hers_en/psobrevals/bombari/yes_ind_QC.txt
covar=/hpc/hers_en/psobrevals/bombari/ind_qc_cov.txt
sex=/hpc/hers_en/psobrevals/bombari/sex_QC.txt

#### QUALITY CONTROL CHROMOSOMES

cd /hpc/hers_en/psobrevals/QC_JAMA_new/

#plink --bfile $chr --geno 0.05 --make-bed --out /hpc/hers_en/psobrevals/QC_JAMA_new/chr_nsex_3

#plink --bfile /hpc/hers_en/psobrevals/QC_JAMA_new/chr_nsex_3 --mind 0.05 --make-bed --out /hpc/hers_en/psobrevals/QC_JAMA_new/chr_nsex_4

 #SEX CHECK

plink --bfile $chr --remove $sex --make-bed --out chr_nsex_5

#AUTOSOMAL

plink --bfile chr_nsex_5 --threads 3 --exclude range /hpc/hers_en/shared/Bochao_Paula/complex_ld_structures.txt --make-bed --out chr_nsex_6

plink --bfile chr_nsex_6 --threads 3  --exclude /hpc/hers_en/psobrevals/bombari/exclude_info08_maf001.txt --make-bed --out chr_nsex_8

#plink --bfile chr_nsex_8 --threads 3  --hwe 1e-6 --make-bed --out chr_nsex_9

#plink --bfile chr_nsex_9 --threads 3  --list-duplicate-vars ids-only suppress-first  

#plink --bfile chr_nsex_9 --threads 3 --exclude plink.dupvar --make-bed out chr_all_qc

#CLUMPING


cd /hpc/hers_en/psobrevals/

plink \
    --bfile chr_nsex_8 \
    --clump-p1 1 \
    --clump-p2 1 \
    --clump-r2 0.5 \
    --clump-kb 250 \
    --clump $gwas \
    --clump-snp-field SNP \
    --clump-field P \
    --threads 3 \
    --out /hpc/hers_en/psobrevals/PRS_JAMA_new/chr_nsex_SCZ
    

awk '{print $3}'  /hpc/hers_en/psobrevals/PRS_JAMA_new/chr_nsex_SCZ.clumped > /hpc/hers_en/psobrevals/PRS_JAMA_new/clumped_chr_nsex_SCZ_r1

awk 'NR == FNR{c[$1]++;next};c[$1] > 0'  /hpc/hers_en/psobrevals/PRS_JAMA_new/clumped_chr_nsex_SCZ_r1  $gwas >  /hpc/hers_en/psobrevals/PRS_JAMA_new/clean_nsex_SCZ_round1

plink \
    --bfile chr_nsex_8 \
    --clump /hpc/hers_en/psobrevals/PRS_JAMA_new/clean_nsex_SCZ_round1 \
    --extract /hpc/hers_en/psobrevals/PRS_JAMA_new/clumped_chr_nsex_SCZ_r1 \
    --clump-p1 1 \
    --clump-p2 1 \
    --clump-r2 0.1 \
    --clump-kb 500 \
    --threads 5 \
    --out /hpc/hers_en/psobrevals/PRS_JAMA_new/chr_nsex_SCZ2
    

awk '{print $3}'  /hpc/hers_en/psobrevals/PRS_JAMA_new/chr_nsex_SCZ2.clumped > /hpc/hers_en/psobrevals/PRS_JAMA_new/clumped_nsex_SCZ_round2

awk 'NR == FNR{c[$1]++;next};c[$1] > 0'  /hpc/hers_en/psobrevals/PRS_JAMA_new/clumped_nsex_SCZ_round2 $gwas  >  /hpc/hers_en/psobrevals/PRS_JAMA_new/clean_SCZ_nsex_round2


plink \
    --bfile chr_nsex_8 \
    --extract /hpc/hers_en/psobrevals/PRS_JAMA_new/clumped_nsex_SCZ_round2 \
    --threads 5 \
    --make-bed \
    --out /hpc/hers_en/psobrevals/PRS_JAMA_new/clumped_chr_nsex_SCZ
    
    
chr=/hpc/hers_en/psobrevals/CHR/ukb_chr#_QC
gwas=/hpc/hers_en/psobrevals/GWAS/SCZ.sumstats.Transformedr
phe=/hpc/hers_en/psobrevals/bombari/yes_distressing_qc.txt
inds=/hpc/hers_en/psobrevals/bombari/yes_ind_QC.txt
covar=/hpc/hers_en/psobrevals/bombari/ind_qc_cov.txt

cd /hpc/hers_en/psobrevals/PRSice_linux/

 Rscript PRSice.R --dir . \
 --prsice ./PRSice_linux \
 --base $gwas \
 --target $chr \
 --pheno $phe  \
 --thread 3 \
 --stat OR \
 --pvalue P \
 --model add \
 --A1 A1 \
 --A2 A2 \
 --score sum \
 --all-score \
 --missing MEAN_IMPUTE \
 --no-clump \
 --bar-levels 5e-8,5e-7,5e-6,5e-5,5e-4,5e-3,5e-2,0.1,0.2,0.5,1 \
 --quantile 10 \
 --keep $inds \
 --binary-target T \
 --cov $covar \
 --out /hpc/hers_en/psobrevals/PRS_JAMA_new/PRSICE_chr_nsex_SCZ \
 --or \
 --geno 0.05 \
--maf 0.1 \
 --pheno-col PHE \
 --fastscore \
 --non-cumulate 


## With clump

cd /hpc/hers_en/psobrevals/PRSice_linux/

Rscript PRSice.R --dir . \
 --prsice ./PRSice_linux \
 --base $gwas \
 --target $chr \
 --pheno $phe  \
 --thread 3 \
 --stat OR \
 --pvalue P \
 --model add \
 --A1 A1 \
 --A2 A2 \
 --score sum \
 --all-score \
 --clump-r2 0.1 \
 --clump-kb 300 \
 --missing MEAN_IMPUTE \
 --bar-levels 5e-8,5e-7,5e-6,5e-5,5e-4,5e-3,5e-2,0.1,0.2,0.5,1 \
 --quantile 10 \
 --keep $inds \
 --binary-target T \
 --cov $covar \
 --out /hpc/hers_en/psobrevals/PRS_JAMA_new/PRSICE_bgen_SCZ \
 --or \
 --pheno-col PHE \
 --fastscore

