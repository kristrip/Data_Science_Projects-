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
