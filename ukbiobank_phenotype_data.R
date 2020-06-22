setwd("/hpc/hers_en/mbombari/ukbb/data")

#------ Needed libraries
#install.packages("ukbtools")
library(usethis)
library(devtools)
devtools::install_github("kenhanscombe/ukbtools", build_vignettes = TRUE, dependencies = TRUE)
library(ukbtools)
library(ggplot2)
library(naniar)
library(data.table)
library(english)

#------ Load data using ukbtools
my_ukb_data <- ukb_df("ukb39284")
#my_ukb_key <- ukb_df_field("ukb39284")
#View(my_ukb_data)
#View(my_ukb_key)
'''
save(my_ukb_data, file = "my_ukb_data_100.rda") # Save the data in a new file
load("my_ukb_data_100.rda") #To load the data saved

#------ Have a look at data by variables
ukb_context(my_ukb_data, nonmiss.var = my_ukb_data$standing_height_f50_0_0 )

my_subset_of_interest <- (my_ukb_data$body_mass_index_bmi_f21001_0_0 < 300)
ukb_context(my_ukb_data, subset.var = my_subset_of_interest )
'''
#----- Some of the questions have been answered more than once for the same
#   person, so this is to get just once the name of the question
col.names <- colnames(my_ukb_data)
questionaries <- c()
for (i in col.names) {
  if (endsWith(i,"0_0")) {
    questionaries <- c(questionaries,i)
  }
}
#questionaries # Name of non repeated questions
#my_ukb_data[,questionaries[936:945]] # To have a look at the questions
#my_ukb_data[grep("20191",col.names)]

#------ Get those columns with ever had a psychotic experience.
#   IQuestions, ID's and names: 20468	Ever believed in an un-real conspiracy against self, 20474	Ever believed in un-real communications or signs, 20463	Ever heard an un-real voice, 20471	Ever seen an un-real vision.
id.psych.exp <- c("20468","20474", "20463", "20466", "20471")
psych.experience <- matrix(nrow = nrow(my_ukb_data),ncol = 0)
psych.experience <- cbind(my_ukb_data[1], psych.experience)
for (i in id.psych.exp){
  id <- grep(i,col.names)
  psych.experience <- cbind(psych.experience, my_ukb_data[id])
}
psych.experience <- as.matrix(psych.experience)

#------ Find the "Yes" and "No" answers
y.values <- which(psych.experience=="Yes", arr.ind = T)[,1]
n.values <- which(psych.experience=="No", arr.ind = T)[,1]
n.values <- n.values[! n.values %in% y.values]

#------ Find the indiv with Yes and No answers
y.ind <- array(dim = 0)
for (i in y.values) {
  y.ind <- c(y.ind, psych.experience[i,1])
}

n.ind <- array(dim = 0)
for (i in n.values) {
  n.ind <- c(n.ind, psych.experience[i,1])
}

y.ind <- unique(y.ind) # Get unique ids so we have stored all the at least 1 psychotic experience
n.ind <- unique(n.ind)

to_plot <-rep(T:F,c(length(y.ind), length(n.ind)))
to_plot <- as.matrix(to_plot)
yes.no <- c()
for (i in to_plot[,1]){
  if (i==0){
    yes.no <- append(yes.no, "no")
  }
  else{
    yes.no <- append(yes.no, "yes")
  }
}
to_plot <- cbind(to_plot,yes.no )

ggplot(data=as.data.frame(to_plot), aes(x=to_plot[,2], fill=to_plot[,2])) +
  geom_bar(stat="count", show.legend = F) +
  geom_text(stat='count',aes(label=..count..),vjust=-1) +
  ggtitle("Participants answers on having any psychotic experience")+
  ylab("Total answers") +
  theme(axis.line=element_blank(),axis.ticks = element_blank(), axis.title.x = element_blank())


#------ Save files
write.csv(y.ind, file = "Generated_data/yes_ind.csv")
write.csv(n.ind, file = "Generated_data/no_ind.csv")
ggsave("Generated_data/histogram.pdf")


#------ Get the whole data for individuals with any psychotic experience

data.y <- as.matrix(merge(yes.ind, my_ukb_data,  by="eid"))[,-1]
write.csv(data.y, file = "Generated_data/data_y.csv")
'''
data.mx <- as.matrix(my_ukb_data)
data.y <- matrix(nrow = 0, ncol = ncol(data.mx))
for (i in y.ind) {
  id <- which(data.mx[,1] == i, arr.ind = T)
  data.y <- rbind(data.y, data.mx[id,])
}
write.csv(data.y, file = "Generated_data/data_y.csv")


data.y = ind with yes to any psychotic exp
'''

