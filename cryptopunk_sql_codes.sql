SELECT COUNT(*) FROM cryptopunks;

SELECT name, eth_price, usd_price, event_date AS date
FROM cryptopunks
ORDER BY usd_price DESC
LIMIT 5;


SELECT event_date, usd_price, AVG(usd_price) OVER (ORDER BY event_date ASC ROWS BETWEEN 50 PRECEDING AND CURRENT ROW) AS moving_avg
FROM cryptopunks;

SELECT name, AVG(usd_price) AS average_price
FROM cryptopunks
GROUP BY name
ORDER BY average_price DESC;

SELECT DAYNAME(event_date)
FROM cryptopunks;

SELECT DAYNAME(event_date) AS day_of_week, COUNT(*) AS no_of_sales, AVG(eth_price) AS avg_eth_price
FROM cryptopunks
GROUP BY day_of_week
ORDER BY no_of_sales;

SELECT CONCAT(name, 'was sold for $', ROUND(usd_price, 3), 
' to ', buyer_address, ' by ', seller_address, ' on ', event_date) AS summary
FROM cryptopunks;

CREATE VIEW 1919_purchases AS
SELECT * FROM cryptopunks1919_purchases1919_purchases1919_purchases
WHERE buyer_address = 0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685;

(SELECT name, MIN(usd_price) AS price, 'lowest' AS status 
FROM cryptopunks
GROUP BY name)
UNION (SELECT name, MAX(usd_price) AS price, 'highest' AS status 
FROM cryptopunks
GROUP BY name)
ORDER BY name, status ASC;


SELECT year, month, name, avg_price FROM (
SELECT YEAR(event_date) AS year,
	   MONTH(event_date) AS month,
       name, AVG(usd_price) AS avg_price, 
       RANK() OVER (PARTITION BY YEAR(event_date), MONTH(event_date) ORDER BY COUNT(*) DESC) AS rank_most_sold 
FROM cryptopunks
GROUP BY year, month) AS t;

SELECT YEAR(event_date) AS year, MONTH(event_date) AS month,
ROUND(SUM(usd_price), -2) AS sum_monthly_sales
FROM cryptopunks
GROUP BY year, month
ORDER BY year, month ASC;

SELECT COUNT(*)
FROM cryptopunks
WHERE buyer_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685' OR
	 seller_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685';

CREATE TEMPORARY TABLE avg_daily_price AS
SELECT event_date, usd_price, AVG(usd_price) OVER (PARTITION BY event_date) AS avg_daily_price
FROM cryptopunks;

SELECT event_date, AVG(usd_price) AS estimated_avg_daily
FROM avg_daily_price
WHERE usd_price > 0.9 * avg_daily_price AND usd_price < 1.1 * avg_daily_price
GROUP BY event_date;

SELECT t1.buyer_address AS wallet, ROUND(total_selling_price - total_buying_price,2) AS profit 
FROM
(SELECT buyer_address, SUM(usd_price) AS total_buying_price
FROM cryptopunks
GROUP BY buyer_address) t1
JOIN 
(SELECT seller_address, SUM(usd_price) AS total_selling_price
FROM cryptopunks
GROUP BY seller_address) t2
ON t1.buyer_address = t2.seller_address
ORDER BY profit ASC;

SELECT 
CONCAT(ROUND(eth_price, -2),'-', LEAD(ROUND(eth_price, -2)) OVER (ORDER BY ROUND(eth_price, -2))) AS bins,
COUNT(*) AS count
FROM cryptopunks
GROUP BY ROUND(eth_price, -2)
ORDER BY ROUND(eth_price, -2) ASC