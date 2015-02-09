#Chad Burdyshaw
#Globally defined variables and functions for Twitter location wordcloud
library(tm)
library(wordcloud)
library(memoise)

# The list of valid time zones
regions <<- list("Eastern Time Zone US"  = "eastern",
                 "Central Time Zone US"  = "central",
                 "Mountain Time Zone US" = "mountain",
                 "Pacific Time Zone US"  = "pacific")

#custom word removal function
myremove <- function(x, ...) {gsub("&amp|http.*|[#@íâ€½¼¾‰´¸‚]*","",x, perl=TRUE)}

# Using "memoise" to automatically cache the results
getTermMatrix <- memoise(function(region) {
    # Careful not to let just any name slip in here; a
    # malicious user could manipulate this value.
    if (!(region %in% regions)) stop("Unknown time zone")
    
    text <- readLines(sprintf("./%s.txt", region), encoding="UTF-8")
    myCorpus = Corpus(VectorSource(text))
    myCorpus = tm_map(myCorpus, tolower)
    myCorpus = tm_map(myCorpus, removePunctuation)
    myCorpus = tm_map(myCorpus, removeNumbers)
    additionalStopWords=c("the", "but","í","amp")
    myCorpus = tm_map(myCorpus, removeWords, c(stopwords("SMART"),additionalStopWords))
    myCorpus = tm_map(myCorpus, myremove)    
    myDTM = TermDocumentMatrix(myCorpus, control = list(minWordLength = 1))
    m = as.matrix(myDTM)
    sort(rowSums(m), decreasing = TRUE)
})