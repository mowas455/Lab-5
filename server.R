dataSet = read.csv("APIResponse.csv")
colnames(dataSet)

dataSet$LeadSponsorClass = as.factor(dataSet$LeadSponsorClass)
levels(dataSet$LeadSponsorClass)[levels(dataSet$LeadSponsorClass) == "OTHER"] = "Academic"

dataSet$OverallStatus = as.factor(dataSet$OverallStatus)
levels(dataSet$OverallStatus)[levels(dataSet$OverallStatus) == ""] = "Others"

x=as.vector(dataSet$InterventionName)
split_func <- function(x)strsplit(as.character(x), "|", fixed = T)  
sample<-split_func(x)
library(tm)
library(SnowballC)
library(wordcloud)



sample_corpus<-VCorpus(VectorSource(sample))
inspect(sample_corpus[1:2])
sample_c_corpus<-tm_map(sample_corpus,content_transformer(tolower))
sample_c_corpus<-tm_map(sample_c_corpus,removeNumbers)
sample_c_corpus<-tm_map(sample_c_corpus,removePunctuation)
sample_c_corpus<-tm_map(sample_c_corpus,stripWhitespace)
sample_c_corpus<-tm_map(sample_c_corpus,removeWords,stopwords())
sample_c_corpus<-tm_map(sample_c_corpus,stemDocument)
inspect(sample_c_corpus[1:2])
sample_c_corpus<-tm_map(sample_c_corpus, PlainTextDocument) 


myDTM = TermDocumentMatrix(sample_c_corpus)
m = as.matrix(myDTM)
word_freqs = sort(rowSums(m), decreasing=TRUE)
dm = data.frame(word=names(word_freqs), freq=word_freqs)


library(shiny)
library(ggplot2)
server <- function(input,output,session){
  columns = colnames(dataSet)
  
  
  output$barplot1 <- renderPlot(
    barplot(table(dataSet[,input$variable]))
  )
  output$barplot2 <- renderPlot(
    ggplot(data = dataSet,aes(x=OverallStatus,fill=OverallStatus),width=20)+geom_bar()+labs(x = "Over All Status", y = "Number of Trials")
  )
  
  #word cloud
  wordcloud_rep <- repeatable(wordcloud)
  output$plot <- renderPlot({
    wordcloud_rep(dm$word, dm$freq, random.order=FALSE , 
                  max.words=600,
                  colors=brewer.pal(5, "Dark2"))
  })
}

