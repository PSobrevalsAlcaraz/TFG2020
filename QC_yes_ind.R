setwd("/hpc/hers_en/psobrevals/")

library(robustbase)

#yes.ind <- read.csv("./Real_data/yes_ind.csv", header = T)
yes.ind <- read.table("/hpc/hers_en/psobrevals/bombari/yes_ind.txt", sep = " ", header = T)
yes.ind <- yes.ind[,1]
yes.ind <- as.matrix(yes.ind)
#no.ind <- read.csv("/hpc/hers_en/psobrevals/bombari/no_ind.csv", header = T)
data.i <- read.csv("/hpc/hers_en/psobrevals/bombari/data_y.csv", header = T)
data.y <- as.matrix(data.i)
col.names <- colnames(data.y)

#----- QC of yes individuals
to_delete <- c()


#--- eMethods6 to exclude individuals of Association of Genetic Liability to Psychotic Experiences With Neuropsychotic Disorders and Traits:

# eMethods 6. Individuals Excluded
# 
# Quality control step 1 consisted of excluding study individuals that (i) did not have a selfreported
# White British or Irish ethnicity, (ii) did not have genetic data available, or (iii)
# did not pass initial genetic quality control parameters (missingness). Step 2 consisted of
# excluding individuals that did not have European genetic ancestry as defined by principal
# components (see ‘defining European genetic ancestry’ above). Step 3 consisted of
# excluding related individuals and finally, step 4 excluded individuals with a
# schizophrenia, bipolar disorder or psychotic disorder diagnosis.

# 1 Ethnicity

ethnicity <- grep("21000",col.names)
ethnic <- as.matrix(yes.ind)
ethnic <- cbind(ethnic, data.y[,ethnicity])


# Take those that are British, Irish or White. 
by_ethnicity <- ethnic[ethnic[,2]!="British" &  ethnic[,2]!="Irish" &  ethnic[,2]!="White",1]


by_ethnicity <- unique(by_ethnicity) #674
to_delete <- c(to_delete, yes.ind[(yes.ind %in% by_ethnicity)])
to_delete <- unique(to_delete)
length(to_delete)

# 1 MISSINGNESS
miss <- grep("22005", col.names)
missing <- as.matrix(yes.ind)
missing <- cbind(missing, data.y[,miss])
by_miss <- c()
m <- which(missing[,2] <= 0.05, arr.ind = T)

by_miss <- missing[m,1]#  (183 out)
to_delete <- c(to_delete, yes.ind[!(yes.ind %in% by_miss)])
to_delete <- unique(to_delete)
length(to_delete)

# 1 No genotypig 
chr <- seq(0,9,1)
ch <- c()
for (i in chr) {
  ch <- c(ch, paste("0",i,sep=""))
}
chr <- c(ch, seq(10,24,1))


by_gen <- c()
for (i in chr) {
  gen <- grep(paste("221",i,sep=""),col.names)
  genetic <- as.matrix(yes.ind)
  genetic <- cbind(genetic,data.y[,gen])
  by_gen <- c(by_gen, genetic[is.na(genetic[,2]),1])
}
by_gen <- unique(by_gen) # (177 out)

to_delete <- c(to_delete, yes.ind[(yes.ind %in% by_gen)])

to_delete <- unique(to_delete)
length(to_delete)
#yes.ind <- yes.ind[!(yes.ind %in% to_delete)]
#832

# 2 PC
pc <- grep("22009",col.names)
pca <- as.matrix(yes.ind)
data.1 <- data.y[,2]
data.1 <- cbind(data.1, data.i[,pc])
# for (i in pc) {
#   data.1 <- cbind(data.1, as.in(data.y[,i]))
# }


colnames(pca)[1] <- "eid"
colnames(data.1)[1] <- "eid"
pca <- merge(pca, data.1, by="eid")
rownames(pca) <- pca[,1]
#pca <- pca[,-1]

pca_cov <- princomp(pca, cov=covMcd(pca))
pca_result <- pca_cov$scores
q90th <- quantile(pca_result, .90, na.rm = T)
high90 <- which(pca_result > q90th, arr.ind = T)[,1]
pca_result <- cbind(rownames(pca_result),pca_result)
by_pca <- pca[high90,1]
by_pca <- unique(by_pca) 

