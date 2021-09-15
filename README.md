Abstract

This report employs supervised learning algorithms to analyse the Survival of Heart Failure Patients. The dataset used contains 13 variables of patients physical and lifestyle information. The analyses are performed using R programming language. We employ two different supervised learning algorithms for the analyses which are the logistic regression and the random forest. The methods are implemented for prediction and the accuracy of each method is measured and compared. According to the findings, both algorithms perform very well at predicting the survival of heart failure patients. 

Section 1: Introduction

In this paper, we analyse a dataset of 299 patients with heart failure collected in 2015 sourced from the Public Library of Science , under the Creative Commons license. The dataset contains the medical records of 299 heart failure patients collected at the Faisalabad Institute of Cardiology and at the Allied Hospital in Faisalabad (Pakistan), during April–December 2015. The patients consisted of 105 women and 194 men, aged between 40 and 95 years old. All patients had left ventricular systolic dysfunction and had previous heart failures.

![alt text](https://github.com/freakatom7/Predicting-Heart-Attack-Survival-logistic-regresion-and-random-forest-/blob/main/diagram1.png)

Before proceeding to the modelling stage, we separate the dataset into training and test set, in 2/3 and 1/3 ratio respectively. The reason behind this ratio is that due to the moderate size of the dataset (n = 299), we think it is appropriate for the test set not to go lower than 1/3 of the original dataset size.

Section 2: Modelling 

Cardiovascular diseases kill approximately 17 million people globally every year, and they mainly exhibit as myocardial infarctions and heart failures. Myocardial infarctions usually happen when a blood clot blocks blood flow to the heart. Without enough blood, tissue loses oxygen and dies.  And heart failures occur when the heart cannot pump enough blood to meet the needs of the body. 

Available electronic medical records that quantify symptoms, body features, and clinical laboratory test values can be used to perform biostatistical analysis aimed at highlighting patterns and correlations otherwise undetected by medical doctors. Furthermore, machine learning can be utilised to predict patients’ survival from their data, allowing physicians to personalise the patients’ care and thus maximising the chance of survival of the patients.

Modelling survival for heart failure is still a problem nowadays, both in terms of achieving high prediction accuracy and identifying the driving factors. Most of the models developed for this purpose reach only modest accuracies, with limited interpretability from the predicting variables. More recent models show improvements, especially if the survival outcome is coupled with additional targets (for example, hospitalization). Although scientists have identified a broad set of predictors and indicators, there is no shared consensus on their relative impact on survival prediction. 

As pointed out by Sakamoto et al. in 2018, this situation is largely due to a lack of reproducibility, which prevents drawing definitive conclusions about the importance of the detected factors. Further, this lack of reproducibility strongly affects model performances: generalisation to external validation datasets is often inconsistent and achieves only modest discrimination. Consequently, risk factors statistical significances from the models suffer similar problems, limiting their reliability. 

In this paper, we provide 2 reproducible machine learning algorithms that can be used to model the survival of heart attack patients and identify the most important factors determining the survivals. The first model is the logistic regression which is presented in Section 2 (a). We also employ the random forest algorithm on the dataset, and it is presented in Section 2 (b). 

Section 2 (a): Logistic Regression 

Logistic regression is used to model the probability of a certain event. In this case, we refer to the probability of surviving a heart attack event. This event is recorded in DEATH_EVENT column, where 0 means the patients survives and 1 means the patients deceases. 

Firstly, we specify the logistic regression model of interest. Then we fit the training set onto model specified.  In this paper, we specify logistic_regression1 as the primary choice of model. The first model includes every column in the dataset. In this model, we would like to see which variables are significant to predict the survival of heart attack patients. Presented below is the trained model for this logistic regression. 

![image](https://user-images.githubusercontent.com/44749458/133460479-127398e5-02f2-420c-9376-afc8cbe3917c.png)

At a glance, we notice that there are only 3 statistically significant variables. Ejection fraction and time are statistically significant at 100% confidence level, whilst serum creatinine is statistically significant at 99.9% confidence level. Moving onto the coefficients, we observe that the signs of the statistically significant variables are as expected. Such as that the negative sign of ejection fraction signifies that this clinical laboratory test value is negatively correlated with a patient’s death. The same sign is observed for time. Meanwhile, a positive sign is observed for serum creatinine. 

Generally, the results of logistic_regresison1 makes sense. However, we would like to improve the model and thus we re-specify another logistic regression model. This second model (logistic_regression2) is only made up of the statistically significant dependent variables from the first specification. I.e., ejection fraction, serum creatinine and time. 

Presented below is the refined model. We see that now all the estimated coefficients more or less the same as before. (Same signs and magnitudes) Only now, all the estimates are statistically significant at 100% confidence level.

![image](https://user-images.githubusercontent.com/44749458/133460601-39171db2-e9eb-4a50-9216-def01ccd7e0e.png)

Next, we perform several tests to compare the 2 logistic regression models and determine the better model based on the test results and interpretability of the models. The table below summarises the results of the tests performed on both logistic regression models. Based on the results of the following tests, we conclude that logistic_regression2 is the better logistic regression model for this dataset. 

![alt text](https://github.com/freakatom7/Predicting-Heart-Attack-Survival-logistic-regresion-and-random-forest-/blob/main/diagram2.png)

![alt text](https://github.com/freakatom7/Predicting-Heart-Attack-Survival-logistic-regresion-and-random-forest-/blob/main/diagram2a.png) 

![alt text](https://github.com/freakatom7/Predicting-Heart-Attack-Survival-logistic-regresion-and-random-forest-/blob/main/diagram3.png) 

![alt text](https://github.com/freakatom7/Predicting-Heart-Attack-Survival-logistic-regresion-and-random-forest-/blob/main/diagram4.png) 

![alt text](https://github.com/freakatom7/Predicting-Heart-Attack-Survival-logistic-regresion-and-random-forest-/blob/main/diagram5.png) 

![alt text](https://github.com/freakatom7/Predicting-Heart-Attack-Survival-logistic-regresion-and-random-forest-/blob/main/diagram6.png) 

![alt text](https://github.com/freakatom7/Predicting-Heart-Attack-Survival-logistic-regresion-and-random-forest-/blob/main/diagram7.png) 
