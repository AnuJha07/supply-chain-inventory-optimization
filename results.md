# SQL Analysis Results — Supply Chain & Inventory Optimization

**Database:** `supply_chain_inventory` | **Table:** `inventory_data`
**Dataset:** 73,100 records | 5 stores | 20 products | Jan 2022 – Jan 2024

---

## Category 1: Data Verification

### Q1: Does the total record count match the original dataset?
**Tool Used:** MySQL Workbench
**Result:** 73,100 rows
**Insight:** Confirms the full dataset was imported correctly into SQL with no data loss, making it safe to proceed with analysis.

---

### Q2: How many unique stores and products exist in the dataset?
**Tool Used:** MySQL Workbench
**Result:** 5 stores, 20 products
**Insight:** Analysis covers the complete business scope defined in the dataset — no store or product is missing.

---

### Q3: Are there any rows where Units Sold exceeds Inventory Level?
**Tool Used:** MySQL Workbench
**Result:** 0 rows
**Insight:** Confirms no stock-logic violations remain in the dataset, meaning inventory KPIs calculated from it can be trusted.

---

## Category 2: Core Inventory KPIs

### Q4: What is the annualized Inventory Turnover Ratio per Product-Store combination?
**Tool Used:** MySQL Workbench
**Result:** Ratios range approximately **175–195** across all 100 product-store combinations, with minimal spread between highest and lowest performers.
**Insight:** All products turn over inventory at a similarly fast rate — no single product is a dramatic outlier. High turnover combined with low average inventory (~270-280 units) suggests the business operates on very lean stock levels company-wide.

---

### Q5: What is the average Days of Inventory (DOI) per Product-Store combination?
**Tool Used:** MySQL Workbench
**Result:** DOI ranges from **1.86 to 2.13 days** across all 100 product-store combinations.
**Insight:** This is a critical finding — current stock, on average, would be depleted within ~2 days at normal sales rates. Compared to typical retail lead times (3–7 days for restocking), this indicates the business is operating with almost no safety buffer, making it highly vulnerable to stockouts.

---

### Q6: What is the average daily demand per product?
**Tool Used:** MySQL Workbench
**Result:** Average daily demand across all 20 products ranges narrowly from **133.47 units (P0002, lowest)** to **139.12 units (P0016, highest)**.
**Insight:** Unlike typical retail portfolios, demand is fairly uniform across the product range — no single product dominates or lags significantly. This means reorder point planning can't rely on isolating a few "problem" products; the lean-inventory and volatility risks identified earlier (Q5, Q8) apply broadly across the entire catalog rather than a specific subset.

---

## Category 3: Stockout & Demand Risk

### Q7: Which specific product-store combinations have the lowest Days of Inventory (highest stockout risk)?
**Tool Used:** MySQL Workbench
**Result:**

| Product ID | Store ID | Avg Inventory | Avg Daily Sales | Days of Inventory |
|---|---|---|---|---|
| P0015 | S005 | 277.91 | 149.25 | **1.86** |
| P0020 | S002 | 276.31 | 144.11 | 1.92 |
| P0005 | S003 | 277.57 | 144.20 | 1.92 |
| P0001 | S002 | 278.34 | 145.01 | 1.92 |
| P0003 | S001 | 274.54 | 141.44 | 1.94 |
| P0018 | S002 | 272.03 | 140.19 | 1.94 |
| P0019 | S003 | 277.97 | 142.99 | 1.94 |
| P0017 | S003 | 277.15 | 143.05 | 1.94 |
| P0013 | S003 | 285.26 | 147.03 | 1.94 |
| P0011 | S004 | 271.73 | 139.74 | 1.94 |

**Insight:** P0015 at Store S005 is the single highest-priority stockout risk in the entire business, with just 1.86 days of stock on hand. This top-10 list represents the most urgent action items for inventory managers — expedited restocking or increased safety stock should be prioritized here first, ahead of the rest of the ~2-day-average portfolio.

---

