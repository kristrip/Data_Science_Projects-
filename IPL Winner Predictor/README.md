# **IPL WIN PREDICTOR OVER BY OVER**



Step 1 — Understanding the dataset!
While dealing with data, Kaggle: Your Home for Data Science is the to-go platform. I used the dataset https://www.kaggle.com/nowke9/ipldata. The dataset has 2 files: matches.csv having every match detail from 2008 to 2019 and deliveries.csv having ball by ball detail for every match


Step 2 — Getting the data into the playground and cleaning it!
I am using .read_csv() to read the CSV file. The path in the .read_csv() function can be relative or absolute. Here, I am using Jupyter Notebook as my playground and hence the file is stored there.

Step 3 — Further preprocessing the data
While playing around with the data, I found an interesting redundancy. Team Rising Pune SuperGiants were duplicated in columns team_1, team_2, winner, and toss_winner


Step 4 — Feature Engineering
columns taken into consideration are: team_1, team_2,total_runs, city and winner.

For the columns to be able to assist the model in the prediction, the values should make some sense to the computers. Since they (still) don’t have the ability to understand and draw inference from the text, we need to encode the strings to numeric categorical values. While we may choose to do the process manually, the Scikit-learn library gives us an option to use LabelEncoder.


Before we hop on to building models, an important observation has to be acknowledged. Columns like toss_winner, toss_decision, and winner might make sense to us, but what about the machines?



Step 5 — Building, Training & Testing the Model
For a Classification problem, multiple algorithms can train the classifier according to the data we have and using the pattern, predict the outcomes of certain input conditions. We will try DecisionTreeClassifier, RandomForestClassifier, LogisticRegression choose the algorithm best suited for our data distribution.

Once we build the model, we need to validate that model using values that are never exposed to the model. Hence we split our data using train_test_split, a class provided by Scikit-learn into 2 parts having a distribution of 80–20. The model is trained on 80% of data and validated against the other 20% of the data.



# Random Forest
A big part of machine learning is classification — we want to know what class (a.k.a. group) an observation belongs to. The ability to precisely classify observations is extremely valuable for various business applications like predicting whether a particular user will buy a product or forecasting whether a given loan will default or not.

Data science provides a plethora of classification algorithms such as logistic regression, support vector machine, naive Bayes classifier, and decision trees. But near the top of the classifier hierarchy is the random forest classifier (there is also the random forest regressor but that is a topic for another day).

In this post, we will examine how basic decision trees work, how individual decisions trees are combined to make a random forest, and ultimately discover why random forests are so good at what they do.

Decision Trees
Let’s quickly go over decision trees as they are the building blocks of the random forest model. Fortunately, they are pretty intuitive. I’d be willing to bet that most people have used a decision tree, knowingly or not, at some point in their lives.


Simple Decision Tree Example
It’s probably much easier to understand how a decision tree works through an example.

Imagine that our dataset consists of the numbers at the top of the figure to the left. We have two 1s and five 0s (1s and 0s are our classes) and desire to separate the classes using their features. The features are color (red vs. blue) and whether the observation is underlined or not. So how can we do this?

Color seems like a pretty obvious feature to split by as all but one of the 0s are blue. So we can use the question, “Is it red?” to split our first node. You can think of a node in a tree as the point where the path splits into two — observations that meet the criteria go down the Yes branch and ones that don’t go down the No branch.

The No branch (the blues) is all 0s now so we are done there, but our Yes branch can still be split further. Now we can use the second feature and ask, “Is it underlined?” to make a second split.

The two 1s that are underlined go down the Yes subbranch and the 0 that is not underlined goes down the right subbranch and we are all done. Our decision tree was able to use the two features to split up the data perfectly. Victory!

Obviously in real life our data will not be this clean but the logic that a decision tree employs remains the same. At each node, it will ask —

What feature will allow me to split the observations at hand in a way that the resulting groups are as different from each other as possible (and the members of each resulting subgroup are as similar to each other as possible)?

The Random Forest Classifier
Random forest, like its name implies, consists of a large number of individual decision trees that operate as an ensemble. Each individual tree in the random forest spits out a class prediction and the class with the most votes becomes our model’s prediction (see figure below).


Visualization of a Random Forest Model Making a Prediction
The fundamental concept behind random forest is a simple but powerful one — the wisdom of crowds. In data science speak, the reason that the random forest model works so well is:

A large number of relatively uncorrelated models (trees) operating as a committee will outperform any of the individual constituent models.

The low correlation between models is the key. Just like how investments with low correlations (like stocks and bonds) come together to form a portfolio that is greater than the sum of its parts, uncorrelated models can produce ensemble predictions that are more accurate than any of the individual predictions




# Logistic regression


Logistic regression is another powerful supervised ML algorithm used for binary classification problems (when target is categorical). The best way to think about logistic regression is that it is a linear regression but for classification problems. Logistic regression essentially uses a logistic function defined below to model a binary output variable (Tolles & Meurer, 2016). The primary difference between linear regression and logistic regression is that logistic regression's range is bounded between 0 and 1. In addition, as opposed to linear regression, logistic regression does not require a linear relationship between inputs and output variables. This is due to applying a nonlinear log transformation to the odds ratio (will be defined shortly).


In the logistic function equation, x is the input variable. Let's feed in values −20 to 20 into the logistic function the inputs have been transferred to between 0 and 1.

As opposed to linear regression where MSE or RMSE is used as the loss function, logistic regression uses a loss function referred to as “maximum likelihood estimation (MLE)” which is a conditional probability. If the probability is greater than 0.5, the predictions will be classified as class 0. Otherwise, class 1 will be assigned. Before going through logistic regression derivation, let's first define the logit function. Logit function is defined as the natural log of the odds. A probability of 0.5 corresponds to a logit of 0, probabilities smaller than 0.5 correspond to negative logit values, and probabilities greater than 0.5 correspond to positive logit values., logistic function ranges between 0 and 1 (P∈[0,1]) while logit function can be any real number from minus infinity to positive infinity (P∈[−∞, ∞]).
