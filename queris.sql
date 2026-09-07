-- ============================================
-- Q1: Does the total record count match the original dataset?
select count(*) from inventory_data; 



-- ============================================
-- Q2: How many unique stores and products exist in the dataset?
select count(distinct `Store ID`) as stores ,
count(distinct`Product ID`) as product 
from inventory_data;


-- ============================================
-- Q3: Are there any rows where Units Sold exceeds Inventory Level?
select count(*) 
from inventory_data
where `Units Sold` > `Inventory Level`;

-- CATEGORY 2 — Core Inventory KPIs

-- ============================================
-- Q4 : Annual Turnover Ratio per Product per Store

SELECT `Product ID`,`Store ID`,
       SUM(`Units Sold`) AS total_sold,
       round (AVG(`Inventory Level`) ,2)AS avg_inventory,
      round( (SUM(`Units Sold`) / AVG(`Inventory Level`)) /2 ,2) AS turnover_ratio
FROM inventory_data
GROUP BY `Product ID` ,`Store ID` 
ORDER BY turnover_ratio DESC;

-- ============================================
-- Q5: What is the average Days of Inventory (DOI) for each 
--     Product-Store combination?

select `Product ID` , `Store ID`,
Round (avg(`Inventory Level`),2) as avg_inventory ,
round ( avg(`Units Sold`),2) as avg_unitsold ,
round (avg(`Inventory Level`)/avg(`Units Sold`),2) as days_ofinventory 
from inventory_data
group by `Product ID` , `Store ID`
order by days_ofinventory asc;


-- ============================================
-- Q6: What is the average daily demand for each product 
--     (across all stores)?

select `Product ID`,
round (avg(`Units Sold`),2) as avg_sold 
from inventory_data
group by `Product ID`
order by avg_sold;

-- CATEGORY 3 — Stockout & Overstock Risk

-- ============================================
-- Q7: Which product-store combinations are at highest stockout risk?

SELECT `Product ID`, `Store ID`,
       ROUND(AVG(`Inventory Level`), 2) AS avg_inventory,
       ROUND(AVG(`Units Sold`), 2) AS avg_daily_sales,
       ROUND(AVG(`Inventory Level`) / AVG(`Units Sold`), 2) AS days_of_inventory
FROM inventory_data
GROUP BY `Product ID`, `Store ID`
HAVING days_of_inventory < 2
ORDER BY days_of_inventory asc limit 10;

-- ============================================
-- Q8: Which products show the highest variability (volatility) 
--     in daily units sold?

select `Product ID`,
round (avg(`Units Sold`),2)as avg_unitsold,
round(stddev(`Units Sold`),2)as sales_volatility 
from inventory_data
group by `Product ID` 
order by sales_volatility desc
limit 15;


-- ============================================
-- Q9: For each product, is demand being systematically 
--     under-forecasted or over-forecasted?

select `Product ID`,
round(avg(`Forecast Error`),2) as avg_forecastError ,
case 
when avg(`Forecast Error`) > 0 then 'Under-forecast (stockout risk)' 
when avg(`Forecast Error`) < 0 then 'over-forecast (Excess stock orderd)'
else 'Accurate'
end as forecast_direction 
from inventory_data
group by `Product ID`
order by abs(avg(`Forecast Error`)) desc;



-- CATEGORY 4 — Revenue & Business Performance
-- ============================================
-- Q10: Which products generate the highest total revenue?

select `Product ID` , 
round(sum(`Created Revenue`),2) as total_revenue 
from inventory_data
group by `Product ID`
order by total_revenue desc
limit 10;

-- ============================================
-- Q11: Which stores generate the most and least revenue overall?

SELECT `Store ID`,
       ROUND(SUM(`Created Revenue`), 2) AS total_revenue,
       SUM(`Units Sold`) AS total_units_sold
FROM inventory_data
GROUP BY `Store ID`
ORDER BY total_revenue DESC;

-- ============================================
-- Q12: Which product categories perform best in terms of revenue 
--      and inventory efficiency?

select `Category`,
round(sum(`Created Revenue`),2) as total_revenue ,
round(avg(`Inventory Level`) ,2) as avg_inventory 
from inventory_data
group by `Category`
order by total_revenue desc
limit 10 ;

-- ============================================
-- Q13: How does average demand vary across seasons?

select `Seasonality`,
round(avg(`Units Sold`),2) as avg_sold 
from inventory_data
group by `Seasonality`
order by avg_sold desc
limit 10 ;

-- CATEGORY 5 — Pricing & Competitive Analysis
 --  ============================================

-- Q14: Which products are priced higher than competitors, and does
--      it correlate with lower sales?

select `Product ID`,
round(avg(`Price`),2) as avg_price,
round(avg(`Competitor Pricing`),2 ) as avg_competitor_price ,
round(avg(`Price Gap`),2) as avg_price_gap,
round(avg(`Units Sold`),2) as avg_unit_sold
from inventory_data
group by `Product ID`
order by  avg_price_gap desc;


-- ============================================
-- Q15: Does offering a discount actually increase units sold?
SELECT
    `Product ID`,

    ROUND(AVG(CASE
        WHEN `Discount` > 0 THEN `Discount`
    END), 2) AS avg_discount,

    ROUND(AVG(CASE
        WHEN `Discount` > 0 THEN `Units Sold`
    END), 2) AS discounted_units_sold,

    ROUND(AVG(CASE
        WHEN `Discount` = 0 THEN `Units Sold`
    END), 2) AS no_discount_units_sold,

    ROUND(
        AVG(CASE
            WHEN `Discount` > 0 THEN `Units Sold`
        END)
        -
        AVG(CASE
            WHEN `Discount` = 0 THEN `Units Sold`
        END),
        2
    ) AS sales_difference,

    ROUND(
        (
            AVG(CASE
                WHEN `Discount` > 0 THEN `Units Sold`
            END)
            -
            AVG(CASE
                WHEN `Discount` = 0 THEN `Units Sold`
            END)
        )
        /
        NULLIF(
            AVG(CASE
                WHEN `Discount` = 0 THEN `Units Sold`
            END),
            0
        ) * 100,
        2
    ) AS sales_lift_percentage

FROM inventory_data

GROUP BY `Product ID`

ORDER BY sales_lift_percentage DESC;
