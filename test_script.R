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

#_______________________________
#Continuous numeric variables
#_______________________________

#serum_cholesterol_mg_per_dl (126 to 564) 
#oldpeak_eq_st_depression (ST depression induced by exercise relative to rest )
#exercise_induced_angina (1 = yes; 0 = no)
#max_heart_rate_achieved
#Rest_BP 
#Age

#heart_disease_present - what we are trying to predict


#************************************************************************************************************
#Exploratory Analysis
#------------------------------------------------------------------------------------------------------------
library(ggplot2)

# Custom Binning. I can just give the size of the bin
ggplot(train, aes(x=age)) + geom_histogram(binwidth = 5,color="white", fill=rgb(0.2,0.7,0.1,0.4) )
ggplot(train, aes(x=age)) + geom_histogram(binwidth = 5,aes(fill = ..count..)  )

# Age (continuous numeric variable) vs heart disease(binary)
ggplot(train, aes(age, fill = factor(heart_disease_present))) + 
  geom_histogram(bins=30) + 
  xlab("Age") +theme_few() + scale_colour_few()+
  scale_fill_discrete(name = "Presence_of_Heart_disease") + 
  ggtitle("Age vs Heart disease")



#Sex(nominal qualitative variable) vs vs heart disease(binary)
ggplot(train, aes(sex, fill = factor(heart_disease_present))) + 
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

#SystolicBP vs Heart disease
ggplot(train, aes(resting_blood_pressure, fill = factor(heart_disease_present))) + 
  geom_histogram(bins=20) + 
  xlab("Resting_BP")+ 
  scale_fill_discrete(name = "Presence_of_Heart_disease") + 
  ggtitle("Resting_BP vs Heart disease")

#... more exploratory analysis required


#********************************************************************************************
#Check for missing values      DONE
#********************************************************************************************

sapply(train, function(x) sum(is.na(x)))

sapply(train, function(x) length(unique(x)))#unique values for all columns in dataset

library(Amelia)
missmap(train, main="Missing values vs observed")


#********************************************************************************************
#Model fitting    DONE
#********************************************************************************************
train <- subset( train, select = -patient_id )

model<-glm(heart_disease_present ~., family = binomial(link = 'logit'), data=train)
summary(model)


confint(model)
exp(coef(model)) # exponentiated coefficients
exp(confint(model)) # 95% CI for exponentiated coefficients
predict(model, type="response") # predicted values
residuals(model, type="deviance") # residuals
