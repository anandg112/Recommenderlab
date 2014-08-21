#loading required libraries
library(recommenderlab)
library(ggplot2)

#loading the data
data(MovieLense)
MovieLense
#The dataset contains about 100,000 ratings (1-5) from 943 users on 1664 movies

#visualizing a image sample 
image(sample(MovieLense,500),main="Raw Ratings")

#visualizing ratings
qplot(getRatings(MovieLense), binwidth =1, main="Histogram of ratings",xlab="Rating")

summary(getRatings(MovieLense))

#normalized ratings
qplot(getRatings(normalize(MovieLense, method="Z-score")), main="Histogram of normalized ratings", xlab="Rating")
summary(getRatings(normalize(MovieLense, method="Z-score")))

#no. of movies rated by an average user
qplot(rowCounts(MovieLense), binwidth=10, main="Movies rated on Average", xlab="# of users", ylab="# of movies rated")

#Mean rating of each movie
qplot(colMeans(MovieLense), binwidth=0.1, main="Mean ratings of Movies", xlab="Rating", ylab="# of movies")

recommenderRegistry$get_entries(dataType="realRatingMatrix")

scheme <- evaluationScheme(MovieLense, method="split", train=0.9, k=1, given=10, goodRating=4)

scheme

algorithms <- list(
  "random items" = list(name="RANDOM", param=list(normalize = "Z-score")),
  "popular items" = list(name="POPULAR", param=list(normalize = "Z-score")),
  "user-based CF" = list(name="UBCF", param=list(normalize = "Z-score", method="Cosine", nn=50, minRating=3)),
  "item-based CF" = list(name="IBCF2", param=list(normalize = "Z-score", method="Cosine"))
)
  # run algorithms, predict next n movies
  results <- evaluate(scheme, algorithms, n=c(1, 3, 5, 10, 15, 20))
  
  # Draw ROC curve
  plot(results, annotate = 1:4, legend="topleft")
  
  # See precision / recall
  plot(results, "prec/rec", annotate=3)