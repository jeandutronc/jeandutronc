library(dplyr)
library(data.table)
#install.packages("data.table", dependencies=TRUE)

# list of stock
stock <- data.frame(rbind(
# Symbol        ,Shares   ,Price        ,Currency   ,PurchaseDate     ,Broker     ,SellDate       ,SellPrice  
c("SXR8.DE"	    ,17       ,300.36	      ,"EUR"	    ,"2020-11-10"	    ,"Binck"    ,"2021-11-19"   ,423.913    ),
c("CNDX.AS"	    ,4	      ,636	        ,"EUR"	    ,"2021-05-10"	    ,"Binck"    ,"2021-11-19"   ,827.5      ),
c("CNDX.AS"	    ,9	      ,577.89	      ,"EUR"	    ,"2020-12-14"	    ,"Binck"    ,"2021-11-19"   ,827.5      ),
c("CSX5.AS"	    ,9	      ,132.89	      ,"EUR"	    ,"2021-04-09"	    ,"Binck"    ,"2021-11-19"   ,147.332    ),
c("CSX5.AS"	    ,42       ,116.68	      ,"EUR"	    ,"2020-12-14"	    ,"Binck"    ,"2021-11-19"   ,147.332    ),
c("RR.L"	      ,20.79    ,98.57	      ,"GBP"	    ,"2021-01-25"	    ,"Binck"    ,"2021-11-19"   ,135.493    ),
c("RR.L"	      ,60	      ,133	        ,"GBP"	    ,"2020-12-04"	    ,"Binck"    ,"2021-11-19"   ,135.493    ),
c("STZ.PA"	    ,103	    ,48.42	      ,"EUR"	    ,"2020-12-14"	    ,"Binck"    ,"2021-11-19"   ,61.5       ),
c("INRG.MI"	    ,190	    ,15.88	      ,"EUR"	    ,"2021-01-08"	    ,"Binck"    ,"2021-09-15"   ,10.843     ),
c("INRG.MI"	    ,150	    ,16.02	      ,"EUR"	    ,"2021-01-08"	    ,"Binck"    ,"2021-09-15"   ,10.843     ),
c("INRG.MI"	    ,174	    ,11.53	      ,"EUR"	    ,"2021-03-04"	    ,"Binck"    ,"2021-09-15"   ,10.843     ),
c("NVDA"	      ,16       ,166.1	      ,"USD"	    ,"2021-06-02"	    ,"IBKR"	    ,NA             ,NA         ),
c("SXR8.DE"	    ,6	      ,389.87	      ,"EUR"	    ,"2021-08-24"	    ,"IBKR"	    ,NA             ,NA         ),
c("STZ.PA"	    ,35	      ,58.43	      ,"EUR"	    ,"2021-08-24"	    ,"IBKR"	    ,NA             ,NA         ),
c("CSX5.AS"	    ,15	      ,141.13	      ,"EUR"	    ,"2021-08-25"	    ,"IBKR"	    ,NA             ,NA         ),
c("TSLA"	      ,4	      ,751.02	      ,"USD"	    ,"2021-09-16"	    ,"IBKR"	    ,"2021-11-19"   ,1106.16    ),
c("AAPL"  	    ,15	      ,147.42	      ,"USD"	    ,"2021-09-16"	    ,"IBKR"	    ,NA             ,NA         ),
c("TSLA"	      ,1	      ,757.95	      ,"USD"	    ,"2021-09-17"	    ,"IBKR"	    ,"2021-11-19"   ,1106.16    ),
c("AAPL"	      ,15	      ,148.69	      ,"USD"	    ,"2021-09-17"	    ,"IBKR"	    ,NA             ,NA         ),
c("SXR8.DE"	    ,4	      ,412.478	    ,"EUR"	    ,"2021-11-04"	    ,"IBKR"	    ,NA             ,NA         ),
c("SXR8.DE"	    ,37	      ,272	        ,"EUR"	    ,"2020-05-08"	    ,"Binck"    ,"2020-06-05"   ,283.62     ),
c("SXR8.DE"	    ,19	      ,254.5	      ,"EUR"	    ,"2020-04-21"	    ,"Binck"    ,"2020-06-05"   ,283.62     ),
c("SXR8.DE"	    ,36	      ,286.01	      ,"EUR"	    ,"2020-08-10"	    ,"Binck"    ,"2020-09-03"   ,301.88     ),
c("SXR8.DE"	    ,18	      ,275	        ,"EUR"	    ,"2020-07-27"	    ,"Binck"    ,"2020-09-03"   ,301.88     ),
c("SONY"	      ,50	      ,110.02	      ,"USD"	    ,"2022-01-24"	    ,"IBKR"	    ,NA             ,NA         ),
c("MA"	        ,6	      ,391.62	      ,"USD"	    ,"2022-02-01"	    ,"IBKR"	    ,NA             ,NA         ),
c("V"	          ,10	      ,231.25	      ,"USD"	    ,"2022-02-01"	    ,"IBKR"	    ,NA             ,NA         ),
c("PYPL"  	    ,18	      ,130	        ,"USD"	    ,"2022-02-02"	    ,"IBKR"	    ,NA             ,NA         ),
c("PYPL"  	    ,15	      ,172.56	      ,"USD"	    ,"2022-02-01"	    ,"IBKR"	    ,NA             ,NA         ),
c("IJPN.AS"	    ,180	    ,13.92	      ,"EUR"	    ,"2022-03-07"	    ,"IBKR"	    ,NA             ,NA         ),
c("XUFN.DE"	    ,100	    ,24.49	      ,"EUR"	    ,"2022-03-07"	    ,"IBKR"	    ,NA             ,NA         ),
c("IUHE.AS"	    ,370	    ,6.61	        ,"EUR"	    ,"2022-03-07"	    ,"IBKR"	    ,NA             ,NA         ),
c("IWDA.AS"	    ,50	      ,75.72	      ,"EUR"	    ,"2022-03-21"	    ,"IBKR"	    ,NA             ,NA         ),
c("XDWH.DE"	    ,60	      ,43.3	        ,"EUR"	    ,"2022-05-10"	    ,"IBKR"	    ,NA             ,NA         ),
c("5MVW.DE"	    ,330	    ,6.11	        ,"EUR"	    ,"2022-05-06"	    ,"IBKR"	    ,NA             ,NA         ),
c("GDIG.MI"	    ,65	      ,30.34	      ,"EUR"	    ,"2022-05-06"	    ,"IBKR"	    ,NA             ,NA         ),
c("IWDA.AS"	    ,55	      ,72.16	      ,"EUR"	    ,"2022-05-06"	    ,"IBKR"	    ,NA             ,NA         ),
c("SXRV.DE"	    ,10	      ,651.2	      ,"EUR"	    ,"2022-06-27"	    ,"IBKR"	    ,NA             ,NA         ),
c("SXR8.DE"	    ,9	      ,370.52	      ,"EUR"	    ,"2022-07-01"	    ,"IBKR"	    ,NA             ,NA         )
))


