'''
Module for testing newspaper functionality
'''
import newspaper
from newspaper import Article
from newspaper import Config

def processSite(siteURL):
    
    site = newspaper.build(siteURL)
    print "ARTICLES"
    for article in site.articles:
        print article.url        
    print    
    
    print "CATEGORIES"
    for category in site.category_urls():
        print category
    print
    
def processArticle(articleURL):
    article = Article(url=articleURL)
    article.download()
    article.parse()
    print "TITLE: " + article.title
    print "AUTHORS: " + article.text
    print "SUMMARY: " + article.summary
    print "TEXT: " + article.text
    print "TAGS:"    
    print article.tags
    print "KEYWORDS:"    
    print article.keywords
    
    
    #processArticle("http://edition.cnn.com/video/data/2.0/video/world/2014/07/28/pkg-sidner-gaza-un-school-strike.cnn.html")
    #processArticle("http://www.theguardian.com/environment/2014/jul/28/bee-research-funding-pesticides-mps")
    #processArticle("http://www.indystar.com/story/news/local/hamilton-county/2014/07/27/carmel-couple-die-apparent-murder-suicide/13255503/")
    #processArticle("http://www.tristate-media.com/pdclarion/article_3793b120-12ed-11e4-9c26-001a4bcf887a.html")
    