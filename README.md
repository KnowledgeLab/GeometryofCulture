Geometry of Culture
=================
Code and data associated with the ASR paper on the Geometry of Culture. The full paper can be found here: https://journals.sagepub.com/doi/full/10.1177/0003122419877135

## Data
<i>Word Embedding Models</i>
 * We provide 2 pre-trained word embedding models that are used in our analyses.<br/>
   * Google News embedding: https://www.dropbox.com/s/5m9s5326off2lcg/google_news_embedding.zip?dl=0 <br/>
   * Google Ngrams US, 2000-12: https://www.dropbox.com/s/v823bz2hbalobhs/google_us_ngrams_embedding.zip?dl=0
   * GLoVe embedding: https://nlp.stanford.edu/projects/glove/
 <br/>

<i> Google Ngrams Raw Text </i>
<br/>
 * For our historical analyses and contemporary validation, we train embedding models on the full Google Ngrams US corpus for particular time periods. The Google Ngrams US corpus is publicly available for download and is hosted here: 
 <br/>

 <i> Survey of Cultural Associations </i>
 <br/>
 * We also provide results from the Mechanical Turk survey of cultural associations. Data files include mean associations on race, class, and gender dimensions for 59 terms. We provide files with and without poststratification weights. These files are hosted here on github in the "Survey of Cultural Associations" directory. Details of the survey can be found in Appendix A of the article.
<br/>

## Code
 * We provide scripts to assist in training embeddings and building "cultural dimensions" according to the method described in the paper. Scripts for complete replication are forthcoming.
    * w2v_train_model.py trains embedding model on raw text. It is specifically set up to read 5grams, but could be slightly adjusted to read in sentences of natural language.
    * build_cultural_dimensions.R loads in the pretrained models available above, builds cultural dimensions from the antonym pairs provided in the attached csv files, and validates correspondence between survey estimates and embedding projections.
  
