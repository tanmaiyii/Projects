import nltk
from nltk.corpus import treebank

# here we load in the sentences
sentence22 = treebank.parsed_sents('wsj_0003.mrg')[21]
sentence7 = treebank.parsed_sents('wsj_0003.mrg')[6]
sentence13 = treebank.parsed_sents('wsj_0004.mrg')[12]

# Q3 - sentence tree and rules
sentence22.draw()
sentence22.productions()

sentence7.draw()
sentence7.productions()

sentence13.draw()
sentence13.productions()

# here we define a grammar
grammar = nltk.CFG.fromstring("""
S -> NP VP
NP -> Det N | 'NLP' | 'I'
VP -> V NP
Det -> 'the'
N -> 'students' | 'subject'
V -> 'like' | 'love'
""")

# Q3 - sentence 22 tree and rules
sentence22.draw()
sentence22.productions()


#4b
grammar = nltk.CFG.fromstring("""
S -> NP VP
S -> Aux NP VP
S -> VP
S -> IVP
NP -> Pronoun
NP -> Proper-Noun
NP -> Det Nominal
Nominal -> N
Nominal -> Nominal N
Nominal -> Nominal PP
VP -> V
VP -> V NP
VP -> V NP PP
VP -> V PP
VP -> VP PP
PP -> Preposition NP
IVP -> IVerb NP NP
IVP -> IVerb NP NP PP
IVerb -> 'list'
Det -> 'the'
N -> 'seats'|'flight'| 'list'
V -> 'list'
Pronoun -> 'me'
Proper-Noun -> 'Denver'
Aux -> 'does'
Preposition -> 'on' | 'to'
""")

#4c
grammar = nltk.CFG.fromstring("""
S -> NP VP
S -> Aux NP VP
S -> VP
S -> IVP
NP -> Pronoun
NP -> Proper-Noun
NP -> Det Nominal
Nominal -> N
Nominal -> Nominal N
Nominal -> Nominal PP
VP -> V
VP -> V NP
VP -> V NP PP
VP -> V PP
VP -> VP PP
PP -> Preposition NP
IVP -> IVerb NP NP
IVP -> IVerb NP NP PP
IVerb -> 'list'
Det -> 'the'
N -> 'seats'|'flight'| 'list'
V -> 'list'
Pronoun -> 'me'
Proper-Noun -> 'Denver'
Aux -> 'does'
Preposition -> 'on' | 'to'
NP -> NP PP
""")

# here we let nltk construct a chart parser from our grammar
parser = nltk.ChartParser(grammar)

# input: a list of words
# returns all the parses of a sentence
def allParses(sentenceList):
	return parser.parse(sentenceList)

# input: a list of parse trees
# prints all the parse trees
def printParses(parses):
	for tree in parses:
		print(tree)

# input: a sentence as a string or as a list of words
# prints a sentence, then parses it and prints all the parse trees
def processSentence(sentence):
	sentenceList = sentence
	if isinstance(sentence,str):
		sentenceList = sentence.split(' ')
	print 'Original sentence: ' + ' '.join(sentenceList)
	printParses(allParses(sentenceList))

def mainScript():
    processSentence('I like NLP')
    processSentence('the students love the subject')
    processSentence('list me the seats on the flight to Denver') # question 4 

    # processSentence('list me the seats on the flight to Denver') ## uncomment to run the function