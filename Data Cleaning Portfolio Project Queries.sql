/* 
Cleaning Data in SQL Queries
*/

Select * from PortfolioProject.dbo.NashvilleHousing

------------------------------------------------------------------------------------------------------------------------------------------------------

--Standardize Date Format

Select SaleDate, CONVERT(Date,SaleDate) 
from PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDate Date;
Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

--------------------------------------------------------------------------------------------------------------------------------------------------

--Populate Property Address Data

Select * from PortfolioProject.dbo.NashvilleHousing 
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID  = b.ParcelID
AND a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


Update a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID  = b.ParcelID
AND a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------------------------------


--Breaking out Address into individual Columns (Address,City, State)
Select PropertyAddress from PortfolioProject.dbo.NashvilleHousing 
--Where PropertyAddress is null
--order by ParcelID


Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address 

from PortfolioProject.dbo.NashvilleHousing 



 Select OwnerAddress from PortfolioProject.dbo.NashvilleHousing


 Select PARSENAME(REPLACE(OwnerAddress,',', '.'),3) 
 ,PARSENAME(REPLACE(OwnerAddress,',', '.'),2) 
 ,PARSENAME(REPLACE(OwnerAddress,',', '.'),1) 
 from PortfolioProject.dbo.NashvilleHousing

 Select PARSENAME(OwnerAddress,1) from PortfolioProject.dbo.NashvilleHousing 
 ------------------------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes AND NO in "Sold" as Vacant Field

 Select Distinct(SoldAsVacant),Count(SoldAsVacant) from PortfolioProject.dbo.NashvilleHousing 
 Group by (SoldAsVacant)
 Order by 2


 Select SoldAsVacant,
 CASE When SoldASVacant = 'Y' THEN 'YES'
      When SoldASVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant 
	  END 
from PortfolioProject.dbo.NashvilleHousing 



Update NashvilleHousing
SET SoldAsVacant = CASE When SoldASVacant = 'Y' THEN 'YES'
                        When SoldASVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant 
	  END

	  ------------------------------------------------------------------------------------------------- -----------------------------------------------
	  --ReMove Duplicates
	 WITH RowNumCTE As( 
	  
	  Select *,
	  ROW_NUMBER() OVER (
	  PARTITION BY ParcelID,
	  PropertyAddress,
	  Saleprice,
	  SaleDate,
	  LegalReference
	  ORDER BY 
	  UniqueID
	  ) row_num
	  from PortfolioProject.dbo.NashvilleHousing 
	  --Order by ParcelID
	  )
	  Select * from RowNumCTE
	  Where row_num > 1
	  Order by PropertyAddress




	  ------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns

Select * from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress




































