#personal project 1 - supervised learning

##data cleaning part##
#load heart failure data 
library(readr)
heart_failure <- read_csv("heart_failure.csv")
#summary statistics
pastecs::stat.desc(heart_failure)
#plot data distributions 
library('tidyverse')
ggplot(gather(heart_failure), aes(value)) +
  geom_histogram(bins = 20) +
  facet_wrap(~key, scales = 'free_x')
#rescaling variables 
heart_failure[,1:12] <- scale(heart_failure[,1:12])

#split data into train and test 
library(caTools)
set.seed(123)
split <- sample.split(heart_failure$DEATH_EVENT, SplitRatio = 2/3)
training_set <- subset(heart_failure, split == TRUE)
test_set <- subset(heart_failure, split == FALSE)

##Section 2(a) - logistic regression##
#train model 1 (with all variables)
logistic_train1 <- glm(DEATH_EVENT ~ ., data = training_set, family = "binomial")
summary(logistic_train1)
#train model 2 (with statistically significant variables)
logistic_train2 <- glm(DEATH_EVENT ~ ejection_fraction + serum_creatinine + time, data = training_set, family = "binomial")
summary(logistic_train2)
#calculate mse 
library(modelr)
mse(logistic_train1, training_set)
mse(logistic_train2, training_set)
#compute variable importance - higher value indicates higher importance
library(caret)
varImp(logistic_train1)
varImp(logistic_train2)
#calculate VIF values for dependent variables 
# VIF > 5 suggests multicollinearity 
library(car)
vif(logistic_train1)
vif(logistic_train2)
#no multicollinearity in either model
#proceed with model logistic_train2
library(InformationValue)
predicted <- predict(logistic_train2, test_set, type = "response")
optimal <- optimalCutoff(test_set$DEATH_EVENT, predicted)[1]
#the optimal probability cutoff for death is 0.5758 = 58%
#create confusion matrix prediction compared to actual deaths
confusionMatrix(test_set$DEATH_EVENT, predicted)
#calculate sensitivity 
sensitivity(test_set$DEATH_EVENT, predicted)
#calculate specificity 
specificity(test_set$DEATH_EVENT, predicted)
#calculate total misclassification error rate 
misClassError(test_set$DEATH_EVENT, predicted, threshold = optimal)
#13% - the lower the better
#plot ROC curve
plotROC(test_set$DEATH_EVENT, predicted)
#to plot the graph logistic_train2
#create data frame of probabilities of dying from heart attack and the actual status
predicted.data <- data.frame(
  probability.of.death = logistic_train2$fitted.values, 
  death_event = training_set$DEATH_EVENT
)
#sort data frame from low probabilities to high probabilities 
predicted.data <- predicted.data[
  order(predicted.data$probability.of.death, decreasing = FALSE),]
#add a new column to the data frame that ranks each sample from low to high prob
predicted.data$rank <- 1:nrow(predicted.data)
library(ggplot2)
library(cowplot)
ggplot(data=predicted.data, aes(x=rank, y=probability.of.death)) +
  geom_point(aes(colour=death_event), alpha=1, shape=4, stroke=2) +
  xlab("Index") + 
  ylab("Predicted probability of not surviving heart attack") +
  ggtitle("Logistic Regression Model of Survival of Heart Failure Patients")


##Section 2(b) - random forest##
library(ggplot2)
library(cowplot)
library(randomForest)

set.seed(24)
heart_failure$DEATH_EVENT <- as.factor(heart_failure$DEATH_EVENT)
training_set$DEATH_EVENT <- as.factor(training_set$DEATH_EVENT)
test_set$DEATH_EVENT <- as.factor(test_set$DEATH_EVENT)

#build random forest models
random_forest1 <- randomForest(DEATH_EVENT ~ ., data = training_set, proximity = TRUE)
random_forest1
#OBB error rate = 15.58%
#124 patients predicted to survive survive, 11 patients predicted deceased survive
#47 patients predicted deceased deceased, 17 patients predicted survive deceased

random_forest2 <- randomForest(DEATH_EVENT ~ ejection_fraction + serum_creatinine + time, data = training_set, proximity = TRUE)
random_forest2
#OBB error rate = 18.59% 
#random_forest1 performs better with respect to OOB error rate

#to observe evolution of error rate as the number of trees changes
#for random_forest1
oob.error.data1 <- data.frame(
  Trees = rep(1:nrow(random_forest1$err.rate), times = 3),
  Type = rep(c("OOB", "Survived", "Deceased"), each = nrow(random_forest1$err.rate)),
  Error = c(random_forest1$err.rate[,"OOB"], 
            random_forest1$err.rate[,"0"], 
            random_forest1$err.rate[,"1"]))
#plot the graph 
ggplot(data = oob.error.data1, aes(x=Trees, y=Error)) +
  geom_line(aes(colour=Type)) +
  ggtitle("Error Rate Evolution for random_forest1")

