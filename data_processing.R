library(dplyr)

# Required geographic abstractions
source("geography.R")

### Load data  ---------------------------------------------------

dir.project= "C:/Users/Massimo/OneDrive/Documents/GitHub/Coursera/DataScience/DataProducts/Project"
dir.project= "."
dir.data= "Data"

file.Yearly= "unhcr_popstats_export_asylum_seekers_all_data.csv"
file.Monthly= "unhcr_popstats_export_asylum_seekers_monthly_all_data.csv"
file.Monthly.2015="unhcr_popstats_export_asylum_seekers_monthly_2015_11_22_010602.csv"
file.poc= "unhcr_popstats_export_persons_of_concern_all_data.csv"
file.countryCodes= "country_codes.csv"

yearly.asyl_seek= read.csv(paste(dir.project,dir.data,file.Yearly,sep="/"),header=T,skip=3)

monthly.asyl_seek= read.csv(paste(dir.project,dir.data,file.Monthly,sep="/"),header=T,skip=3)
monthly.asyl_seek.2015= read.csv(paste(dir.project,dir.data,file.Monthly.2015,sep="/"),header=T,skip=3)
monthly.asyl_seek= rbind(monthly.asyl_seek,monthly.asyl_seek.2015)

poc.data= read.csv(paste(dir.project,dir.data,file.poc,sep="/"),header=T,skip=3)
countryCodes.data= read.csv(paste(dir.project,dir.data,file.countryCodes,sep="/"),header=T)


### A look on the data ---------------------------------------------

#### Yearly Refugee Data
dim(yearly.asyl_seek)
names(yearly.asyl_seek)
length(unique(yearly.asyl_seek$Country...territory.of.asylum.residence))
length(unique(yearly.asyl_seek$Origin))

#### Monthly Refugee Data
dim(monthly.asyl_seek)
names(monthly.asyl_seek)
length(unique(monthly.asyl_seek$Country...territory.of.asylum.residence))
length(unique(monthly.asyl_seek$Origin))

#### Persons of Concern Data
dim(poc.data)
names(poc.data)
length(unique(poc.data$Country...territory.of.asylum.residence))
length(unique(poc.data$Origin))
length(unique(poc.data$Origin))


### Data Cleaning =========================================================================

#  two  types of data cleaning are required
#  1. Data  is  loaded into factors,   but much of the data should be numeric, so it should be transformed
#  2. Colum names are too long,  they should be shortened fur code  readability

data_cleaning <- function (data, cols_To_Change, new_Names){
  
  # 1. The data is all read in as factors,  much of it needs to  be changed into  numeric  values
  # 2. Missing values and 0s  are represented as null strings or factors, 
  #                           by transforming them in numeric they become NA
  #                           NA are  then removed to become 0s
  as.number <- function (values) {
    values.num= suppressWarnings(
      as.numeric(as.character(values)))
    replace(values.num,is.na(values.num),0)}
  
  #fix  the type of the content of the table
  data[,cols_To_Change]= sapply(cols_To_Change, 
                                function(column) {
                                  data[,column]= as.number(data[,column])
                                })
  # fnix columns names
  names(data)=  new_Names
  # return the changged data
  data
}


yearly.asyl_seek= data_cleaning(data=yearly.asyl_seek,
                                cols_To_Change=c("Total.persons.pending.start.year",        
                                                 "of.which.UNHCR.assisted",      
                                                 "Applied.during.year",
                                                 "statistics.filter.decisions_recognized",
                                                 "statistics.filter.decisions_other",      
                                                 "Rejected",
                                                 "Otherwise.closed",
                                                 "Total.decisions",                        
                                                 "Total.persons.pending.end.year",
                                                 "of.which.UNHCR.assisted.1" ),
                                new_Names= c("Year",
                                             "Host.Coutry",
                                             "Origin",                                 
                                             "RSD.procedure.type...level",
                                             "Total.persons.pending.start.year",
                                             "of.which.UNHCR.assisted",                
                                             "Applied.during.year",
                                             "statistics.filter.decisions_recognized",
                                             "statistics.filter.decisions_other",      
                                             "Rejected",
                                             "Otherwise.closed",
                                             "Total.decisions",                        
                                             "Total.persons.pending.end.year",
                                             "of.which.UNHCR.assisted.1"))


