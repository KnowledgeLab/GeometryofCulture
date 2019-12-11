##year_1 and year_2 comprise the time period of ngrams to read##
year_1=2000
year_2=2012

import numpy
import scipy
import cython
import gensim
from gensim import models, similarities
import logging
import os
import re
import sys  
import itertools
import math

#reload(sys)  
#sys.setdefaultencoding('utf8')
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.INFO)

class MySentences(object):
    def __init__(self, dirname, start_year, end_year, limit=None):
        self.dirname = dirname
        self.start_year = start_year
        self.end_year = end_year
        self.limit = limit
 
    def __iter__(self):
         # iterate through each the compressed file directory
        for fname in os.listdir(self.dirname):
            # for each compressed file open it
            with gensim.utils.smart_open(os.path.join(self.dirname, fname)) as fin:
                for line in itertools.islice(fin, self.limit):
                    line = gensim.utils.to_unicode(line).split("\t")
                    if len(line)<3:
                        continue
                    ngram = line[0]
                    try:
                        year = int(line[1])
                    except ValueError:
                        continue
                    match_count = int(line[2])
                    if year < self.start_year or year > self.end_year:
                        continue
                    # lower case the ngram, remove pos
                    processed_ngram = [word.split("_")[0] for word in ngram.lower().split()]
                    for x in range(match_count):
                        yield processed_ngram

assert gensim.models.word2vec.FAST_VERSION > -1
##Reads ngrams one-by-one into word2vec##
sentences = MySentences("/dir_name_here/", year_1, year_2) # a memory-friendly iterator

###Set parameters. Details here: https://radimrehurek.com/gensim/models/word2vec.html###
model = gensim.models.word2vec.Word2Vec(sentences,sg=1, size=300, window=5, min_count=10, workers=10, hs=0, negative=8)
model.save('w2vmodel_ng5_'+str(year_1)+'_'+str(year_2)+'_full')
syn0_object=model.wv.syn0

##output vector space##
numpy.savetxt('syn0_ngf_'+str(year_1)+'_'+str(year_2)+'_full.txt',syn0_object,delimiter=" ")

#output vocab list#
vocab_list = model.wv.index2word
for i in range(0,len(vocab_list)):
	if vocab_list[i] == '':
		vocab_list[i] = "thisisanemptytoken"+str(i)

with open('vocab_list_ngf_'+str(year_1)+'_'+str(year_2)+'_full.txt','wb') as outfile:
    for i in range(0,len(vocab_list)):
        outfile.write(vocab_list[i].encode('utf8')+"\n".encode('ascii'))
