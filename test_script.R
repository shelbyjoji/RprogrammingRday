library(readr)
d1 <- read_csv("train_values.csv")
d2 <- read_csv("train_labels.csv")
d3 <- read_csv("test_values.csv")
View(d1)
View(d2)
View(d3)
train<- total <- merge(d1,d2,by="patient_id")
View(train)
#check data
str(train)
summary(train)


#OBJECTIVE
#Predict whether patient have heart disease or not


#_______________________________
#Categorical
#_______________________________
#Sex

#thal (shows how well blood flows into your heart while exercising or at rest)
        #results of thallium stress test measuring blood flow to the heart, with possible 
        #values normal,fixed_defect, reversible_defect
#chest_pain_type
        #-- Value 1: typical angina 
        #-- Value 2: atypical angina 
        #-- Value 3: non-anginal pain 
        #-- Value 4: asymptomatic 


 
#resting_ekg_results
        #-- Value 0: normal 
        #-- Value 1: having ST-T wave abnormality (T wave inversions and/or ST elevation or depression of > 0.05 mV) 
        #-- Value 2: showing probable or definite left ventricular hypertrophy by Estes' criteria 

#slope_of_peak_exercise_st_segment 
        #-- Value 1: upsloping 
        #-- Value 2: flat 
        #-- Value 3: downsloping
#exercise_induced_angina (1 = yes; 0 = no)
#_______________________________
#Continuous numeric variables
#_______________________________

#serum_cholesterol_mg_per_dl (126 to 564) 
#oldpeak_eq_st_depression (ST depression induced by exercise relative to rest )

#max_heart_rate_achieved
#Rest_BP 
#Age

#heart_disease_present - what we are trying to predict


#************************************************************************************************************
#Exploratory Analysis    PENDING
#------------------------------------------------------------------------------------------------------------
install.packages("magrittr")
library(ggplot2)
library(magrittr)
# Custom Binning. I can just give the size of the bin

train%>% ggplot(aes(x=age)) + geom_histogram(binwidth = 5,color="white", fill=rgb(0.2,0.7,0.1,0.4) )
train%>% ggplot(aes(x=age)) + geom_histogram(binwidth = 5,aes(fill = ..count..)  )

# Age (continuous numeric variable) vs heart disease(binary)
train%>%
ggplot(aes(age, fill = factor(heart_disease_present))) + 
  geom_histogram(bins=30) + 
  xlab("Age") +
  scale_fill_discrete(name = "Presence_of_Heart_disease") + 
  ggtitle("Age vs Heart disease")



#Sex(nominal qualitative variable) vs vs heart disease(binary)
train%>%
ggplot(aes(sex, fill = factor(heart_disease_present))) + 
  geom_bar(stat = "Count", position = 'dodge')+
  xlab("Sex") +
  ylab("Count") +
  scale_fill_discrete(name = "Presence_of_Heart_disease") + 
  ggtitle("Sex vs Heart disease")

#Sex vs heart disease vs Age 
ggplot(train, aes(age, fill = factor(heart_disease_present))) + 
  geom_histogram(bins=30) + 
  xlab("Age") +
  ylab("Count") +
  facet_grid(.~sex)+
  scale_fill_discrete(name = "heart_disease_present") + 
  ggtitle("Age vs Sex vs Heart disease")

#SystolicBP(resting) vs Heart disease
ggplot(train, aes(resting_blood_pressure, fill = factor(heart_disease_present))) + 
  geom_histogram(bins=20) + 
  xlab("Resting_BP")+ 
  scale_fill_discrete(name = "Presence_of_Heart_disease") + 
  ggtitle("Resting_BP vs Heart disease")

#num_major_vessels(nominal qualitative variable) vs vs heart disease(binary)
train%>%
  ggplot(aes(num_major_vessels, fill = factor(heart_disease_present))) + 
  geom_bar(stat = "Count", position = 'dodge')+
  xlab("Major vessels") +
  ylab("Count") +
  scale_fill_discrete(name = "Presence_of_Heart_disease") + 
  ggtitle("Major vessels vs Heart disease")

#Thalium stress test result(nominal qualitative variable) vs vs heart disease(binary)
train%>%
  ggplot(aes(thal, fill = factor(heart_disease_present))) + 
  geom_bar(stat = "Count", position = 'dodge')+
  xlab("Thalium stress test") +
  ylab("Count") +
  scale_fill_discrete(name = "Presence_of_Heart_disease") + 
  ggtitle("Thalium stress test result vs Heart disease")


train%>%
  ggplot(aes(oldpeak_eq_st_depression, fill = factor(heart_disease_present))) + 
  geom_histogram(bins=30) + 
  xlab("Oldpeak ST depression") +
  scale_fill_discrete(name = "Presence_of_Heart_disease") + 
  ggtitle("Oldpeak ST depression vs Heart disease")

summary(train$oldpeak_eq_st_depression)
View(train)
names(train)
#... more exploratory analysis required


#********************************************************************************************
#Check for missing values      DONE
#********************************************************************************************

