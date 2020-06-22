	setwd("/hpc/hers_en/shared/Bombari_Paula/ukbb/data/")

#------ Needed libraries
library(ukbtools)

#------ Load data using ukbtools
data.i <- read.csv("./Generated_data/data_y.csv", header = T)
data.y <- as.matrix(data.i)

col.names <- colnames(data.y)

#------ Get those columns with ever had a psychotic experience.
#   IQuestions, ID's and names: 
# 20468	Ever believed in an un-real conspiracy against self, 
# 20474	Ever believed in un-real communications or signs, 
# 20463	Ever heard an un-real voice, 
# 20471	Ever seen an un-real vision.
id.psych.exp <- c("20468","20474", "20463", "20471")
psych.experience <- matrix(nrow = nrow(data.y),ncol = 0)
psych.experience <- cbind(data.y[,2], data.y[,2], psych.experience)
for (i in id.psych.exp){
  id <- grep(i,col.names)
  psych.experience <- cbind(psych.experience, data.y[,id])
}
psych.experience <- as.matrix(psych.experience)
colnames(psych.experience) <- c("FID","IID", "Ever believed in an un-real conspiracy against self",
                               "Ever believed in un-real communications or signs", "Ever heard an un-real voice",
                               "Ever seen an un-real vision")
psych.qc <- merge(yes.ind.qc,psych.experience, by= c("FID","IID"))

write.csv(psych.qc, "/hpc/hers_en/psobrevals/bombari/psych_exp_qc.csv", col.names = T,row.names = F)

psych.qc <- as.matrix(read.csv("/hpc/hers_en/psobrevals/bombari/psych_exp_qc.csv", header= T))

psych.qc <- replace(psych.qc, (psych.qc == "Yes"), 2)
psych.qc <- replace(psych.qc, (psych.qc == "No"), 1)
psych.qc <- replace(psych.qc, is.na(psych.qc), -9)
colnames(psych.qc) = c("FID","IID","PHE1","PHE2","PHE3","PHE4")

write.table(psych.qc, "/hpc/hers_en/psobrevals/bombari/psych_exp_qc.txt", col.names = T,row.names = F)

# Load psych experiences to count the number of individuals:

diff <- read.csv("/hpc/hers_en/psobrevals/bombari/psych_exp_qc.csv", header=T)
non_healthy <- read.table("/hpc/hers_en/psobrevals/bombari/non_healthy_diff.txt",header=T)

#--Non healthy
conspiracy <- as.matrix(non_healthy[non_healthy[,3]=="Yes",1])
comunication <- as.matrix(non_healthy[non_healthy[,4]=="Yes",1])
voice <- as.matrix(non_healthy[non_healthy[,5]=="Yes",1])
vision <- as.matrix(non_healthy[non_healthy[,6]=="Yes",1])

i = conspiracy
colnames(i)[1] <- "eid"


#--Healthy

h_conspiracy <-  as.matrix(diff[diff[,3]=="Yes",1])
# 763
h_comunication <- as.matrix(diff[diff[,4]=="Yes",1])
# 678
h_voice <-  as.matrix(diff[diff[,5]=="Yes",1])
# 2039
h_vision <-  as.matrix(diff[diff[,6]=="Yes",1])
# 3979

i = h_conspiracy
colnames(i)[1] <- "eid"



#--Distressing

distr <- read.table("/hpc/hers_en/psobrevals/bombari/yes_distressing_qc.txt",header=T)
yes_distr <- distr[distr[,3]==2,1]
no_distr <- distr[distr[,3]==1,1]
h_nd_conspiracy <- no_distr[(no_distr %in% h_conspiracy)]

#--No distr/healthy
 length(no_distr[(no_distr %in% h_conspiracy)])
#[1] 426
 length(no_distr[(no_distr %in% h_comunication)])
#[1] 414
 length(no_distr[(no_distr %in% h_vision)])
#[1] 2363
 length(no_distr[(no_distr %in% h_voice)])
#[1] 1240

#- Distressing/healthy
 length(yes_distr[(yes_distr %in% h_voice)])
#[1] 752
 length(yes_distr[(yes_distr %in% h_vision)])
#[1] 1492
 length(yes_distr[(yes_distr %in% h_comunication)])
#[1] 246
 length(yes_distr[(yes_distr %in% h_conspiracy)])
#[1] 309


distr_nh <- read.table("/hpc/hers_en/psobrevals/bombari/yes_distressing.txt",header=T)

yes_distr <- distr_nh[distr_nh[,3]==2,1]
no_distr <- distr_nh[distr_nh[,3]==1,1]

 length(yes_distr[(yes_distr %in% conspiracy)])
#[1] 137
 length(yes_distr[(yes_distr %in% comunication)])
#[1] 120
 length(yes_distr[(yes_distr %in% voice)])
#[1] 155
 length(yes_distr[(yes_distr %in% vision)])
#[1] 134


#--Age :

 col.names <- colnames(data.y)
 age <- grep("21003",col.names)[1]
 age.questions <- c("eid",colnames(data.y)[age])
 age.data <- matrix(nrow = nrow(data.y),ncol = 0)
 age.data <- cbind(data.y[,2], age.data)
 age.data <- cbind(age.data, data.y[,age])
 colnames(age.data) <- age.questions



i = conspiracy
mean(as.numeric(levels(merge(i,age.data, by = "eid")[,2]))[merge(i,age.data, by = "eid")[,2]])

i = h_conspiracy
mean(as.numeric(levels(merge(i,age.data, by = "eid")[,2]))[merge(i,age.data, by = "eid")[,2]])


#--Sex :

sex <- grep("f31",col.names)[1]
sex.questions <- c("eid",colnames(data.y)[sex])
sex.data <- matrix(nrow = nrow(data.y),ncol = 0)
sex.data <- cbind(data.y[,1], sex.data)
sex.data <- cbind(sex.data, data.y[,sex])
colnames(sex.data) <- sex.questions
sex.data[sex.data[,2]=="Male",2] = 1
sex.data[sex.data[,2]=="Female",2] = 2



#--Overlapping:

#	Vision / Voice
        # Healthy
length(intersect(h_voice,h_vision))
