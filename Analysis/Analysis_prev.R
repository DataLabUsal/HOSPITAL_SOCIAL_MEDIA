###Hospital Correspondence Analysis
##R_script

#Import data
hospital <- read.delim("~/Documents/DataLab/Hospitales_RRSS/hospital")

#Factorize data
hospital_factor <- apply(hospital[,-1],2,as.factor)

#Comunidades vector
Comunidades <- read.table("~/Documents/DataLab/Hospitales_RRSS/Comunidades.csv", quote="\"", comment.char="")

#New_data creation
New_hospital <- cbind.data.frame(Comunidades,hospital_factor)
names(New_hospital)[1] <- 'Comunidades'
#freq_hosp_com <- summary(New_hospital$Comunidades)

#Remove unnecessary objects
rm(hospital_factor,Comunidades)

#Cross-Table
TABLE0 <- table(New_hospital$Comunidades,New_hospital[,3])
TABLE <- as.data.frame(matrix(0,nrow=length(unique(New_hospital$Comunidades)),ncol=18))
#Comunidades names
rownames(TABLE) <- rownames(TABLE0)
#Rename TABLE
var_names <- rep(0,16)
var_names[seq(1,16,2)] <- paste(names(New_hospital[,-c(1:3)]),'No')
var_names[seq(2,16,2)] <- paste(names(New_hospital[,-c(1:3)]),'Si')
names(TABLE) <- c('Publico','Privado',var_names)

TABLE[,1] <- TABLE0[,1]#/freq_hosp_com
TABLE[,2] <- TABLE0[,2]#/freq_hosp_com

vector_impar <- seq(3,18,2)
vector_par <- seq(4,18,2)

for (i in 4:11)
{
	TABLE0 <- table(New_hospital$Comunidades,New_hospital[,i])
	TABLE[,vector_impar[i-3]] <- TABLE0[,1]#/freq_hosp_com
	TABLE[,vector_par[i-3]] <- TABLE0[,2]#/freq_hosp_com
}

#Libraries
library("FactoMineR")
library("factoextra")
library('ggplot2')

#Correspondence Analysis
CA_result <- CA(TABLE[,c(1,2,4,6,8,10,12,14,16,18)],graph = FALSE)

Coord_row <- as.data.frame(CA_result$row$coord[,1:2])
Coord_col <- as.data.frame(CA_result$col$coord[,1:2])
names(Coord_row) <- c('Dim_1','Dim_2') #make names readable
names(Coord_col) <- c('Dim_1','Dim_2')
rownames(Coord_col) <- c('Publico','Privado','Twitter','Facebook','Blog','Wikipedia','Youtube','GooglePlus','Linkedin','Web')

#########################Correspondence Analysis Plot#########################

ggplot(data=Coord_row,aes(x=Dim_1,y=Dim_2))+
geom_point()+
geom_text(aes(label=rownames(Coord_row)),hjust=0.5, vjust=-.8)+
#geom_point(data=Coord_col,aes(x=Dim_1,y=Dim_2),col='red')+
geom_segment(mapping = aes(x = 0, y = 0, xend =Dim_1, yend =Dim_2),data = Coord_col,arrow = arrow(length=unit(0.30,"cm"), type = "open"), size = 0.7,col='red')+
geom_text(data=Coord_col,aes(x=Coord_col[,1]+.015*sign(Coord_col[,1]),y=Coord_col[,2]+.015*sign(Coord_col[,2]),label=rownames(Coord_col)),hjust=0, vjust=0,col='red')


#################################Results######################################
Explain_var <- CA_result$eig
Contributions_Com_Aut <- CA_result$row$contrib
Contributions_SM <- CA_result$col$contrib

###########################MultBiplotR approach###############################
require(MultBiplotR)
Table_ca <- TABLE[,c(1,2,4,6,8,10,12,14,16,18)]
names(Table_ca) <- c(names(TABLE[,1:2]),gsub('.{3}$', '', names(TABLE[,c(4,6,8,10,12,14,16,18)])))
CA_resultsB <- CA(Table_ca,dim=4,alpha=5)