# cov=covMcd(pca[,-1])
# pca[cov$best,]
# cov_best <- na.omit(pca[cov$best,])
# options(digits=10)
# pca_best <- sapply(cov_best, function(i) 
#   if ( is.factor(i)){
#     as.double(i)
#   }
#   else { i})
# pca_best <- data.frame(pca_best)
# q90th <- quantile(cov$cov, .90, na.rm = T)
# high90 <- which(cov$cov > q90th, arr.ind = T)[,1]
# by_pca <- pca[high90,1]
by_pca <- unique(by_pca)
by_pca_del <- yes.ind[!(yes.ind %in% by_pca)] #344

to_delete <- c(to_delete, by_pca_del)
to_delete <- unique(to_delete)

# 3 RELATED
related <- read.table("./bombari/ukb55392_rel_s488265.dat", header = T)
r <- as.matrix(yes.ind)
colnames(r)[1] <- "ID1"
rel_m1 <- merge(r, related, by = "ID1")
colnames(r)[1] <- "ID2"
rel_m2 <- merge(r, related, by = "ID2")

real <- merge(rel_m1, rel_m2, by = c("ID1","ID2","HetHet", "IBS0", "Kinship"))
kinsh15 <- which(real[,ncol(real)]>0.15, arr.ind = T)
by_relatedness <- real[kinsh15,1]
by_relatedness <- unique(by_relatedness) # 11!

to_delete <- c(to_delete, by_relatedness)
to_delete <- unique(to_delete) # 1163
#yes.ind <- yes.ind[!(yes.ind %in% to_delete)]
# 11 

# NEXT STEP ONLY TO DELETE THOSE WITH SEVERAL MENTAL ILLNESS:

# 4 BPD, SCZ, PSY individuals
mi_ind <- c()
# From id 20002:


id20002 <- grep("20002",col.names)
individuals_20002 <- matrix(nrow = nrow(data.y),ncol = 0)
individuals_20002 <- cbind(data.y[,2], individuals_20002)
for (i in id20002){
  individuals_20002 <- cbind(individuals_20002, data.y[,i])
}
scz <- which(individuals_20002==" 1289", arr.ind = T)[,1]
bpd <- which(individuals_20002==" 1291", arr.ind = T)[,1]
psy <- which(individuals_20002==" 1243", arr.ind = T)[,1]
for (id in scz){
  mi_ind <- c(mi_ind,individuals_20002[id,1])
}
for (id in bpd){
  mi_ind <- c(mi_ind,individuals_20002[id,1])
}
for (id in psy){
  mi_ind <- c(mi_ind,individuals_20002[id,1])
}
mi_ind <- unique(mi_ind)
length(mi_ind) #270

# From id 20544:

id20544 <- grep("20544",col.names)
individuals_20544 <- matrix(nrow = nrow(data.y),ncol = 0)
individuals_20544 <- cbind(data.y[,2], individuals_20544)
for (i in id20544){
  individuals_20544 <- cbind(individuals_20544, data.y[,i])
}
scz2 <- which(individuals_20544=="Schizophrenia", arr.ind = T)[,1]
psy2 <- which(individuals_20544=="Any other type of psychosis or psychotic illness", arr.ind = T)[,1]
bpd2 <- which(individuals_20544=="Mania, hypomania, bipolar or manic-depression", arr.ind = T)[,1]

for (id in scz2){
  mi_ind <- c(mi_ind,individuals_20544[id,1])
}
for (id in bpd2){
  mi_ind <- c(mi_ind,individuals_20544[id,1])
}
for (id in psy2){
  mi_ind <- c(mi_ind,individuals_20544[id,1])
}
mi_ind <- unique(mi_ind)

# From id 41202:

id41202 <- grep("41202",col.names)
individuals_41202 <- matrix(nrow = nrow(data.y),ncol = 0)
individuals_41202 <- cbind(data.y[,2], individuals_41202)
for (i in id41202){
  individuals_41202 <- cbind(individuals_41202, data.y[,i])
}

