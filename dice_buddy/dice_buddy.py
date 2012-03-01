import math
import itertools

def combinations_with_replacement(iterable, r):
    # combinations_with_replacement('ABC', 2) --> AA AB AC BB BC CC
    pool = tuple(iterable)
    n = len(pool)
    if not n and r:
        return
    indices = [0] * r
    yield tuple(pool[i] for i in indices)
    while True:
        for i in reversed(range(r)):
            if indices[i] != n - 1:
                break
        else:
            return
        indices[i:] = [indices[i] + 1] * (r - i)
        yield tuple(pool[i] for i in indices)

def histogram( d, tup ):
    hist = [0] * (d+1) 
    for element in tup:
        hist[element] += 1
    return hist

def pairs( d, n ):
    dice = range( 1, d+1 )
    pairs_without_overlap = [0] * n
    pairs_with_overlap = [0] * n
    combinations = itertools.product( dice, repeat=n )
    counter = 0
    for tup in combinations: 
        counter += 1
        hist = histogram( d, tup ) 
        highest_match = max(hist)
        for i in range( 0, n ):
            if highest_match > i:
                pairs_with_overlap[i] += 1
                pairs_without_overlap[i] += 1

    lp = len(pairs_without_overlap) 
    for i in range( 1, lp ):
        current_val = pairs_without_overlap[ lp - i ] 
        all_values_after_that = pairs_without_overlap[ (lp - i)+1 : lp ] 
        pairs_without_overlap[ lp - i ] = current_val - sum( all_values_after_that ) 

    probabilities_with_overlap =  [ float(x) / counter for x in pairs_with_overlap ]  
    probabilities_without_overlap = [ float(x) / counter for x in pairs_without_overlap ] 
   
    print "With " + str(n) + "d" + str(d) + ", " 
    print "There are " + str(pairs_without_overlap[0]) + " different unique rolls, and... " 
    for i in range( 1, lp ):
        print "There is a " + str(math.floor( probabilities_without_overlap[i]*100 )) + "% chance of getting exactly a " + str(i+1) + "-of-a-kind" 
        print "There is a " + str(math.floor( probabilities_with_overlap[i]*100 )) + "% chance of getting at least a " + str(i+1) + "-of-a-kind" 

for i in range( 2, 12 ):
    pairs( 6, i ) 
    print " ------------------- " 
    print " " 
