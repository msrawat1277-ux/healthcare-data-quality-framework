-- =====================================
-- Healthcare Data Cleaning Project
-- Presenter : Mukul Singh Rawat
-- Description: Data Quality Framework
-- =====================================


create database Healthcare;
use Healthcare;
select * from healthcare;

# DATA PROFILING 
SELECT COUNT(*) AS total_records FROM healthcare;

# Column Null Analysis
SELECT 
COUNT(*) AS total_records,
SUM(CASE WHEN id IS NULL OR id='' THEN 1 ELSE 0 END) AS missing_id,
SUM(CASE WHEN pregnancies IS NULL THEN 1 ELSE 0 END) AS missing_pregnancies,
SUM(CASE WHEN skinThickness IS NULL THEN 1 ELSE 0 END) AS missing_skinThickness
FROM healthcare;

# DUPLICATE DETECTION 
SELECT id, COUNT(*) AS duplicate_count
FROM healthcare
GROUP BY id
HAVING COUNT(*) > 1;

# CREATE CLEAN LAYER 

CREATE TABLE healthcare_clean AS
SELECT *
FROM healthcare;

# CLEANING PROCESS
# Remove Duplicates 
DELETE FROM healthcare_clean
WHERE id IN (
    SELECT id FROM (
        SELECT id,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY age DESC) AS rn
        FROM healthcare_clean
    ) t
    WHERE rn > 1
);
select * from healthcare;

# DATA VALIDATION SUMMARY TABLE
CREATE TABLE data_quality_summary AS
SELECT 
COUNT(*) AS total_clean_records,
SUM(CASE WHEN Glucose ='UNKNOWN' THEN 1 ELSE 0 END) AS unknown_glucose_count,
SUM(CASE WHEN age < 20 THEN 1 ELSE 0 END) AS under_age
FROM healthcare_clean;

