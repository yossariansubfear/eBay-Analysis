ebay = read.csv("ebayA.csv")

summary(ebay)
mean(ebay$sold)
table(ebay$size)

ebay_1 = ebay

cat_cols = c('biddable', 'sold', 'condition', 'heel', 'style', 'color')
ebay[cat_cols] = lapply(ebay[cat_cols], factor)
summary(ebay)

set.seed(123)
library(caTools)

spl = sample.split(ebay$sold, 0.7)
ebay_train = subset(ebay, spl == TRUE)
ebay_test = subset(ebay, spl == FALSE)

glmebay1 = glm(sold~biddable + startprice + condition + heel + style + color + material, data=ebay_train, family="binomial")

summary(glmebay1)

glmebay2 = glm(sold~biddable + startprice + condition + size + heel + style + color + material, data=ebay_train, family="binomial")

summary(glmebay2)

ebay_train = ebay_train[!is.na(ebay_train[,"size"]),]

glmebay3 = glm(sold~biddable + startprice + condition + size + heel + style + color + material, data=ebay_train, family="binomial") 
summary(glmebay3)
glmpred = predict(glmebay2, newdata=ebay_test, type="response")

(confu_mat = table(ebay_test$sold, glmpred >= 0.5)) 
(pred_acc = (confu_mat[1,1] + confu_mat[2,2])/sum(confu_mat))

library(rpart) 
library(rpart.plot)

CARTebay = rpart(formula = sold ~ biddable + startprice + condition + size + heel + style + color + material, data = ebay_train, cp = 0.005)

library(randomForest)

ebay_rf = randomForest(sold~biddable + startprice + condition + size + heel + style + color + material, data = ebay_train)
ebay_rf
varImpPlot(ebay_rf, main = "Variable Importance Plot")