### Q8: Which products show the highest variability (volatility) in daily units sold?
**Tool Used:** MySQL Workbench
**Result:** Top products (e.g., P0009, P0007, P0020) show average daily sales of ~134–139 units with a standard deviation of ~108–111 units — volatility nearly as large as the average itself (~80% coefficient of variation).
**Insight:** Demand is highly unpredictable across the board, not just low on average. Combined with the ~2-day inventory buffer (Q5), even a single above-average demand day could trigger a stockout. This makes demand volatility, not static overstock, the primary operational risk.

---

### Q9: For each product, is demand systematically under-forecasted or over-forecasted?
**Tool Used:** MySQL Workbench
**Result:** All 20 products show a **negative average forecast error**, ranging from -4.76 (P0020) to -5.29 (P0018) — every single product is being **over-forecasted**.

| Product ID | Avg Forecast Error | Direction |
|---|---|---|
| P0018 | -5.29 | Over-forecasted |
| P0013 | -5.21 | Over-forecasted |
| P0003 | -5.17 | Over-forecasted |
| P0001 | -5.16 | Over-forecasted |
| P0004 | -5.15 | Over-forecasted |
| ... | ... | ... |
| P0020 | -4.76 | Over-forecasted |

**Insight:** This is a consistent, company-wide pattern rather than an isolated issue with a few products — every product's demand forecast is set slightly higher than actual sales (by ~4.8 to 5.3 units on average). This seems counter-intuitive alongside the stockout risk found in Q5/Q7 (DOI ~2 days). The likely explanation: forecasts are modestly over-predicted, but the business still orders/stocks conservatively relative to that forecast, resulting in tight inventory despite over-forecasting demand. This suggests the disconnect isn't in the forecasting model's direction, but in how forecast outputs translate into actual stock ordering — a gap worth flagging for the supply chain/ordering process.

---

## Category 4: Revenue & Business Performance

### Q10: Which products generate the highest total revenue?
**Tool Used:** MySQL Workbench
**Result:**

| Product ID | Total Revenue (₹) |
|---|---|
| P0020 | 28,306,192.40 |
| P0011 | 28,155,025.56 |
| P0016 | 28,153,328.38 |
| P0014 | 28,110,375.77 |
| P0005 | 27,916,663.02 |
| P0013 | 27,914,863.65 |
| P0015 | 27,742,249.64 |
| P0009 | 27,675,549.22 |
| P0007 | 27,632,505.00 |
| P0001 | 27,477,692.24 |

**Insight:** P0020 is the top revenue-generating product over the 2-year period, though the top 10 products are tightly clustered (~₹27.4M–₹28.3M), consistent with the earlier finding that demand is fairly uniform across the catalog (Q6). Notably, P0020, P0011, and P0015 also appear among the top stockout-risk combinations (Q7) — meaning some of the highest-revenue products are also the ones most exposed to lost sales from stockouts, making them the highest priority for inventory investment.

---

### Q11: Which stores generate the most and least revenue overall?
**Tool Used:** MySQL Workbench
**Result:**

| Store ID | Total Revenue (₹) | Total Units Sold |
|---|---|---|
| S005 | 111,713,826.32 | 2,010,176 |
| S003 | 111,318,414.04 | 2,022,696 |
| S002 | 110,062,487.59 | 1,987,715 |
| S004 | 108,947,413.59 | 1,979,245 |
| S001 | 108,186,743.37 | 1,975,750 |

**Insight:** Store performance is fairly balanced across all 5 locations, with only a ~3% gap between the highest (S005) and lowest (S001) performing stores in revenue. S005 leads in revenue despite S003 selling more units — suggesting S005 either sells a higher-margin product mix or benefits from slightly better average pricing. Since no store is a significant outlier, inventory strategy doesn't need major store-specific rebalancing — the risk factors found earlier (low DOI, high volatility) apply fairly evenly across all locations.

---

### Q12: Which product categories perform best in revenue and inventory efficiency?
**Tool Used:** MySQL Workbench
**Result:**

| Category | Total Revenue (₹) | Avg Inventory |
|---|---|---|
| Furniture | 111,511,804.34 | 275.82 |
| Groceries | 110,984,538.20 | 275.76 |
| Clothing | 109,651,037.00 | 274.60 |
| Toys | 109,642,444.19 | 273.65 |
| Electronics | 108,439,061.18 | 272.51 |

