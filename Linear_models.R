## LINEAR REGRESSION

library(sizeMat)

# All Outcomes
Outcomes <- c("Accomodation_environment","Alcohol_nonbinary","Wellbeing_nonbinary", "SES_nonbinary", "Accomodation_type","Cannabis", "Confide", "Depression", "Education_attainment", "Employment", "GAD", "Leisure", "SelfHarmed","Smoking", "Visit", "Worthliving")

# To create colnames:
gwas_yes_no_hall <-c("SCZ_noPE", "SCZ_yesPE", "SCZ_hall", "MDD_noPE", "MDD_yesPE", "MDD_hall", "BIP_noPE", "BIP_yesPE", "BIP_hall")
group_indiv <- c("All", "Without_severeMI", "Without_anyMI", "Only_Severe", "Only_MI")
for_colnames <- c()
for ( i in gwas_yes_no_hall) {
  for ( j in group_indiv ) {
    for_colnames = c(for_colnames,paste(i,j,sep ="_"))
  }
}


# Create the df to store the results
lm_results <- matrix(nrow = 16, ncol = 45)
colnames(lm_results) <- for_colnames
rownames(lm_results) <- Outcomes
lm_results <- as.data.frame(lm_results)



######  YES FILES:

for (outcome in Outcomes) {
  
  # First we fill the yes/hall files:
  files <- list.files(path="/hpc/hers_en/psobrevals/Outcomes", pattern=paste("*",outcome,"*",sep=""), full.names=TRUE, recursive=FALSE)
  yes_file <- files[endsWith(files, "yes.txt")]
  outcome_yes <- read.table(yes_file, header=T)
  out <- sub("/hpc/hers_en/psobrevals/Outcomes/","",yes_file)
  cov_y <- read.table("/hpc/hers_en/psobrevals/bombari/cov_sex_age.txt", header=T)
  individual_groups_files <- list.files(path="/hpc/hers_en/psobrevals/PRS_extracted2", pattern="yesPE", full.names=TRUE, recursive=FALSE)
  
  # For each individual group:
  for (indiv_group in individual_groups_files) {
    
    #Determine the gwas:
    gwas <- sub("/hpc/hers_en/psobrevals/PRS_extracted2/PRSICE_","",indiv_group)
    gwas <- substr(gwas, start = 1, stop = 3)
    
    # Determine which group of individuals are we:
    if (endsWith(indiv_group, "ind_all_.score")) {
      gp <- "All"
    }
    else if (endsWith(indiv_group, "nosevereMI_ind_.score")) {
      gp <- "Without_severeMI"
    }
    else if (endsWith(indiv_group, "noMI_ind_.score")) {
      gp <- "Without_anyMI"
    }
    else if (endsWith(indiv_group, "severeMI_ind_.score")) {
      gp <- "Only_Severe"
    }
    else if (endsWith(indiv_group, "onlyMI_ind_.score")) {
      gp <- "Only_MI"
    }
    
    
    # Check if is hall or not
    if (grepl( "hall", indiv_group) ) {
      find_column <- paste(gwas, gp, sep="_hall_")
    }
    
    # If is yesPE__
    else {
      find_column <- paste(gwas,gp,sep="_yesPE_")
    }
    
    # Obtain necessary files to de the lm or gml:
    PRS_y <- read.table(indiv_group, header=T)
    colnames(PRS_y)[3] <- "PRS"
    
    fdf <- merge(outcome_yes,PRS_y, by = c("FID","IID"))
    fdf <- merge(fdf,cov_y, by = c("FID","IID"))
    fdf <- as.data.frame(fdf)
    fdf$SEX <- factor(fdf$SEX)
    
    # Check if its nonbinary so we have to do lm:
    if ( grepl( "nonbinary", out) ) {
      
      model_yes <- lm(fdf$PHE ~ fdf$PRS + fdf$PC1+ fdf$PC2 + fdf$PC3 + fdf$PC4 + fdf$PC5 + fdf$SEX + fdf$AGE)
      r2 <- summary(model_yes)$adj.r.squared
      
      lm_results[outcome,find_column] <- r2
      
    }
    
    # If its binary we have to do logistic regression:
    else {
      fdf$PHE <- fdf$PHE - 1
      model_yes <- glm(fdf$PHE ~ fdf$PRS + fdf$PC1+ fdf$PC2 + fdf$PC3 + fdf$PC4 + fdf$PC5 + fdf$SEX + fdf$AGE,family = 'binomial')
      nk2 <- nagelkerkeR2(model_yes)
      lm_results[outcome,find_column] <- nk2
      
    }
  }
}



######  NO FILES:

for (outcome in Outcomes) {
  
  # First we fill the no files:
  files <- list.files(path="/hpc/hers_en/psobrevals/Outcomes", pattern=paste("*",outcome,"*",sep=""), full.names=TRUE, recursive=FALSE)
  no_file <- files[endsWith(files, "no.txt")]
  outcome_no <- read.table(no_file, header=T)
  out <- sub("/hpc/hers_en/psobrevals/Outcomes/","",no_file)
  cov_y <- read.table("/hpc/hers_en/psobrevals/bombari/cov_sex_age.txt", header=T)
  individual_groups_files <- list.files(path="/hpc/hers_en/psobrevals/PRS_extracted2", pattern="noPE", full.names=TRUE, recursive=FALSE)
  
  # For each individual group:
  for (indiv_group in individual_groups_files) {
    
    #Determine the gwas:
    gwas <- sub("/hpc/hers_en/psobrevals/PRS_extracted2/PRSICE_","",indiv_group)
    gwas <- substr(gwas, start = 1, stop = 3)
    
    # Determine which group of individuals are we:
    if (endsWith(indiv_group, "ind_all_.score")) {
      gp <- "All"
    }
    else if (endsWith(indiv_group, "nosevereMI_ind_.score")) {
      gp <- "Without_severeMI"
    }
    else if (endsWith(indiv_group, "noMI_ind_.score")) {
      gp <- "Without_anyMI"
    }
    else if (endsWith(indiv_group, "severeMI_ind_.score")) {
      gp <- "Only_Severe"
    }
    else if (endsWith(indiv_group, "onlyMI_ind_.score")) {
      gp <- "Only_MI"
    }
    
    find_column <- paste(gwas,gp,sep="_noPE_")

    
    # Obtain necessary files to de the lm or gml:
    PRS_y <- read.table(indiv_group, header=T)
    colnames(PRS_y)[3] <- "PRS"
    
    fdf <- merge(outcome_no,PRS_y, by = c("FID","IID"))
    fdf <- merge(fdf,cov_y, by = c("FID","IID"))
    fdf <- as.data.frame(fdf)
    fdf$SEX <- factor(fdf$SEX)
    
    # Check if its nonbinary so we have to do lm:
    if ( grepl( "nonbinary", out) ) {
      
      model_no <- lm(fdf$PHE ~ fdf$PRS + fdf$PC1+ fdf$PC2 + fdf$PC3 + fdf$PC4 + fdf$PC5 + fdf$SEX + fdf$AGE)
      r2 <- summary(model_no)$adj.r.squared
      
      lm_results[outcome,find_column] <- r2
      
    }
    
    # If its binary we have to do logistic regression:
    else {
      fdf$PHE <- fdf$PHE - 1
      model_no <- glm(fdf$PHE ~ fdf$PRS + fdf$PC1+ fdf$PC2 + fdf$PC3 + fdf$PC4 + fdf$PC5 + fdf$SEX + fdf$AGE,family = 'binomial')
      nk2 <- nagelkerkeR2(model_no)
      lm_results[outcome,find_column] <- nk2
      
    }
  }
}