monthly.asyl_seek= data_cleaning(data=monthly.asyl_seek,
                                 cols_To_Change=c("Value"),
                                 new_Names= c("Host.Coutry",
                                              "Origin",
                                              "Year",                                   
                                              "Month",
                                              "Value"))

poc.data= data_cleaning(data=poc.data,
                        cols_To_Change=c("Refugees..incl..refugee.like.situations.", 
                                         "Asylum.seekers..pending.cases.",
                                         "Returned.refugees",                       
                                         "Internally.displaced.persons..IDPs.",
                                         "Returned.IDPs",
                                         "Stateless.persons",                       
                                         "Others.of.concern",
                                         "Total.Population"),
                        new_Names= c("Year",                                     
                                     "Host.Coutry",
                                     "Origin",                                
                                     "Refugees",
                                     "Asylum.seekers",
                                     "Returned.refugees",                       
                                     "Internally.displaced.persons..IDPs.",
                                     "Returned.IDPs",  
                                     "Stateless.persons",                       
                                     "Others.of.concern",
                                     "Total.Population"))


## generate the mapping between countries names used by UNHBC and the 3 letters code
countryCodes.data= arrange(countryCodes.data,CountryName)[-(1:30),]
country_name.code.mapping= data.frame(UN= countryCodes.data$UN)
rownames(country_name.code.mapping)= countryCodes.data$CountryName



###  Relevant Data Frames #####################################################################

#---  Additional Geographic Definitions ----------------------------------

AllWorld= union(poc.data$Host.Coutry,poc.data$Origin)
RestWorld= setdiff(AllWorld,c(Europe, MiddleEast, NorthAfrica))


#### Using POC data -------------------------------------

# --- extract yearly data of refugees from Syria
poc.from_Syria.Yearly= filter(poc.data, Origin==Syria)


# --- extract data on different destinations

poc.from_Syria.to_Neighbors= filter(poc.from_Syria.Yearly,
                                 Host.Coutry %in% SyriaNeighbors)

poc.from_Syria.to_RestMiddleEast= filter(poc.from_Syria.Yearly,
                                          Host.Coutry %in% RestMiddleEast) 

poc.from_Syria.to_NorthAfrica= filter(poc.from_Syria.Yearly,
                                           Host.Coutry %in% NorthAfrica)

poc.from_Syria.to_Europe= filter(poc.from_Syria.Yearly,
                                 Host.Coutry %in% Europe)

poc.from_Syria.to_RestWorld= filter(poc.from_Syria.Yearly,
                                         Host.Coutry %in% RestWorld)


# --- extract 2014 data

poc.from_Syria.2014= filter(poc.from_Syria.Yearly,Year==2014)

poc.from_Syria.to_Neighbors.2014= filter(poc.from_Syria.to_Neighbors,Year==2014)

poc.from_Syria.to_RestMiddleEast.2014= filter(poc.from_Syria.to_RestMiddleEast,Year==2014)

poc.from_Syria.to_NorthAfrica.2014= filter(poc.from_Syria.to_NorthAfrica,Year==2014)

poc.from_Syria.to_Europe.2014= filter(poc.from_Syria.to_Europe,Year==2014)

poc.from_Syria.to_RestWorld.2014= filter(poc.from_Syria.to_RestWorld,Year==2014)



### Data for charts ############################################################################


#### map1: Distribution of Syrian refugees across the different countries ---------------------------
# this map should contain the total number of Syriann refugees that n 2014

##--- Extract relevaant data: host country and total polulation there 
map1.data= data.frame(Host.Coutry= poc.from_Syria.2014$Host.Coutry,
                      Total.Population= poc.from_Syria.2014$Total.Population)
##--- replace host country name with country code
map1.data= mutate(map1.data,
                  Host.Coutry= sapply(map1.data$Host.Coutry,
                                      function(country){
                                        country_name.code.mapping[as.character(country),]
                                      }))


#### Histogram1: Distribution of Syrian refugees by Geographic Area ---------------------------

