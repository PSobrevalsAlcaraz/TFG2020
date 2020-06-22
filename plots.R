
# BARPLOTS for demographics PE

# Total PE
#distressingness PE non healthy

diff_PE <- matrix(nrow=4, ncol=2)

diff_PE[1,1] = 137
 diff_PE[2,1] = 120
 diff_PE[3,1] = 155
 diff_PE[4,1] = 135
 diff_PE[1,2] = 224
 diff_PE[2,2] = 209
 diff_PE[3,2] = 222
 diff_PE[4,2] = 208

colnames(diff_PE) <- c("Distressingness","Non distressingness")

f <- t(diff_PE)

d <- f
d[1,1] <- 309
 d[2,1] <- 426
 d[2,2] <- 414
 d[1,2] <- 246
 d[1,2] <- 752
 d[1,2] <- 246
 d[2,3] <- 1240
 d[1,3] <- 752
 d[2,4] <- 2363
 d[1,4] <- 1492
 d

df <- cbind(f,d)

dd <- cbind(df[,8],df[,4],df[,7],df[,3],df[,5],df[,1],df[,6],df[,2])

col.order <- c("Communication Non Healthy","Communication Healthy","Voice Non Healthy","Voice Healthy","Conspiracy Non Healthy","Conspiracy Healthy","Vision Non Healthy","Vision Healthy")
colnames(dd) <- col.order

barplot(dd,main = "Demographics within PE",xlab = "Type of experiences",col = c("#009E73","lightblue"))
legend("topright",c("Distressingness","Non Distressingness"),fill = c("#009E73","lightblue"),cex=0.9)



###### Supperposition of 2 PE

c1 <- c(758,261,165,206,164,101)
c2 <- c(217,159,172,188,208,201)
pes <- cbind(c1,c2)
t <- t(pes)

tt <- cbind(t[,1],t[,2],t[,4],t[,5],t[,3],t[,6])
colnames(tt) <- c("Vision-Voice","Vision-Communication","Voice-Communication","Voice-Conspiracy","Vision-Communication","Communication-Conspiracy")
rownames(tt) <- c("Non Healthy", "Healthy") 

barplot(tt,main = "Demographics within PE",xlab = "Types of experiences",col = c("#009E73","lightblue"))
legend("topright",c("Non Healthy","Healthy"),fill = c("#009E73","lightblue"),cex = 0.9)


# HEatMaps
# PE ind

Ex = read.table("/hpc/hers_en/psobrevals/bombari/CSV_PE.csv", sep  = ";", header = TRUE)
row.names(Ex) <- Ex$X
Ex = Ex[,-1]
Ex <- as.matrix(Ex)
heatmap(Ex, cexCol = 1.3, cexRow = 1.3)

# No PE

Ex = read.table("/hpc/hers_en/psobrevals/bombari/CSV_noPE.csv", sep  = ";", header = TRUE)
row.names(Ex) <- Ex$X
Ex = Ex[,-1]
Ex <- as.matrix(Ex)
heatmap(Ex, cexCol = 1.3, cexRow = 1.3)


#### BARPLOT lm

r2 <-  read.table("/hpc/hers_en/psobrevals/bombari/lm.csv", sep  = ";", header = TRUE, strip.white=TRUE)
row.names(r2) <- r2$X
r2 <- r2[,-1]
r2 <- as.matrix(r2)
r2 <- t(r2)
r <- r2*100

library(RColorBrewer)
coul <- brewer.pal(6, "Paired")
par(oma = c(6,0,0,0))
barplot(r, col=coul, las = 2, cex.names=0.7, beside = T, main = "Explained variance per outcome", ylab= "Explained variance (r2)" ) 
legend("topleft",c("SCZ PE" , "SCZ noPE", "BIP PE", "BIP noPE", "MDD", "MDD noPE"),fill = coul,cex = 0.7)


### BARPLOT PRSice r2

r2 <-  read.table("/hpc/hers_en/psobrevals/bombari/prsice.csv", sep  = ";", header = TRUE, strip.white=TRUE)
row.names(r2) <- r2$X
r2 <- r2[,-1]
r2 <- as.matrix(r2)
r2 <- t(r2)
r <- r2*100

library(RColorBrewer)
coul <- brewer.pal(6, "Paired")
par(oma = c(6,0,0,0))
barplot(r, col=coul, las = 2, cex.names=0.7, beside = T, main = "Explained variance per outcome", ylab= "PRS model fit (r2)" )
legend("topleft",c("SCZ PE" , "SCZ noPE", "BIP PE", "BIP noPE", "MDD", "MDD noPE"),fill = coul,cex = 0.7)

