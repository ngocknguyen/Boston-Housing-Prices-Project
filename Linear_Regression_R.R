#import MASS package to run the Boston dataset
library(MASS)
data(Boston)
#simple EDA to learn about the dimension and names of columns in the dataset
colnames(Boston)
dim(Boston)
#split the dataset into 90% training set and 10% testing set
subset <- sample(nrow(Boston),nrow(Boston)*0.9)
Boston_train = Boston[subset, ]
Boston_test = Boston[-subset, ]
#Model building
#Find if there's outliers in the dataset
summary(Boston_train)
boxplot(Boston_train,1:14, col = "rosybrown1")
#Linear Regression
model_train = lm(medv~., data = Boston_train)
summary(model_train)
#Variable Selection (Best subset)
install.packages("leaps")
library(leaps)
Boston_subset <- regsubsets(medv ~ ., data = Boston_train, nbest = 2, nvmax = 14) 
summary(Boston_subset)
plot(Boston_subset, scale='bic')
#Best model
Boston_model = lm(medv~. -age - indus,data=Boston_train)
summary(Boston_model)
#out of sample performance
#Test on original model to find MSE
pi <- predict(model_train, Boston_test)
mean((pi - Boston_test$medv)^2)
#Test on best model to find MSE
pi1 <- predict(Boston_model, Boston_test)
mean((pi1 - Boston_test$medv)^2)
#10 folds cross validation
library(boot)
odel_10folds = glm(medv~. -age -indus, data= Boston)
cv.glm(data=Boston,glmfit = Model_10folds, K = 10)$delta[2]

## Decision Tree
library(rpart)
library(rpart.plot)
boston_rpart <- rpart(formula = medv ~ ., data = Boston_train)
#Printing and ploting the tree 
boston_rpart
prp(boston_rpart,digits = 4, extra = 1)
#Pruning the tree
boston_largetree <- rpart(formula = medv ~ ., data = Boston_train, cp =0.001)
prp(boston_largetree)
plotcp(boston_largetree)
Boston_prune <- rpart(formula = medv ~ ., data = Boston_train, cp =0.008)
#Prediction using regression tree
boston_train_pred_tree = predict(Boston_prune)
boston_train_pred_tree
mean((boston_train_pred_tree - Boston_train$medv)^2)
boston_test_pred_tree = predict(Boston_prune,Boston_test)
boston_test_pred_tree
mean((boston_test_pred_tree - Boston_test$medv)^2)
##Test on linear regression
#In-sample MSE
Boston_model = lm(medv~. -age - indus,data=Boston_train)
pi2 <- summary(Boston_model)
(pi2$sigma)^2 
#Out-of-sample MSE
pi1 <- predict(Boston_model, Boston_test)
mean((pi1 - Boston_test$medv)^2)

