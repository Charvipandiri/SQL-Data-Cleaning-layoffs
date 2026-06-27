-- ============================================================
-- SQL Data Cleaning Project - Layoffs Dataset
-- ============================================================
-- Objective:
-- Clean the raw layoffs dataset by:
-- 1. Creating staging tables
-- 2. Removing duplicate records
-- 3. Standardizing inconsistent values
-- 4. Handling missing values
-- 5. Removing unnecessary records
-- 6. Preparing the dataset for Exploratory Data Analysis (EDA)
-- ============================================================


-- ============================================================
-- Step 1: Create a staging table
-- ============================================================
SELECT * FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;


-- ============================================================
-- Step 2: Create another staging table for removing duplicates
-- ============================================================

CREATE TABLE layoffs_staging2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT,
    percentage_laid_off TEXT,
    `date` TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT,
    row_num INT
);

INSERT INTO layoffs_staging2
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY company,
                        location,
                        industry,
                        total_laid_off,
                        percentage_laid_off,
                        `date`,
                        stage,
                        country,
                        funds_raised_millions
       ) AS row_num
FROM layoffs_staging;


-- ============================================================
-- Step 3: Remove duplicate records
-- ============================================================

-- Turn off safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Delete duplicate rows
DELETE
FROM layoffs_staging2
WHERE row_num > 1;


-- ============================================================
-- Step 4: Clean and standardize the data
-- ============================================================

-- Remove leading and trailing spaces from company names
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Convert blank industries to NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Fill missing industry values using other records from the same company
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON TRIM(t1.company) = TRIM(t2.company)
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Standardize Crypto industry values
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Remove trailing period from country names
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Convert date column to DATE datatype
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- ============================================================
-- Step 5: Remove unnecessary records
-- ============================================================

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


-- ============================================================
-- Step 6: Remove the helper column
-- ============================================================

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


-- ============================================================
-- Step 7: Verify the cleaned data
-- ============================================================

-- Total cleaned records
SELECT COUNT(*) AS total_records
FROM layoffs_staging2;

-- Verify no duplicate records remain
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company,
                            location,
                            industry,
                            total_laid_off,
                            percentage_laid_off,
                            `date`,
                            stage,
                            country,
                            funds_raised_millions
           ) AS row_num
    FROM layoffs_staging2
) AS duplicates
WHERE row_num > 1;

-- Verify no blank industries remain
SELECT *
FROM layoffs_staging2
WHERE industry = '';

-- Verify country values are standardized
SELECT DISTINCT country
FROM layoffs_staging2
WHERE country LIKE 'United States%';

-- Check if Crypto industry values are standardized
SELECT DISTINCT industry
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- Verify date datatype
DESCRIBE layoffs_staging2;


-- ============================================================
-- Project Summary
-- ============================================================
-- Removed duplicate records
-- Cleaned company names
-- Standardized industry and country values
-- Converted the date column to DATE format
-- Filled missing industry values where possible
-- Removed unnecessary records
-- Final cleaned table: layoffs_staging2
-- ============================================================