**Insight:** Revenue is fairly evenly distributed across all 5 categories (within ~3% of each other), with Furniture leading and Electronics trailing slightly. Average inventory levels are also nearly identical across categories, meaning no single category is being over- or under-stocked relative to the others. This confirms the inventory risk findings (low DOI, high volatility) are a business-wide issue rather than being concentrated in any one product category.

---

### Q13: How does average demand vary across seasons?
**Tool Used:** MySQL Workbench
**Result:**

| Seasonality | Avg Units Sold |
|---|---|
| Autumn | 137.78 |
| Winter | 136.83 |
| Spring | 135.83 |
| Summer | 135.43 |

**Insight:** Seasonal demand variation is minimal (only a ~1.7% difference between the highest and lowest season), with Autumn showing marginally higher demand than Summer. Unlike typical retail patterns with strong seasonal peaks (e.g. holiday season spikes), this dataset shows demand is largely season-independent — meaning inventory planning should focus more on managing day-to-day demand volatility (Q8) than on building seasonal stock reserves.

---

## Category 5: Pricing & Competitive Analysis

### Q14: Which products are priced higher than competitors, and does it correlate with lower sales?
**Tool Used:** MySQL Workbench
**Result:** *(Query adjusted to show avg price, avg competitor price, price gap, and avg units sold for full context)*

| Product ID | Avg Price | Avg Competitor Price | Avg Price Gap | Avg Units Sold |
|---|---|---|---|---|
| P0002 | 55.27 | 55.16 | **+0.11** | 133.47 |
| P0018 | 54.82 | 54.71 | +0.10 | 134.76 |
| P0005 | 55.02 | 54.98 | +0.05 | 137.80 |
| P0012 | 54.96 | 54.92 | +0.04 | 134.52 |
| P0006 | 54.77 | 54.76 | +0.01 | 136.01 |
| P0016 | 54.83 | 54.82 | +0.01 | 139.12 |
| P0004 | 55.54 | 55.54 | ~0.00 | 135.57 |
| P0009 | 55.16 | 55.16 | ~0.00 | 137.37 |
| P0003 | 54.89 | 54.90 | -0.01 | 134.96 |
| P0008 | 55.35 | 55.36 | -0.01 | 133.67 |
| P0013 | 55.06 | 55.07 | -0.01 | 136.97 |
| P0020 | 55.52 | 55.53 | -0.01 | 138.91 |
| P0001 | 54.55 | 54.59 | -0.05 | 136.27 |
| P0011 | 56.43 | 56.49 | -0.05 | 136.62 |
| P0015 | 54.77 | 54.82 | -0.05 | 138.79 |
| P0017 | 54.65 | 54.69 | -0.05 | 136.94 |
| P0019 | 55.08 | 55.13 | -0.05 | 136.22 |
| P0007 | 54.92 | 54.98 | -0.06 | 136.61 |
| P0014 | 55.76 | 55.85 | -0.09 | 138.88 |
| P0010 | 55.36 | 55.47 | -0.11 | 135.83 |

**Insight:** Price gaps versus competitors are negligible across the entire catalog (all within ±₹0.11), and there's no meaningful correlation between price gap and units sold — e.g., P0002 is the most overpriced (+0.11) yet has one of the lowest sales volumes (133.47), while P0016 is also overpriced (+0.01) but has the highest sales volume (139.12). This indicates pricing is **not** a meaningful driver of demand differences in this dataset — the stockout and volatility risks identified earlier (Q5, Q7, Q8) are not explained by competitive pricing pressure, reinforcing that the core issue is inventory/demand planning, not price positioning.

---

### Q15: Does offering a discount actually increase units sold?
**Tool Used:** MySQL Workbench
**Result:** *(Query refined to a per-product comparison of discounted vs non-discounted average units sold)*

