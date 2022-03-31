/*

Cleaning Data in MS SQL Server

*/

SELECT *
FROM NashvillePortfolio.dbo.nashvillehousing;

--------------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT SaleDate, CONVERT(DATE,SALEDATE)
FROM NashvillePortfolio.dbo.nashvillehousing;

ALTER TABLE nashvillehousing
ADD SaleDateConverted DATE;

Update nashvillehousing
SET SaleDateConverted = CONVERT(DATE,SaleDate);

SELECT SaleDateConverted, CONVERT(DATE,SALEDATE)
FROM NashvillePortfolio.dbo.nashvillehousing;

-- New Column Created with Sale Date Standardized

--------------------------------------------------------------------------------------------------

-- Populate Property Address Data

SELECT *
FROM NashvillePortfolio.dbo.nashvillehousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvillePortfolio.dbo.nashvillehousing a
JOIN NashvillePortfolio.dbo.nashvillehousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvillePortfolio.dbo.nashvillehousing a
JOIN NashvillePortfolio.dbo.nashvillehousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;


--------------------------------------------------------------------------------------------------

-- Breaking Out Address Into Individual Columns

SELECT PropertyAddress
FROM NashvillePortfolio.dbo.nashvillehousing
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID
;

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
CHARINDEX(',', PropertyAddress),
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +2, LEN(PropertyAddress))  AS City
FROM NashvillePortfolio.dbo.nashvillehousing;

-- Data That Needs To Be Split Is Identified

ALTER TABLE nashvillehousing
ADD PropertySplitAddress NVARCHAR(255);

Update nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE nashvillehousing
ADD PropertySplitCity NVARCHAR(255);

Update nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +2, LEN(PropertyAddress));

-- Data Is Split Into New Columns

/*
Alternative Split Method
*/

SELECT OwnerAddress
FROM NashvillePortfolio.dbo.nashvillehousing;

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM NashvillePortfolio.dbo.nashvillehousing;

-- Data That Needs To Be Split Is Identified

ALTER TABLE nashvillehousing
ADD OwnerSplitAddress NVARCHAR(255);

Update nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3);

ALTER TABLE nashvillehousing
ADD OwnerSplitCity NVARCHAR(255);

Update nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2);

ALTER TABLE nashvillehousing
ADD OwnerSplitState NVARCHAR(255);

Update nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1);

SELECT OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
FROM NashvillePortfolio.dbo.nashvillehousing;

-- Data Is Split Into New Columns

--------------------------------------------------------------------------------------------------

-- Change Y And N To Yes And No In "Sold As Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvillePortfolio.dbo.nashvillehousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM NashvillePortfolio.dbo.nashvillehousing;

UPDATE nashvillehousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END;

-- Data Successfully Standardized

--------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH  RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
			ORDER BY UniqueID) row_num
FROM NashvillePortfolio.dbo.nashvillehousing
-- ORDER BY ParcelID;
)
SELECT *
FROM RowNumCTE
WHERE Row_num > 1;
-- ORDER BY PropertyAddress

-- Duplicate Data Identified

WITH  RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
			ORDER BY UniqueID) row_num
FROM NashvillePortfolio.dbo.nashvillehousing
-- ORDER BY ParcelID;
)
DELETE
FROM RowNumCTE
WHERE Row_num > 1;


-- Duplicate Data Deleted

--------------------------------------------------------------------------------------------------

/*  Delete Superfluous Columns
	Now That SaleDate, OwnerAddress, and PropertyAddress Have Been Standardized
*/

ALTER TABLE NashvillePortfolio.dbo.nashvillehousing
DROP COLUMN SaleDate, OwnerAddress, PropertyAddress;

SELECT *
FROM NashvillePortfolio.dbo.nashvillehousing;

--------------------------------------------------------------------------------------------------