sapply(train, function(x) sum(is.na(x)))

sapply(train, function(x) length(unique(x)))#unique values for all columns in dataset

library(Amelia)
missmap(train, main="Missing values vs observed")


#********************************************************************************************
#Model fitting    PENDING
#********************************************************************************************

#Logistic regression
# - dependent variable is dichotomous 
# - explain relationship between response variable and one or more categorical(nominal), categorical(ordinal), interval or retio-level indpendent variables

#ASSUMPTIONS
# - Response varibale is dichotomous
# - No outliers in the data
# - There should be no multicolinearity (high correlation) among predictors .  Do a correlation matrix
#   This assuption is metv as long as correlation coefficents are less than 0.90


#**************************************************************
#CORRELATION MATRIX
train2 <- subset( train, select = c('exercise_induced_angina','chest_pain_type','num_major_vessels','oldpeak_eq_st_depression','sex'))
train3<-subset( train, select = c('exercise_induced_angina','chest_pain_type','num_major_vessels','oldpeak_eq_st_depression','sex','heart_disease_present'))


install.packages("corrplot")
names(train)
train4<-subset(train, select = c('serum_cholesterol_mg_per_dl','oldpeak_eq_st_depression','max_heart_rate_achieved','resting_blood_pressure','age'))
library(corrplot)
M <- cor(train4, method = c("pearson"))

corrplot(M, type = "upper", tl.pos = "td",
         method = "circle", tl.cex = 0.75, tl.col = 'black',
         order = "hclust", diag = FALSE)



#***********************************************************



train$thalach[train$thal == "normal"] <- 0   
train$thalach[train$thal == "fixed_defect"] <- 1
train$thalach[train$thal == "reversible_defect"] <- 2

library(broom)
names(train)

model<-glm(heart_disease_present ~slope_of_peak_exercise_st_segment+thal+resting_blood_pressure+chest_pain_type+num_major_vessels+fasting_blood_sugar_gt_120_mg_per_dl+resting_ekg_results+serum_cholesterol_mg_per_dl+oldpeak_eq_st_depression+sex+age+max_heart_rate_achieved+exercise_induced_angina+thalach,family = binomial(link = 'logit'), data=train)
tidy(model)
summary(model)
backwards = step(model)

#for all the above statistically significant variables, num_major_vessels has the lowest p-value suggesting 
#a strong association of the num_major_vessels of patients with probablity of having heart disease.

# included in the model
# exercise_induced_angina
# chest_pain_type
# num_major_vessels
# oldpeak_eq_st_depression
# sex
# thalach



anova(model, test="Chisq")

# The difference between the null deviance and the residual deviance shows how our model is
# doing against the null model (a model with only the intercept). The wider this gap, the better. 
# Analyzing the table we can see the drop in deviance when adding each variable one at a time.
model2<-glm(heart_disease_present ~exercise_induced_angina+chest_pain_type+num_major_vessels+oldpeak_eq_st_depression+sex+thalach+resting_blood_pressure+slope_of_peak_exercise_st_segment+fasting_blood_sugar_gt_120_mg_per_dl,family = binomial(link = 'logit'), data=train)

summary(model2)
anova(model2, test="Chisq")
# Again, adding resting_blood_pressure, slope_of_peak_exercise_st_segment, fasting_blood_sugar_gt_120_mg_per_dl  does not affect the residual deviance drop to any extend. 
# Look for the other variables  that seems to improve the model less even though low p value is okay. 
# A large p-value here indicates that the model without the variable explains more or less the same amount of variation.

# Ultimately what you would like to see is a significant drop in deviance and the AIC.

#not include / reject from model
# resting_blood_pressure
# slope_of_peak_exercise_st_segment
# fasting_blood_sugar_gt_120_mg_per_dl
# age
# serum_cholesterol_mg_per_dl
# max_heart_rate_achieved
# resting_ekg_results

#the McFadden R2 index can be used to assess the model fit 
#Need to find a way to interpret this......pending
install.packages("pscl")
library(pscl)
pR2(model)

# to get odds ratio
require(MASS)
exp(cbind(Odd_Ratio = coef(model), confint(model)))

logit2prob <- function(x){
  odds <- exp(x)
  prob <- odds / (1 + odds)
  return(prob)
}

# to get probablity
logit2prob(coef(model))


confint(model)
exp(coef(model)) # exponentiated coefficients
exp(confint(model)) # 95% CI for exponentiated coefficients
predict(model, type="response") # predicted values
residuals(model, type="deviance") # residuals


# how well this model predicts
#***************************************
model<-glm(heart_disease_present ~exercise_induced_angina+chest_pain_type+num_major_vessels+oldpeak_eq_st_depression+sex,family = binomial(link = 'logit'), data=train)
summary(model)
fitted.results <- predict(model,newdata=subset(d3,select=c('exercise_induced_angina','chest_pain_type','num_major_vessels','oldpeak_eq_st_depression','sex')),type='response')
fitted.results
fitted.results <- ifelse(fitted.results > 0.5,1,0)
fitted.results

 