index_cons_close <- function(index_name="000300", from_date="20220101", 
                             to_date="20230101", website=c("sina", "oriental")){
  ak <- reticulate::import("akshare") 
  index <- ak$index_zh_a_hist(index_name, start_date=from_date, end_date=to_date)
  cons <- ak$index_stock_cons_sina(index_name)  
  cons_num <- nrow(cons)
  print(paste("The number of stock index is", cons_num))
  
  if(website=="sina"){
    ###Sina Finance, Mass crawling is easy to block IP
    funs <- ak$stock_zh_a_daily
    symbol <- cons$symbol
  }else {
    ###Oriental Wealth Network
    funs <- ak$stock_zh_a_hist
    symbol <- cons$code
  }
  
  ###Start crawling
  cdata<-list()
  pb <- txtProgressBar(style = 3)
  for (i in 1:cons_num) {
    cdata[[i]] <- try(funs(symbol=symbol[i], start_date=from_date, end_date=to_date))
    if("try-error" %in% class(cdata[[i]])){
      cdata[[i]] <- NULL
    }
    setTxtProgressBar(pb, i/cons_num)
  }
  close(pb)
  
  
  ###Merging data
  date <- as.Date(index$日期, tryFormats ="%Y-%m-%d")
  stock_data <- data.frame(date=date, close=index$收盘)
  
  if(website=="sina"){
    for (j in 1:cons_num) {
      datej <- as.Date(cdata[[j]]$date, tryFormats ="%Y-%m-%d")
      dataj <- data.frame(date=datej, closej=cdata[[j]]$close)
      stock_data <- dplyr::left_join(stock_data, dataj, by="date")
    }
  }else{
    for (j in 1:cons_num) {
      datej <- as.Date(cdata[[j]]$日期, tryFormats ="%Y-%m-%d")
      dataj <- data.frame(date=datej, closej=cdata[[j]]$收盘)
      stock_data <- dplyr::left_join(stock_data, dataj, by="date")
    }
  }
  
  colnames(stock_data) <- c("date", index_name, cons$code)
  
  ## Use the previous day's closing price to interpolate missing data.
  ## It must be ensured that the first day's data is not empty.
  for (j in 2:ncol(stock_data)) {
    for (i in 2:nrow(stock_data)) {
      if(is.na(stock_data[i, j])) {stock_data[i, j] <- stock_data[i-1,j]}
    }
  }
  
  stock_data
  
}



##Example
index_name <- ak$index_stock_info()                  
index_name
stock_data <- index_cons_close(index_name="000016", from_date="20220101", 
                                to_date="20230301", website="sina")

