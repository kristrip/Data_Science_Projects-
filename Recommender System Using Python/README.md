# Recommendation Systems

A recommender system, or a recommendation system,
is a subclass of information filtering system that seeks to predict the “rating” or “preference” a user would give to an item.
They are primarily used in commercial applications.

Examples of such applications include recommending products on Amazon, music on Spotify, and of course, stories on Medium.
The famous The Netflix Prize is also a competition in the context of recommendation systems.

More formally, the recommender problem can be interpreted as determining the mapping (c, i) → R where c denotes a user, i denotes an item, and R is the utility of the user being recommended with the item. Items are then sorted by utility and top N items are presented to user as recommendation.

The abstract concept of utility can sometimes be measured by the user’s action followed, such as purchase of the item, click of “not interested” or “not show again”, etc.

Ranking vs. Recommendation
People sometimes confuse between ranking (or search ranking) system and recommender system, and some may even think they are interchangeable. While both algorithms are trying to present items in a sorted way, there are some key differences between these two:

Ranking algorithms rely on search query provided by users, who know what they are looking for. Recommender systems, on the other hand, without any explicit inputs from users, aim to discovering things they might not have found otherwise.
Ranking algorithms normally put more relevant items closer to the top of the showing list whereas recommender systems sometimes try to avoid overspecialization. A good recommender system should not recommend items that are too similar to what users have seen before, and should diversify its recommendations.
Recommender systems put more emphasize on personalization, and hence, are more exposed to data sparsity.


## Types of Recommender Systems
Recommender systems are typically classified into the following categories:

1.Content-based filtering
2.Collaborative filtering
3.Hybrid systems
Depending on whether a model is learned from the underlying data, recommender systems can also be divided into:

Memory-based
Model-base
Content-base Filtering
Content-based filtering methods are based on featuralization of items (as oppose to users) and a profile of a user’s utility. It is best suited to problem with known data on items (e.g., leading actors, year of release, genre for movies) and how the user historically interact with the recommender system, but lack of the user’s personal information. Content-based recommenders is essentially a user-specific learning problem to quantify the user’s utility (likes and dislikes, rating, etc.) based on item features.

More formally, the utility u(c, i) of item i for user c is estimated based on the utilities assigned by the same user c to other items seen before.

Let’s assume ωᵢ is the feature vector for item i and ωᵥ is the profile vector for user v. A user profile can be interpreted as a summary of the user’s utility on all the items seen before.

Memory-base Example
Let’s use a rating system as an example, one way to model the user profile vector is through the rating-weighted average, i.e.,


Then the utility u(c, i) becomes


Utility function is usually represented in the information retrieval literature by the cosine similarity measure


where K is the dimension of item and user profile vector.

Model-base Example
Naive Bayesian classifier has been widely used as a model-based approach for recommender systems.

Let’s use a video recommender system as an example, and a user’s utility is measured by whether a recommended video is clicked by the user. More formally, this recommendation problem can be modeled as estimating the probability of click (or click-through-rate in some literature), i.e.,


By Bayes’ theorem,
By chain rule,


from Wikipedia
Now, with the help of “naive” conditional independence assumption, we have


Here α is a normalization parameter to ensure the resulted probability reside within [0, 1]. This is, however, not necessary for some recommender systems where we only care about the relative ranking among all items.

Limitation
Data sparsity, memory-based or model-based, they both leverage a user’s historical interaction with the recommender systems. So for inactive users, recommendations may be very inaccurate.
New user, which is an extreme case of inactive user, and hence, make content-based filtering approach not applicable.
Collaborative filtering methods address the above limitations by leveraging cross-user information.

Collaborative Filtering
Collaborative filtering is best suited to problem with known data on users (age, gender, occupation, etc), but lack of data for items or difficult to do feature extraction for items of interest.

Unlike content-based approach, collaborative recommender systems try to predict a user’s utility for an item based on other users’ previous utility with the item.

Memory-base Example
Reusing the rating system example, memory-based methods essentially are heuristics that predicts a user’s rating for an item based on the collection of rating for the item from other users, i.e.,


where C is the user set excluding the user c of interest.

Several realization of the aggregation function are


(1) is simply an average rating for the item from all other users. (2) is trying to weight other users’ ratings by how close they are close to user c, and one way to measure that is the similarity function between two users’ feature vector (age, gender, location, occupation, etc.). (3) is to address the issue that users may have different rating scale for what they mean “like”, for example, some users may be more generous to give a top rating for the item they like.

Model-base Example
Similar to model-based content-based filtering, model-based collaborative filtering use historical data (from other users) to learn a model. For the rating example, a model-based way is to build a linear regression model with user profile as features and rating as target for each item separately.

Limitation
Similar to the limitation of content-based approach, collaborative filtering methods are also subject to some constraints listed below

Data sparsity, for less popular items with few ratings, it is difficult for the collaborative algorithm to make accurate predictions.
New item, which is an extreme case of less popular items, and hence, make collaborative filtering approach not applicable.
Hybrid Methods
Given the limitation of both content-based and collaborative methods, and they both address some limitations from the other, it is natural to consider combining these two methods together, which leads to the Hybrid method. The way to combine include:

Implement content-based and collaborative methods separately and combine their predictions. This is essentially a model ensemble approach.
Incorporate content-based characteristics into a collaborative method. One way to do this is to leverage user profile to measure similarity between two users, and use this similarity as weight during the aggregation step of collaborative approach.
Incorporate collaborative characteristics into a content-based method. One way to do this is to apply dimension reduction techniques on a group of user profiles, and present this as a collaborative-version profile for the user of interest.
A cross-user and cross-item model. This is to build a model with both item features and user features as inputs, such as linear regression model, tree model, neural network model, etc.