id41204 <- grep("41204",col.names)
individuals_41204 <- matrix(nrow = nrow(data.y),ncol = 0)
individuals_41204 <- cbind(data.y[,2], individuals_41204)
for (i in id41204){
  individuals_41204 <- cbind(individuals_41204, data.y[,i])
}

id40001 <- grep("40001",col.names)
individuals_40001 <- matrix(nrow = nrow(data.y),ncol = 0)
individuals_40001 <- cbind(data.y[,2], individuals_40001)
for (i in id40001){
  individuals_40001 <- cbind(individuals_40001, data.y[,i])
}
scz_bpd_psy <- c("F200", "F200", "F201", "F202" ,"F203" ,"F204", "F205" ,"F206", "F208" ,"F209", "F21" , "F22",  "F220", "F228" ,"F229", "F23" , "F230",
                 "F231", "F232", "F233" ,"F238", "F239",  "F25" , "F250" ,"F251", "F252" ,"F258" ,"F259", "F28" , "F29","F300", "F301", "F302", "F308", "F309", "F310", 
                 "F311", "F312" ,"F313", "F314" ,"F315", "F316", "F317","F318", "F319")
#scz_bpd_psy <- sub("F","",scz_bpd_psy)

for ( i in scz_bpd_psy){
  id <- which(individuals_41202==i, arr.ind = T)[,1]
  mi_ind <- c(mi_ind,individuals_41202[id,1])
}

# From id 41204:

for ( i in scz_bpd_psy){
  id <- which(individuals_41204==i, arr.ind = T)[,1]
  mi_ind <- c(mi_ind,individuals_41204[id,1])
}

# From id 40001:

for ( i in scz_bpd_psy){
  id <- which(individuals_40001==i, arr.ind = T)[,1]
  mi_ind <- c(mi_ind,individuals_40001[id,1])
}

mi_ind <- unique(mi_ind)
to_delete <- unique(to_delete)


# NEXT STEP TO DELETE INDIVIDUALS WITH ANY MENTAL ILLNESS:

id20544 <- grep("20544",col.names)
individuals_20544 <- matrix(nrow = nrow(data.y),ncol = 0)
individuals_20544 <- cbind(data.y[,2], individuals_20544)
for (i in id20544){
  individuals_20544 <- cbind(individuals_20544, data.y[,i])
}

individuals_20544 <- individuals_20544[!(rowSums(is.na(individuals_20544)) == ncol(individuals_20544)-1), ]
all_mi <- individuals_20544[,1]

mi_ind <- unique(mi_ind)
to_delete <- unique(to_delete)


#--- Get only those healthy yes individuals
y.ind1 <- yes.ind[!(yes.ind %in% to_delete)]
y.ind <- y.ind1[(y.ind1 %in% mi_ind)] # keep only individuals with Mental illnesses
y.ind <- cbind(y.ind,y.ind)
colnames(y.ind) <- c("FID","IID")
write.table(y.ind, file = "/hpc/hers_en/psobrevals/bombari/yesPE_yesMI_ind_QC.txt", row.names = F)

#----- ONLY THE HALLUCINATIONS

hall <- read.table("/hpc/hers_en/psobrevals/bombari/hallucinations_yes_ind.txt", header = T)

#----- FILES OUTCOME
#yesPE_ind_all.txt : y.ind1
#yesPE_ind_all_hall.txt : merge(hall,y.ind1, by = c("FID","IID"))
#yesPE_nosevereMI_ind.txt : y.ind <- y.ind1[!(y.ind1 %in% mi_ind)]
#yesPE_nosevereMI_ind_hall.txt : merge(hall,y.ind, by = c("FID","IID"))
#yesPE_noMI_ind.txt : y.ind2 <- y.ind1[!(y.ind1 %in% all_mi)]
#yesPE_noMI_ind_hall.txt : merge(hall,y.ind2, by = c("FID","IID"))

#yesPE_severeMI_ind.txt : y.ind <- y.ind1[(y.ind1 %in% mi_ind)]
#yesPE_severeMI_ind_hall.txt : merge(hall,y.ind, by = c("FID","IID"))
#yesPE_onlyMI_ind.txt : y.ind2 <- y.ind1[(y.ind1 %in% all_mi)]
#yesPE_onlyMI_ind_hall.txt : merge(hall,y.ind2, by = c("FID","IID"))


