-- Select all data from the Nashville table
SELECT * FROM Nashville;

-- Join Nashville table on ParcelID and unique ID to find and update records where PropertyAddress is missing
SELECT 
    a.ParcelID, a.PropertyAddress, 
    b.ParcelID, b.PropertyAddress, 
    ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Nashville a 
JOIN Nashville b 
    ON a.ParcelID = b.ParcelID 
    AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress IS NULL;

-- Update PropertyAddress with values from another record if it is missing
UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Nashville a 
JOIN Nashville b 
    ON a.ParcelID = b.ParcelID 
    AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress IS NULL;

-- Select records where PropertyAddress is still missing after the update
SELECT *
FROM Nashville 
WHERE PropertyAddress IS NULL;

-- Delete records with missing PropertyAddress
DELETE FROM Nashville
WHERE PropertyAddress IS NULL;

----------------------------------------------------------------------------------------------------

-- Parsing the PropertyAddress into components such as number, street, city, and state
SELECT
    PropertyAddress,
    LEFT(PropertyAddress, CHARINDEX(' ', PropertyAddress + ' ') - 1) AS Property_a_num, -- Extract house number
    TRIM(
        REPLACE(
            PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2), -- Extract street
            TRIM(LEFT(PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2), CHARINDEX(' ', PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2)))),
            ''
        )
    ) AS Property_a_street,
    PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1) AS Property_a_city -- Extract city
FROM Nashville;

-- Adding new columns for Property Address components
ALTER TABLE Nashville
ADD P_A_num VARCHAR(10), -- Adding house number column
    P_A_street VARCHAR(150), -- Adding street column
    P_A_city VARCHAR(150); -- Adding city column

-- Updating the new columns with data from PropertyAddress
UPDATE Nashville
SET P_A_num = TRY_CAST(LEFT(PropertyAddress, CHARINDEX(' ', PropertyAddress + ' ') - 1) AS INT);

UPDATE Nashville
SET P_A_street = 
    TRIM(
        REPLACE(
            PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2),
            TRIM(LEFT(PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2), CHARINDEX(' ', PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2)))),
            ''
        )
    );

UPDATE Nashville
SET P_A_city = PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1);

-- Drop the original PropertyAddress column
ALTER TABLE Nashville
DROP COLUMN PropertyAddress;

----------------------------------------------------------------------------------------------------

-- Parsing the OwnerAddress into components
SELECT
    OwnerAddress,
    LEFT(OwnerAddress, CHARINDEX(' ', OwnerAddress + ' ') - 1) AS Owner_a_num, -- Extract house number
    TRIM(SUBSTRING(OwnerAddress, CHARINDEX(' ', OwnerAddress)+1, CHARINDEX(',', OwnerAddress)- CHARINDEX(' ', OwnerAddress)-1)) AS Owner_a_street, -- Extract street name
    TRIM(
        REPLACE(
            PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2), -- Extract city
            TRIM(LEFT(PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2), CHARINDEX(' ', PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)))),
            ''
        )
    ) AS Owner_a_city,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS Owner_a_state -- Extract state
FROM Nashville;

-- Adding new columns for Owner Address components
ALTER TABLE Nashville
ADD Owner_a_num VARCHAR(10),
    Owner_a_street VARCHAR(150),
    Owner_a_city VARCHAR(150),
    Owner_a_state VARCHAR(150);

-- Extracting and updating data for Owner Address columns
UPDATE Nashville
SET Owner_a_num = LEFT(OwnerAddress, CHARINDEX(' ', OwnerAddress + ' ') - 1);

UPDATE Nashville
SET Owner_a_street = TRIM(SUBSTRING(OwnerAddress, CHARINDEX(' ', OwnerAddress)+1, CHARINDEX(',', OwnerAddress)- CHARINDEX(' ', OwnerAddress)-1));

UPDATE Nashville
SET Owner_a_street = 
    CASE 
        WHEN CHARINDEX(' ', OwnerAddress) > 0 AND CHARINDEX(',', OwnerAddress) > CHARINDEX(' ', OwnerAddress)
        THEN TRIM(SUBSTRING(OwnerAddress, CHARINDEX(' ', OwnerAddress)+1, CHARINDEX(',', OwnerAddress)- CHARINDEX(' ', OwnerAddress)-1))
        ELSE NULL
    END;

UPDATE Nashville
SET Owner_a_city = 
        TRIM(
        REPLACE(
            PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
            TRIM(LEFT(PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2), CHARINDEX(' ', PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)))),
            ''
        )
    );

UPDATE Nashville
SET Owner_a_state = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

-- Drop the original OwnerAddress column
ALTER TABLE Nashville
DROP COLUMN OwnerAddress;

----------------------------------------------------------------------------------------------------

-- Select records from Nashville table
SELECT * FROM Nashville;

-- Group by SoldAsVacant and count occurrences
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Nashville
GROUP BY SoldAsVacant
ORDER BY 2;


-- Update SoldAsVacant with 'Yes' and 'No' instead of 'Y' and 'N'
SELECT SoldAsVacant, COUNT(SoldAsVacant) AS COUNT,
    CASE 
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END
FROM Nashville
WHERE SoldAsVacant IN ('Y', 'N')
GROUP BY SoldAsVacant;

-- Update SoldAsVacant with 'Yes' or 'No' values
UPDATE Nashville
SET SoldAsVacant = 
        CASE 
            WHEN SoldAsVacant = 'Y' THEN 'Yes'
            WHEN SoldAsVacant = 'N' THEN 'No'
            ELSE SoldAsVacant
        END;

-- Deleting records where SoldAsVacant is not 'Yes' or 'No'
DELETE FROM Nashville
WHERE SoldAsVacant NOT IN ('Yes', 'No');

----------------------------------------------------------------------------------------------------

-- Select duplicate records based on multiple fields, marking them with row numbers
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY ParcelID, LandUse, SaleDate, SalePrice, LegalReference, SoldAsVacant, 
                     OwnerName, TaxDistrict, Bedrooms, FullBath, HalfBath, 
                     P_A_num, P_A_street, P_A_city, Owner_a_num, Owner_a_street, 
                     Owner_a_city, Owner_a_state
        ORDER BY UniqueID
    ) AS RowNum
    FROM Nashville
)
SELECT *
FROM CTE
WHERE RowNum > 1;

-- Delete duplicates based on the given criteria
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY ParcelID, LandUse, SaleDate, SalePrice, LegalReference, SoldAsVacant, 
                     OwnerName, Acreage, TaxDistrict, Bedrooms, FullBath, HalfBath, 
                     P_A_num, P_A_street, P_A_city, Owner_a_num, Owner_a_street, 
                     Owner_a_city, Owner_a_state
        ORDER BY UniqueID
    ) AS RowNum
    FROM Nashville
)
DELETE FROM Nashville
WHERE UniqueID IN (SELECT UniqueID FROM CTE WHERE RowNum > 1);

----------------------------------------------------------------------------------------------------

-- Select all records after changes
SELECT * FROM Nashville;

-- Update OwnerName to 'Unknown' where it is NULL
UPDATE Nashville
SET OwnerName = 'Unknown'
WHERE OwnerName IS NULL;
