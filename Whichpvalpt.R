
# module load R/3.6.3

### FOR MDD checking if pval of outcomes are < 0.05 for the pTh = 0.05

significant_mdd <- c() # files with < 0.05

# No PE:

prsice <- list.files(path="/hpc/hers_en/psobrevals/PRS_mdd_2", pattern="PRSICE_MDD_noPE__*", full.names=TRUE, recursive=FALSE)
a <- endsWith(prsice, ".prsice")
prsice <- prsice[a]

for (pr in prsice) {
  file <- read.table(pr, header=TRUE) 
  if (file[8,4] < 0.05) {
    significant_mdd <- c(significant_mdd, pr)
  }
}

# Yes PE:

prsice <- list.files(path="/hpc/hers_en/psobrevals/PRS_mdd_2", pattern="PRSICE_MDD_yesPE__*", full.names=TRUE, recursive=FALSE)
a <- endsWith(prsice, ".prsice")
prsice <- prsice[a]

for (pr in prsice) {
  file <- read.table(pr, header=TRUE)
  if (file[8,4] < 0.05) {
    significant_mdd <- c(significant_mdd,pr)
  }
}

# Hall:

prsice <- list.files(path="/hpc/hers_en/psobrevals/PRS_mdd_2", pattern="PRSICE_MDD_yesPE_hall_*", full.names=TRUE, recursive=FALSE)
a <- endsWith(prsice, ".prsice")
prsice <- prsice[a]

for (pr in prsice) {
  file <- read.table(pr, header=TRUE)
  if (file[8,4] < 0.05) {
    significant_mdd <- c(significant_mdd,pr)
  }
}


### FOR SCZ checking if pval of outcomes are < 0.05 for the pTh = 0.05

significant_scz <- c() # files with < 0.05

# No PE:

prsice <- list.files(path="/hpc/hers_en/psobrevals/PRS_scz_2", pattern="PRSICE_SCZ_noPE__*", full.names=TRUE, recursive=FALSE)
a <- endsWith(prsice, ".prsice")
prsice <- prsice[a]

for (pr in prsice) {
  file <- read.table(pr, header=TRUE) 
  if (file[8,4] < 0.05) {
    significant_scz <- c(significant_scz, pr)
  }
}

# Yes PE:

prsice <- list.files(path="/hpc/hers_en/psobrevals/PRS_scz_2", pattern="PRSICE_SCZ_yesPE__*", full.names=TRUE, recursive=FALSE)
a <- endsWith(prsice, ".prsice")
prsice <- prsice[a]

for (pr in prsice) {
  file <- read.table(pr, header=TRUE)
  if (file[8,4] < 0.05) {
    significant_scz <- c(significant_scz,pr)
  }
}

# Hall:

prsice <- list.files(path="/hpc/hers_en/psobrevals/PRS_scz_2", pattern="PRSICE_SCZ_yesPE_hall_*", full.names=TRUE, recursive=FALSE)
a <- endsWith(prsice, ".prsice")
prsice <- prsice[a]

for (pr in prsice) {
  file <- read.table(pr, header=TRUE)
  if (file[8,4] < 0.05) {
    significant_scz <- c(significant_scz,pr)
  }
}


### FOR BIP checking if pval of outcomes are < 0.01 for the pTh = 0.05

significant_bip <- c() # files with < 0.01

# No PE:

prsice <- list.files(path="/hpc/hers_en/psobrevals/PRS_bip_2", pattern="PRSICE_BIP_noPE__*", full.names=TRUE, recursive=FALSE)
a <- endsWith(prsice, ".prsice")
prsice <- prsice[a]

for (pr in prsice) {
  file <- read.table(pr, header=TRUE) 
  if (file[7,4] < 0.05) {
    significant_bip <- c(significant_bip, pr)
  }
}

# Yes PE:

prsice <- list.files(path="/hpc/hers_en/psobrevals/PRS_bip_2", pattern="PRSICE_BIP_yesPE__*", full.names=TRUE, recursive=FALSE)
a <- endsWith(prsice, ".prsice")
prsice <- prsice[a]

for (pr in prsice) {
  file <- read.table(pr, header=TRUE)
  if (file[7,4] < 0.05) {
    significant_bip <- c(significant_bip,pr)
  }
}

# Hall:

prsice <- list.files(path="/hpc/hers_en/psobrevals/PRS_bip_2", pattern="PRSICE_BIP_yesPE_hall_*", full.names=TRUE, recursive=FALSE)
a <- endsWith(prsice, ".prsice")
prsice <- prsice[a]

for (pr in prsice) {
  file <- read.table(pr, header=TRUE)
  if (file[7,4] < 0.05) {
    significant_bip <- c(significant_bip,pr)
  }
}


length(significant_mdd)
length(significant_bip)
length(significant_scz)

significant_all <- c(significant_mdd, significant_scz, significant_bip)

# Now we have in the variable signif all those files wih significat pval.

# One by one we check all the Outcomes:


outcome <- "Smok"

for (out in outcome) {
  grap <- c()
  for (prs in significant_all) {
    grap <- c(grap,grepl(outcome, prs ))
  }
  sig_files <- significant_all[grap]
  for (file in sig_files){
    extr <- read.table(file, header=T)
    if ( grepl("BIP", extr)  ){
      print(file)
      print(extr[7,3])
      print(" ")
    }
    else {
      print(file)
      print(extr[8,3])
      print(" ")
    }
  }
}


### GET THE SIGNIFICANT PT FOR EACH PRS:


Out <- "Edu" #Since all the PRS are equal for all the Outcomes, we choose one outcome as an example. So we get only one of each kind of individual files.

files <- list.files(path="/hpc/hers_en/psobrevals/PRS_signif2", pattern=paste("*",Out,"*",sep=""), full.names=TRUE, recursive=FALSE)
lapply(files, function(x) {
  full <- read.table(x, header=TRUE, fill=T) # load file
  
  if ( grepl("BIP", x)   ){
    extract2 <-	cbind(full$FID,full$IID,full$X0.01)
    colnames(extract2) <- c("FID","IID","0.01")
    y <- sub("/hpc/hers_en/psobrevals/PRS_signif2/", "", x)
    # write to file
    write.table(extract2, paste("/hpc/hers_en/psobrevals/PRS_extracted2/",y,sep=""), sep="\t", quote=FALSE, row.names=FALSE, col.names=TRUE)
    }
  else {
    extract2 <-	cbind(full$FID,full$IID,full$X0.05)
    colnames(extract2) <- c("FID","IID","0.05")
    y <- sub("/hpc/hers_en/psobrevals/PRS_signif2/", "", x)
    # write to file
    write.table(extract2, paste("/hpc/hers_en/psobrevals/PRS_extracted2/",y,sep=""), sep="\t", quote=FALSE, row.names=FALSE, col.names=TRUE)
  }
  
})

#### Change file names: (in bash)

# change each time the onlyMI_ind_ for the different files 

for f in *onlyMI_ind_* # change here
do
newName=${f/onlyMI_ind_*\./onlyMI_ind_.}  # change here twice too
mv -i "$f" "$newName"
done