#------ Get the whole data for individuals with non NA's on having psychotic exxperience, so Yes and No.
data.a <- data.y
for (i in n.ind) {
  id <- which(data.mx[,1] == i, arr.ind = T)
  data.a <- rbind(data.a, data.mx[id,])
}
data.a <- data.a[order(data.a[,1]),]
write.csv(data.a, file = "Generated_data/data_a.csv")
'''
View(data.a) = ind that answered yes or no to any spych experience
'''

#------ From the yes individuals separate them with distressing and not distressing
distressing <- grep("20462",col.names)
yes_distressing <- as.matrix(y.ind)
yes_distressing <- cbind(yes_distressing, data.y[,distressing])
yes_distressing[,1] <- yes_distressing[,2]
colnames(yes_distressing) <- c("FID", "IID", "PHE_distressing")
write.csv(yes_distressing, file = "Generated_data/distressing_within_yes.csv")

distressing <- read.csv("Generated_data/distressing_within_yes.csv", header = T)
for (i in distressing[,3]){
  if (distressing[distressing[,3]=="Not distressing at all, it was a positive experience",3] <- "0" { distressing[,3] <- 0}
}
  
  if (i == "Prefer not to answer") {
    distressing[distressing[,3]==i,3] <- 0
  }
  else if (i == "Do not know") {
    distressing[distressing[,3]==i,3] <- 0
  }
  else if (i == "Not distressing at all, it was a positive experience") {
    distressing["Not distressing at all, it was a positive experience",3]  <- 1
  }
  else if (i == "Not distressing, a neutral experience") {
    distressing[distressing[,3]==i,3] <- 1
  }
  else if (i == "A bit distressing") {
    distressing[distressing[,3]==i,3] <- 2
  }
  else if (i == "Quite distressing") {
    distressing[distressing[,3]==i,3] <- 2
  }
  else if (i == "Very distressing") {
    distressing[distressing[,3]==i,3] <- 2
  }
}

#------ Get the questions that we are interested in
'''
library(stringr)
psy <- str_squish(psy)
psy <- strsplit(psy, " ")
write.csv(ask, file = "Table_questionaries_id_used.csv")
'''
questions.file <- read.csv("Table_questionaries_id_used.csv")
ids.wanted.questions <- as.array(questions.file[,3])

#------ Get the questions that we are interested in for indv that answered yes or no
interest.questions <- matrix(nrow = nrow(data.a),ncol = 0)
interest.questions <- cbind(data.a[,1], interest.questions)
colnames.questions <- c()
colnames.questions <- append(colnames.questions, "eid")

for (i in ids.wanted.questions){
  id <- grep(i,col.names)[1]
  colnames.questions <- append(colnames.questions, colnames(data.a)[id])
  interest.questions <- cbind(interest.questions, data.a[,id])
}
colnames(interest.questions) <- colnames.questions

#----- Create Barplots for each question % of missingness
# Function to colour the axis individuals by answer in psychotic experiences
colouring <- function(value) {
  to_colour <- c()
  for (j in value){
    if (j %in% y.ind){
      to_colour <- append(to_colour, "red")
    }
    else {to_colour <- append(to_colour, "black")}
  }
  return(to_colour)
}
to_colour <- colouring(data.a[,1])

gg_miss_fct(x = as.data.frame(interest.questions), fct = eid) +
  theme(axis.text.x = element_text(colour = to_colour)) +
  labs(title = "% Missingness per participant and question") + xlab("Participants") + ylab("Questions")
ggsave("Generated_data/ids_quest_missing.png", width = 90, height = 60, units = "cm")

#----- Mean age
age <- grep("21003",col.names)[1]
age.questions <- c("eid",colnames(data.a)[age])
age.data <- matrix(nrow = nrow(data.a),ncol = 0)
age.data <- cbind(data.a[,1], age.data)
age.data <- cbind(age.data, data.a[,age])
colnames(age.data) <- age.questions
av.age <- mean(as.integer(age.data[,2]))

write.csv(av.age, file = "Generated_data/av_age.csv")

#----- SEX
sex <- grep("f31",col.names)[1]
sex.questions <- c("eid",colnames(data.a)[sex])
sex.data <- matrix(nrow = nrow(data.a),ncol = 0)
sex.data <- cbind(data.a[,1], sex.data)
sex.data <- cbind(sex.data, data.a[,sex])
colnames(sex.data) <- sex.questions
sex.data[sex.data[,2]=="Male",2] = 1
sex.data[sex.data[,2]=="Female",2] = 2
write.csv(sex.data, file = "Generated_data/sex.csv")


#---- To clour the barplots x yes?no in psychosis
colouring <- function(value) {
  to_colour <- c()
  for (j in value){
    if (j %in% y.ind){
      to_colour <- append(to_colour, "red")
    }
    else {to_colour <- append(to_colour, "darkgrey")}
  }
  return(to_colour)
}