# add column names
ColumnNames <- c("Symbol","Shares","Price","Currency","PurchaseDate","Broker","SellDate","SellPrice") #créer un vecteur avec les noms des colonnes
colnames(stock) <- ColumnNames #utiliser le vecteur ColumnNames comme nom de colonnes
rm(ColumnNames)

# add purchase id
stock <- stock[
  with(stock, order(PurchaseDate,Symbol)),
]

stock$PurchaseID <- seq.int(nrow(stock))


# convert numbers to numerical, dates to date
stock <- transform(stock, Shares = as.numeric(Shares),
                   Price   = as.numeric(Price),
                   PurchaseDate = as.Date(PurchaseDate, format='%Y-%m-%d'),
                   SellDate = as.Date(SellDate, format='%Y-%m-%d'),
                   SellPrice   = as.numeric(SellPrice)
                   )



##############################
## DOWNLOAD HISTORICAL DATA ##
##############################


# create links to download data from Yahoo
stocklinks <- aggregate(PurchaseDate ~ Symbol, stock,function(x) min(x)) #minimum purchase date
stocklinks <- paste0("https://query1.finance.yahoo.com/v7/finance/download/",stocklinks$Symbol,"?period1=",as.numeric(as.POSIXct(stocklinks$PurchaseDate ,origin = "1900-01-01")),"&period2=",as.numeric(as.POSIXct(Sys.Date()+1 ,origin = "1900-01-01")),"&interval=1d&events=history&includeAdjustedClose=true")


# function to open a csv and add the file name
read.csv.and.add.filename <- function(filepath){
  read.csv(filepath) %>%
    mutate(filepath=filepath)
}


# open all links and include link in dataset
StockHistory <-  do.call(rbind, lapply(stocklinks, function(x) read.csv.and.add.filename(x)))

# extract symbol from link
StockHistory$symbol = substr(StockHistory$filepath,54,65) # substring is different in R, the second parameter does not start from the first but from the start 
StockHistory$symbol = gsub("\\?.*","",StockHistory$symbol) # \\ needed to escape "?" -> "?" is a parameter, \\? makes it a text

StockHistory <- cbind(StockHistory$Date ,StockHistory$Close ,StockHistory$symbol )

StockHistory <- data.frame(StockHistory)

# add column names
ColumnNames <- c("Date","Close","Symbol")
colnames(StockHistory) <- ColumnNames #utiliser le vecteur ColumnNames comme nom de colonnes
rm(ColumnNames)

# convert numbers to numerical, dates to date
StockHistory <- transform(StockHistory, Date = as.Date(Date, format='%Y-%m-%d'),
                                        Close   = as.numeric(Close)
)

##########################################
## CREATE ALL DATES WITH RELEVANT STOCK ##
##########################################


# defining start date
date <- as.Date("2020-04-21",format="%Y-%m-%d")

# defining length of range 
len <- Sys.Date()-date+1
print(len)

# generating range of dates
DateTable <- seq(date, by = "day", length.out = len)


StockAllDates <- merge(x = stock, y = DateTable, by = NULL)

StockAllDates <- rename(StockAllDates,Date = y )

StockAllDates <- filter(StockAllDates, Date >= PurchaseDate)
StockAllDates <- filter(StockAllDates, Date <= SellDate | is.na(SellDate))


##############
## CURRENCY ##
##############


dollar <- read.csv(paste0("https://query1.finance.yahoo.com/v7/finance/download/EURUSD=X?period1=1577836800&period2=",as.numeric(as.POSIXct(Sys.Date()+1 ,origin = "1900-01-01")),"&interval=1d&events=history&includeAdjustedClose=true"))
dollar <- subset(dollar, select = c(Date,Close) )
dollar$Currency = 'USD'

pound <- read.csv(paste0("https://query1.finance.yahoo.com/v7/finance/download/EURGBP=X?period1=1577836800&period2=",as.numeric(as.POSIXct(Sys.Date()+1 ,origin = "1900-01-01")),"&interval=1d&events=history&includeAdjustedClose=true"))
pound <- subset(pound, select = c(Date,Close) )
pound$Currency = 'GBP'

CurrencyTable <- union_all(dollar,pound)

CurrencyTable <- rename(CurrencyTable,CurrencyDate = Date )
CurrencyTable <- rename(CurrencyTable,CurrencyClose = Close )

CurrencyTable <- transform(CurrencyTable, CurrencyDate = as.Date(CurrencyDate, format='%Y-%m-%d'),
                                          CurrencyClose   = as.numeric(CurrencyClose)
)

# remove duplicates by taking the last value of a day

CurrencyTable <- CurrencyTable %>%
  group_by(CurrencyDate,Currency) %>%
  mutate(row_number_bygroup = 1:n())

