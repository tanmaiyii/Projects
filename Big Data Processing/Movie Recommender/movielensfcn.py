def removeDuplicates((userid, ratings)): #movies the user has rated 
    (item1, value1) = ratings[0]
    (item2, value2) = ratings[1]
    return item1 < item2

def itemItem((item,values)):
    (itemA, valueA) = values[0]
    (itemB, valueB) = values[1]
    return ((itemA, itemB), (valueA, valueB))