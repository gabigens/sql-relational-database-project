# SQL Relational Database Project

## About the project

This project was developed as part of a practical SQL exercise focused on the fundamentals of relational databases and data analysis.

The database contains information related to an e-commerce business, including companies, transactions, users, credit cards, and products. The project covers the creation and manipulation of relational databases, as well as analytical queries using SQL.

## Objectives

The main objectives of this project were to:

- Review the fundamentals of relational databases
- Create and structure database tables
- Define primary and foreign keys
- Load data from SQL and CSV files
- Establish relationships between tables
- Retrieve and analyze data using SQL
- Practice different types of queries and SQL techniques

## Database Structure

The project works with two database structures.

### Transactions database

The initial database contains:

- `company` — company information
- `transaction` — transaction records

A one-to-many relationship exists between `company` and `transaction`, where one company can have multiple transactions.

A `credit_card` table was later added and related to the transactions.

### Transactions star database

A second database, `transactions_star`, was created using data from several CSV files.

The main tables are:

- `company`
- `user`
- `credit_card`
- `transaction`

The `transaction` table acts as the central table connecting the other tables. Users from the American and European datasets were combined into a single `user` table, with an additional `region` column to distinguish them.

A `product` table and an intermediate `join_transaction_product` table were later created to connect the product data with the transactions.

## SQL Concepts Practiced

### Database and table creation

- `CREATE DATABASE`
- `CREATE TABLE`
- `ALTER TABLE`
- Primary keys
- Foreign keys

### Data loading and manipulation

- `LOAD DATA INFILE`
- `INSERT`
- `UPDATE`
- `DELETE`
- `DROP COLUMN`

### Data querying

- `SELECT`
- `WHERE`
- `DISTINCT`
- `ORDER BY`
- `GROUP BY`
- `HAVING`
- `LIMIT`
- Aggregate functions such as `COUNT()` and `AVG()`
- `CASE`
- `CONVERT()`
- `ROUND()`

### Table relationships

- `JOIN`
- Foreign key relationships
- Intermediate tables

### Subqueries

The project includes subqueries for:

- Filtering transactions by company location
- Identifying companies with transactions above the overall average
- Finding companies without registered transactions
- Identifying users with more than 80 transactions
- Filtering transactions belonging to a specific company

### Views

A `VistaMarketing` view was created to provide company information together with the average purchase amount, excluding declined transactions.

### Window functions

The project also introduces the use of:

- `ROW_NUMBER()`
- `PARTITION BY`

These were used to identify the three most recent transactions for each credit card and determine whether each card should be classified as active or inactive.

### Working with product IDs

The `transaction` table contains `product_ids`, which can represent multiple products associated with a transaction.

To connect these IDs with the `product` table, an intermediate table was created using:

- `FIND_IN_SET()`
- `REPLACE()`

This allowed the product information to be associated with individual transactions.

## Project Structure

```text
.
├── Tasca S2.01. Nocions bàsiques SQL.sql
├── Tasca S2.01. Nocions bàsiques SQL.pdf
└── README.md