| Product ID | Avg Discount | Discounted Units Sold | No-Discount Units Sold | Sales Difference | Sales Lift % |
|---|---|---|---|---|---|
| P0007 | 12.61 | 138.16 | 130.33 | +7.83 | **+6.01%** |
| P0001 | 12.65 | 137.62 | 130.59 | +7.04 | +5.39% |
| P0017 | 12.50 | 138.18 | 131.96 | +6.22 | +4.72% |
| P0018 | 12.63 | 135.84 | 130.17 | +5.67 | +4.36% |
| P0008 | 12.61 | 134.70 | 129.58 | +5.13 | +3.96% |
| P0015 | 12.36 | 139.57 | 135.52 | +4.05 | +2.99% |
| P0002 | 12.58 | 134.09 | 131.17 | +2.92 | +2.22% |
| P0011 | 12.22 | 137.28 | 134.19 | +3.10 | +2.31% |
| P0012 | 12.43 | 134.99 | 132.64 | +2.35 | +1.77% |
| P0013 | 12.60 | 137.32 | 135.61 | +1.71 | +1.26% |
| P0016 | 12.51 | 139.36 | 138.13 | +1.23 | +0.89% |
| P0009 | 12.63 | 137.62 | 136.31 | +1.30 | +0.96% |
| P0003 | 12.45 | 135.09 | 134.44 | +0.66 | +0.49% |
| P0020 | 12.52 | 138.79 | 139.37 | -0.59 | -0.42% |
| P0004 | 12.71 | 134.87 | 138.20 | -3.33 | -2.41% |
| P0005 | 12.48 | 136.91 | 141.16 | -4.25 | -3.01% |
| P0010 | 12.49 | 135.03 | 139.16 | -4.14 | -2.97% |
| P0014 | 12.42 | 138.04 | 142.34 | -4.30 | -3.02% |
| P0019 | 12.55 | 135.00 | 141.11 | -6.11 | -4.33% |
| P0006 | 12.48 | 134.63 | 141.65 | -7.02 | -4.96% |

**Insight:** Discount impact is inconsistent and mostly negligible across the catalog — 13 of 20 products show a positive sales lift (ranging from a marginal +0.49% up to +6.01%), while 7 products actually show *lower* sales on discounted days (down to -4.96%), despite discounts averaging ~12.5% across the board. There is no clear, universal pattern that discounting drives higher sales. This suggests the current blanket discount strategy is not consistently effective and is eroding margin on nearly a third of the catalog without a corresponding sales benefit — a strong candidate for a targeted, product-specific discount review rather than a uniform approach.

---

## Key Business Recommendations

1. **Increase safety stock buffers, prioritizing top revenue-at-risk products first.** With average Days of Inventory at just ~2 days company-wide (Q5) and demand volatility nearly as large as average demand itself (Q8), the business operates with almost no cushion against demand spikes. Products like P0015 (Store S005, 1.86 DOI) and P0020/P0011 — which rank among both the highest-revenue (Q10) and highest-risk (Q7) combinations — should be the first priority for increased buffer stock, since a stockout here carries the highest revenue impact.

2. **Investigate the gap between forecasting and ordering, rather than the forecasting model itself.** Every product is being over-forecasted (Q9, by ~4.8–5.3 units on average), yet inventory remains critically lean. This is counter-intuitive and suggests the disconnect isn't forecast accuracy — it's how forecast outputs translate into actual purchase orders. This process gap should be reviewed with the supply/ordering team.

3. **Move from a blanket discount strategy to a targeted, per-product one.** Discounting shows inconsistent results (Q15) — 7 of 20 products actually sell *fewer* units on discount days, while price positioning versus competitors shows no meaningful correlation with sales (Q14). This means a uniform ~12.5% discount is eroding margin on roughly a third of the catalog without a sales benefit. Discounts should be reserved for the products that demonstrably respond to them (e.g., P0007, P0001, P0017), not applied uniformly.

**Supporting context:** Store performance (Q11) and category performance (Q12) are both fairly balanced (within ~3% across the board), and seasonal demand variation is minimal (Q13, ~1.7% spread) — meaning these risks are systemic across the whole business rather than isolated to a specific store, category, or season, which is why the recommendations above focus on business-wide inventory and pricing process changes rather than location- or season-specific fixes.