#---- Create Barplots for each group question % of missingness
cats <- unique(questions.file[,2])

for ( i in cats){
  id <- c()
  for ( j in questions.file[,2]){
    if (i == j){
      id <- c(id,questions.file[questions.file[,2]==j,3])
    }
    else {
      if(length(id) > 0){
        q <- paste(i,".questions", sep="")
        q <- assign(q, matrix(nrow = nrow(data.a),ncol = 0))
        q <- cbind(data.a[,1], q)
        c <- paste(i,".colnames", sep="")
        c <- assign(c, c("eid"))
        for (k in id){
          qid <- grep(k,col.names)[1]
          c <- append(c, colnames(data.a)[qid])
          q <- cbind(q, data.a[,qid])
        }
        colnames(q) <- c
        na.questions <- apply(q, 2, function(x) all(is.na(x)))
        q <- q[,!na.questions]
        gg_miss_fct(x = as.data.frame(q), fct = eid) +
          theme(axis.text.x = element_text(colour = to_colour)) +
          labs(title = paste(i,"related missingness", sep=" ")) + xlab("Participants") + ylab("Questions")
        ggsave(paste("Generated_data/missingness_",i,".png", sep=""), width = 30, units = "cm")
        break
      }
      next
    }
  }
}

'''

# If only one needed, follow this template:


########################################
###### Unusual and psychotic experiences
########################################

un.psy.exp <- c( "20461","20462","20468","20474","20463","20466","20471","20477","20467","20470","20476","20465","20473")
un.psy.exp.questions <- matrix(nrow = nrow(data.a),ncol = 0)
un.psy.exp.questions <- cbind(data.a[,1], un.psy.exp.questions)
un.psy.exp.colnames <- c("eid")

for (i in un.psy.exp){
  id <- grep(i,col.names)[1]
  un.psy.exp.colnames <- append(un.psy.exp.colnames, colnames(data.a)[id])
  un.psy.exp.questions <- cbind(un.psy.exp.questions, data.a[,id])
}
colnames(un.psy.exp.questions) <- un.psy.exp.colnames
na.questions <- apply(un.psy.exp.questions, 2, function(x) all(is.na(x)))
un.psy.exp.questions <- un.psy.exp.questions[,!na.questions]

gg_miss_fct(x = as.data.frame(un.psy.exp.questions), fct = eid) +
  theme(axis.text.x = element_text(colour = to_colour)) +
  labs(title = "Unusual psychotic experiences related missingness") + xlab("Participants") + ylab("Questions")
ggsave("Generated_data/missingness_unusual_psy_exp.png", width = 30, units = "cm")

#  If only one needed, follow this template example2:

##################
###### 	Education
##################

education <- c( "f6138", "20191")
education.questions <- matrix(nrow = nrow(data.a),ncol = 0)
education.questions <- cbind(data.a[,1], education.questions)
education.colnames <- c("eid")

for (i in education){
  id <- grep(i,col.names)[1]
  education.colnames <- append(education.colnames, colnames(data.a)[id])
  education.questions <- cbind(education.questions, data.a[,id])
}
colnames(education.questions) <- education.colnames
na.questions <- apply(education.questions, 2, function(x) all(is.na(x)))
education.questions <- education.questions[,!na.questions]

gg_miss_fct(x = as.data.frame(education.questions), fct = eid) +
  theme(axis.text.x = element_text(colour = to_colour)) +
  labs(title = "education Information related missingness") + xlab("Participants") + ylab("Questions")
ggsave("Generated_data/missingness_education.png", width = 30, units = "cm")
'''

#------ Get the questions with +1 instance
instance.data <- read.csv("Instances_ids.csv")[,-1]
repeated.questions <- matrix(nrow = 0,ncol = 2)
colnames(repeated.questions) <- colnames(instance.data)
i = max(instance.data[,2])
while (i > 1) {
    repeated.questions <- rbind(repeated.questions, instance.data[instance.data[,2]==i,])
    i = i-1
}

#repeated.questions # matrix of 2 columns fields of the question and instances of the question. (with questions that have +1 instance)

#------ Plot questions by instance:
n = max(instance.data[,2])
while ( n > 1) {
  n.questions.id <- repeated.questions[repeated.questions[,2] == n,]
  n.questions.idx <- c()
  n.questions.names <- c()
  for (i in n.questions.id[,1]){
    idx <- grep(i, col.names)
    n.questions.idx <- c(n.questions.idx, idx)
    n.questions.names <- c(n.questions.names, colnames(data.a)[idx])
  }
  j = 0

  while (j < n) {
    j.n <- paste(as.english(j),".instance", sep="")
    j.n <- assign(j.n, matrix(nrow = nrow(data.a), ncol = 0))
    j.n <- cbind(data.a[,1], j.n)
    if (j == 0) {
        zero.colnames <- c(n.questions.names %like% "_0_0")
        zero.colnames <- c("eid",n.questions.names[zero.colnames])
        zero.instance <- cbind(data.a[,1], data.a[,zero.colnames])
        zero.nas <- sum(is.na(zero.instance))
        zero.total <- length(zero.instance)
        zero.av.miss <- round((zero.nas/zero.total)*100, digits = 3)
        Instances <- c("1st Instance")
        Missing <- c(zero.nas)
        Total <- c(zero.total)
        Percentage <- c(zero.av.miss)
    }
    else if (j == 1) {
      one.colnames <- c(n.questions.names %like% "_1_0")
      one.colnames <- c("eid",n.questions.names[one.colnames])
      one.instance <- cbind(data.a[,1], data.a[,one.colnames])
      one.nas <- sum(is.na(one.instance))
      one.total <- length(one.instance)
      one.av.miss <- round((one.nas/one.total)*100, digits = 3)
      Instances <- c(Instances, "2nd Instance")
      Missing <- c(Missing, one.nas)
      Total <- c(Total, one.total)
      Percentage <- c(Percentage, one.av.miss)
    }
    else if (j == 2) {
      two.colnames <- c(n.questions.names %like% "_2_0")
      two.colnames <- c("eid",n.questions.names[two.colnames])
      two.instance <- cbind(data.a[,1], data.a[,two.colnames])
      two.nas <- sum(is.na(two.instance))
      two.total <- length(two.instance)
      two.av.miss <- round((two.nas/two.total)*100, digits = 3)
      Instances <- c(Instances, "3rd Instance")
      Missing <- c(Missing, two.nas)
      Total <- c(Total, two.total)
      Percentage <- c(Percentage, two.av.miss)

    }
    else if (j == 3) {
      three.colnames <- c(n.questions.names %like% "_3_0")
      three.colnames <- c("eid",n.questions.names[three.colnames])
      three.instance <- cbind(data.a[,1], data.a[,three.colnames])
      three.nas <- sum(is.na(three.instance))
      three.total <- length(three.instance)
      three.av.miss <- round((three.nas/three.total)*100, digits = 3)
      Instances <- c(Instances, "4th Instance")
      Missing <- c(Missing, three.nas)
      Total <- c(Total, three.total)
      Percentage <- c(Percentage, three.av.miss)
    }
    j = j + 1
  }
  n.table <- data.frame(Instances = Instances, Missing = Missing, Total = Total, Percentage = Percentage)
 ggplot(data=n.table, aes(x=n.table[,1], y=n.table[,2])) +
   geom_bar(stat="identity", aes(fill=n.table[,4]), show.legend = F)+
   geom_text(aes(y=n.table[,2], label=paste(n.table[,4], "%", "\n", n.table[,2] )), vjust=1.6, 
             color="white", size=3.5)+
   ggtitle(paste("Missingness per time point in questions with", n, "instances.","Total answers:", zero.total, sep = " ")) + xlab("Time point") + ylab("Missingness") +
  ggsave(paste("Total_data/time_points_", n, "_instances.pdf", sep = ""))
  n = n-1
}

#------ DISTRESSING:

distressing <- grep("20462",col.names)
yes_distressing <- as.matrix(yes.ind)[,2]
yes_distressing <- cbind(yes_distressing, data.y[,distressing])
yes_distressing <- cbind(yes_distressing, data.y[,distressing])
colnames(yes_distressing) <- c("IID", "PHE_distressing", "Binary")

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

write.csv(yes_distressing, file = "Generated_data/yes_distressing_01.csv")

#---- Recode the file of distressingness + ind, to match the plink format:

distressing_raw <- read.csv("Generated_data/yes_distressing_01.csv", header = T)
distressing_clean <- cbind(distressing_raw[,2], distressing_raw[,2], distressing_raw[,4])
colnames(distressing_clean) <- c("FID", "IID", "PHE")

write.csv(distressing_clean, file = "Generated_data/yes_distressing_cleaned.csv")

'''
-9 missing 
     0 missing
     1 unaffected
     2 affected

'''

distressing_clean <- read.csv("Generated_data/yes_distressing_cleaned.csv", header = T)[,-1]
distressing_clean <- distressing_clean[,-1]
head(distressing_clean)
write.table(distressing_clean, file = "Generated_data/yes_distressing_cleaned.txt", row.names = F)
distressing_clean[distressing_clean[,4]==1,4] <- "2"
distressing_clean[distressing_clean[,4]==0,4] <- "1"
distressing_clean[distressing_clean[,4]==-999,4] <- "-9"
