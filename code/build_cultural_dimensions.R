library("ggplot2")
memory.limit(1500000)


survey<-readRDS("/DIRECTORY/survey_dataset_means_weighted.rds")
df<-read.csv(file="/DIRECTORY/GoogleNews_Embedding.csv", header=TRUE,row.names=1, sep=",")
#df<-read.csv(file="/DIRECTORY/US_Ngrams_2000_12.csv")

#####DEFINE FUNCTIONS##########
#Calculate norm of vector#
norm_vec <- function(x) sqrt(sum(x^2))

#Dot product#
dot <- function(x,y) (sum(x*y))

#Cosine Similarity#
cos <- function(x,y) dot(x,y)/norm_vec(x)/norm_vec(y)

#Normalize vector#
nrm <- function(x) x/norm_vec(x)

#Calculate semantic dimension from antonym pair#
dimension<-function(x,y) nrm(nrm(x)-nrm(y))

###STORE EMBEDDING AS MATRIX, NORMALIZE WORD VECTORS###
cdfm<-as.matrix(data.frame(df))
cdfmn<-t(apply(cdfm,1,nrm))


###IMPORT LISTS OF TERMS TO PROJECT AND ANTONYM PAIRS#####
ant_pairs_aff <- read.csv("DIR/affluence_pairs.csv",header=FALSE, stringsAsFactor=F)
ant_pairs_gen <- read.csv("DIR/gender_pairs.csv",header=FALSE, stringsAsFactor=F)
ant_pairs_race <- read.csv("DIR/race_pairs.csv",header=FALSE, stringsAsFactor=F)


word_dims<-matrix(NA,nrow(ant_pairs_aff),300)


###SETUP "make_dim" FUNCTION, INPUT EMBEDDING AND ANTONYM PAIR LIST#######
###OUTPUT AVERAGE SEMANTIC DIMENSION###

make_dim<-function(embedding,pairs){
word_dims<-data.frame(matrix(NA,nrow(pairs),300))
for (j in 1:nrow(pairs)){
rp_word1<-pairs[j,1]
rp_word2<-pairs[j,2]
tryCatch(word_dims[j,]<-dimension(embedding[rp_word1,],embedding[rp_word2,]),error=function(e){})
}
dim_ave<-colMeans(word_dims, na.rm = TRUE)
dim_ave_n<-nrm(dim_ave)
return(dim_ave_n)
}


#####CONSTRUCT AFFLUENCE, GENDER, AND RACE DIMENSIONS######
aff_dim<-make_dim(df,ant_pairs_aff)
gender_dim<-make_dim(df,ant_pairs_gen)
race_dim<-make_dim(df,ant_pairs_race)


####ANGLES BETWEEN DIMENSIONS#######
cos(aff_dim,gender_dim)
cos(aff_dim,race_dim)
cos(gender_dim,race_dim)


####CALCULATE PROJECTIONS BY MATRIX MULTIPLICATION####
###(Equivalent to cosine similarity because vectors are normalized)###
aff_proj<-cdfmn%*%aff_dim
gender_proj<-cdfmn%*%gender_dim
race_proj<-cdfmn%*%race_dim

projections_df<-cbind(aff_proj, gender_proj, race_proj)
colnames(projections_df)<-c("aff_proj","gender_proj","race_proj")


####MERGE WITH SURVEY AND CALCULATE CORRELATION####
projections_sub<-subset(projections_df, rownames(projections_df) %in% rownames(survey))
colnames(projections_sub)<-c("aff_proj","gender_proj","race_proj")
survey_proj<-merge(survey,projections_sub,by=0)


cor(survey_proj$survey_class,survey_proj$aff_proj)
cor(survey_proj$survey_gender,survey_proj$gender_proj)
cor(survey_proj$survey_race,survey_proj$race_proj)

########################################################################


###CREATE VISUALIZATION###
wlist=c("camping","baseball","boxing","volleyball","softball","golf","tennis","soccer","basketball","hockey")
Visualization<-ggplot(data=data.frame(projections_df[wlist,]),aes(x=gender_proj,y=aff_proj,label=wlist)) + geom_text()
Visualization+ theme_bw() +ylim(-.25,.25) +xlim(-.25,.25)

########################################################################

