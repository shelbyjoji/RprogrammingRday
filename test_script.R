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

#Exploratory Analysis
#Age
#Sex
#Rest_BP 
#thal (shows how well blood flows into your heart while exercising or at rest)
#max_heart_rate_achieved
#slope_of_peak_exercise_st_segment 
#oldpeak_eq_st_depression
#slope 

# Age (continuous numeric variables) vs heart disease(binary)
library(ggplot2)
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

#Sex vs Survived vs Age 
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