#for random_forest2
oob.error.data2 <- data.frame(
  Trees = rep(1:nrow(random_forest2$err.rate), times = 3),
  Type = rep(c("OOB", "Survived", "Deceased"), each = nrow(random_forest2$err.rate)),
  Error = c(random_forest2$err.rate[,"OOB"], 
            random_forest2$err.rate[,"0"], 
            random_forest2$err.rate[,"1"]))
#plot the graph 
ggplot(data = oob.error.data2, aes(x=Trees, y=Error)) +
  geom_line(aes(colour=Type)) +
  ggtitle("Error Rate Evolution for random_forest2")
#from graphs, tree = 145 is sufficient (save computational power) and optimal (any higher, error rate does not decrease)
#both random_forest1 and random_forest2 error rates evolve similarly (no improvements after trees=200)
#up to this point, random_forest1 is slightly preferred due to general OBB error rate
#however, considering interpretability-accuracy trade-off, we'll go with random_forest2, which only include certain variables, instead of all

#respecify random forest models with tree=1000 to check OOB 
random_forest1new <- randomForest(DEATH_EVENT ~ ., data = training_set, ntree=1000, proximity = TRUE)
random_forest1new 
#OOB error rate = 14.07% 
random_forest2new <- randomForest(DEATH_EVENT ~ ejection_fraction + serum_creatinine + time, data = training_set, ntree=1000, proximity = TRUE)
random_forest2new
#OOB error rate 18.59% 

#to observe evolution of error rate as the number of trees increase (for testing)
#for random_forest1new
oob.error.data1new <- data.frame(
  Trees = rep(1:nrow(random_forest1new$err.rate), times = 3),
  Type = rep(c("OOB", "Survived", "Deceased"), each = nrow(random_forest1new$err.rate)),
  Error = c(random_forest1new$err.rate[,"OOB"], 
            random_forest1new$err.rate[,"0"], 
            random_forest1new$err.rate[,"1"]))
#plot the graph 
ggplot(data = oob.error.data1new, aes(x=Trees, y=Error)) +
  geom_line(aes(colour=Type)) +
  ggtitle("Error Rate Evolution for random_forest1 (trees=1000)")

#for random_forest2new
oob.error.data2new <- data.frame(
  Trees = rep(1:nrow(random_forest2new$err.rate), times = 3),
  Type = rep(c("OOB", "Survived", "Deceased"), each = nrow(random_forest2new$err.rate)),
  Error = c(random_forest2new$err.rate[,"OOB"], 
            random_forest2new$err.rate[,"0"], 
            random_forest2new$err.rate[,"1"]))
#plot the graph 
ggplot(data = oob.error.data2new, aes(x=Trees, y=Error)) +
  geom_line(aes(colour=Type)) +
  ggtitle("Error Rate Evolution for random_forest2 (trees=1000)")
#random_forest2 appears more stable after increasing tree to 1000

#now we test the optimal number of variables at each internal node in the tree
#random_forest1 vs random_forest2 
#create empty vector that can hold 10 values 
#for random_forest1
obb.values1 <- vector(length = 10)
#create a loop that tests different number of variables at each step
for(i in 1:10){
  temp.model1 <- randomForest(DEATH_EVENT~., data = training_set, mtry = i, ntree = 500)
  obb.values1[i] <- temp.model1$err.rate[nrow(temp.model1$err.rate),1]
}
obb.values1
#for random_forest2 
obb.values2 <- vector(length = 10)
for(i in 1:10){
  temp.model2 <- randomForest(DEATH_EVENT ~ ejection_fraction + serum_creatinine + time, data = training_set, mtry = i, ntree = 500)
  obb.values2[i] <- temp.model2$err.rate[nrow(temp.model2$err.rate),1]
}
obb.values2 
#stick with 1 variable, instead of 9 suggested, since we only have 4 independent variables in random_forest2
#best random forest model = random_forest2 

#MDS plots#
#create distance matrix: 1-proximity matrix
distance.matrix <- dist(1-random_forest2$proximity)
#run cmd (classical multi-dimensional scaling) on the distance matrix
mds.stuff <- cmdscale(distance.matrix, eig=TRUE, x.ret=TRUE)
#then calculate percentage of variation in the distancce matrix
mds.var.per <- round(mds.stuff$eig/sum(mds.stuff$eig)*100, 1)
#format data for ggplot
mds.values <- mds.stuff$points
mds.data <- data.frame(Sample=rownames(mds.values),
                       X=mds.values[,1],
                       Y=mds.values[,2], 
                       Status=training_set$DEATH_EVENT)
#plot the graph
ggplot(data=mds.data, aes(x=X, y=Y, label=Sample)) +
  geom_text(aes(colour=Status))+
  theme_bw() +
  xlab(paste("MDS1 -", mds.var.per[1], "%", sep="")) + 
  ylab(paste("MDS2 -", mds.var.per[2], "%", sep=""))+
  ggtitle("MDS plot using (1- Random Forest Proximities)")
#the patients in blue are deceased patients
#the patients in red are those who survived
#random_forest2 did a good job predicting the outcome 
#there are some exceptions (blue patients on the right side of the graph)
#Conclusion: random forest did a good job predicting, but imperfect.
#There are other factors in the play: expert opinions, other characteristics of the patients.