/*
Cleaning data in sql queries
*/

select *
from PortfolioProject.dbo.nashvilleHousing


--Standardise data format

select SaleDateConverted,cast(saledate as date)--[convert(date,saledate)]
from nashvilleHousing

alter table nashvilleHousing
add saledateConverted date;

update nashvilleHousing
set SaleDateConverted=convert(date,saledate)

--EXEC sp_rename 'nashvilleHousing.saledataConverted', 'SaleDateConverted', 'COLUMN';

---------------------------------------------------------------------------------------------------------------------


--populate property Address data

select *
from PortfolioProject.dbo.nashvilleHousing
--where propertyaddress is null 
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.propertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.nashvilleHousing a
join PortfolioProject.dbo.nashvilleHousing b
on a.parcelID=b.ParcelID AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress=isnull(a.propertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.nashvilleHousing a
join PortfolioProject.dbo.nashvilleHousing b
on a.parcelID=b.ParcelID AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

select * from nashvilleHousing



--Breaking out Address into Individual columns(Address,City,State)

select PropertyAddress
from PortfolioProject.dbo.nashvilleHousing
--where propertyaddress is null 
--order by ParcelID

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as address
from PortfolioProject.dbo.nashvilleHousing


select PropertySplitAddress
from nashvilleHousing

alter table nashvilleHousing
add PropertySplitAddress varchar(225)

update nashvilleHousing
set PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

alter table nashvilleHousing
add PropertySplitCity varchar(225)

update nashvilleHousing
set PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) 

select * 
from PortfolioProject.dbo.nashvilleHousing




select ownerAddress 
from PortfolioProject.dbo.nashvilleHousing


select 
PARSENAME(Replace(ownerAddress, ',' ,'.') , 3),
PARSENAME(Replace(ownerAddress, ',' ,'.') , 2),
PARSENAME(Replace(ownerAddress, ',' ,'.') , 1)
from PortfolioProject.dbo.nashvilleHousing 


alter table nashvilleHousing
add ownerSplitAddress varchar(225)

update nashvilleHousing
set ownerSplitAddress=PARSENAME(Replace(ownerAddress, ',' ,'.') , 3)

alter table nashvilleHousing
add ownerSplitCity varchar(225)

update nashvilleHousing
set ownerSplitCity=PARSENAME(Replace(ownerAddress, ',' ,'.') , 2)

alter table nashvilleHousing
add ownerSplitState varchar(225)

update nashvilleHousing
set ownerSplitState=PARSENAME(Replace(ownerAddress, ',' ,'.') , 1)

select *
from PortfolioProject.dbo.nashvilleHousing


--Change Y AND N to	Yes and NO in Solid as Vacant' Field

Select Distinct(SoldAsVacant),Count(SoldAsVacant) 
from PortfolioProject.dbo.nashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
,CASE When SoldAsVacant='Y' then 'Yes'
	  When SoldAsVacant='N' then 'No'
	  ELSE SoldAsVacant
	  END
from PortfolioProject.dbo.nashvilleHousing


Update nashvilleHousing
set SoldAsVacant=CASE When SoldAsVacant='Y' then 'Yes'
	  When SoldAsVacant='N' then 'No'
	  ELSE SoldAsVacant
	  END



-------------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates
with RowNumCTE as(
select *,
ROW_NUMBER() over(
PARTITION BY ParcelID,
			 PropertyAddress,
			 Saleprice,
			 saleDate,
			 LegalReference
			 ORDER BY
			  uniqueID
			  ) row_num
from PortfolioProject.dbo.nashvilleHousing
--order by ParcelID
)
select *
from RowNumCTE
Where row_num>1
order by PropertyAddress



------------------------------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused data

select *
from PortfolioProject.dbo.nashvilleHousing

ALTER TABLE PortfolioProject.dbo.nashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE PortfolioProject.dbo.nashvilleHousing
DROP COLUMN SaleDate