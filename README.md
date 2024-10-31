import pandas as pd

data = [
    ["SXR8.DE", 17, 300.36, "EUR", "2020-11-10", "Binck", "2021-11-19", 423.913],
    ["CNDX.AS", 4, 636, "EUR", "2021-05-10", "Binck", "2021-11-19", 827.5],
    ["CNDX.AS", 9, 577.89, "EUR", "2020-12-14", "Binck", "2021-11-19", 827.5],
    ["CSX5.AS", 9, 132.89, "EUR", "2021-04-09", "Binck", "2021-11-19", 147.332],
    ["CSX5.AS", 42, 116.68, "EUR", "2020-12-14", "Binck", "2021-11-19", 147.332],
    ["RR.L", 20.79, 98.57, "GBP", "2021-01-25", "Binck", "2021-11-19", 135.493],
    ["RR.L", 60, 133, "GBP", "2020-12-04", "Binck", "2021-11-19", 135.493],
    ["STZ.PA", 103, 48.42, "EUR", "2020-12-14", "Binck", "2021-11-19", 61.5],
    ["INRG.MI", 190, 15.88, "EUR", "2021-01-08", "Binck", "2021-09-15", 10.843],
    ["INRG.MI", 150, 16.02, "EUR", "2021-01-08", "Binck", "2021-09-15", 10.843],
    ["INRG.MI", 174, 11.53, "EUR", "2021-03-04", "Binck", "2021-09-15", 10.843],
    ["NVDA", 16, 166.1, "USD", "2021-06-02", "IBKR", None, None],
    ["SXR8.DE", 6, 389.87, "EUR", "2021-08-24", "IBKR", None, None],
    ["STZ.PA", 35, 58.43, "EUR", "2021-08-24", "IBKR", None, None],
    ["CSX5.AS", 15, 141.13, "EUR", "2021-08-25", "IBKR", None, None],
    ["TSLA", 4, 751.02, "USD", "2021-09-16", "IBKR", "2021-11-19", 1106.16],
    ["AAPL", 15, 147.42, "USD", "2021-09-16", "IBKR", None, None],
    ["TSLA", 1, 757.95, "USD", "2021-09-17", "IBKR", "2021-11-19", 1106.16],
    ["AAPL", 15, 148.69, "USD", "2021-09-17", "IBKR", None, None],
    ["SXR8.DE", 4, 412.478, "EUR", "2021-11-04", "IBKR", None, None],
    ["SXR8.DE", 37, 272, "EUR", "2020-05-08", "Binck", "2020-06-05", 283.62],
    ["SXR8.DE", 19, 254.5, "EUR", "2020-04-21", "Binck", "2020-06-05", 283.62],
    ["SXR8.DE", 36, 286.01, "EUR", "2020-08-10", "Binck", "2020-09-03", 301.88],
    ["SXR8.DE", 18, 275, "EUR", "2020-07-27", "Binck", "2020-09-03", 301.88],
    ["SONY", 50, 110.02, "USD", "2022-01-24", "IBKR", None, None],
    ["MA", 6, 391.62, "USD", "2022-02-01", "IBKR", None, None],
    ["V", 10, 231.25, "USD", "2022-02-01", "IBKR", None, None],
    ["PYPL", 18, 130, "USD", "2022-02-02", "IBKR", None, None],
    ["PYPL", 15, 172.56, "USD", "2022-02-01", "IBKR", None, None],
    ["IJPN.AS", 180, 13.92, "EUR", "2022-03-07", "IBKR", None, None],
    ["XUFN.DE", 100, 24.49, "EUR", "2022-03-07", "IBKR", None, None],
    ["IUHE.AS", 370, 6.61, "EUR", "2022-03-07", "IBKR", None, None],
    ["IWDA.AS", 50, 75.72, "EUR", "2022-03-21", "IBKR", None, None],
    ["XDWH.DE", 60, 43.3, "EUR", "2022-05-10", "IBKR", None, None],
    ["5MVW.DE", 330, 6.11, "EUR", "2022-05-06", "IBKR", None, None],
    ["GDIG.MI", 65, 30.34, "EUR", "2022-05-06", "IBKR", None, None],
    ["IWDA.AS", 55, 72.16, "EUR", "2022-05-06", "IBKR", None, None],
    ["SXRV.DE", 10, 651.2, "EUR", "2022-06-27", "IBKR", None, None],
    ["SXR8.DE", 9, 370.52, "EUR", "2022-07-01", "IBKR", None, None]
]

columns = ["Symbol", "Shares", "Price", "Currency", "PurchaseDate", "Broker", "SellDate", "SellPrice"]

df = pd.DataFrame(data, columns=columns)

print(df)