setDT(CurrencyTable)[, Max:= max(row_number_bygroup), list(Currency,CurrencyDate)]

CurrencyTable <- filter(CurrencyTable, row_number_bygroup == Max)



##################
## MERGE TABLES ##
##################

StockView <- merge(StockHistory,StockAllDates, by.x=c("Date", "Symbol"), by.y=c("Date", "Symbol"),all.y=TRUE)

StockView <- merge(StockView,CurrencyTable, by.x=c("Date", "Currency"), by.y=c("CurrencyDate", "Currency"),all.x=TRUE)


# fx rate on purchase date
FXPP <- merge(stock,CurrencyTable, by.x=c("Currency", "PurchaseDate"), by.y=c("Currency", "CurrencyDate"))
FXPP = subset(FXPP, select = c(PurchaseID,CurrencyClose) )
FXPP <- rename(FXPP,PurchaseIDPP = PurchaseID )
FXPP <- rename(FXPP,CurrencyClosePP = CurrencyClose )

StockView <- merge(StockView,FXPP, by.x=c("PurchaseID"), by.y=c("PurchaseIDPP"),all.x=TRUE)


StockView <- StockView[
  with(StockView, order(PurchaseID,Date)),
]




##################
## CALCULATIONS ##
##################


# if close value is missing, taking previous one, looping until none missing
i <- sum(ifelse(is.na(StockView$Close) & lag(StockView$PurchaseID) == StockView$PurchaseID ,1 , 0))
while (i > 0) {
  StockView$Close = ifelse(is.na(StockView$Close) & lag(StockView$PurchaseID) == StockView$PurchaseID, lag(StockView$Close) , StockView$Close)
  StockView$CurrencyClose = ifelse(is.na(StockView$CurrencyClose) & lag(StockView$PurchaseID) == StockView$PurchaseID, lag(StockView$CurrencyClose) , StockView$CurrencyClose)
  i = sum(ifelse(is.na(StockView$Close) & lag(StockView$PurchaseID) == StockView$PurchaseID ,1 , 0))
}


StockView$CurrencyClose = ifelse(StockView$Currency == 'EUR',1,StockView$CurrencyClose)
StockView$CurrencyClosePP = ifelse(StockView$Currency == 'EUR',1,StockView$CurrencyClosePP)

# Original Value (purchase price * nb of positions)
StockView$OriginalValue = StockView$Price*StockView$Shares
StockView$OriginalValueEUR = StockView$Price*StockView$Shares/StockView$CurrencyClose
StockView$OriginalValueEURFxCorrected = StockView$Price*StockView$Shares/StockView$CurrencyClosePP

# Current Value (Close * nb of positions)
StockView$CurrentValue = StockView$Close*StockView$Shares
StockView$CurrentValueEUR = StockView$Close*StockView$Shares/StockView$CurrencyClose

# Gains
StockView$Gain = StockView$CurrentValueEUR - StockView$OriginalValueEUR
StockView$GainFxCorrected = StockView$CurrentValueEUR - StockView$OriginalValueEURFxCorrected


# Clean useless columns
StockView = subset(StockView, select = -c(row_number_bygroup,Max ) )


########################
## PRINT FINAL RESULT ##
########################
# open
CurrentBalance <- filter(StockView, Date == max(StockView$Date))
CurrentBalanceEUR <- filter(CurrentBalance, Currency == 'EUR')
CurrentBalanceUSD <- filter(CurrentBalance, Currency == 'USD')


# closed
ClosedPositions <- filter(StockView, SellDate == Date & Date != max(StockView$Date ))

# Day by day
DBD = subset(StockView, select = c(Gain, GainFxCorrected,Date,CurrentValueEUR,OriginalValueEURFxCorrected ))
DBD <- aggregate(cbind(DBD$Gain, DBD$GainFxCorrected,DBD$CurrentValueEUR,DBD$OriginalValueEURFxCorrected),by = list(Date=DBD$Date), FUN=sum)
DBDA <- tail(DBD,n=2)  # last 2 days
DBD1 <- tail(DBDA,n=1) # today
DBD2 <- head(DBDA,n=1) # yesterday

