#Chad Burdyshaw
#shiny server for twitter location word cloud
library(shiny)
library(shinyIncubator)

shinyServer(function(input, output, session) {
    # Define a reactive expression for the document term matrix
    terms <- reactive({getTermMatrix(input$selection)})
    
    # Make the wordcloud drawing predictable during a session
    wordcloud_rep <- repeatable(wordcloud)
    
    output$plot <- renderPlot({
        v <- terms()
        wordcloud_rep(names(v), v, scale=c(4,0.5),
                      min.freq = input$freq, max.words=input$max,
                      colors=brewer.pal(8, "Dark2"))
    })    
    
    output$image <- renderImage({
        if (is.null(input$selection))
            return(NULL)

        if (input$selection == "eastern") {
            return(list(
                src = "easternTZtweets.png",
                contentType = "image/png",
                height = 250,
                width = 400,
                alt = "Eastern Time Zone Tweets"
            ))
        } else if (input$selection == "central") {
            return(list(
                src = "centralTZtweets.png",
                contentType = "image/jpeg",
                height = 250,
                width = 400,
                alt = "Central Time Zone Tweets"
            ))
        } else if (input$selection == "mountain") {
            return(list(
                src = "mountainTZtweets.png",
                filetype = "image/jpeg",
                height = 250,
                width = 400,
                alt = "Mountain Time Zone Tweets"
            ))
        } else if (input$selection == "pacific") {
            return(list(
                src = "pacificTZtweets.png",
                filetype = "image/jpeg",
                height = 250,
                width = 400,
                alt = "Pacific Time Zone Tweets"
            ))
        }
    }, deleteFile = FALSE)
    
    output$text1 <- renderText("This App displays a word cloud of the most frequently used words gathered from a three minute sample of Twitter feeds from the United States. For each word, font size and color are relative to frequency. 
                               The points plotted on the map indicate the physical location of the tweet. Selecting a time zone will display the tweets gathered from individuals who had registered their twitter accounts in the given time zone.
                               The points that appear outside of the selected time zone on the map show that the Twitter user is tweeting from outside their registered time zone.")
})