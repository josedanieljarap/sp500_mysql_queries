-- Loading data to the sp500_companies table from the sp500_companies.csv:
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


-- Loading data to the sp500_index table from the sp500_index.csv:
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


-- Loading data to the sp500_stocks table from the sp500_stocks.csv:
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
