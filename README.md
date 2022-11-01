# eBay-Analysis
## Predicting Sales on eBay


#### This analysis aims to predict shoe sales on eBay using relevant variables such as starting/listed price of the shoe, size, color, material, etc. We start with a basic exploratory analysis followed by fitting a logistic regression model for sales prediction. Then we also use CART and RandomForest to understand the variables of importance. R language is used for the analysis. You can access the data used [here](https://drive.google.com/file/d/1qKbVDGnl2Wuo_oKr2g13ppR4lolnmQgS/view?usp=share_link).  


Let's first have a look at the data.  


ebay = read.csv("ebayA.csv")

View(ebay)

summary(ebay)


Based on the summary, we can see that "saleprice" and "size" have 2997 and 68 missing values respectively. While we can work around with 68 missing values, 2997 missing values basically means we just do not have much data for "saleprice". So, "saleprice" would not be of much use to us going forward. We can ask some other questions to get more insight in to the sales.

What proportion of all shoes were sold?

mean(ebay$sold) 

Around 21.04% of the listed shoes are sold.


What is the most common shoe size in the data set?
table(ebay$size)
We can see that size 8 is the most frequently listed size.

It is a good idea to create a copy of the original data set before we make any changes. 
ebay_1 = ebay

Before we start building a model, let's change the variable types to categorical/factor for some of the variables (for which the categories make sense).

cat_cols = c('biddable', 'sold', 'condition', 'heel', 'style', 'color')
ebay[cat_cols] = lapply(ebay[cat_cols], factor)
summary(ebay)


Now, let's move on to splitting the data in train and test data sets to perform logistic regression.

set.seed(123)
library(caTools)

We have chosen to make a 70-30 divide for train-test sets.

spl = sample.split(eBay$sold, 0.7)
ebay_train = subset(ebay, spl == TRUE)
ebay_test = subset(ebay, spl == FALSE)

Fit the logistic regression model to classify if a shoes into two categories, sold = 0 and sold = 1.
We have chosen 8 out of 12 variables for this intitial model. Variables 'saleprice', 'size', 'snippit', and 'description' are not included. As we saw earlier, 2997 of 3796 observations for 'saleprice' are missing. 'snippt' and 'description' are character variables including which won't add anything meaningful to the model. 

For the variable 'size', while there are 68 missing values, it is still usable in the model. So, we will fit two models, one with and one without the 'size' variable, and a third one where we remove the missing observations from 'size'. Then we can compare these three and finalize the best one.

Model 1 - without the variable 'size':

glmebay1 = glm(sold~biddable + startprice + condition + heel + style + color + material, data=Train, family="binomial")
summary(glmebay1)

Based on the model 1 summary, we can see that there are 9 significant variables in total (including the coded version of the caregorical variables):
1. Biddable = 0,
2. startprice,
3. condition = Pre-owned,
4. heel = Low,
5. heel = Medium,
6. style = Stilleto,
7. color = Brown,
8. color = Other/Missing,
9. material = Satin

Also, the residual deviance is 2363.7 with AIC of 2411.7.


Model 2 - including the variable 'size':

glmebay2 = glm(sold~biddable + startprice + condition + size + heel + style + color + material, data=Train, family="binomial")
summary(glmebay2)

Based on the model 1 summary, we can see that there are 8 significant variables in total (including the coded version of the categorical variables):
1. startprice,
2. condition = Pre-owned,
3. heel = Low,
4. heel = Medium,
5. style = Stilleto,
6. color = Brown,
7. color = Other/Missing,
8. material = Satin

Also, the residual deviance is 2310 with AIC of 2360.
So, the variable 'biddable = 0' has become less significant (p-value changed from less than 0.05 to less than 0.1) after we added 'size' to the model. Both residual deviance and AIC values are decreased, meaning model 2 is somewhat better than the model 1. 

Now, let's first remove observations with missing entries in 'size'. (In this particular case, imputing data based on the observed data does not make much sense because the data is MNAR).

ebay_train = ebay_train[!is.na(ebay_train[,"size"]),]

Model 3 - after removing NAs from 'size':

glmebay3 = glm(sold~biddable + startprice + condition + size + heel + style + color + material, data=Train, family="binomial")
summary(glmebay3)

As we can be seen in the output, the result is exactly the same as Model 2. So, we will use the Model 2 to make predictions.

glmpred = predict(glmebay2, newdata=ebay_test, type="response")

Confusion Matrix:
(confu_mat = table(ebay_test$sold, glmpred >= 0.5))
(pred_acc = (confu_mat[1,1] + confu_mat[2,2])/sum(confu_mat))

Model 2 has a prediction accuracy of 82.41%.

Now, let's move on to building a CART model to check the variables of importance.

library(rpart)
library(rpart.plot)

CARTebay = rpart(formula = sold ~ biddable + startprice + condition + size + heel + style + color + material, data = ebay_train, cp = 0.005)
cp= 0.005 was chosen instead of default 0.01 because we want depper trees to get a better idea.

Based on the output, we can see that the variable 'startprice' is the most important variable followed by 'size' and 'style' respectively.

Now, let's fit a RandomForest model and see if this variable importance order still holds.

library(randomForest)
ebay_rf = randomForest(sold~biddable + startprice + condition + size + heel + style + color + material, data = ebay_train)
ebay_rf
varImpPlot(ebay_rf, main = "Variable Importance Plot")

From the plot, 'startprice' comes out on the top as the most important variable in predicting the class for shoes sales, 'size' and 'style' being the second and third most important variables. This order of importance is same as what we got from the CART model.

## Conclusion

After this analysis, we can make following remarks regarding the shoe sales on eBay:
1. Start price of the product matters the most when selling shoes. If it is more than 104, there is practically no chance of selling the shoes. For the best shot at selling, the price should be between 22-104.
2. Following combinations of the variables make up most of the sold shoes:
    a. Price= 22-104, style = Other/Missing, biddable = 1, material = any
    b. Price= 22-104, style = Other/Missing, biddable = 0
    c. Price= 22-104, style = !Other/Missing
    d. Price< 22





