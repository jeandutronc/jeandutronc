import pandas as pd
import numpy as np
import yfinance as yf
from datetime import datetime, timedelta

# Data for stock portfolio
data = {
    "Symbol": ["SXR8.DE", "CNDX.AS", "CNDX.AS", "CSX5.AS", "CSX5.AS", "RR.L", "RR.L", "STZ.PA", 
               "INRG.MI", "INRG.MI", "INRG.MI", "NVDA", "SXR8.DE", "STZ.PA", "CSX5.AS", "TSLA", 
               "AAPL", "TSLA", "AAPL", "SXR8.DE", "SXR8.DE", "SXR8.DE", "SXR8.DE", "SXR8.DE", 
               "SONY", "MA", "V", "PYPL", "PYPL", "IJPN.AS", "XUFN.DE", "IUHE.AS", "IWDA.AS", 
               "XDWH.DE", "5MVW.DE", "GDIG.MI", "IWDA.AS", "SXRV.DE", "SXR8.DE"],
    "Shares": [17, 4, 9, 9, 42, 20.79, 60, 103, 190, 150, 174, 16, 6, 35, 15, 4, 15, 1, 15, 4, 
               37, 19, 36, 18, 50, 6, 10, 18, 15, 180, 100, 370, 50, 60, 330, 65, 55, 10, 9],
    "Price": [300.36, 636, 577.89, 132.89, 116.68, 98.57, 133, 48.42, 15.88, 16.02, 11.53, 166.1, 
              389.87, 58.43, 141.13, 751.02, 147.42, 757.95, 148.69, 412.478, 272, 254.5, 286.01, 
              275, 110.02, 391.62, 231.25, 130, 172.56, 13.92, 24.49, 6.61, 75.72, 43.3, 6.11, 
              30.34, 72.16, 651.2, 370.52],
    "Currency": ["EUR", "EUR", "EUR", "EUR", "EUR", "GBP", "GBP", "EUR", "EUR", "EUR", "EUR", 
                 "USD", "EUR", "EUR", "EUR", "USD", "USD", "USD", "USD", "EUR", "EUR", "EUR", 
                 "EUR", "EUR", "USD", "USD", "USD", "USD", "USD", "EUR", "EUR", "EUR", "EUR", 
                 "EUR", "EUR", "EUR", "EUR", "EUR", "EUR", "EUR"],
    "PurchaseDate": ["2020-11-10", "2021-05-10", "2020-12-14", "2021-04-09", "2020-12-14", 
                     "2021-01-25", "2020-12-04", "2020-12-14", "2021-01-08", "2021-01-08", 
                     "2021-03-04", "2021-06-02", "2021-08-24", "2021-08-24", "2021-08-25", 
                     "2021-09-16", "2021-09-16", "2021-09-17", "2021-09-17", "2021-11-04", 
                     "2020-05-08", "2020-04-21", "2020-08-10", "2020-07-27", "2022-01-24", 
                     "2022-02-01", "2022-02-01", "2022-02-02", "2022-02-01", "2022-03-07", 
                     "2022-03-07", "2022-03-07", "2022-03-21", "2022-05-10", "2022-05-06", 
                     "2022-05-06", "2022-05-06", "2022-06-27", "2022-07-01"],
    "Broker": ["Binck", "Binck", "Binck", "Binck", "Binck", "Binck", "Binck", "Binck", 
               "Binck", "Binck", "Binck", "IBKR", "IBKR", "IBKR", "IBKR", "IBKR", 
               "IBKR", "IBKR", "IBKR", "IBKR", "Binck", "Binck", "Binck", "Binck", 
               "IBKR", "IBKR", "IBKR", "IBKR", "IBKR", "IBKR", "IBKR", "IBKR", "IBKR", 
               "IBKR", "IBKR", "IBKR", "IBKR", "IBKR", "IBKR"],
    "SellDate": ["2021-11-19", "2021-11-19", "2021-11-19", "2021-11-19", "2021-11-19", 
                 "2021-11-19", "2021-11-19", "2021-11-19", "2021-09-15", "2021-09-15", 
                 "2021-09-15", None, None, None, None, "2021-11-19", None, "2021-11-19", 
                 None, None, "2020-06-05", "2020-06-05", "2020-09-03", "2020-09-03", 
                 None, None, None, None, None, None, None, None, None, None, None, None, 
                 None, None, None],
    "SellPrice": [423.913, 827.5, 827.5, 147.332, 147.332, 135.493, 135.493, 61.5, 
                  10.843, 10.843, 10.843, None, None, None, None, 1106.16, None, 
                  1106.16, None, None, 283.62, 283.62, 301.88, 301.88, None, None, 
                  None, None, None, None, None, None, None, None, None, None, None, 
                  None, None]
}

# Convert to DataFrame
stock = pd.DataFrame(data)

# Convert date columns to datetime
stock["PurchaseDate"] = pd.to_datetime(stock["PurchaseDate"])
stock["SellDate"] = pd.to_datetime(stock["SellDate"])

# Add PurchaseID for unique identifier
stock = stock.sort_values(by=["PurchaseDate", "Symbol"]).reset_index(drop=True)
stock["PurchaseID"] = range(1, len(stock) + 1)

# Download historical data from Yahoo Finance
symbols = stock["Symbol"].unique()
min_purchase_dates = stock.groupby("Symbol")["PurchaseDate"].min()
stock_data = pd.DataFrame()

# Download data for each symbol from the minimum purchase date to the present
for symbol in symbols:
    start_date = min_purchase_dates[symbol]
    end_date = datetime.today() + timedelta(days=1)
    data = yf.download(symbol, start=start_date, end=end_date, interval="1d")["Close"]
    data = data.reset_index()
    data["Symbol"] = symbol
    stock_data = pd.concat([stock_data, data], ignore_index=True)

# Rename and format columns
stock_data.rename(columns={"Date": "Date", "Close": "Close", "Symbol": "Symbol"}, inplace=True)
stock_data["Date"] = pd.to_datetime(stock_data["Date"])
stock_data["Close"] = stock_data["Close"].astype(float)

# Merge stock data with purchase and sell dates
result = pd.merge(stock_data, stock, how="right", on=["Symbol", "Date"])

# Further analysis and calculations would follow here based on the original R script's calculations.
