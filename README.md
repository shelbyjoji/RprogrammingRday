# RprogrammingRday
Project for R day Group 6

Coronary artery disease (CAD), caused by narrowing of arteries from fat deposits, has been one among the major heart diseases that affect the country. Coronary artery disease may or may not be present with symptoms and, if left untreated, it could lead to life-threatening heart blockages.

Exercise stress test is a cost effective and easy way to analyze the stain on heart and thereby help diagnose coronary artery disease. Although stress test is not a conclusive way to measure the severity of coronary artery disease, it helps avoid expensive angiogram procedure for people who otherwise have normal vessels.

For this project, we used data from 180 patients, who exhibited symptoms of coronary artery disease and were subjected to exercise stress test and was investigated for this research study. Dataset was obtained from UC Irvine machine learning repository. This is project explores factors relating to presence or absence of coronary artery disease(CAD). Dataset has 180 observations and 14 variables. The analysis attempts to answer the question, "Which factors influence the presence heart disease the most?" 

The aim of the project is to develop a model that predicts the binary outcome: what factors predicts the presence of heart disease?' 


There are 14 columns in the dataset, where the patient_id column is a unique and random identifier. The remaining 13 features are described in the section below.

slope_of_peak_exercise_st_segment (type: int): the slope of the peak exercise ST segment, an electrocardiography read out indicating quality of blood flow to the heart

thal (type: categorical): results of thallium stress test measuring blood flow to the heart, with possible values normal, fixed_defect, reversible_defect

resting_blood_pressure (type: int): resting blood pressure

chest_pain_type (type: int): chest pain type (4 values)

num_major_vessels (type: int): number of major vessels with >50% narrowing (0-3) colored by flourosopy

fasting_blood_sugar_gt_120_mg_per_dl (type: binary): fasting blood sugar > 120 mg/dl

resting_ekg_results (type: int): resting electrocardiographic results (values 0,1,2)

serum_cholesterol_mg_per_dl (type: int): serum cholestoral in mg/dl

oldpeak_eq_st_depression (type: float): oldpeak = ST depression induced by exercise relative to rest, a measure of abnormality in electrocardiograms

sex (type: binary): 0: female, 1: male

age (type: int): age in years

max_heart_rate_achieved (type: int): maximum heart rate achieved (beats per minute)

exercise_induced_angina (type: binary): exercise-induced chest pain (0: False, 1: True)

We have two datasets train and test data
The training set should be used to build your models. For the training set, we provide the outcome (also known as the “ground truth”) for each patient. Your model will be based on “features” like chest pain type, sex and age. 

The test set should be used to see how well your model performs on unseen data. For the test set, ground truth is not provided for each patient. We need to predict these outcomes. For each patient in the test set, use the model we trained to predict whether or not they have heart disease.