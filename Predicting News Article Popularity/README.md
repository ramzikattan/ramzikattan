Project Description: 
  Our team ran an in-depth analysis on a dataset that chronicled articles published by Mashable over a period of two years. This dataset utilized over fifty different features to predict the number of times each article would get shared via social networks as an indicator of popularity and word-of-mouth buzz. Our question was this: what aspects of an article or blog piece, both within and surrounding its release, are the most important in determining its popularity? With an answer to this question, we could potentially help small businesses that are having difficulties reaching larger audiences selectively craft eye-catching articles that will increase attraction and attention to their services, getting people talking about what they have to offer. Small businesses offer so much to their communities, but it can be hard for them to get off the ground. Depending on our findings, we could help such ventures get more people invested and involved.

Machine Learning Models Deployed: 
  1. K-Nearest Neighbors - A simple non-computationally exhaustive model that predicts the number of shares of an article as the average number of shares of similar articles. Cross-Validation with minimum RMSE as optimizer was used to select k. 
  2. Linear Regression - A widely used model that is non-computationally exhaustive and provides the added bonus of interpretable relationships between the dependent variables and the number of shares.
  3. Lasso Regression - A version of linear regression that subsets the dependent variables by driving non-important variables to zero, further establishing the most important variables to predict number of shares and their effects. Value of alpha was found through cross validation.
  4. Regression Tree - An easy to visualize predictor that can incorporate non-linear relationships between variables while still providing insights into feature importance.
  5. Random Forest Regessor - An easy to use ensemble method that balances the bias-variance tradeoff well by using the predictions of multiple decision trees all built on a different, randomly selected subset of the dependent variables.
  6. Neural Network - A model that uses a wide selection of randomly selected parameters in linear models to make a prediction, this allows for the capture of complex non-linear relationships with less of a risk of overfitting. The model uses the Adaptive Moment Estimation (AdaM) gradient descent method to reach minimum loss values quickly by incorporating previous loss characteristics in future calculations.
  7. Naive Bayes - A strong classifier model that uses Bayes' theorem with a strong (naive) independence assumption. Stratified K fold was used to ensure each fold accurately represented the characteristics of the whole data set, with the goal of increased accuracy. 

Project Contributors: 
  Siboney Cardoso
  Adithya Murali
  Andrew White
  Carissa Ing

Tech Stack: 
  Pandas - Data Wrangling, Cleaning, and Exploratory Data Analysis
  Seaborn - Visualizations
  Ski-Kit Learn - Data Prepping, Machine Learning Model Training, and Machine Learning Model Testing
  PyTorch - Neural Network Data Prepping, Neural Network Training, and Neural Network Testing
  Numpy - Array Operations
  Patsy - Design Matrices 


  
