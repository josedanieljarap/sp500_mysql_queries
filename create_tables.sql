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


CREATE TABLE sp500_index (
    date DATE NOT NULL,
    value DECIMAL(10,2),
    PRIMARY KEY (date)
);


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
