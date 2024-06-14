-- 1. Companies with the highest market capitalization
SELECT symbol, shortname, marketcap 
FROM sp500_companies 
ORDER BY marketcap DESC 
LIMIT 10;

-- 2. Companies with the highest revenue growth
SELECT symbol, shortname, revenuegrowth 
FROM sp500_companies 
ORDER BY revenuegrowth DESC 
LIMIT 10;

-- 3. Comparison of adjusted closing prices of companies on the most recent date
 SELECT c.symbol, c.shortname, s.date, s.adj_close
 FROM sp500_companies c
 JOIN sp500_stocks s ON c.symbol = s.symbol
 WHERE s.date = (SELECT MAX(date) FROM sp500_stocks)
 ORDER BY s.adj_close DESC
 LIMIT 10;

-- 4. Show rows with at least one NULL value in sp500_stocks
 SELECT * FROM sp500_stocks 
 WHERE adj_close IS NULL 
    OR close IS NULL 
    OR high IS NULL 
    OR low IS NULL 
    OR open IS NULL 
    OR volume IS NULL;

-- 5. Average adjusted closing price per sector
 SELECT c.sector, AVG(s.adj_close) AS avg_adj_close
 FROM sp500_companies c
 JOIN sp500_stocks s ON c.symbol = s.symbol
 GROUP BY c.sector
 ORDER BY avg_adj_close DESC;

-- 6. Top 5 companies with the highest EBITDA
 SELECT symbol, shortname, ebitda 
 FROM sp500_companies 
 ORDER BY ebitda DESC 
 LIMIT 5;

-- 7. Daily average volume traded for each stock
 SELECT s.symbol, c.longname, AVG(s.volume) AS avg_volume
 FROM sp500_stocks s
 JOIN sp500_companies c
 ON s.symbol = c.symbol
 GROUP BY s.symbol
 ORDER BY avg_volume DESC;

-- 8. Percentage change in the S&P 500 index value over a specific period
 SELECT 
     MIN(date) AS start_date, 
     MAX(date) AS end_date,
     ((MAX(value) - MIN(value)) / MIN(value)) * 100 AS percentage_change
 FROM sp500_index
 WHERE date BETWEEN '2023-01-01' AND '2023-12-31';

-- 9. List companies with a market cap above a certain threshold and sorted by revenue growth
 SELECT symbol, shortname, marketcap, revenuegrowth
 FROM sp500_companies
 WHERE marketcap > 100000000000  -- Example threshold: 100 billion
 ORDER BY revenuegrowth DESC;

-- 10. Monthly average adjusted closing price for each stock
 SELECT symbol, 
        DATE_FORMAT(date, '%Y-%m') AS month, 
        AVG(adj_close) AS avg_adj_close
 FROM sp500_stocks
 GROUP BY symbol, month
 ORDER BY symbol, month;

-- 11. Find the top 10 companies with the highest adjusted closing price on the most recent date
 SELECT c.symbol, c.shortname, s.adj_close
 FROM sp500_companies c
 JOIN sp500_stocks s ON c.symbol = s.symbol
 WHERE s.date = (SELECT MAX(date) FROM sp500_stocks)
 ORDER BY s.adj_close DESC
 LIMIT 10;