# Final
FinalResult <- rbind(
paste0("Situation as of ",max(StockView$Date)),
'',
paste0(round(sum(CurrentBalance$OriginalValueEUR), digits = 2)," EUR invested on ",n_distinct(CurrentBalance$Symbol)," instruments"),
paste0("Corrected for Fx: ",round(sum(CurrentBalance$OriginalValueEURFxCorrected), digits = 2)," EUR"),
paste0("Unrealised: ",round(sum(CurrentBalance$Gain), digits = 2)," EUR"),
paste0("Unrealised corrected for Fx: ",round(sum(CurrentBalance$GainFxCorrected), digits = 2)," EUR"),
paste0("Unrealised today: ",round(DBD1$V1-DBD2$V1, digits = 2)," EUR"),
paste0("Unrealised today corrected for Fx: ",round(DBD1$V2-DBD2$V2, digits = 2)," EUR"),
'',
paste0(round(sum(CurrentBalanceEUR$OriginalValueEUR), digits = 2)," EUR invested on ",n_distinct(CurrentBalanceEUR$Symbol)," instruments in EUR"),
paste0("Unrealised: ",round(sum(CurrentBalanceEUR$Gain), digits = 2)," EUR"),
'',
paste0(round(sum(CurrentBalanceUSD$OriginalValueEUR), digits = 2)," EUR invested on ",n_distinct(CurrentBalanceUSD$Symbol)," instruments in USD"),
paste0("After Fx Correction: ",round(sum(CurrentBalanceUSD$OriginalValueEURFxCorrected), digits = 2)," EUR"),
paste0("Unrealised: ",round(sum(CurrentBalanceUSD$Gain), digits = 2)," EUR"),
paste0("Unrealised corrected for Fx: ",round(sum(CurrentBalanceUSD$GainFxCorrected), digits = 2)," EUR"),
'',
paste0("Realised: ",round(sum(ClosedPositions$Gain), digits = 2)," EUR"),
paste0("Realised corrected for Fx: ",round(sum(ClosedPositions$GainFxCorrected), digits = 2)," EUR")
)

par(mfrow=c(2,1))

plot(V3 ~ Date, data = filter(DBD, Date>= '2022-01-01') ,type='l',lty=1, col='violet',lwd=2,main="Value vs Purchase Price Corrected",col.main='black', xlab = "",ylab= "", ylim = c(0, max(filter(DBD, Date>= '2022-01-01')$V3)+1000), las = 1)
lines(V4 ~ Date, data = filter(DBD, Date>= '2022-01-01') ,lty=1, col='black',lwd=2,main="My Stock",col.main='blue' )
legend('bottomright',inset=0.05,c("Current Value","Purchase Price Fx"),lty=1,col=c('violet','black'),lwd=2)

plot(V1 ~ Date, data = filter(DBD, Date>= '2022-01-01') ,type='l',lty=1, col='red',lwd=2,main="Gain and Gain Corrected",col.main='black', xlab = "", ylab= "", ylim = c(min(filter(DBD, Date>= '2022-01-01')$V1)-1000, max(filter(DBD, Date>= '2022-01-01')$V2)+1000), las = 1)
lines(V2 ~ Date, data = filter(DBD, Date>= '2022-01-01') ,lty=1, col='green',lwd=2,main="My Stock",col.main='blue' )
legend('bottomleft',inset=0.05,c("Gain","Gain Corrected"),lty=1,col=c('red','green'),lwd=2)

#############
## CLEANUP ##
#############

rm(date)
rm(len)
rm(DateTable)
rm(stocklinks)
rm(stock)
rm(StockAllDates)
rm(StockHistory)
rm(dollar)
rm(pound) 
rm(FXPP) 
rm(DBD) 
rm(DBD1) 
rm(DBD2) 
rm(DBDA)
