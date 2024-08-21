Project Description: 
  
  This project is what I produced as part of a friendly competition among classmates on creating the best predictor for Austin Housing prices based on feature engineering, scraping new data, selecting and optimizing machine learning models. This project was an in-depth, hands on experience relating to the true operations of a data analyst. 

Feature Engineering: 
  1. Feature Removal: Features that had little to no effect, or had little intuitive relation to the target variable, were removed.
  2. Grouping Zip Codes into Areas: Areas in Austin are well defined and are expected to affect the pricing of the house. Zip codes were therefore grouped into what area around Austin they are in.
  3. House Build Year to Age of House: Converting year the house was built into age of the house.
  4. Household Income by Zip Code: Census data was scrapped for household median income by zipcode, a feature that proved to be the most important feature in the data set.
  5. Number of Features: The original data contain many features called "num of ___" which signified number of appliances, windows, and other household features. These were combined into one variable.
  6. Numerical Variables to Categorical: Some numerical variables were turned into categorical ones.
  7. One-Hot Encoding: Encoding categorical variables into factors.


Machine Learning Models Deployed: 
  1. Regression Trees: A non-linear model that predicts outcomes by recursively splitting the data into subsets based on feature values.
  2. Bagging: An ensemble method that averages the predictions of multiple decision trees trained on different random samples to reduce variance.
  3. Random Forest: An ensemble technique that combines multiple decision trees, each built on random samples and features, to improve prediction accuracy and robustness.
  4. BART (Bayesian Additive Regression Trees): A flexible Bayesian approach that models complex relationships by summing multiple decision trees, providing probabilistic predictions.
  5. Boosting: An ensemble method that builds models sequentially, each focusing on correcting the errors of the previous ones, to reduce bias and improve predictions.
  6. Stepwise Selection Linear Regression: A model selection technique that iteratively adds or removes predictors based on statistical criteria to find the best-fit linear model.
  7. Ridge Linear Regression: A linear regression model that includes a penalty term to shrink coefficients, helping to prevent overfitting by addressing multicollinearity.
  8. Lasso Linear Regression: A linear regression model that applies L1 regularization to enforce sparsity, potentially driving some coefficients to zero for feature selection.
  9. Principal Component Regression: A regression technique that reduces the dimensionality of the predictors by using principal components before fitting the linear model.

Tech Stack: 
  1. caret: Machine Learning Model Training and Testing
  2. rpart.plot: Visualization of Decision Trees
  3. glmnet: Regularized Regression Models (Ridge, Lasso)
  4. gbm: Gradient Boosting Machine Learning Models
  5. BART: Bayesian Additive Regression Trees (Non-linear Modeling)
  6. dplyr: Data Manipulation and Wrangling
  7. stringr: String Manipulation and Text Processing
  8. tree: Decision Tree Models and Visualization
  9. bartMachine: Bayesian Additive Regression Trees (BART) with Parallel Computing
  10. rJava: Interface for Java Integration in R

