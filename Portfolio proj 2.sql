/* Standardising date format*/
SELECT SaleDateConverted
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;
 
Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

SELECT SaleDate, SaleDateConverted
 FROM NashvilleHousing

/* Populate Propery Address data*/
SELECT *
FROM NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM NashvilleHousing A
JOIN NashvilleHousing B
	on A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress is null

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM NashvilleHousing A
JOIN NashvilleHousing B
	on A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress is null

-- Breaking out address into individual Columns (Address, City, State)
SELECT PropertyAddress
FROM NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as CleanAddress
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255)
 
Update NashvilleHousing
SET PropertySplitAddress =  SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);
 
Update NashvilleHousing
SET  PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT * 
FROM NashvilleHousing

-- Uniformising columns
SELECT Distinct(SoldAsVacant)
FROM NashvilleHousing

SELECT SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'YES'
	When SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
	When SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END

-- REMOVING DUPLICATES
WITH RowNUMCte AS (
SELECT *,
	ROW_NUMBER()  OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
					) row_num
FROM NashvilleHousing
--DER BY ParcelID
)
SELECT *
FROM RowNUMCte
WHERE row_num > 1

--- Delete Unused Columns
SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, TaxDistrict, SaleDate

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate