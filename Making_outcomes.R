data_y <- read.csv("/hpc/hers_en/shared/Paula_Carina2/data_y.csv",header=T)
library("plyr")
yes <- read.table("/hpc/hers_en/psobrevals/bombari/yes_ind_QC.txt",header=T)


#USE 7000 people

#OUTCOMES

#1 Education and IQ
education_IQ_all <- c(data_y$fluid_intelligence_score_f20016_0_0,
                      data_y$fluid_intelligence_score_f20016_1_0,
                      data_y$fluid_intelligence_score_f20016_2_0,
                      data_y$fluid_intelligence_score_f20016_3_0)

eduIQ_bin <- mapvalues(education_IQ_all, 
                       from = c("Daily or almost daily", "Less than monthly","Monthly","Never","Weekly", "Prefer not to answer"),
                       to = c("5", "2", "3", "1", "4", NA))


#education --> 1=university/college, 0 - lager
## TIMEPOINT 0## 1 universiteit of college, 0= lager
edu_qua_bin_00 <- mapvalues(data_y$qualifications_f6138_0_0, 
                            from = c("A levels/AS levels or equivalent", "College or University degree",
                                     "CSEs or equivalent","None of the above","NVQ or HND or HNC or equivalent",
                                     "O levels/GCSEs or equivalent", 
                                     "Other professional qualifications eg: nursing, teaching",
                                     "Prefer not to answer"),
                            to = c("0", "1", "0", NA, "0", "0", "0", NA))

edu_qua_bin_01 <- mapvalues(data_y$qualifications_f6138_0_1, 
                            from = c("A levels/AS levels or equivalent",
                                     "CSEs or equivalent","NVQ or HND or HNC or equivalent",
                                     "O levels/GCSEs or equivalent", 
                                     "Other professional qualifications eg: nursing, teaching"),
                            to = c("0", "0", "0", "0", "0"))

edu_qua_bin_02 <- mapvalues(data_y$qualifications_f6138_0_2, 
                            from = c("CSEs or equivalent","NVQ or HND or HNC or equivalent",
                                     "O levels/GCSEs or equivalent", 
                                     "Other professional qualifications eg: nursing, teaching"),
                            to = c("0", "0", "0", "0"))

edu_qua_bin_03 <- mapvalues(data_y$qualifications_f6138_0_3, 
                            from = c("CSEs or equivalent","NVQ or HND or HNC or equivalent", 
                                     "Other professional qualifications eg: nursing, teaching"),
                            to = c( "0", "0", "0"))

edu_qua_bin_04 <- mapvalues(data_y$qualifications_f6138_0_4, 
                            from = c("NVQ or HND or HNC or equivalent",
                                     "Other professional qualifications eg: nursing, teaching"),
                            to = c( "0", "0"))

edu_qua_bin_05 <- mapvalues(data_y$qualifications_f6138_0_5, 
                            from = c("Other professional qualifications eg: nursing, teaching"),
                            to = c("0"))

edu_qua_bin_00_num <- as.numeric(edu_qua_bin_00)
edu_qua_bin_01_num <- as.numeric(edu_qua_bin_01)
edu_qua_bin_02_num <- as.numeric(edu_qua_bin_02)
edu_qua_bin_03_num <- as.numeric(edu_qua_bin_03)
edu_qua_bin_04_num <- as.numeric(edu_qua_bin_04)
edu_qua_bin_05_num <- as.numeric(edu_qua_bin_05)

edu_qua_total_0_num <- data.frame(edu_qua_bin_00_num, edu_qua_bin_01_num, edu_qua_bin_02_num, 
                                  edu_qua_bin_03_num, edu_qua_bin_04_num, edu_qua_bin_05_num)
edu_qua_total_0_num$sum <- rowSums(edu_qua_total_0_num, na.rm = T)

## TIMEPOINT 1## 1 universiteit of college, 0= lager
edu_qua_bin_10 <- mapvalues(data_y$qualifications_f6138_1_0, 
                            from = c("A levels/AS levels or equivalent", "College or University degree",
                                     "CSEs or equivalent","None of the above","NVQ or HND or HNC or equivalent",
                                     "O levels/GCSEs or equivalent", 
                                     "Other professional qualifications eg: nursing, teaching",
                                     "Prefer not to answer"),
                            to = c("0", "1", "0", NA, "0", "0", "0", NA))

edu_qua_bin_11 <- mapvalues(data_y$qualifications_f6138_1_1, 
                            from = c("A levels/AS levels or equivalent",
                                     "CSEs or equivalent","NVQ or HND or HNC or equivalent",
                                     "O levels/GCSEs or equivalent", 
                                     "Other professional qualifications eg: nursing, teaching"),
                            to = c("0", "0", "0", "0", "0"))

edu_qua_bin_12 <- mapvalues(data_y$qualifications_f6138_1_2, 
                            from = c("CSEs or equivalent","NVQ or HND or HNC or equivalent",
                                     "O levels/GCSEs or equivalent", 
                                     "Other professional qualifications eg: nursing, teaching"),
                            to = c("0", "0", "0", "0"))

edu_qua_bin_13 <- mapvalues(data_y$qualifications_f6138_1_3, 
                            from = c("CSEs or equivalent","NVQ or HND or HNC or equivalent", 
                                     "Other professional qualifications eg: nursing, teaching"),
                            to = c( "0", "0", "0"))

edu_qua_bin_14 <- mapvalues(data_y$qualifications_f6138_1_4, 
                            from = c("NVQ or HND or HNC or equivalent",
                                     "Other professional qualifications eg: nursing, teaching"),
                            to = c( "0", "0"))

edu_qua_bin_15 <- mapvalues(data_y$qualifications_f6138_1_5, 
                            from = c("Other professional qualifications eg: nursing, teaching"),
                            to = c("0"))

edu_qua_bin_10_num <- as.numeric(edu_qua_bin_10)
edu_qua_bin_11_num <- as.numeric(edu_qua_bin_11)
edu_qua_bin_12_num <- as.numeric(edu_qua_bin_12)
edu_qua_bin_13_num <- as.numeric(edu_qua_bin_13)
edu_qua_bin_14_num <- as.numeric(edu_qua_bin_14)
edu_qua_bin_15_num <- as.numeric(edu_qua_bin_15)

edu_qua_total_1_num <- data.frame(edu_qua_bin_10_num, edu_qua_bin_11_num, edu_qua_bin_12_num, 
                                  edu_qua_bin_13_num, edu_qua_bin_14_num, edu_qua_bin_15_num)
edu_qua_total_1_num$sum <- rowSums(edu_qua_total_1_num, na.rm = T)

## TIMEPOINT 2## 1 universiteit of college, 0= lager
edu_qua_bin_20 <- mapvalues(data_y$qualifications_f6138_2_0, 
                            from = c("A levels/AS levels or equivalent", "College or University degree",
                                     "CSEs or equivalent","None of the above","NVQ or HND or HNC or equivalent",
                                     "O levels/GCSEs or equivalent", 
                                     "Other professional qualifications eg: nursing, teaching",
                                     "Prefer not to answer"),
                            to = c("0", "1", "0", NA, "0", "0", "0", NA))

edu_qua_bin_21 <- mapvalues(data_y$qualifications_f6138_2_1, 
                            from = c("A levels/AS levels or equivalent",
                                     "CSEs or equivalent","NVQ or HND or HNC or equivalent",
                                     "O levels/GCSEs or equivalent", 
                                     "Other professional qualifications eg: nursing, teaching"),
                            to = c("0", "0", "0", "0", "0"))

edu_qua_bin_22 <- mapvalues(data_y$qualifications_f6138_2_2, 
                            from = c("CSEs or equivalent","NVQ or HND or HNC or equivalent",
                                     "O levels/GCSEs or equivalent", 
                                     "Other professional qualifications eg: nursing, teaching"),
                            to = c("0", "0", "0", "0"))

edu_qua_bin_23 <- mapvalues(data_y$qualifications_f6138_2_3, 
                            from = c("CSEs or equivalent","NVQ or HND or HNC or equivalent", 
                                     "Other professional qualifications eg: nursing, teaching"),
                            to = c( "0", "0", "0"))

edu_qua_bin_24 <- mapvalues(data_y$qualifications_f6138_2_4, 
                            from = c("NVQ or HND or HNC or equivalent",
                                     "Other professional qualifications eg: nursing, teaching"),
                            to = c( "0", "0"))

edu_qua_bin_25 <- mapvalues(data_y$qualifications_f6138_2_5, 
                            from = c("Other professional qualifications eg: nursing, teaching"),
                            to = c("0"))

edu_qua_bin_20_num <- as.numeric(edu_qua_bin_20)
edu_qua_bin_21_num <- as.numeric(edu_qua_bin_21)
edu_qua_bin_22_num <- as.numeric(edu_qua_bin_22)
edu_qua_bin_23_num <- as.numeric(edu_qua_bin_23)
edu_qua_bin_24_num <- as.numeric(edu_qua_bin_24)
edu_qua_bin_25_num <- as.numeric(edu_qua_bin_25)

edu_qua_total_2_num <- data.frame(edu_qua_bin_20_num, edu_qua_bin_21_num, edu_qua_bin_22_num, 
                                  edu_qua_bin_23_num, edu_qua_bin_24_num, edu_qua_bin_25_num)
edu_qua_total_2_num$sum <- rowSums(edu_qua_total_2_num, na.rm = T)

## TIMEPOINT 2## 1 universiteit of college, 0= lager
edu_qua_bin_30 <- mapvalues(data_y$qualifications_f6138_3_0, 
                            from = c("A levels/AS levels or equivalent", "College or University degree",
                                     "CSEs or equivalent","None of the above","NVQ or HND or HNC or equivalent",
                                     "O levels/GCSEs or equivalent"),
                            to = c("0", "1", "0", NA, "0", "0"))

edu_qua_bin_31 <- mapvalues(data_y$qualifications_f6138_3_1, 
                            from = c("A levels/AS levels or equivalent",
                                     "CSEs or equivalent","NVQ or HND or HNC or equivalent",
                                     "O levels/GCSEs or equivalent", 
                                     "Other professional qualifications eg: nursing, teaching"),
                            to = c("0", "0", "0", "0", "0"))

edu_qua_bin_32 <- (data_y$qualifications_f6138_3_2)
edu_qua_bin_33 <- (data_y$qualifications_f6138_3_3)
edu_qua_bin_34 <- (data_y$qualifications_f6138_3_4)
edu_qua_bin_35 <- (data_y$qualifications_f6138_3_5)

edu_qua_bin_30_num <- as.numeric(edu_qua_bin_30)
edu_qua_bin_31_num <- as.numeric(edu_qua_bin_31)
edu_qua_bin_32_num <- as.numeric(edu_qua_bin_32)
edu_qua_bin_33_num <- as.numeric(edu_qua_bin_33)
edu_qua_bin_34_num <- as.numeric(edu_qua_bin_34)
edu_qua_bin_35_num <- as.numeric(edu_qua_bin_35)

edu_qua_total_3_num <- data.frame(edu_qua_bin_30_num, edu_qua_bin_31_num, edu_qua_bin_32_num, 
                                  edu_qua_bin_33_num, edu_qua_bin_34_num, edu_qua_bin_35_num)
edu_qua_total_3_num$sum <- rowSums(edu_qua_total_3_num, na.rm = T)
View(edu_qua_total_3_num)

edu_qua_0 <- edu_qua_total_0_num$sum
edu_qua_1 <- edu_qua_total_1_num$sum
edu_qua_2 <- edu_qua_total_2_num$sum
edu_qua_3 <- edu_qua_total_3_num$sum
edu_qua_df <- data.frame(edu_qua_0, edu_qua_1, edu_qua_2, edu_qua_3)

edu_qua_df$edu_qua_0[edu_qua_df$edu_qua_0 < 1] <- "0"
edu_qua_df$edu_qua_1[edu_qua_df$edu_qua_1 < 1] <- "0"
edu_qua_df$edu_qua_2[edu_qua_df$edu_qua_2 < 1] <- "0"
edu_qua_df$edu_qua_3[edu_qua_df$edu_qua_3 < 1] <- "0"

edu_qua_df$edu_qua_0[edu_qua_df$edu_qua_0 >= 1] <- "1"
edu_qua_df$edu_qua_1[edu_qua_df$edu_qua_1 >= 1] <- "1"
edu_qua_df$edu_qua_2[edu_qua_df$edu_qua_2 >= 1] <- "1"
edu_qua_df$edu_qua_3[edu_qua_df$edu_qua_3 >= 1] <- "1"

edu_qua_0_num <- as.numeric(edu_qua_0)
edu_qua_1_num <- as.numeric(edu_qua_1)
edu_qua_2_num <- as.numeric(edu_qua_2)
edu_qua_3_num <- as.numeric(edu_qua_3)

edu_qua_df_numeric <- data.frame(edu_qua_0_num, edu_qua_1_num, edu_qua_2_num, edu_qua_3_num)

edu_qua_df_numeric$sum <- rowSums(edu_qua_df_numeric, na.rm = T)
edu_qua_df_numeric$sum[edu_qua_df_numeric$sum >= 1] <- "1"
edu_qua_df_numeric$sum[edu_qua_df_numeric$sum < 1] <- "0"
edu_qua_df_numeric_sumnum <- as.numeric(edu_qua_df_numeric$sum)

Education_attainment <- edu_qua_df_numeric_sumnum

#2 Employment # 1 is gewerkt, 0 = niet gewerkt
#EMPLOYMENT

#timepoint 0
data_y$current_employment_status_f6142_0_0

emp_df_0_bin <- mapvalues(data_y$current_employment_status_f6142_0_0, 
                          from = c("Doing unpaid or voluntary work", "Full or part-time student", 
                                   "In paid employment or self-employed","Looking after home and/or family",
                                   "None of the above", "Prefer not to answer","Retired","Unable to work because of sickness or disability",
                                   "Unemployed"),
                          to = c("1", "1", "1", "0", "0", NA,"1","0","0")) 

emp_df_1_bin <- mapvalues(data_y$current_employment_status_f6142_0_1, 
                          from = c("Doing unpaid or voluntary work", "Full or part-time student", 
                                   "Looking after home and/or family",
                                   "Retired","Unable to work because of sickness or disability",
                                   "Unemployed"),
                          to = c("1", "1", "0","1","0","0")) 

emp_df_2_bin <- mapvalues(data_y$current_employment_status_f6142_0_2, 
                          from = c("Doing unpaid or voluntary work", "Full or part-time student", 
                                   "Looking after home and/or family",
                                   "Unable to work because of sickness or disability",
                                   "Unemployed"),
                          to = c("1", "1", "0","0","0")) 

emp_df_3_bin <- mapvalues(data_y$current_employment_status_f6142_0_3, 
                          from = c("Doing unpaid or voluntary work", "Full or part-time student"),
                          to = c("1", "1")) 

#only NA
emp_df_4_bin <- (data_y$current_employment_status_f6142_0_4)
emp_df_5_bin <- (data_y$current_employment_status_f6142_0_5)
emp_df_6_bin <- (data_y$current_employment_status_f6142_0_6) 

#numeric maken
emp_df_0_bin_num <- as.numeric(emp_df_0_bin)
emp_df_1_bin_num <- as.numeric(emp_df_1_bin)
emp_df_2_bin_num <- as.numeric(emp_df_2_bin)
emp_df_3_bin_num <- as.numeric(emp_df_3_bin)
emp_df_4_bin_num <- as.numeric(emp_df_4_bin)
emp_df_5_bin_num <- as.numeric(emp_df_5_bin)
emp_df_6_bin_num <- as.numeric(emp_df_6_bin)

#numeric dataframe (0=1 unemployed, 1=2 employment)
emp_total_0_num <- data.frame(emp_df_0_bin_num, emp_df_1_bin_num, emp_df_2_bin_num, emp_df_3_bin_num,
                              emp_df_4_bin_num, emp_df_5_bin_num, emp_df_6_bin_num)
emp_total_0_num$sum <- rowSums(emp_total_0_num, na.rm = T)
View(emp_total_0_num)
##hoger dan 1 is werk, 1 of lager is geen werk

#TIMEPOINT 1
cylinder <- table(data_y$current_employment_status_f6142_1_6)
View(cylinder)

emp1_df_0_bin <- mapvalues(data_y$current_employment_status_f6142_0_0, 
                           from = c("Doing unpaid or voluntary work", "Full or part-time student", 
                                    "In paid employment or self-employed","Looking after home and/or family",
                                    "None of the above", "Prefer not to answer","Retired","Unable to work because of sickness or disability",
                                    "Unemployed"),
                           to = c("1", "1", "1", "0", "0", NA,"1","0","0")) 

emp1_df_1_bin <- mapvalues(data_y$current_employment_status_f6142_0_1, 
                           from = c("Doing unpaid or voluntary work", "Full or part-time student", 
                                    "Looking after home and/or family",
                                    "Retired","Unable to work because of sickness or disability"),
                           to = c("1", "1", "0","1","0")) 

emp1_df_2_bin <- mapvalues(data_y$current_employment_status_f6142_0_2, 
                           from = c("Doing unpaid or voluntary work", "Full or part-time student", 
                                    "Looking after home and/or family"),
                           to = c("1", "1", "0")) 

#only NA
emp1_df_3_bin <- (data_y$current_employment_status_f6142_0_3)
emp1_df_4_bin <- (data_y$current_employment_status_f6142_0_4)
emp1_df_5_bin <- (data_y$current_employment_status_f6142_0_5)
emp1_df_6_bin <- (data_y$current_employment_status_f6142_0_6) 

#numeric maken
emp1_df_0_bin_num <- as.numeric(emp_df_0_bin)
emp1_df_1_bin_num <- as.numeric(emp_df_1_bin)
emp1_df_2_bin_num <- as.numeric(emp_df_2_bin)
emp1_df_3_bin_num <- as.numeric(emp_df_3_bin)
emp1_df_4_bin_num <- as.numeric(emp_df_4_bin)
emp1_df_5_bin_num <- as.numeric(emp_df_5_bin)
emp1_df_6_bin_num <- as.numeric(emp_df_6_bin)

#numeric dataframe (0=1 unemployed, 1=2 employment)
emp_total_1_num <- data.frame(emp1_df_0_bin_num, emp1_df_1_bin_num, emp1_df_2_bin_num, emp1_df_3_bin_num,
                              emp1_df_4_bin_num, emp1_df_5_bin_num, emp1_df_6_bin_num)
emp_total_1_num$sum <- rowSums(emp_total_1_num, na.rm = T)
View(emp_total_1_num)

##hoger dan 1 is werk, 1 of lager is geen werk

#TIMEPOINT 2
cylinder <- table(data_y$current_employment_status_f6142_2_6)
View(cylinder)

emp2_df_0_bin <- mapvalues(data_y$current_employment_status_f6142_2_0, 
                           from = c("Doing unpaid or voluntary work", "Full or part-time student", 
                                    "In paid employment or self-employed","Looking after home and/or family",
                                    "None of the above", "Prefer not to answer","Retired","Unable to work because of sickness or disability",
                                    "Unemployed"),
                           to = c("1", "1", "1", "0", "0", NA,"1","0","0")) 

emp2_df_1_bin <- mapvalues(data_y$current_employment_status_f6142_2_1, 
                           from = c("Doing unpaid or voluntary work", "Full or part-time student", 
                                    "Looking after home and/or family",
                                    "Retired","Unable to work because of sickness or disability",
                                    "Unemployed"),
                           to = c("1", "1", "0","1","0","0")) 

emp2_df_2_bin <- mapvalues(data_y$current_employment_status_f6142_2_2, 
                           from = c("Doing unpaid or voluntary work", "Full or part-time student", 
                                    "Looking after home and/or family",
                                    "Unable to work because of sickness or disability"),
                           to = c("1", "1", "0","0")) 

emp2_df_3_bin <- mapvalues(data_y$current_employment_status_f6142_2_3, 
                           from = c( "Full or part-time student"),
                           to = c( "1")) 

#only NA
emp2_df_4_bin <- (data_y$current_employment_status_f6142_2_4)
emp2_df_5_bin <- (data_y$current_employment_status_f6142_2_5)
emp2_df_6_bin <- (data_y$current_employment_status_f6142_2_6) 

#numeric maken
emp2_df_0_bin_num <- as.numeric(emp2_df_0_bin)
emp2_df_1_bin_num <- as.numeric(emp2_df_1_bin)
emp2_df_2_bin_num <- as.numeric(emp2_df_2_bin)
emp2_df_3_bin_num <- as.numeric(emp2_df_3_bin)
emp2_df_4_bin_num <- as.numeric(emp2_df_4_bin)
emp2_df_5_bin_num <- as.numeric(emp2_df_5_bin)
emp2_df_6_bin_num <- as.numeric(emp2_df_6_bin)

#numeric dataframe (0=1 unemployed, 1=2 employment, Na= 0)
emp_total_2_num <- data.frame(emp2_df_0_bin_num, emp2_df_1_bin_num, emp2_df_2_bin_num, emp2_df_3_bin_num,
                              emp2_df_4_bin_num, emp2_df_5_bin_num, emp2_df_6_bin_num)
emp_total_2_num$sum <- rowSums(emp_total_2_num, na.rm = T)
View(emp_total_2_num)

#TIMEPOINT 3
cylinder <- table(data_y$current_employment_status_f6142_3_3)
View(cylinder)


emp3_df_0_bin <- mapvalues(data_y$current_employment_status_f6142_3_0, 
                           from = c("In paid employment or self-employed","Looking after home and/or family",
                                    "Retired"),
                           to = c("1", "0", "1")) 

emp3_df_1_bin <- mapvalues(data_y$current_employment_status_f6142_3_1, 
                           from = c( "Looking after home and/or family"),
                           to = c( "0")) 

emp3_df_2_bin <- mapvalues(data_y$current_employment_status_f6142_3_2, 
                           from = c("Doing unpaid or voluntary work"),
                           to = c("1")) 

#only NA
emp3_df_3_bin <- (data_y$current_employment_status_f6142_3_3) 
emp3_df_4_bin <- (data_y$current_employment_status_f6142_3_4)
emp3_df_5_bin <- (data_y$current_employment_status_f6142_3_5)
emp3_df_6_bin <- (data_y$current_employment_status_f6142_3_6) 

#numeric maken
emp3_df_0_bin_num <- as.numeric(emp3_df_0_bin)
emp3_df_1_bin_num <- as.numeric(emp3_df_1_bin)
emp3_df_2_bin_num <- as.numeric(emp3_df_2_bin)
emp3_df_3_bin_num <- as.numeric(emp3_df_3_bin)
emp3_df_4_bin_num <- as.numeric(emp3_df_4_bin)
emp3_df_5_bin_num <- as.numeric(emp3_df_5_bin)
emp3_df_6_bin_num <- as.numeric(emp3_df_6_bin)

#numeric dataframe (0=1 unemployed, 1=2 employment)
emp_total_3_num <- data.frame(emp3_df_0_bin_num, emp3_df_1_bin_num, emp3_df_2_bin_num, emp3_df_3_bin_num,
                              emp3_df_4_bin_num, emp3_df_5_bin_num, emp3_df_6_bin_num)
emp_total_3_num$sum <- rowSums(emp_total_3_num, na.rm = T)
View(emp_total_3_num)

#sum samen doen
employment_0 <- emp_total_0_num$sum
employment_1 <- emp_total_1_num$sum
employment_2 <- emp_total_2_num$sum
employment_3 <- emp_total_3_num$sum

Employment_df <- data.frame(employment_0, employment_1, employment_2, employment_3)
# 1= geen werk, 2= wel werk, 0 = NA

Employment_df$employment_0[Employment_df$employment_0 < 1] <- "0"
Employment_df$employment_1[Employment_df$employment_1 < 1] <- "0"
Employment_df$employment_2[Employment_df$employment_2 < 1] <- "0"
Employment_df$employment_3[Employment_df$employment_3 < 1] <- "0"

Employment_df$employment_0[Employment_df$employment_0 >= 1] <- "1"
Employment_df$employment_1[Employment_df$employment_1 >= 1] <- "1"
Employment_df$employment_2[Employment_df$employment_2 >= 1] <- "1"
Employment_df$employment_3[Employment_df$employment_3 >= 1] <- "1"

Employment_df$employment_0_num <- as.numeric(Employment_df$employment_0)
Employment_df$employment_1_num <- as.numeric(Employment_df$employment_1)
Employment_df$employment_2_num <- as.numeric(Employment_df$employment_2)
Employment_df$employment_3_num <- as.numeric(Employment_df$employment_3)

employm_df_numeric <- data.frame(Employment_df$employment_0_num, 
                                 Employment_df$employment_1_num, 
                                 Employment_df$employment_2_num, 
                                 Employment_df$employment_3_num)


employm_df_numeric$sum <- rowSums(employm_df_numeric, na.rm = T)
employm_df_numeric$sum[employm_df_numeric$sum >= 1] <- "1"
employm_df_numeric$sum[employm_df_numeric$sum < 1] <- "0"
employm_df_numeric_sumnum <- as.numeric(employm_df_numeric$sum)

Employment <- employm_df_numeric_sumnum

# 1 is gewerkt, 0 = niet gewerkt

#3 Social support
#social support
confide0 <- data_y$able_to_confide_f2110_0_0 
confide1 <- data_y$able_to_confide_f2110_1_0
confide2 <- data_y$able_to_confide_f2110_2_0
confide3 <- data_y$able_to_confide_f2110_3_0

#1= almost daily to once every few months, 0= never or almost never
confide0_bin <- mapvalues(confide0, 
                          from = c("2-4 times a week","About once a month","About once a week",
                                   "Almost daily", "Do not know", "Never or almost never",
                                   "Once every few months","Prefer not to answer"),
                          to = c("1", "1","1","1", NA,"0","1", NA)) 

confide1_bin <- mapvalues(confide1, 
                          from = c("2-4 times a week","About once a month","About once a week",
                                   "Almost daily", "Do not know", "Never or almost never",
                                   "Once every few months"),
                          to = c("1", "1","1","1", NA,"0","1")) 

confide2_bin <- mapvalues(confide2, 
                          from = c("2-4 times a week","About once a month","About once a week",
                                   "Almost daily", "Do not know", "Never or almost never",
                                   "Once every few months","Prefer not to answer"),
                          to = c("1", "1","1","1", NA,"0","1", NA)) 

confide3_bin <- mapvalues(confide3, 
                          from = c("2-4 times a week","About once a month","About once a week",
                                   "Almost daily", "Never or almost never",
                                   "Once every few months"),
                          to = c("1", "1","1","1","0","1")) 

confide0_bin_num <- as.numeric(confide0_bin)
confide1_bin_num <- as.numeric(confide1_bin)
confide2_bin_num <- as.numeric(confide2_bin)
confide3_bin_num <- as.numeric(confide3_bin)
confide_df_num <- data.frame(confide0_bin_num, confide1_bin_num, confide2_bin_num, confide3_bin_num)
confide_df_num$sum <- rowSums(confide_df_num, na.rm = T)

confide_df_num$sum[confide_df_num$sum >= 1] <- "1"
confide_df_num$sum[confide_df_num$sum < 1] <- "0"

confide_num <- as.numeric(confide_df_num$sum)
Confide <- confide_num 

####ISITS 0= less then once a month to never , 1= once a month or more
visits0 <- data_y$frequency_of_friendfamily_visits_f1031_0_0
visits1 <- data_y$frequency_of_friendfamily_visits_f1031_1_0
visits2 <- data_y$frequency_of_friendfamily_visits_f1031_2_0
visits3 <- data_y$frequency_of_friendfamily_visits_f1031_3_0

visits0_bin <- mapvalues(visits0, 
                         from = c("2-4 times a week","About once a month","About once a week",
                                  "Almost daily", "Do not know", "Never or almost never",
                                  "No friends/family outside household",
                                  "Once every few months","Prefer not to answer"),
                         to = c("1", "1","1","1", NA,"0","0", "1",NA)) 

visits1_bin <- mapvalues(visits1, 
                         from = c("2-4 times a week","About once a month","About once a week",
                                  "Almost daily", "Never or almost never",
                                  "No friends/family outside household",
                                  "Once every few months","Prefer not to answer"),
                         to = c("1", "1","1","1","0","0", "1",NA)) 

visits2_bin <- mapvalues(visits2, 
                         from = c("2-4 times a week","About once a month","About once a week",
                                  "Almost daily", "Do not know", "Never or almost never",
                                  "No friends/family outside household",
                                  "Once every few months","Prefer not to answer"),
                         to = c("1", "1","1","1", NA,"0","0", "1",NA)) 

visits3_bin <- mapvalues(visits3, 
                         from = c("2-4 times a week","About once a month","About once a week",
                                  "Almost daily", "Never or almost never",
                                  "Once every few months"),
                         to = c("1", "1","1","1","0", "1")) 

visits0_bin_num <- as.numeric(visits0_bin)
visits1_bin_num <- as.numeric(visits1_bin)
visits2_bin_num <- as.numeric(visits2_bin)
visits3_bin_num <- as.numeric(visits3_bin)
visits_df_num <- data.frame(visits0_bin_num, visits1_bin_num, visits2_bin_num, visits3_bin_num)
visits_df_num$sum <- rowSums(visits_df_num, na.rm = T)

visits_df_num$sum[visits_df_num$sum >= 1] <- "1"
visits_df_num$sum[visits_df_num$sum < 1] <- "0"

visits_num <- as.numeric(visits_df_num$sum)
Visits_familyfriends <- visits_num 

##LEISURE 0 = no participation in social activities at least weekly, 1= yes participation
#TIMEPOINT 0
leisure00 <- data_y$leisuresocial_activities_f6160_0_0
leisure01 <- data_y$leisuresocial_activities_f6160_0_1
leisure02 <- data_y$leisuresocial_activities_f6160_0_2
leisure03 <- data_y$leisuresocial_activities_f6160_0_3
leisure04 <- data_y$leisuresocial_activities_f6160_0_4

cylinder <- table(leisure01)
View(cylinder)

leisure_00_bin <- mapvalues(leisure00, 
                            from = c("Adult education class","None of the above", "Other group activity",
                                     "Prefer not to answer", "Pub or social club", "Religious group", "Sports club or gym"),
                            to = c("1", "0","1",NA, "1","1","1")) 

leisure_01_bin <- mapvalues(leisure01, 
                            from = c("Adult education class", "Other group activity",
                                     "Pub or social club", "Religious group"),
                            to = c("1","1", "1","1")) 

leisure_02_bin <- mapvalues(leisure02, 
                            from = c("Adult education class", "Other group activity",
                                     "Religious group"),
                            to = c("1","1", "1")) 

leisure_03_bin <- mapvalues(leisure03, 
                            from = c("Adult education class", "Other group activity"),
                            to = c("1", "1")) 

#only NA
leisure_04_bin <- leisure04

leisure_00_bin_num <- as.numeric(leisure_00_bin)
leisure_01_bin_num <- as.numeric(leisure_01_bin)
leisure_02_bin_num <- as.numeric(leisure_02_bin)
leisure_03_bin_num <- as.numeric(leisure_03_bin)
leisure_04_bin_num <- as.numeric(leisure_04_bin)

leisure0_df_num <- data.frame(leisure_00_bin_num, leisure_01_bin_num, leisure_02_bin_num,
                              leisure_03_bin_num, leisure_04_bin_num)
leisure0_df_num$sum <- rowSums(leisure0_df_num, na.rm = T)

#TIMEPOINT 1
leisure10 <- data_y$leisuresocial_activities_f6160_1_0
leisure11 <- data_y$leisuresocial_activities_f6160_1_1
leisure12 <- data_y$leisuresocial_activities_f6160_1_2
leisure13 <- data_y$leisuresocial_activities_f6160_1_3
leisure14 <- data_y$leisuresocial_activities_f6160_1_4

cylinder <- table(leisure13)
View(cylinder)

leisure_10_bin <- mapvalues(leisure10, 
                            from = c("Adult education class","None of the above", "Other group activity",
                                     "Pub or social club", "Religious group", "Sports club or gym"),
                            to = c("1", "0","1", "1","1","1")) 

leisure_11_bin <- mapvalues(leisure11, 
                            from = c("Adult education class", "Other group activity",
                                     "Pub or social club", "Religious group"),
                            to = c("1","1", "1","1")) 

leisure_12_bin <- mapvalues(leisure12, 
                            from = c("Adult education class", "Other group activity",
                                     "Religious group"),
                            to = c("1","1", "1")) 

leisure_13_bin <- mapvalues(leisure13, 
                            from = c("Adult education class", "Other group activity"),
                            to = c("1", "1")) 

#only NA
leisure_14_bin <- leisure14

leisure_10_bin_num <- as.numeric(leisure_10_bin)
leisure_11_bin_num <- as.numeric(leisure_11_bin)
leisure_12_bin_num <- as.numeric(leisure_12_bin)
leisure_13_bin_num <- as.numeric(leisure_13_bin)
leisure_14_bin_num <- as.numeric(leisure_14_bin)

leisure1_df_num <- data.frame(leisure_10_bin_num, leisure_11_bin_num, leisure_12_bin_num,
                              leisure_13_bin_num, leisure_14_bin_num)
leisure1_df_num$sum <- rowSums(leisure1_df_num, na.rm = T)


#TIMEPOINT 2
leisure20 <- data_y$leisuresocial_activities_f6160_2_0
leisure21 <- data_y$leisuresocial_activities_f6160_2_1
leisure22 <- data_y$leisuresocial_activities_f6160_2_2
leisure23 <- data_y$leisuresocial_activities_f6160_2_3
leisure24 <- data_y$leisuresocial_activities_f6160_2_4

cylinder <- table(leisure24)
View(cylinder)

leisure_20_bin <- mapvalues(leisure20, 
                            from = c("Adult education class","None of the above", "Other group activity",
                                     "Pub or social club", "Religious group", "Sports club or gym"),
                            to = c("1", "0","1", "1","1","1")) 

leisure_21_bin <- mapvalues(leisure21, 
                            from = c("Adult education class", "Other group activity",
                                     "Pub or social club", "Religious group"),
                            to = c("1","1", "1","1")) 

leisure_22_bin <- mapvalues(leisure22, 
                            from = c("Adult education class", "Other group activity",
                                     "Religious group"),
                            to = c("1","1", "1")) 

leisure_23_bin <- mapvalues(leisure23, 
                            from = c("Other group activity"),
                            to = c( "1")) 

#only NA
leisure_24_bin <- leisure24

leisure_20_bin_num <- as.numeric(leisure_20_bin)
leisure_21_bin_num <- as.numeric(leisure_21_bin)
leisure_22_bin_num <- as.numeric(leisure_22_bin)
leisure_23_bin_num <- as.numeric(leisure_23_bin)
leisure_24_bin_num <- as.numeric(leisure_24_bin)

leisure2_df_num <- data.frame(leisure_20_bin_num, leisure_21_bin_num, leisure_22_bin_num,
                              leisure_23_bin_num, leisure_24_bin_num)
leisure2_df_num$sum <- rowSums(leisure2_df_num, na.rm = T)


#TIMEPOINT 3
leisure30 <- data_y$leisuresocial_activities_f6160_3_0
leisure31 <- data_y$leisuresocial_activities_f6160_3_1
leisure32 <- data_y$leisuresocial_activities_f6160_3_2
leisure33 <- data_y$leisuresocial_activities_f6160_3_3
leisure34 <- data_y$leisuresocial_activities_f6160_3_4

cylinder <- table(leisure30)
View(cylinder)

leisure_30_bin <- mapvalues(leisure30, 
                            from = c("None of the above", "Other group activity",
                                     "Pub or social club", "Religious group", "Sports club or gym"),
                            to = c("0","1", "1","1","1")) 

leisure_31_bin <- mapvalues(leisure31, 
                            from = c("Adult education class", "Other group activity",
                                     "Pub or social club", "Religious group"),
                            to = c("1","1", "1","1")) 

#only NA
leisure_32_bin <- leisure32
leisure_33_bin <- leisure33
leisure_34_bin <- leisure34

leisure_30_bin_num <- as.numeric(leisure_30_bin)
leisure_31_bin_num <- as.numeric(leisure_31_bin)
leisure_32_bin_num <- as.numeric(leisure_32_bin)
leisure_33_bin_num <- as.numeric(leisure_33_bin)
leisure_34_bin_num <- as.numeric(leisure_34_bin)

leisure3_df_num <- data.frame(leisure_30_bin_num, leisure_31_bin_num, leisure_32_bin_num,
                              leisure_33_bin_num, leisure_34_bin_num)
leisure3_df_num$sum <- rowSums(leisure3_df_num, na.rm = T)

####
#sum samen doen
leisure_0 <- leisure0_df_num$sum
leisure_1 <- leisure1_df_num$sum
leisure_2 <- leisure2_df_num$sum
leisure_3 <- leisure3_df_num$sum

leisure_df_sum <- data.frame(leisure_0, leisure_1, leisure_2, leisure_3)

leisure_df_sum$leisure_0[leisure_df_sum$leisure_0 >= 1] <- "1"
leisure_df_sum$leisure_1[leisure_df_sum$leisure_1 >= 1] <- "1"
leisure_df_sum$leisure_2[leisure_df_sum$leisure_2 >= 1] <- "1"
leisure_df_sum$leisure_3[leisure_df_sum$leisure_3 >= 1] <- "1"

leisure_df_sum$leisure_0[leisure_df_sum$leisure_0 < 1] <- "0"
leisure_df_sum$leisure_1[leisure_df_sum$leisure_1 < 1] <- "0"
leisure_df_sum$leisure_2[leisure_df_sum$leisure_2 < 1] <- "0"
leisure_df_sum$leisure_3[leisure_df_sum$leisure_3 < 1] <- "0"

leisure_0_num <- as.numeric(leisure_df_sum$leisure_0)
leisure_1_num <- as.numeric(leisure_df_sum$leisure_1)
leisure_2_num <- as.numeric(leisure_df_sum$leisure_2)
leisure_3_num <- as.numeric(leisure_df_sum$leisure_3)
leisure_df_num <- data.frame(leisure_0_num, leisure_1_num, leisure_2_num, leisure_3_num)

leisure_df_num$sum <- rowSums(leisure_df_num, na.rm = T)

leisure_df_num$sum[leisure_df_num$sum >= 1] <- "1"
leisure_df_num$sum[leisure_df_num$sum < 1] <- "0"
leisure_df_sumnum <- as.numeric(leisure_df_num$sum)
Leisure <- leisure_df_sumnum


#4 Type of accomodation
#TYPE OF ACCOMODATION
# 1= OWN HOUSE = CONTINU, 0 = SHELTERED OR TEMPORARY
accotype0 <- data_y$type_of_accommodation_lived_in_f670_0_0
accotype1 <- data_y$type_of_accommodation_lived_in_f670_1_0
accotype2 <- data_y$type_of_accommodation_lived_in_f670_2_0
accotype3 <- data_y$type_of_accommodation_lived_in_f670_3_0

accotype0_bin <- mapvalues(accotype0, 
                           from = c("A flat, maisonette or apartment", "A house or bungalow",
                                    "Mobile or temporary structure (i.e. caravan)","None of the above",
                                    "Sheltered accommodation", "Prefer not to answer"),
                           to = c("1", "1", "0", NA, "0", NA))

accotype1_bin <- mapvalues(accotype1, 
                           from = c("A flat, maisonette or apartment", "A house or bungalow",
                                    "Mobile or temporary structure (i.e. caravan)","None of the above",
                                    "Sheltered accommodation"),
                           to = c("1", "1", "0", NA, "0"))

accotype2_bin <- mapvalues(accotype2, 
                           from = c("A flat, maisonette or apartment", "A house or bungalow",
                                    "Mobile or temporary structure (i.e. caravan)","None of the above",
                                    "Sheltered accommodation", "Prefer not to answer"),
                           to = c("1", "1", "0", NA, "0", NA))

accotype3_bin <- mapvalues(accotype3, 
                           from = c("A flat, maisonette or apartment", "A house or bungalow"),
                           to = c("1", "1"))

accotype_df <- data.frame(accotype0_bin, accotype1_bin, accotype2_bin, accotype3_bin)

accotype0_bin_num <- as.numeric(accotype0_bin)
accotype1_bin_num <- as.numeric(accotype1_bin)
accotype2_bin_num <- as.numeric(accotype2_bin)
accotype3_bin_num <- as.numeric(accotype3_bin)

accotype_df_num <- data.frame(accotype0_bin_num, accotype1_bin_num, accotype2_bin_num, accotype3_bin_num)
accotype_df_num$sum <- rowSums(accotype_df_num, na.rm = T)

sum_bin <- accotype_df_num$sum[accotype_df_num$sum >= 1] <- "1"
sum_bin <- accotype_df_num$sum[accotype_df_num$sum < 1] <- "0"

accotyp_sum_num <- as.numeric(accotype_df_num$sum)
accomodation_type <- accotyp_sum_num

#environment
acco_environment <- data_y$living_environment_score_england_f26417_0_0

####
#5 Cannabis
data_y$ever_taken_cannabis_f20453_0_0

cannabis_bin <- mapvalues(data_y$ever_taken_cannabis_f20453_0_0, 
                          from = c("No", "Prefer not to answer", "Yes, 1-2 times","Yes, 11-100 times","Yes, 3-10 times", "Yes, more than 100 times"), 
                          to = c("0", NA, "1", "1", "1", "1"))
cannabis_yesno <- mapvalues(cannabis_bin, from = c("1","0"), to = c("Yes", "No"))
Cannabis <- cannabis_bin

Cannabis_num <- as.numeric(cannabis_bin)

#6 depression --> download week 8 depression file
#DEPRESSION

#6 depression --> difficult
depression <- c(data_y$ever_had_prolonged_feelings_of_sadness_or_depression_f20446_0_0,
                data_y$fraction_of_day_affected_during_worst_episode_of_depression_f20436_0_0,
                data_y$frequency_of_depressed_days_during_worst_episode_of_depression_f20439_0_0,
                data_y$impact_on_normal_roles_during_worst_period_of_depression_f20440_0_0)

#Sadness
depression_bin_1 <- mapvalues(data_y$ever_had_prolonged_feelings_of_sadness_or_depression_f20446_0_0, from = c("Yes", "Prefer not to answer", "No"), to = c("1", "NA", "0"))
sadness_yesno <- mapvalues(depression_bin_1, from = c("1","0"), to = c("Sadness", "No sadness"))


#fraction
fraction_bin <- mapvalues(data_y$fraction_of_day_affected_during_worst_episode_of_depression_f20436_0_0,
                          from = c("About half of the day", "All day long", "Do not know", "Less than half of the day", "Most of the day", "Prefer not to answer"), 
                          to = c("0", "1", NA, "0","1", NA))
fraction_yesno <- mapvalues(fraction_bin, from = c("1","0"), to = c("Most of the day or all day", "Less than half of the day"))


#frequency
frequency_bin <- mapvalues(data_y$frequency_of_depressed_days_during_worst_episode_of_depression_f20439_0_0,
                           from = c("Almost every day", "Do not know", "Every day", "Less often", "Prefer not to answer"), 
                           to = c("1", NA, "1","0", NA))
frequency_yesno <- mapvalues(fraction_bin, from = c("1","0"), to = c("(Almost) every day", "Less often"))


#impact
impact_bin <- mapvalues(data_y$impact_on_normal_roles_during_worst_period_of_depression_f20440_0_0,
                        from = c("A little", "A lot", "Not at all", "Prefer not to answer", "Somewhat"), 
                        to = c("0", "1","0", NA,"1"))
impact_yesno <- mapvalues(fraction_bin, from = c("1","0"), to = c("Somewhat or a lot", "A little or not at all"))

#5 of meer symptomen

data_y$ever_had_prolonged_feelings_of_sadness_or_depression_f20446_0_0
prosadness_bin <- mapvalues(data_y$ever_had_prolonged_feelings_of_sadness_or_depression_f20446_0_0, 
                            from = c("No", "Prefer not to answer", "Yes"), 
                            to = c("0", NA, "1"))
prosadness_yesno <- mapvalues(prosadness_bin, from = c("1","0"), to = c("Yes", "No"))


#or
data_y$ever_had_prolonged_loss_of_interest_in_normal_activities_f20441_0_0
interestloss_bin <- mapvalues(data_y$ever_had_prolonged_loss_of_interest_in_normal_activities_f20441_0_0, 
                              from = c("No", "Prefer not to answer", "Yes"), 
                              to = c("0", NA, "1"))
interestloss_yesno <- mapvalues(interestloss_bin, from = c("1","0"), to = c("Yes", "No"))

#or
data_y$feelings_of_tiredness_during_worst_episode_of_depression_f20449_0_0
tiredness_bin <- mapvalues(data_y$feelings_of_tiredness_during_worst_episode_of_depression_f20449_0_0, 
                           from = c("No", "Prefer not to answer", "Yes", "Do not know"), 
                           to = c("0", NA, "1", NA))
tiredness_yesno <- mapvalues(tiredness_bin, from = c("1","0"), to = c("Yes", "No"))


#or
data_y$weight_change_during_worst_episode_of_depression_f20536_0_0
weightchange_bin <- mapvalues(data_y$weight_change_during_worst_episode_of_depression_f20536_0_0, 
                              from = c("Both gained and lost some weight during the episode", "Do not know", "Gained weight", "Lost weight", "Prefer not to answer", "Stayed about the same or was on a diet"), 
                              to = c("1", NA, "1", "1", NA, "0"))
weightchange_yesno <- mapvalues(weightchange_bin, from = c("1","0"), to = c("Yes", "No"))


#or
data_y$did_your_sleep_change_f20532_0_0
sleepchange_bin <- mapvalues(data_y$did_your_sleep_change_f20532_0_0, 
                             from = c("No", "Prefer not to answer", "Yes", "Do not know"), 
                             to = c("0", NA, "1", NA))
sleepchange_yesno <- mapvalues(sleepchange_bin, from = c("1","0"), to = c("Yes", "No"))

#or
data_y$difficulty_concentrating_during_worst_depression_f20435_0_0
concentrationdep_bin <- mapvalues(data_y$difficulty_concentrating_during_worst_depression_f20435_0_0, 
                                  from = c("No", "Prefer not to answer", "Yes", "Do not know"), 
                                  to = c("0", NA, "1", NA))
concentrationdep_yesno <- mapvalues(concentrationdep_bin, from = c("1","0"), to = c("Yes", "No"))



#or
data_y$feelings_of_worthlessness_during_worst_period_of_depression_f20450_0_0
worthlessness_bin <- mapvalues(data_y$feelings_of_worthlessness_during_worst_period_of_depression_f20450_0_0, 
                               from = c("No", "Prefer not to answer", "Yes", "Do not know"), 
                               to = c("0", NA, "1", NA))
worthlessness_yesno <- mapvalues(worthlessness_bin, from = c("1","0"), to = c("Yes", "No"))



#or
data_y$thoughts_of_death_during_worst_depression_f20437_0_0
deaththoughts_bin <- mapvalues(data_y$thoughts_of_death_during_worst_depression_f20437_0_0, 
                               from = c("No", "Prefer not to answer", "Yes", "Do not know"), 
                               to = c("0", NA, "1", NA))
deaththoughts_yesno <- mapvalues(deaththoughts_bin, from = c("1","0"), to = c("Yes", "No"))

#numeric
prosadness_bin_num <- as.numeric(prosadness_bin)
interestloss_bin_num <- as.numeric(interestloss_bin)
tiredness_bin_num <- as.numeric(tiredness_bin)
weightchange_bin_num <- as.numeric(weightchange_bin)
sleepchange_bin_num <- as.numeric(sleepchange_bin)
concentrationdep_bin_num <- as.numeric(concentrationdep_bin)
worthlessness_bin_num <- as.numeric(worthlessness_bin)
deaththoughts_bin_num <- as.numeric(deaththoughts_bin)

fivesymp_dataframe_num <- data.frame(prosadness_bin_num,interestloss_bin_num, tiredness_bin_num, weightchange_bin_num,
                                     sleepchange_bin_num, concentrationdep_bin_num, worthlessness_bin_num, deaththoughts_bin_num)
fivesymp_dataframe_num$sum <- round(fivesymp_dataframe_num$prosadness_bin_num + fivesymp_dataframe_num$interestloss_bin_num +
                                      fivesymp_dataframe_num$tiredness_bin_num + fivesymp_dataframe_num$weightchange_bin_num +
                                      fivesymp_dataframe_num$sleepchange_bin_num + fivesymp_dataframe_num$concentrationdep_bin_num +
                                      fivesymp_dataframe_num$worthlessness_bin_num + fivesymp_dataframe_num$deaththoughts_bin_num, digits = 2)

fivesymp_dataframe_num$sumyn[fivesymp_dataframe_num$sum >= 5] <- "1" #yes 5 symp
fivesymp_dataframe_num$sumyn[fivesymp_dataframe_num$sum < 5] <- "0" #no 5 symp
fivesymp_yesno <- fivesymp_dataframe_num$sumyn

#eindscore depression
frequency_bin_num <- as.numeric(frequency_bin)
depression_bin_1_num <- as.numeric(depression_bin_1)
impact_bin_num <- as.numeric(impact_bin)
fraction_bin_num <- as.numeric(fraction_bin)
fivesymp_yesno_num <- as.numeric(fivesymp_yesno)

depression_df_num <- data.frame(frequency_bin_num, depression_bin_1_num, impact_bin_num,
                                fraction_bin_num, fivesymp_yesno_num)
depression_df_num$sum <- round(depression_df_num$frequency_bin_num + depression_df_num$depression_bin_1_num +
                                 depression_df_num$impact_bin_num + depression_df_num$fraction_bin_num +
                                 depression_df_num$fivesymp_yesno_num, digits = 2)
depression_df_num$sumyn[depression_df_num$sum >= 5] <- "1" #yes drie symp
depression_df_num$sumyn[depression_df_num$sum < 5] <- "0" #no drie symp
depression_yesno <- depression_df_num$sumyn

depression_num <- as.numeric(depression_yesno)

#7 GAD --> download van week 8 GAD
#GAD

#7 GAD 
fraction_bin <- mapvalues(data_y$fraction_of_day_affected_during_worst_episode_of_depression_f20436_0_0,
                          from = c("About half of the day", "All day long", "Do not know", "Less than half of the day", "Most of the day", "Prefer not to answer"), 
                          to = c("0", "1", NA, "0","1", NA))
fraction_yesno <- mapvalues(fraction_bin, from = c("1","0"), to = c("Most of the day or all day", "Less than half of the day"))


#Worried tense of anxious
tense_anxious_bin <- mapvalues(data_y$ever_felt_worried_tense_or_anxious_for_most_of_a_month_or_longer_f20421_0_0, 
                               from = c("Do not know", "No","Prefer not to answer", "Yes"), 
                               to = c(NA, "0", NA,"1"))
tense_anxious_yesno <- mapvalues(tense_anxious_bin, from = c("1","0"), to = c("Yes", "No"))


#AND Duration >= 6 months or All my life TO DO --> numeric
# -999 = all my life/as long as i can remember

duration_bin <- mapvalues(data_y$longest_period_spent_worried_or_anxious_f20420_0_0, 
                          from = c("-999"), 
                          to = c("1"))
duration_yesno <- mapvalues(tense_anxious_bin, from = c("1","0"), to = c("Yes", "No"))

duration_df <- data.frame(data_y$longest_period_spent_worried_or_anxious_f20420_0_0)

duration_df$data_y.longest_period_spent_worried_or_anxious_f20420_0_0yn[duration_df$data_y.longest_period_spent_worried_or_anxious_f20420_0_0 == -999] <- "1"
duration_df$data_y.longest_period_spent_worried_or_anxious_f20420_0_0yn[duration_df$data_y.longest_period_spent_worried_or_anxious_f20420_0_0 >= 6] <- "1"
duration_df$data_y.longest_period_spent_worried_or_anxious_f20420_0_0yn[duration_df$data_y.longest_period_spent_worried_or_anxious_f20420_0_0 < 6] <- "0"
duration <- duration_df$data_y.longest_period_spent_worried_or_anxious_f20420_0_0yn

#AND Most days = Yes
data_y$worried_most_days_during_period_of_worst_anxiety_f20538_0_0
mostdays_bin <- mapvalues(data_y$worried_most_days_during_period_of_worst_anxiety_f20538_0_0, 
                          from = c("Do not know", "No","Prefer not to answer", "Yes"), 
                          to = c(NA, "0", NA,"1"))
mostdays_yesno <- mapvalues(mostdays_bin, from = c("1","0"), to = c("Yes", "No"))

#AND Excessive: More than most OR Stronger than most
data_y$ever_worried_more_than_most_people_would_in_similar_situation_f20425_0_0

excessive_bin <- mapvalues(data_y$ever_worried_more_than_most_people_would_in_similar_situation_f20425_0_0, 
                           from = c("Do not know", "No","Prefer not to answer", "Yes"), 
                           to = c(NA, "0", NA,"1"))
excessive_yesno <- mapvalues(excessive_bin, from = c("1","0"), to = c("Yes", "No"))


##### OR
data_y$stronger_worrying_than_other_people_during_period_of_worst_anxiety_f20542_0_0
strongworry_bin <- mapvalues(data_y$stronger_worrying_than_other_people_during_period_of_worst_anxiety_f20542_0_0, 
                             from = c("Do not know", "No","Prefer not to answer", "Yes"), 
                             to = c(NA, "0", NA,"1"))
strongworry_yesno <- mapvalues(strongworry_bin, from = c("1","0"), to = c("Yes", "No"))

excessive_bin_num <- as.numeric(excessive_bin)
strongworry_bin_num <- as.numeric(strongworry_bin)
excestron_df_num <- data.frame(excessive_bin_num, strongworry_bin_num)

excestron_df_num$sum <- round(excestron_df_num$excessive_bin_num + excestron_df_num$strongworry_bin_num, digits = 2)

excestron_df_num$sumyn[excestron_df_num$sum >= 1] <- "1" #yes drie symp
excestron_df_num$sumyn[excestron_df_num$sum < 1] <- "0"  #no drie symp
strongworry_yesno <- excestron_df_num$sumyn
strongworry_yn_num <- as.numeric(strongworry_yesno)

#AND Number of issues: More than one thing OR Different worries
data_y$number_of_things_worried_about_during_worst_period_of_anxiety_f20543_0_0

numberissues_bin <- mapvalues(data_y$number_of_things_worried_about_during_worst_period_of_anxiety_f20543_0_0, 
                              from = c("Do not know", "More than one thing","One thing","Prefer not to answer"), 
                              to = c(NA, "1", "0",NA))
numberissues_yesno <- mapvalues(numberissues_bin, from = c("1","0"), to = c("Yes", "No"))

##### OR
data_y$multiple_worries_during_worst_period_of_anxiety_f20540_0_0

mutipleworry_bin <- mapvalues(data_y$multiple_worries_during_worst_period_of_anxiety_f20540_0_0, 
                              from = c("Do not know", "No","Prefer not to answer", "Yes"), 
                              to = c(NA, "0", NA,"1"))
mutipleworry_yesno <- mapvalues(mutipleworry_bin, from = c("1","0"), to = c("Yes", "No"))

cylinder <- table(data_y$multiple_worries_during_worst_period_of_anxiety_f20540_0_0)
View(cylinder)

numberissues_bin_num <- as.numeric(numberissues_bin)
mutipleworry_bin_num <- as.numeric(mutipleworry_bin)
fqworries_df_num <- data.frame(numberissues_bin_num, mutipleworry_bin_num)

fqworries_df_num$sum <- round(fqworries_df_num$numberissues_bin_num + fqworries_df_num$mutipleworry_bin_num, digits = 2)

fqworries_df_num$sumyn[fqworries_df_num$sum >= 1] <- "1" #yes drie symp
fqworries_df_num$sumyn[fqworries_df_num$sum < 1] <- "0"  #no drie symp
frequencyworry_yesno <- fqworries_df_num$sumyn
frequencyworry_yn_num <- as.numeric(frequencyworry_yesno)

#AND Difficult to control: Difficult to stop worrying OR Couldn’t put it out of mind OR Difficult to control
data_y$difficulty_stopping_worrying_during_worst_period_of_anxiety_f20541_0_0

difficultcontrol_bin <- mapvalues(data_y$difficulty_stopping_worrying_during_worst_period_of_anxiety_f20541_0_0, 
                                  from = c("Do not know", "No","Prefer not to answer", "Yes"), 
                                  to = c(NA, "0", NA,"1"))
difficultcontrol_yesno <- mapvalues(difficultcontrol_bin, from = c("1","0"), to = c("Yes", "No"))

#### OR
data_y$frequency_of_inability_to_stop_worrying_during_worst_period_of_anxiety_f20539_0_0

unablestop_bin <- mapvalues(data_y$frequency_of_inability_to_stop_worrying_during_worst_period_of_anxiety_f20539_0_0, 
                            from = c("Do not know", "Never","Often","Prefer not to answer", "Rarely", "Sometimes"), 
                            to = c(NA, "0", "1", NA,"1", "1"))
unablestop_yesno <- mapvalues(unablestop_bin, from = c("1","0"), to = c("Yes", "No"))

cylinder <- table(data_y$frequency_of_inability_to_stop_worrying_during_worst_period_of_anxiety_f20539_0_0)
View(cylinder)

##OR
data_y$frequency_of_difficulty_controlling_worry_during_worst_period_of_anxiety_f20537_0_0
stopcontrol_bin <- mapvalues(data_y$frequency_of_difficulty_controlling_worry_during_worst_period_of_anxiety_f20537_0_0, 
                             from = c("Do not know", "Never","Often","Prefer not to answer", "Rarely", "Sometimes"), 
                             to = c(NA, "0", "1", NA,"1", "1"))
stopcontrol_yesno <- mapvalues(stopcontrol_bin, from = c("1","0"), to = c("Yes", "No"))


stopcontrol_bin_num <- as.numeric(stopcontrol_bin)
unablestop_bin_num <- as.numeric(unablestop_bin)
difficultcontrol_bin_num <- as.numeric(difficultcontrol_bin) 

difficult_df_num <- data.frame(stopcontrol_bin_num, unablestop_bin_num, difficultcontrol_bin_num)

difficult_df_num$sum <- round(difficult_df_num$stopcontrol_bin_num + difficult_df_num$unablestop_bin_num + difficult_df_num$difficultcontrol_bin_num, digits = 2)

difficult_df_num$sumyn[difficult_df_num$sum >= 1] <- "1" #yes drie symp
difficult_df_num$sumyn[difficult_df_num$sum < 1] <- "0"  #no drie symp
difficult_yesno <- difficult_df_num$sumyn
difficult_yn_num <- as.numeric(difficult_yesno)

#AND Functional impairment: Role interference = Some or A lot
data_y$impact_on_normal_roles_during_worst_period_of_anxiety_f20418_0_0
impairment_bin <- mapvalues(data_y$impact_on_normal_roles_during_worst_period_of_anxiety_f20418_0_0, 
                            from = c("A little", "A lot","Not at all","Prefer not to answer", "Somewhat"), 
                            to = c("0", "1", "0",NA,"1"))
impairment_yesno <- mapvalues(impairment_bin, from = c("1","0"), to = c("Yes", "No"))


#AND 3 somatic symptoms out of:
data_y$restless_during_period_of_worst_anxiety_f20426_0_0
restless_bin <- mapvalues(data_y$restless_during_period_of_worst_anxiety_f20426_0_0, 
                          from = c("No","Yes", "Do not know"), 
                          to = c("0", "1", NA))
restless_yesno <- mapvalues(restless_bin, from = c("1","0"), to = c("Yes", "No"))


#or
data_y$keyed_up_or_on_edge_during_worst_period_of_anxiety_f20423_0_0
keyedup_bin <- mapvalues(data_y$keyed_up_or_on_edge_during_worst_period_of_anxiety_f20423_0_0, 
                         from = c("No","Yes", "Do not know"), 
                         to = c("0", "1", NA))
keyedup_yesno <- mapvalues(keyedup_bin, from = c("1","0"), to = c("Yes", "No"))


#or
data_y$easily_tired_during_worst_period_of_anxiety_f20429_0_0
tired_bin <- mapvalues(data_y$easily_tired_during_worst_period_of_anxiety_f20429_0_0, 
                       from = c("No","Yes", "Do not know"), 
                       to = c("0", "1", NA))
tired_yesno <- mapvalues(tired_bin, from = c("1","0"), to = c("Yes", "No"))



#or
data_y$difficulty_concentrating_during_worst_period_of_anxiety_f20419_0_0
concentration_bin <- mapvalues(data_y$difficulty_concentrating_during_worst_period_of_anxiety_f20419_0_0, 
                               from = c("No","Yes", "Do not know"), 
                               to = c("0", "1", NA))
concentration_yesno <- mapvalues(concentration_bin, from = c("1","0"), to = c("Yes", "No"))


#or
data_y$more_irritable_than_usual_during_worst_period_of_anxiety_f20422_0_0
irritable_bin <- mapvalues(data_y$more_irritable_than_usual_during_worst_period_of_anxiety_f20422_0_0, 
                           from = c("No","Yes", "Do not know"), 
                           to = c("0", "1", NA))
irritable_yesno <- mapvalues(irritable_bin, from = c("1","0"), to = c("Yes", "No"))


#or
data_y$tense_sore_or_aching_muscles_during_worst_period_of_anxiety_f20417_0_0
tensemuscle_bin <- mapvalues(data_y$tense_sore_or_aching_muscles_during_worst_period_of_anxiety_f20417_0_0, 
                             from = c("No","Yes", "Do not know"), 
                             to = c("0", "1", NA))
tensemuscle_yesno <- mapvalues(tensemuscle_bin, from = c("1","0"), to = c("Yes", "No"))


#or
data_y$frequent_trouble_falling_or_staying_asleep_during_worst_period_of_anxiety_f20427_0_0
sleepproblems_bin <- mapvalues(data_y$frequent_trouble_falling_or_staying_asleep_during_worst_period_of_anxiety_f20427_0_0, 
                               from = c("No","Yes", "Do not know"), 
                               to = c("0", "1", NA))
sleepproblems_yesno <- mapvalues(sleepproblems_bin, from = c("1","0"), to = c("Yes", "No"))


sleepproblems_bin_num <- as.numeric(sleepproblems_bin)
tensemuscle_bin_num <- as.numeric(tensemuscle_bin)
irritable_bin_num <- as.numeric(irritable_bin)
concentration_bin_num <- as.numeric(concentration_bin)
tired_bin_num <- as.numeric(tired_bin)
keyedup_bin_num <- as.numeric(keyedup_bin)
restless_bin_num <- as.numeric(restless_bin)
threesymp_dataframe_num <- data.frame(sleepproblems_bin_num, tensemuscle_bin_num, irritable_bin_num,
                                      concentration_bin_num,tired_bin_num, keyedup_bin_num, restless_bin_num)
threesymp_dataframe_num$sum <- round(threesymp_dataframe_num$sleepproblems_bin_num + threesymp_dataframe_num$tensemuscle_bin_num +
                                       threesymp_dataframe_num$irritable_bin_num + threesymp_dataframe_num$concentration_bin_num +
                                       threesymp_dataframe_num$tired_bin_num + threesymp_dataframe_num$keyedup_bin_num + 
                                       threesymp_dataframe_num$restless_bin_num, digits = 2)

#werkt niet
threesymp_yes <- threesymp_dataframe_num[which(threesymp_dataframe_num$sum >= "3"),]
threesymp_no <- threesymp_dataframe_num[which(threesymp_dataframe_num$sum < "3"),]
threesymp_yesno <- merge(threesymp_yes, threesymp_no, all = TRUE)
threesymp_dataframe_num$yesno <- round(threesymp_dataframe_num$sum >= "3" , digits = 2)
#

#werkt wel
threesymp_dataframe_num$sumyn[threesymp_dataframe_num$sum >= 3] <- "1" #yes drie symp
threesymp_dataframe_num$sumyn[threesymp_dataframe_num$sum < 3] <- "0"  #no drie symp
threesymp_yn <- threesymp_dataframe_num$sumyn

#eindscore GAD

tense_anxious_bin_num <- as.numeric(tense_anxious_bin)
duration_num <- as.numeric(duration)
mostdays_bin_num <- as.numeric(mostdays_bin)
strongworry_yn_num <- as.numeric(strongworry_yesno)
frequencyworry_yn_num <- as.numeric(frequencyworry_yesno)
difficult_yn_num <- as.numeric(difficult_yesno)
impairment_bin_num <- as.numeric(impairment_bin)
threesymp_yn_num <- as.numeric(threesymp_yn)



gad_dataframe_num <- data.frame(tense_anxious_bin_num, duration_num, mostdays_bin_num,
                                strongworry_yn_num, frequencyworry_yn_num, difficult_yn_num,
                                impairment_bin_num, threesymp_yn_num)

gad_dataframe_num$sum <- round(gad_dataframe_num$tense_anxious_bin_num + gad_dataframe_num$mostdays_bin_num +
                                 gad_dataframe_num$strongworry_yn_num + gad_dataframe_num$frequencyworry_yn_num +
                                 gad_dataframe_num$difficult_yn_num + gad_dataframe_num$threesymp_yn_num +
                                 gad_dataframe_num$duration_num + gad_dataframe_num$impairment_bin_num, digits = 2)
gad_dataframe_num$sumyn[gad_dataframe_num$sum >= 8] <- "1" #yes drie symp
gad_dataframe_num$sumyn[gad_dataframe_num$sum < 8] <- "0"  #no drie symp
GAD_yesno <- gad_dataframe_num$sumyn
GAD_num <- as.numeric(GAD_yesno)


#8 Self-harm behavior
#selfharm_worthliving <- (data_y$ever_thought_that_life_not_worth_living_f20479_0_0)
#selfharm_harmed <- (data_y$ever_selfharmed_f20480_0_0)

#self-harm
sh_harmed_bin <- mapvalues(selfharm_harmed, 
                           from = c("Yes","Prefer not to answer","No" ),
                           to = c("1", NA,"0")) 
sh_worthliving_bin <- mapvalues(selfharm_worthliving, 
                                from = c("Yes, once","Yes, more than once","Prefer not to answer", "No" ),
                                to = c("1", "1",NA,"0")) 

sh_harmed_num <- as.numeric(sh_harmed_bin)
sh_worthliving_num <- as.numeric(sh_worthliving_bin)

#9 happiness/wellbeing
#general happines score (1 is unhappy, 6 happy)
generalhappiness_score <- mapvalues(data_y$general_happiness_f20458_0_0, 
                             from = c("Do not know", "Extremely happy","Extremely unhappy","Moderately happy","Moderately unhappy", "Prefer not to answer", "Very happy","Very unhappy"),
                             to = c(NA, "6", "1", "4", "3", NA, "5", "2"))

#happiness health
healthhappiness_score <- mapvalues(data_y$general_happiness_with_own_health_f20459_0_0, 
                             from = c("Do not know", "Extremely happy","Extremely unhappy","Moderately happy","Moderately unhappy", "Prefer not to answer", "Very happy","Very unhappy"),
                             to = c(NA, "6", "1", "4", "3", NA, "5", "2"))


#meaningfull life
meaningfull_score <- mapvalues(data_y$belief_that_own_life_is_meaningful_f20460_0_0, 
                             from = c("A little", "A moderate amount","An extreme amount","Do not know","Not at all", "Prefer not to answer", "Very much"),
                             to = c("2", "3", "5", NA, "1", NA, "4"))

#SUM scores
wellbeing_dataframe <- data.frame(healthhappiness_score, generalhappiness_score, meaningfull_score)
healthhappiness_score_num <- as.numeric(wellbeing_dataframe$healthhappiness_score)
generalhappiness_score_num <- as.numeric(wellbeing_dataframe$generalhappiness_score)
meaningfull_score_num <- as.numeric(wellbeing_dataframe$meaningfull_score)
wellbeing_dataframe_num <- data.frame(healthhappiness_score_num, generalhappiness_score_num, meaningfull_score_num)
wellbeing_dataframe_num$sum <- round(wellbeing_dataframe_num$healthhappiness_score_num + wellbeing_dataframe_num$generalhappiness_score_num + wellbeing_dataframe_num$meaningfull_score_num, digits = 2)
Wellbeing <- wellbeing_dataframe_num$sum
  

#wellbeing_dataframe_num$sum, 0 is bad wellbeing, 17 is good wellbeing

#10 smoking 
#smoking ever 0 is no, 1 = yes
smoke0 <- data_y$ever_smoked_f20160_0_0
smoke1 <- data_y$ever_smoked_f20160_1_0
smoke2 <- data_y$ever_smoked_f20160_2_0
smoke3 <- data_y$ever_smoked_f20160_3_0

smoking0_bin <- mapvalues(smoke0, 
                          from = c("Yes","No" ),
                          to = c("1", "0")) 

smoking1_bin <- mapvalues(smoke1, 
                          from = c("Yes","No" ),
                          to = c("1", "0")) 

smoking2_bin <- mapvalues(smoke2, 
                          from = c("Yes","No" ),
                          to = c("1", "0")) 

smoking3_bin <- mapvalues(smoke3, 
                          from = c("Yes","No" ),
                          to = c("1", "0")) 

smoke_df <- data.frame(smoking0_bin, smoking1_bin, smoking2_bin, smoking3_bin)

smoking0_bin_num <- as.numeric(smoking0_bin)
smoking1_bin_num <- as.numeric(smoking1_bin)
smoking2_bin_num <- as.numeric(smoking2_bin)
smoking3_bin_num <- as.numeric(smoking3_bin)
smoke_df_num <- data.frame(smoking0_bin_num, smoking1_bin_num, smoking2_bin_num, smoking3_bin_num)
smoke_df_num$sum <- rowSums(smoke_df_num, na.rm = T)

Smoking_test <- smoke_df_num$sum

smoke_df_num$sum[smoke_df_num$sum >= 1] <- "1" #yes 
smoke_df_num$sum[smoke_df_num$sum < 1] <- "0"  #no 
Smoking_yesno <- smoke_df_num$sum
Smoking <- as.numeric(Smoking_yesno)

#11 Alcohol
## PART 1 Hazard: 
#Frequency (scored 0-4) 20414, 
data_y$frequency_of_drinking_alcohol_f20414_0_0
alcoholfq_score <- mapvalues(data_y$frequency_of_drinking_alcohol_f20414_0_0, 
                               from = c("Never", "Monthly or less","2 to 3 times a week","2 to 4 times a month","4 or more times a week", "Prefer not to answer"),
                               to = c("1", "2", "4", "3", "5", NA))

cylinder <- table(data_y$frequency_of_drinking_alcohol_f20414_0_0)
View(cylinder)# 6 answers: prefer not to answer, never,monthly or less, 2 to 3 times a week, 2 to 4 times a month, 4 or more times a week

#typical drinks (score 0-4) 20403, 
data_y$amount_of_alcohol_drunk_on_a_typical_drinking_day_f20403_0_0
amountdrinks_score <- mapvalues(data_y$amount_of_alcohol_drunk_on_a_typical_drinking_day_f20403_0_0, 
                             from = c("1 or 2", "10 or more","3 or 4","5 or 6","7, 8 or 9", "Prefer not to answer"),
                             to = c("1", "5", "2", "3", "4", NA))

cylinder <- table(data_y$amount_of_alcohol_drunk_on_a_typical_drinking_day_f20403_0_0)
View(cylinder) # 6 answers: 1 or 2, 10 or more, 3 or 4, 5 or 6, 7, 8 or 9, Prefer not to answer

#six or more drinks (scored 0-4) 20416
data_y$frequency_of_consuming_six_or_more_units_of_alcohol_f20416_0_0

sixdrinks_score <- mapvalues(data_y$frequency_of_consuming_six_or_more_units_of_alcohol_f20416_0_0, 
                                from = c("Daily or almost daily", "Less than monthly","Monthly","Never","Weekly", "Prefer not to answer"),
                                to = c("5", "2", "3", "1", "4", NA))

cylinder <- table(data_y$frequency_of_consuming_six_or_more_units_of_alcohol_f20416_0_0)
View(cylinder) #6 answers: Daily or almost daily, Less than monthly, Monthly, Never, Prefer not to answer, Weekly

alcohol_dataframe <- data.frame(sixdrinks_score, alcoholfq_score, amountdrinks_score)
sixdrinks_score_num <- as.numeric(alcohol_dataframe$sixdrinks_score)
alcoholfq_score_num <- as.numeric(alcohol_dataframe$alcoholfq_score)
amountdrinks_score_num <- as.numeric(alcohol_dataframe$amountdrinks_score)
alcohol_dataframe_num <- data.frame(sixdrinks_score_num, alcoholfq_score_num, amountdrinks_score_num)
alcohol_dataframe_num$sum <- round(alcohol_dataframe_num$sixdrinks_score_num + alcohol_dataframe_num$alcoholfq_score_num + alcohol_dataframe_num$amountdrinks_score_num, digits = 2)
Alcohol <- alcohol_dataframe_num$sum

# SES (SOCIOECONOMIC STATUS)
SES <- data_y$townsend_deprivation_index_at_recruitment_f189_0_0


#laag is minder alcohol, hoog is meer alcohol

## different PE
#different PE
voices_pe <- data_y$ever_heard_an_unreal_voice_f20463_0_0
vision_pe <- data_y$ever_seen_an_unreal_vision_f20471_0_0
distress_pe <- data_y$distress_caused_by_unusual_or_psychotic_experiences_f20462_0_0
conspiracy_pe <- data_y$ever_believed_in_an_unreal_conspiracy_against_self_f20468_0_0
communication_pe <- data_y$ever_believed_in_unreal_communications_or_signs_f20474_0_0
medication_pe <- data_y$ever_prescribed_a_medication_for_unusual_or_psychotic_experiences_f20466_0_0
talked_pe <- data_y$ever_talked_to_a_health_professional_about_unusual_or_psychotic_experiences_f20477_0_0
frequency_pe <- data_y$frequency_of_unusual_or_psychotic_experiences_in_past_year_f20467_0_0

#voices
View(data_y$ever_heard_an_unreal_voice_f20463_0_0)
voices_bin <- mapvalues(data_y$ever_heard_an_unreal_voice_f20463_0_0, 
                        from = c("Do not know","No", "Prefer not to answer","Yes"),
                        to = c(NA, "0", NA, "1"))
voices_bin_num <- as.numeric(voices_bin)


#vision
vision_bin <- mapvalues(data_y$ever_seen_an_unreal_vision_f20471_0_0, 
                        from = c("Do not know","No", "Prefer not to answer","Yes"),
                        to = c(NA, "0", NA, "1"))
vision_bin_num <- as.numeric(vision_bin)


#distress
distress_bin <- mapvalues(data_y$distress_caused_by_unusual_or_psychotic_experiences_f20462_0_0, 
                          from = c("A bit distressing","Do not know", "Not distressing at all, it was a positive experience",
                                   "Not distressing, a neutral experience", "Prefer not to answer", "Quite distressing", "Very distressing"),
                          to = c("1", NA, "0", "0",NA, "1", "1"))

distress_bin_num <- as.numeric(distress_bin)


#conspiracy
conspiracy_bin <- mapvalues(data_y$ever_believed_in_an_unreal_conspiracy_against_self_f20468_0_0, 
                            from = c("Do not know","No", "Prefer not to answer","Yes"),
                            to = c(NA, "0", NA, "1"))
conspiracy_bin_num <- as.numeric(conspiracy_bin)


#communication
communication_bin <- mapvalues(data_y$ever_believed_in_unreal_communications_or_signs_f20474_0_0, 
                               from = c("Do not know","No", "Prefer not to answer","Yes"),
                               to = c(NA, "0", NA, "1"))
communication_bin_num <- as.numeric(communication_bin)


#frequency
frequency_bin <- mapvalues(data_y$frequency_of_unusual_or_psychotic_experiences_in_past_year_f20467_0_0, 
                           from = c("Less than once a month","More than once a month", "Nearly every day or daily",
                                    "Not at all", "Once or twice", "Prefer not to answer"),
                           to = c("0", "1", "1", "0",  "0", NA))
#1= dagelijks of ergens in de maand, 0= rare, less then month en more less
frequency_bin_num <- as.numeric(frequency_bin)


#talked to health prof
talked_bin <- mapvalues(data_y$ever_talked_to_a_health_professional_about_unusual_or_psychotic_experiences_f20477_0_0, 
                        from = c("Do not know","No", "Prefer not to answer","Yes"),
                        to = c(NA, "0", NA, "1"))
talked_bin_num <- as.numeric(talked_bin)


#prescribed med
medication_bin <- mapvalues(data_y$ever_prescribed_a_medication_for_unusual_or_psychotic_experiences_f20466_0_0, 
                            from = c("Do not know","No", "Prefer not to answer","Yes"),
                            to = c(NA, "0", NA, "1"))
medication_bin_num <- as.numeric(medication_bin)

