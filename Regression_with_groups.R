# Model regression prs
# Pheno ~ PRS + Cov
install.packages("fmsb")


library(fmsb)
Outcomes <- c("Accomodation_environment_nonbinary", "Accomodation_type","Alcohol_nonbinary", "Cannabis", "Confide", "Depression", "Education", "Employment", 
              "GAD", "Leisure", "SelfHarmed", "SES_nonbinary", "Smoking", "Visit", "Wellbeing_nonbinary","Worthliving")
cov <- read.table("/hpc/hers_en/psobrevals/bombari/cov_with_groups.txt", header=T)


files_prs <- list.files(path="/hpc/hers_en/psobrevals/PRSs_all_ind/", full.names=TRUE, recursive=FALSE)

for (prs in files_prs) {
  prs_ <- read.table(prs, header=T)
  gw <- sub("_all.txt","", sub("/hpc/hers_en/psobrevals/PRSs_all_ind//PRSICE_","",prs))
  
  lm_results <- matrix(nrow = 16, ncol = 4)
  colnames(lm_results) <- c("ynPE","Hall","Sev","MI")
  rownames(lm_results) <- Outcomes
  lm_results <- as.data.frame(lm_results)
  print("PRS llegit")
  
  full_results <- matrix(nrow = 16, ncol = 4)
  colnames(full_results) <- c("ynPE","Hall","Sev","MI")
  rownames(full_results) <- Outcomes
  full_results <- as.data.frame(full_results)
  
for (outcome in Outcomes) {
  
  files <- list.files(path="/hpc/hers_en/psobrevals/Outcomes", pattern=paste("*",outcome,"*",sep=""), full.names=TRUE, recursive=FALSE)
  PE <- files[endsWith(files, "PE.txt")]
  outcome_ <- read.table(PE, header=T)
  
    fdf <- merge(outcome_,prs_, by = c("FID","IID"))
    fdf <- merge(fdf,cov, by = c("FID","IID"))
    fdf <- as.data.frame(fdf)
    fdf$SEX <- factor(fdf$SEX)
    fdf$ynPE <- factor(fdf$ynPE)
    fdf$Hall <- factor(fdf$Hall)
    fdf$Sev <- factor(fdf$Sev)
    fdf$MI <- factor(fdf$MI)
    
    # Columns of the cov files we will use: 10, 11, 12, 15
    covariate <- c(12,13,14,17)
    print("Outcome llegit i merge fet")
    if ( grepl( "nonbinary", outcome) ) {
      
      for (c in covariate) {
        covariate_ <- colnames(fdf)[c]
        
      null.lm <- lm(fdf$PHE ~ fdf$PRS + fdf$PC1 + fdf$PC2 + fdf$PC3 + fdf$PC4 + fdf$PC5 + fdf$SEX + fdf$AGE)
      null.r2 <- summary(null.lm)$r.squared

      model.lm <- lm(fdf$PHE ~ fdf$PRS + fdf$PC1 + fdf$PC2 + fdf$PC3 + fdf$PC4 + fdf$PC5 + fdf$SEX + fdf$AGE + fdf[,c])
      r2 <- summary(model.lm)$r.squared
      
      result <- r2-null.r2
      
      full_results[outcome,covariate_] <- r2
      lm_results[outcome,covariate_] <- result
      print("r2")
      }
    }
    
    # If its binary we have to do logistic regression:
    else {
      fdf$PHE <- fdf$PHE - 1
      fdf$PHE <- as.factor(fdf$PHE)
      
      for (c in covariate) {
        covariate_ <- colnames(fdf)[c]

      null.glm <- glm(fdf$PHE ~ fdf$PRS + fdf$PC1+ fdf$PC2 + fdf$PC3 + fdf$PC4 + fdf$PC5 + fdf$SEX + fdf$AGE,
                       family = 'binomial')
      null.nk2 <- NagelkerkeR2(null.glm)$R2
      model.glm <- glm(fdf$PHE ~ fdf$PRS + fdf$PC1+ fdf$PC2 + fdf$PC3 + fdf$PC4 + fdf$PC5 + fdf$SEX + fdf$AGE + fdf[,c],
                  family = 'binomial')
      nk2 <- NagelkerkeR2(model.glm)$R2
      
      result <- nk2-null.nk2
      full_results[outcome,covariate_] <- nk2
      lm_results[outcome,covariate_] <- result
      print("r2")
    }
    }
    }
  write.table(lm_results, paste("/hpc/hers_en/psobrevals/Regression_results/Single_group_explainig",gw,sep = "_"), quote=FALSE, row.names = T, col.names=TRUE)
  write.table(lm_results, paste("/hpc/hers_en/psobrevals/Regression_results/Full_model_explains",gw,sep = "_"), quote=FALSE, row.names = T, col.names=TRUE)
}
