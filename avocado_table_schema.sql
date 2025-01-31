-- table one
DROP TABLE IF EXISTS type;
CREATE TABLE type(
	Index INT PRIMARY KEY NOT NULL,
	type VARCHAR(20)
);

-- table two
DROP TABLE IF EXISTS region;
CREATE TABLE region(
	index INT PRIMARY KEY NOT NULL,
	region VARCHAR(50)
);

-- table three
DROP TABLE IF EXISTS market;
CREATE TABLE market(
	Index INT PRIMARY KEY NOT NULL,
	market VARCHAR(50)
);

-- table four
DROP TABLE IF EXISTS avocados;
CREATE TABLE avocados(
	index INT PRIMARY KEY NOT NULL,
	Date DATE,
	AveragePrice DOUBLE PRECISION,
	TotalVolume DOUBLE PRECISION,
	plu4046 DOUBLE PRECISION,
	plu4225 DOUBLE PRECISION,
	plu4770 DOUBLE PRECISION,
	TotalBags DOUBLE PRECISION,
	SmallBags DOUBLE PRECISION,
	LargeBags DOUBLE PRECISION,
	XLargeBags DOUBLE PRECISION,
	type_ INT,
	region_ INT,
	market_ INT,
	FOREIGN KEY (type) REFERENCES type(Index),
	FOREIGN KEY (region) REFERENCES region(Index),
	FOREIGN KEY (market) REFERENCES market(Index)
);

SELECT * FROM type;
SELECT * FROM region;
SELECT * FROM market;
SELECT * FROM avocados;