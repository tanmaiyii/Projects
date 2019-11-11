import nltk
from nltk import tree
from nltk import Nonterminal, induce_pcfg
from nltk.draw.tree import TreeView

def loadData(path):
	with open(path,'r') as f:
		data = f.read().split('\n')
	return data

def getTreeData(data):
	return map(lambda s: tree.Tree.fromstring(s), data)

# Main script

print ("loading data..")
data = loadData('parseTrees.txt')
print ("generating trees..")
treeData = getTreeData(data)
print ("done")
rules = list()
print ("compiling the rules")
for t in treeData:
    rules.extend(t.productions())
print("Number of rules: " + str(len(rules)))
print ("computing PCFG")
S = Nonterminal('S')
grammar = induce_pcfg(S, rules)
print ("PCFG:")
print(grammar)

sentence = "show me the meals on the flight from Phoenix".split()
print ("parsing with InsideChart parser...")
inside_parser = nltk.InsideChartParser(grammar)
inside_parser.trace(3)
for tree in inside_parser.parse(sentence):
    print(tree)
    tree.draw()
print ("done!")