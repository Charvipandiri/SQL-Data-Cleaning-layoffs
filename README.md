# SQL Data Cleaning Project – World Layoffs Dataset

## Project Overview

This project demonstrates a complete SQL data cleaning workflow using the World Layoffs dataset. The objective was to transform raw data into a clean and analysis-ready dataset by removing duplicates, standardizing values, handling missing data, and converting data types.

The project was completed using MySQL Workbench.

---

## Dataset

* **Dataset:** Layoffs Dataset
* **Source:** Kaggle
* **Database:** MySQL

---

## Objectives

* Create staging tables to preserve the original data.
* Identify and remove duplicate records.
* Standardize inconsistent values.
* Handle missing values.
* Convert the date column to the correct data type.
* Remove unnecessary records.
* Prepare the dataset for Exploratory Data Analysis (EDA).

---

## Data Cleaning Process

### 1. Created Staging Tables

* Created a staging table from the original dataset.
* Created a second staging table for duplicate removal.

### 2. Removed Duplicate Records

* Used the `ROW_NUMBER()` window function.
* Deleted duplicate records while preserving the first occurrence.

### 3. Standardized Data

* Removed leading and trailing spaces from company names.
* Standardized Crypto-related industry values.
* Removed trailing periods from country names.
* Converted the `date` column from text to the `DATE` data type.

### 4. Handled Missing Values

* Converted blank industry values to `NULL`.
* Populated missing industries using a self-join where possible.

### 5. Removed Unnecessary Data

* Deleted records where both `total_laid_off` and `percentage_laid_off` were `NULL`.
* Dropped the helper `row_num` column after cleaning.

---

## SQL Concepts Used

* Window Functions (`ROW_NUMBER()`)
* Common Table Concepts
* Self Joins
* String Functions (`TRIM`)
* Date Functions (`STR_TO_DATE`)
* UPDATE Statements
* DELETE Statements
* ALTER TABLE
* Data Cleaning Techniques

---

## Final Results

* Duplicate records removed.
* Company names standardized.
* Industry values standardized.
* Country names standardized.
* Date column converted to `DATE`.
* Missing industry values populated where possible.
* Invalid records removed.
* Dataset prepared for Exploratory Data Analysis.

---

## Files

* `Data_Cleaning.sql` – Complete SQL data cleaning script.
* `README.md` – Project documentation.

---

## Next Step

The cleaned dataset will be used for Exploratory Data Analysis (EDA) to identify trends and insights from global layoffs.

---

## Author

**Charvi**

Aspiring Data Analyst | SQL | Python | Power BI | Tableau

