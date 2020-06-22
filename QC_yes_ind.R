setwd("/hpc/hers_en/shared/Bombari_Paula/ukbb/data")

library(robustbase)

yes.ind <- read.csv("./Real_data/yes_ind.csv", header = T)
no.ind <- read.csv("/hpc/hers_en/psobrevals/bombari/no_ind.csv", header = T)
data.i <- read.csv("./Generated_data/data_y.csv", header = T)
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


b_i_w <- ethnic[ethnic[,2]=="British" |  ethnic[,2]=="Irish" |  ethnic[,2]=="White",]
arr_dif <- which((b_i_w[,-1] != "British") & (b_i_w[,-1] != "Irish") & (b_i_w[,-1] != "White"), arr.ind=T)
by_ethnicity <- c(by_ethnicity, b_i_w[arr_dif,1])


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
related <- read.table("../ukb55392_rel_s488265.dat", header = T)
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

# 4 BPD, SCZ, PSY individuals
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
  to_delete <- c(to_delete,individuals_20002[id,1])
}
for (id in bpd){
  to_delete <- c(to_delete,individuals_20002[id,1])
}
for (id in psy){
  to_delete <- c(to_delete,individuals_20002[id,1])
}
to_delete <- unique(to_delete)
length(to_delete) #270

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
  to_delete <- c(to_delete,individuals_20544[id,1])
}
for (id in bpd2){
  to_delete <- c(to_delete,individuals_20544[id,1])
}
for (id in psy2){
  to_delete <- c(to_delete,individuals_20544[id,1])
}
to_delete <- unique(to_delete)

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
  to_delete <- c(to_delete,individuals_41202[id,1])
}

# From id 41204:

for ( i in scz_bpd_psy){
  id <- which(individuals_41204==i, arr.ind = T)[,1]
  to_delete <- c(to_delete,individuals_41204[id,1])
}

# From id 40001:

for ( i in scz_bpd_psy){
  id <- which(individuals_40001==i, arr.ind = T)[,1]
  to_delete <- c(to_delete,individuals_40001[id,1])
}

to_delete <- unique(to_delete)


#--- Get only those healthy yes individuals
y.ind <- yes.ind[!(yes.ind %in% to_delete)]
y.ind <- cbind(y.ind,y.ind)
colnames(y.ind) <- c("FID","IID")
write.table(y.ind, file = "../../../../psobrevals/bombari/yes_ind_QC.txt", row.names = F)

#------ DISTRESSING CLEANED:

yes.ind <- read.csv( "./Real_data/yes_ind.csv", header = T)[,-1]

distressing <- grep("20462",col.names)
yes_distressing <- as.matrix(yes.ind)
yes_distressing <- cbind(yes_distressing, data.y[,distressing])
yes_distressing <- cbind(yes_distressing, data.y[,distressing])
colnames(yes_distressing) <- c("IID", "PHE_distressing", "Binary")
QC_yes_distressing_01 <- yes_distressing[,3]

answers <- c("Very distressing", "Quite distressing", "A bit distressing", "Not distressing, a neutral experience", 
             "Not distressing at all, it was a positive experience", "Do not know" , "Prefer not to answer")

for (i in answers) {
  how <- which(yes_distressing[,2]== i, arr.ind = T )
  if ( i == "Very distressing" || i == "Quite distressing" || i == "A bit distressing"){
    yes_distressing[how,3] <- "2"
  }
  else if ( i == "Do not know" || i == "Prefer not to answer" ){
    yes_distressing[how,3] <- "-9"
  }
  else {
    yes_distressing[how,3] <- "1"
  }
}

y_d <- read.table("/hpc/hers_en/psobrevals/bombari/yes_ind_QC.txt", header=T)
y_d <- cbind(y_d, y_d, yes_distressing[,3])
colnames(y_d) <- c("FID","IID","PHE")
write.table(y_d, file = "/hpc/hers_en/psobrevals/bombari/yes_distressing_01.txt",row.names = F)

yes.distr.qc <- merge(y.ind, y_d, by= c("FID","IID") )
write.table(yes.distr.qc,file = "/hpc/hers_en/psobrevals/bombari/yes_distressing_qc.txt",row.names = F)


