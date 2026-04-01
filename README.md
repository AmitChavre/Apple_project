# Apple_project

# Apple Retail Sales SQL Project - Analyzing Millions of Sales Rows

# Project Overview
This project is designed to showcase advanced SQL querying techniques through the analysis of over 1 million rows of Apple retail sales data. The dataset includes information about products, stores, sales transactions, and warranty claims across various Apple retail locations globally. By tackling a variety of questions, from basic to complex, you'll demonstrate your ability to write sophisticated SQL queries that extract valuable insights from large datasets.

# Database Schema
The project uses five main tables:

stores: Contains information about Apple retail stores.

store_id: Unique identifier for each store.
store_name: Name of the store.
city: City where the store is located.
country: Country of the store.
category: Holds product category information.

category_id: Unique identifier for each product category.
category_name: Name of the category.
products: Details about Apple products.

product_id: Unique identifier for each product.
product_name: Name of the product.
category_id: References the category table.
launch_date: Date when the product was launched.
price: Price of the product.
sales: Stores sales transactions.

sale_id: Unique identifier for each sale.
sale_date: Date of the sale.
store_id: References the store table.
product_id: References the product table.
quantity: Number of units sold.
warranty: Contains information about warranty claims.

claim_id: Unique identifier for each warranty claim.
claim_date: Date the claim was made.
sale_id: References the sales table.
repair_status: Status of the warranty claim


#  Objectives
1. Find the number of stores in each country.
2. Calculate the total number of units sold by each store.
3. Identify how many sales occurred in December 2023.
4. Determine how many stores have never had a warranty claim filed.
5. Calculate the percentage of warranty claims marked as "Warranty Void".
6. Identify which store had the highest total units sold in the last year.
7. Count the number of unique products sold in the last year.
8. Find the average price of products in each category.
9. How many warranty claims were filed in 2020?
10. For each store, identify the best-selling day based on highest quantity sold.
11. Identify the least selling product in each country for each year based on total units sold.
12 Calculate how many warranty claims were filed within 180 days of a product sale
13.Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.
14.Analyze product sales trends over time, segmented into key periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.




