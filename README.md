# S&P 500 Data Analysis

This project demonstrates my skills in SQL and MySQL through the creation and analysis of data related to the S&P 500. It includes scripts for creating and populating tables, as well as advanced queries to extract valuable information.

## Installation

### Install MySQL on Ubuntu

Update system packages:

```bash
sudo apt update
sudo apt upgrade
```

Install MySQL and verify the installation:

```bash
sudo apt install mysql-server
sudo systemctl status mysql
```

Access MySQL and create a user and database:
```bash
sudo mysql
```
```sql
CREATE DATABASE rendimiento_inversiones;
CREATE USER 'juan'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON rendimiento_inversiones.* TO 'juan'@'localhost';
FLUSH PRIVILEGES;
```

Access MySQL and create a user and database:
```bash
sudo mysql -u juan -p
```
```sql
SHOW DATABASES; // to list existing databases
USE rendimiento_inversiones; // to connect to the database
```

Then create the databases with the script in the 'create_tables.sql' file. And then import the data obtained from Kaggle (url: https://www.kaggle.com/datasets/andrewmvd/sp-500-stocks/data) with the script in the 'import_data.sql' file.



## Table Structure
### sp500_companies

```sql
CREATE TABLE sp500_companies (
    id INT NOT NULL AUTO_INCREMENT,
    exchange VARCHAR(50),
    symbol VARCHAR(10) UNIQUE,
    shortname VARCHAR(100),
    longname VARCHAR(255),
    sector VARCHAR(100),
    industry VARCHAR(100),
    currentprice DECIMAL(10,2),
    marketcap BIGINT,
    ebitda BIGINT,
    revenuegrowth DECIMAL(5,2),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    fulltimeemployees INT,
    longbusinesssummary TEXT,
    weight DECIMAL(5,2),
    PRIMARY KEY (id)
);
```

### sp500_index
```sql
CREATE TABLE sp500_index (
    date DATE NOT NULL,
    value DECIMAL(10,2),
    PRIMARY KEY (date)
);
```

### sp500_stocks
```sql
CREATE TABLE sp500_stocks (
    id INT NOT NULL AUTO_INCREMENT,
    date DATE NOT NULL,
    symbol VARCHAR(10) NOT NULL,
    adj_close DECIMAL(10,2),
    close DECIMAL(10,2),
    high DECIMAL(10,2),
    low DECIMAL(10,2),
    open DECIMAL(10,2),
    volume BIGINT,
    PRIMARY KEY (id)
);
```



## Data Import
### sp500_companies
```sql
LOAD DATA INFILE '/ruta/al/archivo/sp500_companies.csv'
INTO TABLE sp500_companies
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11, @col12, @col13, @col14, @col15, @col16)
SET
    exchange = @col1,
    symbol = @col2,
    shortname = @col3,
    longname = @col4,
    sector = @col5,
    industry = @col6,
    currentprice = NULLIF(@col7, ''),
    marketcap = NULLIF(@col8, ''),
    ebitda = NULLIF(@col9, ''),
    revenuegrowth = NULLIF(@col10, ''),
    city = @col11,
    state = @col12,
    country = @col13,
    fulltimeemployees = NULLIF(@col14, ''),
    longbusinesssummary = @col15,
    weight = NULLIF(@col16, '');
```

### sp500_index
```sql
LOAD DATA INFILE '/ruta/al/archivo/sp500_index.csv'
INTO TABLE sp500_index
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@col1, @col2)
SET
    date = STR_TO_DATE(@col1, '%Y-%m-%d'),
    value = @col2;
```

### sp500_stocks
```sql
LOAD DATA INFILE '/ruta/al/archivo/sp500_stocks.csv'
INTO TABLE sp500_stocks
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8)
SET
    date = STR_TO_DATE(@col2, '%Y-%m-%d'),
    symbol = @col1,
    adj_close = NULLIF(@col3, ''),
    close = NULLIF(@col4, ''),
    high = NULLIF(@col5, ''),
    low = NULLIF(@col6, ''),
    open = NULLIF(@col7, ''),
    volume = NULLIF(@col8, '');
```

## Highlighted Queries
1. Companies with the highest market capitalization.
   ```sql
   SELECT symbol, shortname, marketcap 
   FROM sp500_companies 
   ORDER BY marketcap DESC 
   LIMIT 10;
   ```

2. Companies with the highest revenue growth
   ```sql
   SELECT symbol, shortname, revenuegrowth 
   FROM sp500_companies 
   ORDER BY revenuegrowth DESC 
   LIMIT 10;
   ```

3. Comparison of adjusted closing prices of companies on a specific date
   ```sql
   SELECT c.symbol, c.shortname, s.date, s.adj_close
   FROM sp500_companies c
   JOIN sp500_stocks s ON c.symbol = s.symbol
   WHERE s.date = '2023-01-01';
   ```

4. Show rows with at least one NULL value in sp500_stocks
   ```sql
    SELECT * FROM sp500_stocks 
    WHERE adj_close IS NULL 
       OR close IS NULL 
       OR high IS NULL 
       OR low IS NULL 
       OR open IS NULL 
       OR volume IS NULL;
   ```

5. Average adjusted closing price per sector
   ```sql
    SELECT c.sector, AVG(s.adj_close) AS avg_adj_close
    FROM sp500_companies c
    JOIN sp500_stocks s ON c.symbol = s.symbol
    GROUP BY c.sector
    ORDER BY avg_adj_close DESC;
   ```

6. Top 5 companies with the highest EBITDA
   ```sql
    SELECT symbol, shortname, ebitda 
    FROM sp500_companies 
    ORDER BY ebitda DESC 
    LIMIT 5;
   ```

7. Daily average volume traded for each stock
   ```sql
    SELECT symbol, AVG(volume) AS avg_volume
    FROM sp500_stocks
    GROUP BY symbol
    ORDER BY avg_volume DESC;
   ```

8. Percentage change in the S&P 500 index value over a specific period
   ```sql
    SELECT 
        MIN(date) AS start_date, 
        MAX(date) AS end_date,
        ((MAX(value) - MIN(value)) / MIN(value)) * 100 AS percentage_change
    FROM sp500_index
    WHERE date BETWEEN '2023-01-01' AND '2023-12-31';
   ```

9. List companies with a market cap above a certain threshold and sorted by revenue growth
   ```sql
    SELECT symbol, shortname, marketcap, revenuegrowth
    FROM sp500_companies
    WHERE marketcap > 100000000000  -- Example threshold: 100 billion
    ORDER BY revenuegrowth DESC;
   ```


10. Monthly average adjusted closing price for each stock
   ```sql
    SELECT symbol, 
           DATE_FORMAT(date, '%Y-%m') AS month, 
           AVG(adj_close) AS avg_adj_close
    FROM sp500_stocks
    GROUP BY symbol, month
    ORDER BY symbol, month;
   ```

11. Find the top 10 companies with the highest adjusted closing price on the most recent date
   ```sql
    SELECT c.symbol, c.shortname, s.adj_close
    FROM sp500_companies c
    JOIN sp500_stocks s ON c.symbol = s.symbol
    WHERE s.date = (SELECT MAX(date) FROM sp500_stocks)
    ORDER BY s.adj_close DESC
    LIMIT 10;
   ```



