#! /bash/bin/

module load R

cd /hpc/hers_en/psobrevals/PRSice_linux/


### --- Generate PRS for each Outcome

gwas=/hpc/hers_en/psobrevals/GWAS_mitchell/SCZ.sumstats.Transformed      #Base of interest
cov=/hpc/hers_en/psobrevals/bombari/cov_sex_age_no.txt                   #Covariate variables
keep=/hpc/hers_en/psobrevals/bombari/no_ind.txt	              		 #Individuals of interest
pheno=/hpc/hers_en/psobrevals/Outcomes/Employment_no.txt        	 #Phenotype of interest
out=/hpc/hers_en/psobrevals/PRS_scz/PRSICE_SCZ_${pheno}_PC10  		 #Output file


Rscript PRSice.R --dir . \
    --prsice ./PRSice_linux     --A1 A1 \
    --A2 A2 \
    --all-score  \
    --bar-levels 5e-08,5e-07,5e-06,5e-05,0.0005,0.005,0.01,0.05,0.1,0.2,0.5,1 \
    --base ${gwas} \
    --binary-target T \
    --clump-kb 300kb \
    --clump-p 1.000000 \
    --clump-r2 0.200000 \
    --cov ${cov} \
    --fastscore  \
    --keep ${keep} \
    --missing mean_impute \
    --model add \
    --or  \
    --out ${out} \
    --pheno ${pheno} \
    --pvalue P \
    --score sum \
    --stat OR \
    --target /hpc/hers_en/psobrevals/QC_chr/ukb_chr#_QC \
    --thread 10