############################Results MultBiplotR###############################
Contributions_SM_b <- CA_resultsB$ColContributions
Contributions_Com_Aut_b <- CA_resultsB$RowContributions

Coord_row <- as.data.frame(CA_resultsB$RowCoordinates)
Coord_col <- as.data.frame(CA_resultsB$ColCoordinates)
names(Coord_row) <- paste('Dim_',1:4,sep='')
names(Coord_col) <- paste('Dim_',1:4,sep='')

#Plano 12#
ggplot(data=Coord_row,aes(x=Dim_1,y=Dim_2))+
  geom_point()+
  geom_text(aes(label=rownames(Coord_row)),hjust=0.5, vjust=-.8)+
  #geom_point(data=Coord_col,aes(x=Dim_1,y=Dim_2),col='red')+
  geom_segment(mapping = aes(x = 0, y = 0, xend =Dim_1, yend =Dim_2),data = Coord_col,arrow = arrow(length=unit(0.30,"cm"), type = "open"), size = 0.7,col='red')+
  geom_text(data=Coord_col,aes(x=Coord_col[,1]+.015*sign(Coord_col[,1]),y=Coord_col[,2]+.015*sign(Coord_col[,2]),label=rownames(Coord_col)),hjust=0, vjust=0,col='red')

#Plano 13#
ggplot(data=Coord_row,aes(x=Dim_1,y=Dim_3))+
  geom_point()+
  geom_text(aes(label=rownames(Coord_row)),hjust=0.5, vjust=-.8)+
  #geom_point(data=Coord_col,aes(x=Dim_1,y=Dim_2),col='red')+
  geom_segment(mapping = aes(x = 0, y = 0, xend =Dim_1, yend =Dim_3),data = Coord_col,arrow = arrow(length=unit(0.30,"cm"), type = "open"), size = 0.7,col='red')+
  geom_text(data=Coord_col,aes(x=Coord_col[,1]+.015*sign(Coord_col[,1]),y=Coord_col[,3]+.015*sign(Coord_col[,3]),label=rownames(Coord_col)),hjust=0, vjust=0,col='red')

#Plano 23#
ggplot(data=Coord_row,aes(x=Dim_2,y=Dim_3))+
  geom_point()+
  geom_text(aes(label=rownames(Coord_row)),hjust=0.5, vjust=-.8)+
  #geom_point(data=Coord_col,aes(x=Dim_1,y=Dim_2),col='red')+
  geom_segment(mapping = aes(x = 0, y = 0, xend =Dim_2, yend =Dim_3),data = Coord_col,arrow = arrow(length=unit(0.30,"cm"), type = "open"), size = 0.7,col='red')+
  geom_text(data=Coord_col,aes(x=Coord_col[,2]+.015*sign(Coord_col[,2]),y=Coord_col[,3]+.015*sign(Coord_col[,3]),label=rownames(Coord_col)),hjust=0, vjust=0,col='red')

##Export results to xls##
require(xlsx)
write.xlsx(Explain_var, '/Users/victor/Documents/DataLab/Hospitales_RRSS/R_code/Results_A.xlsx',sheetName = "Varianza explicada")
write.xlsx(Contributions_SM, '/Users/victor/Documents/DataLab/Hospitales_RRSS/R_code/Results_A.xlsx',sheetName = "Contribucion Redes Sociales",append=TRUE)
write.xlsx(Contributions_Com_Aut, '/Users/victor/Documents/DataLab/Hospitales_RRSS/R_code/Results_A.xlsx',sheetName = "Contribucion CCAA",append=TRUE)
write.xlsx(Contributions_SM_b, '/Users/victor/Documents/DataLab/Hospitales_RRSS/R_code/Results_B.xlsx',sheetName = "Contribucion Redes Sociales")
write.xlsx(Contributions_Com_Aut_b, '/Users/victor/Documents/DataLab/Hospitales_RRSS/R_code/Results_B.xlsx',sheetName = "Contribucion CCAA",append=TRUE)
