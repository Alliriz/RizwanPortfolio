
# Canadian Election via Twitter Sentiment Analysis
* Produced insights on the 2019 Canadian Elections using Twitter Data
* Performed Data cleaning pandas and regular expressions
* Sorted different political parties into bins for further analysis
* Explored data via visualizaiton using ggplot, wordcloud and seaborn
* Used NLP techniques to convert text data into a machine readable format
* Implement and Optimize multiple classification algorithms such as SVM, Naive Bayes, etc.

## Code and Resources Used
Python Version: 3.7<br>
Packages: pandas, numpy, wordcloud, nltk, re, sklearn, matplotlib, seaborn, sklearn

## Data Cleaning
* Identify and convert datatypes
* Parse party out of text
* Convert sentiment to numeric
* Evaluate and transform text by removing stop words, URLs, HTMLs etc.

## Data Visualization
Some highlights from the data visualized are shown here
![Actual vs Prediction](https://github.com/Alliriz/RizwanPortfolio/blob/main/Images/Actual_Predicted.png) ![Positive Words](https://github.com/Alliriz/RizwanPortfolio/blob/main/SentimentAnalysis/Images/Poisitive%20words.png)

## Model Building
I convert the text data to machine readable form using TF-IDF and bags of word approach. <br>
Numerous models were used including SVM, Logistic Regression, XGBoost with accuracy being the performance metric. <br>
After testing the initial model, the highest accuracy was further improved by tuning the hyperparameters.