#---  Data to display  --------------------------------------------------
refugees.host_areas= data.frame(
  Refugees= c(sum(poc.from_Syria.2014$Internally.displaced.persons..IDPs.),
              sum(poc.from_Syria.to_Neighbors.2014$Refugees),
              sum(poc.from_Syria.to_RestMiddleEast.2014$Refugees),
              sum(poc.from_Syria.to_NorthAfrica.2014$Refugees),
              sum(poc.from_Syria.to_Europe.2014$Refugees),
              sum(poc.from_Syria.to_RestWorld.2014$Refugees)),
  Asylum.seekers= c(0, # Syrians do not need to ask for asylum in their own land
                    sum(poc.from_Syria.to_Neighbors.2014$Asylum.seekers),
                    sum(poc.from_Syria.to_RestMiddleEast.2014$Asylum.seekers),
                    sum(poc.from_Syria.to_NorthAfrica.2014$Asylum.seekers),
                    sum(poc.from_Syria.to_Europe.2014$Asylum.seekers),
                    sum(poc.from_Syria.to_RestWorld.2014$Asylum.seekers)),
  Total.Population= c(sum(poc.from_Syria.2014$Internally.displaced.persons..IDPs.),
                      sum(poc.from_Syria.to_Neighbors.2014$Total.Population),
                      sum(poc.from_Syria.to_RestMiddleEast.2014$Total.Population),
                      sum(poc.from_Syria.to_NorthAfrica.2014$Total.Population),
                      sum(poc.from_Syria.to_Europe.2014$Total.Population),
                      sum(poc.from_Syria.to_RestWorld.2014$Total.Population)) ) 
row.names(refugees.host_areas)=c("Syria", "Syria Neighbors", "Rest of Middle East", "North Africa", "Europe", "Rest of the World")


### --- Asyylum seekers time series -------------------------------------------------------



month2number <- function (month) {
  month=as.character(month)
  if (month=="January")   {return("01")}
  if (month=="February")  {return("02")}
  if (month=="March")     {return("03")}
  if (month=="April")     {return("04")}
  if (month=="May")       {return("05")}
  if (month=="June")      {return("06")}
  if (month=="July")      {return("07")}
  if (month=="August")    {return("08")}
  if (month=="September") {return("09")}
  if (month=="October")   {return("10")}
  if (month=="November")  {return("11")}
  if (month=="December")  {return("12")}
}

monthly.asyl_seek$Date= 
  apply(monthly.asyl_seek,1,
        function(y) {
          paste(y[3],"-",month2number(y[4]),sep = "")})


monthly.asyl_seek.from_Syria= monthly.asyl_seek[monthly.asyl_seek$Origin==Syria,]

monthly.asyl_seek.from_Syria.to_Europe= 
  monthly.asyl_seek.from_Syria[
    monthly.asyl_seek.from_Syria$Host.Coutry %in% Europe,]

monthly.asyl_seek.from_Syria.to_EU= 
  monthly.asyl_seek.from_Syria[
    monthly.asyl_seek.from_Syria$Host.Coutry %in% EU,]

monthly.asyl_seek.from_Syria.to_Germany= 
  monthly.asyl_seek.from_Syria[
    monthly.asyl_seek.from_Syria$Host.Coutry=="Germany",]

# compute the sum of all asylum requests in a given month

months= unique(sort(monthly.asyl_seek.from_Syria$Date))

monthlyAsylSeek <- function(data,area,months) {
  ## extract data about the specific area
  area.data= data[data$Host.Coutry %in% area,]
  # comapute the asyl seekers in that area
  asyil.area= sapply(months, 
                     function(month){
                       monthlyAsylSeeks= area.data[area.data$Date==month,]
                       sum(monthlyAsylSeeks$Value)
                     })
  # return number of asyl seekers in that area
  asyil.area
}

syrian_asylum_requests_in_Europe= monthlyAsylSeek(monthly.asyl_seek.from_Syria,Europe,months)
syrian_asylum_requests_in_EU= monthlyAsylSeek(monthly.asyl_seek.from_Syria,EU,months)
syrian_asylum_requests_in_Germany= monthlyAsylSeek(monthly.asyl_seek.from_Syria,c("Germany"),months)


syrian_asylum_requests_in_Europe= data.frame(
  date= as.character(months),
  Europe= syrian_asylum_requests_in_Europe,
  EU=  syrian_asylum_requests_in_EU,
  Germany= syrian_asylum_requests_in_Germany)



