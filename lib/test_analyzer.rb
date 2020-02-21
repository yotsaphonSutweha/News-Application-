require 'sentimentanalyzer'
x = SentimentAnalyzer.new
x.setFilePath('./word_bank/words.json')
puts x.commentSentimentAnalyzer('good')