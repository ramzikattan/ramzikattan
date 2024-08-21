Project Description: 
  Our team ran an in-depth analysis on a comprehensive dataset on 2392 high school students (data obfuscated for confidentiality) containing information on demographic details, study habits, parental involvement and education, extracurriculars, and academic performance. We had 3 main goals: 
      1. Predict an individual student’s GPA based on external factors
      2. Classify which students are likely to pass and which are likely to fail their academic course load
      3. Provide meaningful assistance to at-risk students while keep cost of interventions at a minimum
      
Machine Learning Models Deployed: 

Regression Models:  
  1. K-Nearest Neighbors - A simple non-computationally exhaustive model that predicts the number of shares of an article as the average number of shares of similar articles. Cross-Validation with minimum RMSE as optimizer was used to select k. 
  2. Linear Regression - A widely used model that is non-computationally exhaustive and provides the added bonus of interpretable relationships between the dependent variables and the number of shares.
  3. Regression Tree - An easy to visualize predictor that can incorporate non-linear relationships between variables while still providing insights into feature importance.
  4. Bagging Regressor - An ensemble technique that builds multiple models independently by training them on different random samples of the data, then averaging their predictions to reduce variance and prevent overfitting.
  5. Random Forest Regessor - An easy to use ensemble method that balances the bias-variance tradeoff well by using the predictions of multiple decision trees all built on a different, randomly selected subset of the dependent variables.
  6. Boosting - An ensemble method that builds models sequentially, with each model focusing on correcting the errors of the previous ones, resulting in a strong predictor that reduces bias.
  7. BART - A flexible, Bayesian approach to regression that models complex, non-linear relationships by summing multiple decision trees, providing probabilistic predictions and capturing uncertainty.

Classification Models: 
  1. K-Nearest Neighbors (k-NN): A simple, instance-based classifier that assigns a class to a new data point based on the majority class among its nearest neighbors, effective for small datasets.
  2. Logistic Regression: A linear classifier that models the probability of a binary outcome based on input features, providing interpretable coefficients that indicate feature importance.
  3. Decision Trees: A tree-based classifier that splits data into branches based on feature values, making decisions that lead to a class label, easily interpretable and capable of handling non-linear relationships.
  4. Bagging: An ensemble method that builds multiple decision trees on different random samples of the data, then aggregates their predictions to create a more stable and accurate classifier.
  5. Boosting: An ensemble technique that builds classifiers sequentially, with each focusing on correcting the errors of the previous ones, resulting in a strong classifier that reduces bias and variance.
  6. Random Forest: An ensemble method that constructs multiple decision trees on different random samples and subsets of features, then aggregates their predictions to improve accuracy and reduce overfitting.

Project Contributors: 
  Eashan Arora - Random Forest and Bagging Regessor
  
  Adithya Murali - KNN Regressor and Classifier
  
  Timmy Ren - Linear and Logistic Regression, EDA

  Ramzi Kattan - Regression Tree and Classification Tree, Boosting Regressor and Classifier, Random Forest Classifier, Bagging Classifier, and BART Regressor

Tech Stack: 
  1. Pandas - Data Wrangling, Cleaning, and Exploratory Data Analysis
  2. caret - Data Prepping, Machine Learning Model Training, and Machine Learning Model Testing
  3. tidyverse - Data Wrangling, Cleaning, and Exploratory Data Analysis
  4. BART - BART model creation
  5. GGally - Visualization
  6. rpart - Regression Tree Training and Visualization
  7. pROC - Developing ROC curves
  8. LEAPS - Linear Regression Subset Selection
  9. dplyr - Data Frame Manipulation and Transformations
  10. randomForest - Random Forest Modeling
  11. ggplot2 - Visualization
  12. kknn - K-Nearest Neighbors Modeling

