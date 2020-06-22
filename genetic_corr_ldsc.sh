#! /bash/bin/

###All indiv


cd /hpc/hers_en/psobrevals/ldsc

module load python/2.7.10

gwas1=vision
gwas2=voice

./munge_sumstats.py \
--sumstats /hpc/hers_en/psobrevals/GWAS_PE/GWAS_${gwas1}.assoc \
--N 6068 \
--out /hpc/hers_en/psobrevals/GWAS_PE/GWAS_${gwas1}_Transformed \
--merge-alleles /hpc/hers_en/psobrevals/w_hm3.snplist

./munge_sumstats.py \
--sumstats /hpc/hers_en/psobrevals/GWAS_PE/GWAS_${gwas2}.assoc \
--N 6068 \
--out /hpc/hers_en/psobrevals/GWAS_PE/GWAS_${gwas2}_Transformed \
--merge-alleles /hpc/hers_en/psobrevals/w_hm3.snplist


./ldsc.py \
--rg /hpc/hers_en/psobrevals/GWAS_PE/GWAS_${gwas1}_Transformed.sumstats.gz,/hpc/hers_en/psobrevals/GWAS_PE/GWAS_${gwas2}_Transformed.sumstats.gz \
--ref-ld-chr /hpc/hers_en/psobrevals/eur_w_ld_chr/ \
--w-ld-chr /hpc/hers_en/psobrevals/eur_w_ld_chr/ \
--out /hpc/hers_en/psobrevals/GWAS_PE/ldsc_gc/${gwas1}_${gwas2}_ldsc

# only heritabilities

./ldsc.py \
--h2 /hpc/hers_en/psobrevals/GWAS_PE/GWAS_${gwas2}_Transformed.sumstats.gz \
--ref-ld-chr /hpc/hers_en/psobrevals/eur_w_ld_chr/ \
--w-ld-chr /hpc/hers_en/psobrevals/eur_w_ld_chr/ \
--out /hpc/hers_en/psobrevals/GWAS_PE/ldsc_gc/${gwas2}_h2

###  Half individuals


cd /hpc/hers_en/psobrevals/ldsc

module load python/2.7.10

gwas1=vision
gwas2=voice

./munge_sumstats.py \
--sumstats /hpc/hers_en/psobrevals/GWAS_PE/GWAS_half_${gwas1} \
--N 3034 \
--out /hpc/hers_en/psobrevals/GWAS_PE/GWAS_${gwas1}_half_Transformed \
--merge-alleles /hpc/hers_en/psobrevals/w_hm3.snplist

./munge_sumstats.py \
--sumstats /hpc/hers_en/psobrevals/GWAS_PE/GWAS_half_${gwas2} \
--N 3034 \
--out /hpc/hers_en/psobrevals/GWAS_PE/GWAS_${gwas2}_half_Transformed \
--merge-alleles /hpc/hers_en/psobrevals/w_hm3.snplist


./ldsc.py \
--rg /hpc/hers_en/psobrevals/GWAS_PE/GWAS_${gwas1}_half_Transformed.sumstats.gz,/hpc/hers_en/psobrevals/GWAS_PE/GWAS_${gwas2}_half_Transformed.sumstats.gz \
--ref-ld-chr /hpc/hers_en/psobrevals/eur_w_ld_chr/ \
--w-ld-chr /hpc/hers_en/psobrevals/eur_w_ld_chr/ \
--out /hpc/hers_en/psobrevals/GWAS_PE/ldsc_gc/half_${gwas1}_${gwas2}_ldsc

## Only heritability

./ldsc.py \
--h2 /hpc/hers_en/psobrevals/GWAS_PE/GWAS_${gwas1}_half_Transformed.sumstats.gz \
--ref-ld-chr /hpc/hers_en/psobrevals/eur_w_ld_chr/ \
--w-ld-chr /hpc/hers_en/psobrevals/eur_w_ld_chr/ \
--out /hpc/hers_en/psobrevals/GWAS_PE/ldsc_gc/${gwas1}_h2
