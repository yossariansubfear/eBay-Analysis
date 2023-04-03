# eBay-Analysis
## Predicting Sales on eBay
This analysis aims to predict shoe sales on eBay using relevant variables such as starting/listed price of the shoe, size, color, material, etc. We start with a basic exploratory analysis followed by fitting a logistic regression model for sales prediction. Then we also use CART and RandomForest to understand the variables of importance. R language is used for the analysis. You can access the data used [here](https://drive.google.com/file/d/1qKbVDGnl2Wuo_oKr2g13ppR4lolnmQgS/view?usp=share_link). 

Here is a final plot to understand relative importance of variables involved to predict shoe sales:![Variable Importance Plot](/eBay-Analysis/VarImpPlot.png)

Please go through the Code and Analysis part to make more sense of the conclusion.

## Conclusion:
    After this analysis, we can make following remarks regarding the shoe sales on eBay:
      1. Start price of the product matters the most when selling shoes. If it is more than 104, there is practically no chance of selling the shoes.  
         For the best shot at selling, the price should be between 22-104.
      2. Following combinations of the variables make up most of the sold shoes:  
          a. Price= 22-104, style = Other/Missing, biddable = 1, material = any. 
          b. Price= 22-104, style = Other/Missing, biddable = 0. 
          c. Price= 22-104, style = !Other/Missing 
          d. Price< 22. 
    





