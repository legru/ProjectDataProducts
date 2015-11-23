require(rCharts)
require(rMaps)
require(shiny)

shinyUI(fluidPage(
  titlePanel("Where are the Syrian refugees?"),
  
  
  tabsetPanel(
    tabPanel("Issue", 
             fluidRow(
               column(1,
                      p("")),
               column(7, 
                      
                      h4("The war in Syria is  producing an immense humanitaria  catastrophy. "),
                      h4("Millions of people are displaced from their homes."),
                      h4("Images  coming from the EU borders give the  impression  of  a huge  amount  
                         of people moving desperatly towrds  Europe"),
                      
                      #  PUT A LINK  OR A  PICTURE  HERE
                      
                      h4("It is a moral  imperative  to  host  the Syrian  refugees"),
                      h4("But many still  wonder: Why  are they  coming  here?"),
                      h4("Can somebody else host them?"),
                      h4("In this  simple project I want  to look  at  data  and find  some answers to these questioins"),
                      
                      h2("Questions that will be addressed"),
                      
                      h4("Where are the Syrian refugess really?"),
                      h4("How many  of them  come to  Europe?"),
                      h4("Whow many  of them do  go to  Arab countries?"),
                      
                      h2("Data"),
                      h4("Although the analysis presented here is quite simplistic, the data was downloaded
                         from unhcr.org which is the web site of UNHCR: the UN Refugees Agency")),
               
               column(3,
                      img(src = "picture.jpg",height = 400))
             )
    ), 
    tabPanel("Analysis",
             fluidRow(
               column(1,p(" ")),
               column(9,
                      h2("Where are the Syrian Refugees"),
                      h4("The histagram below shows the Syrian refugee at the end of 2014 which is the 
                         latest date in which refugee data is avaiable."),
                      h4(" Specifically it shows two important types of information related to Syrian Refuges"),
                      h4("The first type of information is their status: whether they are refugees, or they are 
                  asking for asylum in the hosting country"),
                      h4("The second type of information is area in which they are hosted.  For semplicity of 
                  analysis I compare only 6 areas:"),
                      h4("1. Syria"),
                      h4("2, Syria Neighboring Countries"), 
                      h4("3. Rest of Middle East (as defined on Wikipedia)"),
                      h4("4. North Africa"), 
                      h4("5. Europe (including Russia"),
                      h4("6. Rest of the World"),
                      br(),
                      h4("By selecting and deselecting the different options it is possible to have a different view
                  on the data"))),
             
             fluidRow(
               column(1,p(" ")),
               column(9,
                      h2("An analysis  the location of Syrian Refugees at the end of 2014"))),
             fluidRow(
               column(1,p(" ")),
               fluidRow(
                 column(3, 
                        wellPanel(
                          checkboxGroupInput("hgrm1", 
                                             label = h3("Select data to display"), 
                                             choices = list("Refugees" = 1, 
                                                            "Asylum Seekers" = 2, 
                                                            "Internally displaced" = 3,
                                                            "Total Population"= 4),
                                             selected = c(1,2,3,4)),
                          
                          checkboxGroupInput("area", 
                                             label = h3("Select Region to display"), 
                                             choices = list("Syria"= "Syria",
                                                            "Syria Neighbors"= "Syria Neighbors", 
                                                            "Rest of Middle East"= "Rest of Middle East",
                                                            "North Africa" = "North Africa", 
                                                            "Europe" = "Europe",
                                                            "Rest of the World"= "Rest of the World"),
                                             selected = c(
                                               "Syria", "Syria Neighbors", "Rest of Middle East", 
                                               "North Africa", "Europe", "Rest of the World"
                                             )))),
                 column(6,
                        mainPanel(showOutput("Refugees", "Highcharts")))),
               
               fluidRow(
                 column(1,p(" ")),
                 column(9,
                        h4("The histogram shows two important things:"),
                        h4("1. By a large marging the great majority of refugees are either still 
                  in the country (internally displaced) or in neighboring countries"),
                        h4("2. Quite surprisingly the great majority of the asylum requests happens in Europe, even though Europe 
                  has a smaller number of refugees")))
             ),
             
             fluidRow(
               column(1,p(" ")),
               column(9,
                      h2("An analysis of Asylum requests in Europe since Jan 1st, 1999"),
                      h4("The previous histogram shows that the majority requests for asylum are in Europe,
                         It is somewhat natural to wonder whether to what extent they are in the EU,
                         and to what extent they are in Germany which has been a particularly welcoming
                         country."),
                      br(),
                      h4("by selecting and deselecting the areas of asylum (Europe, EU, Germany) it is 
                         possible to highlight different time series"),
                      h4("By moving the slider, it is possible to analyze different time intervals"),
                      h4("Please note that the data ranges from January 1999 to October 2015,  therefore 
                         the data in this graph is more up to date than the data in the previous chart."))),
             fluidRow(
               column(1,p(" ")),
               column(3,
                      wellPanel(
                        checkboxGroupInput("Asylum_Area", 
                                           label = h3("Select area of asylum"), 
                                           choices = list("Europe"= "Europe",
                                                          "EU"= "EU", 
                                                          "Germany"= "Germany"),
                                           selected = c(
                                             "Europe", "EU", "Germany"
                                           )),
                        sliderInput("Range",
                                    label = "Time Window",
                                    min = 1999, max = 2015, 
                                    value = c(1999, 2015)))),
               column(3,
                      mainPanel(showOutput("Asylum_Europe", "Morris")))),
             fluidRow(
               column(1,p(" ")),
               column(9,
                      h4("Two issues emerge from this time series"),
                      h4("1. The Syrian asylum requests in the EU historically tracked very closely the 
                         total EU asylum requests until 2015.  After that there was a major discrepancy.
                         Furthermore in the latest months the number of asylum requests dropped in EU while
                         it grew in the rest of Europe."),
                      h4("2. The percentage of asylum requests in Germany does not seem to be exceptionally high
                         compare to the total requests in the EU.")))
    ), 
    tabPanel("Geographic View", 
             fluidRow(
               column(1,p(" ")),
               column(9,
                      h2("Geographic View"),
                      h4("The data presented here can be effectively displayed on a map."),
                      h4("But there seemed to be a problem that prevented both the map an the charts in the tab 
                  \"analysis\" to be displayed on the same page.  So they have been split.")
               )),
             fluidRow(
               column(1,
                      p(" ")),
               column(6,
                      mainPanel(
                        showOutput("Map","DataMaps")
                      ))),
             fluidRow(
               column(1,
                      p(" ")),
               column(9,
                      br(),
                      br(),
                      br(),
                      h4("This map has a serious problem and it does not really display the data correctly.
                         The problem lies in the use of quantiles in rMap the function \"ichoropleth\"."),
                      h4("Since most of the countries host very few refugees, the scale is quite skewed toward the 
                         low values. In this case the United States that hosts a few thousands refugees is 
                         represented as Libanon or Turkey that received millions of refugees."),
                      h4("The solution would be to change the coloring function,  but there was no time to do that.")
               ))
    ),
    tabPanel("Sources",
             fluidRow(
               column(1,
                      p(" ")),
               column(9,
                      h4("Image on Issue tab from: "),
                      a("https://en.wikipedia.org/wiki/European_migrant_crisis"),
                      h4("Data from "),
                      a("http://popstats.unhcr.org/en/overview"))
             ))
  )
))