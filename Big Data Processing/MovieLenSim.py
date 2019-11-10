!/usr/bin/python

import findspark
findspark.init()

from pyspark import SparkConf, SparkContext, sql
import sys
import re
import random
from math import sqrt
from movielensfcn import removeDuplicates, itemItem

sc = SparkContext(appName = "MovieLens").getOrCreate()
sqlContext = sql.SQLContext(sc)

sc.addPyFile("movielensfcn.py")

#from similarity import cosine_similarity, pearson_similarity

if __name__=="__main__":
    if len(sys.argv)< 8:
        print >> sys.stderr, "Usage: MovieLens ratings movies"
	print >> sys.stderr,"Usage: programname ratings_file, movies_file, movie_id, threshold, topN, minOccurence, algorithm"
	print >> sys.stderr, "spark-submit MovieLensFinal.py /data/movie-ratings/ratings.dat /data/movie-ratings/movies.dat  1 .95 50 100 COSINE"
        exit(-1)
    ratings_file = sys.argv[1]
    movies_file = sys.argv[2]
    if len(sys.argv)>6:
        movie_id = int(sys.argv[3])
        threshold = float(sys.argv[4]) #set to 0.97 when COSINE, 0.5 when ADJCOSINE
        topN= int(sys.argv[5])
        minOccurence = int(sys.argv[6])
        algorithm = sys.argv[7].upper()

print '{0}, {1}, {2}, {3}, {4} {5} {6}'.format(ratings_file, movies_file, movie_id, threshold, topN, minOccurence, algorithm)

def pearson_similarity(ratingPairs):

    numPairs = 0
    sum_xx = sum_yy = sum_xy = sum_x = sum_y = 0

    for ratingX, ratingY in ratingPairs:
        sum_xx += ratingX * ratingX
        sum_yy += ratingY * ratingY
        sum_xy += ratingX * ratingY
        sum_x += ratingX
        sum_y += ratingY
        numPairs += 1
    numerator = (sum_xy * numPairs) - (sum_x * sum_y)
    denominator = sqrt((sum_xx * numPairs) - (sum_x**2)) * sqrt((sum_yy * numPairs) - (sum_y**2))
    score = 0
    if (denominator):
        score = (numerator / (float(denominator)))
    return (score, numPairs)
    
def cosine_similarity(ratingPairs):

    numPairs = 0
    sum_xx = sum_yy = sum_xy = 0

    for ratingX, ratingY in ratingPairs:

        sum_xx += ratingX * ratingX
        sum_yy += ratingY * ratingY
        sum_xy += ratingX * ratingY
        numPairs += 1

    numerator = sum_xy
    denominator = sqrt(sum_xx) * sqrt(sum_yy)

    score = 0
    if (denominator):
        score = ((float(numerator)) / (float(denominator)))

    return (score, numPairs)

ratings_data = sc.textFile(ratings_file)
movies_data = sc.textFile(movies_file)


numPartitions = 1000
if (ratings_file.find('.dat') !=-1):
	print "dat file"
	movies= movies_data.map(lambda line: re.split(r'::',line)).map(lambda x: (int(x[0]),(x[1],x[2])))
	ratings = ratings_data.map(lambda line: re.split(r'::',line)).map(lambda x: (int(x[0]),(int(x[1]),float(x[2])))).partitionBy(numPartitions)
	user_ratings_data = ratings.join(ratings)
	unique_joined_ratings = user_ratings_data.filter(removeDuplicates)
	movie_pairs = unique_joined_ratings.map(itemItem).partitionBy(numPartitions)
else:
	print "csv file"
	ratings_header = ratings_data.take(1)[0]
	movies_header = movies_data.take(1)[0]
	movies= movies_data.filter(lambda line: line!=movies_header).map(lambda line: re.split(r',',line)).map(lambda x: (int(x[0]),(x[1],x[2])))
	ratings = ratings_data.filter(lambda line: line!=ratings_header).map(lambda line: re.split(r',',line)).map(lambda x: (int(x[0]),(int(x[1]),float(x[2])))).partitionBy(numPartitions)
	user_ratings_data = ratings.join(ratings)
	unique_joined_ratings = user_ratings_data.filter(removeDuplicates)
	movie_pairs = unique_joined_ratings.map(itemItem).partitionBy(numPartitions)


movie_pairs_ratings= movie_pairs.groupByKey()

if algorithm == "PEARSON" :
	item_item_similarities = movie_pairs_ratings.mapValues(pearson_similarity).persist()
elif algorithm == "COSINE" :
	item_item_similarities = movie_pairs_ratings.mapValues(cosine_similarity).persist()
else:
	item_item_similarities = movie_pairs_ratings.mapValues(cosine_similarity).persist()


item_item_sorted=item_item_similarities.sortByKey()

#item_item_sorted.saveAsTextFile("movie-similar0001")
# Sample output
#((1, 2), (0.9633070604343126, 71))
#((1, 3), (0.9269097345177958, 39))
#((1, 4), (0.932135764636765, 7))

item_item_sorted.persist()

# Filter for movies with this sim that are "good" as defined by
# our quality thresholds above
filteredResults = item_item_sorted.filter(lambda((item_pair,similarity_occurence)): \
        (item_pair[0] == movie_id or item_pair[1] == movie_id) \
        and similarity_occurence[0] > threshold and similarity_occurence[1] > minOccurence)

if (topN==0):
    topN=10

results = filteredResults.map(lambda((x,y)): (y,x)).sortByKey(ascending = False)
#resultsTopN = results.take(topN)
resultsTopN = sc.parallelize(results.take(topN))
#results.saveAsTextFile("top10test100")

resultsKey = resultsTopN.map(lambda((x,y)): (y[1],x[0])) #y[0]- recommended movieid made as key so we can join it, x[0]- simialarity 


topMoviesJoin = resultsKey.join(movies) 

#sample output: (3114, (0.9870973879980668, (u'Toy Story (1995)', u'Adventure|Animation|Children|Comedy|Fantasy')))

#now want to order it again by the sim score since it has shuffled
top_N_Movies = topMoviesJoin.map(lambda (x,y): (y[0],(x,y[1][0].encode('ascii', 'ignore')))).sortByKey(ascending = False)

# sample output: (0.9870973879980668, (3114, 'Toy Story 2 (1999)'))
top_N_Movies.saveAsTextFile("movie-sim")



top_N_Movies_Sorted = top_N_Movies.map(lambda (x,y): (y[1],y[0],x)).repartition(1)

top_N_Movies_Sorted.saveAsTextFile("TOP10")

#to get the string of the movie we want to recommend for  
film_in_q = resultsTopN.map(lambda((x,y)): (y[0],x[0]))

focus_join= film_in_q.join(movies)

one_movie = focus_join.map(lambda (x,y): (y[1][0].encode('ascii', 'ignore'))).take(1)


print("For movie:" + str(one_movie) + ", the top10 recommended films are:")
top_N_DF = sqlContext.createDataFrame(top_N_Movies_Sorted, ["Top 10 Recommended Movies(Year)","Movie ID","Similarity"])

top_N_DF.show()
#top_N_DF.saveAsTable("MOVIES")
	
sc.stop()
