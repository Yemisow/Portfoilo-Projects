
--Cleaning Data in SQL Queries

select * from PortfolioProject..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

select saledate from PortfolioProject..NashvilleHousing


select saledate, Convert(date,saledate) from PortfolioProject..NashvilleHousing

--Update NashvilleHousing 
--Set Saledate=Convert(date,saledate)

Alter Table PortfolioProject..NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject..NashvilleHousing
Set SaleDateConverted=Convert(date,saledate)


--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
select ParcelID,PropertyAddress from PortfolioProject..NashvilleHousing
where propertyaddress is null


select a.UniqueID,a.ParcelID,a.PropertyAddress,b.UniqueID,b.ParcelID,b.PropertyAddress ,ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join
PortfolioProject..NashvilleHousing b
on a.parcelid=b.parcelid
and
a.UniqueID <>b.UniqueID
where a.PropertyAddress is null


Update a
Set a.propertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join
PortfolioProject..NashvilleHousing b
on a.parcelid=b.parcelid
and
a.UniqueID <>b.UniqueID
where a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)
--Using parsename on to split the propertyaddress

select propertyaddress from PortfolioProject..NashvilleHousing


select parsename(replace(propertyaddress,',','.'),1) from PortfolioProject..NashvilleHousing
select parsename(replace(propertyaddress,',','.'),2) from PortfolioProject..NashvilleHousing

Alter Table PortfolioProject..NashvilleHousing
Add PropertySplitAddress nvarchar (255)

Alter Table PortfolioProject..NashvilleHousing
Add PropertySplitCity nvarchar (255)


Update PortfolioProject..NashvilleHousing
Set PropertySplitAddress = parsename(replace(propertyaddress,',','.'),2)

Update PortfolioProject..NashvilleHousing
Set PropertySplitCity=parsename(replace(propertyaddress,',','.'),1) 



select OwnerAddress from PortfolioProject..NashvilleHousing


select
parsename(REPLACE(OwnerAddress,',','.'),3),
parsename(REPLACE(OwnerAddress,',','.'),2),
parsename(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject..NashvilleHousing



Alter Table PortfolioProject..NashvilleHousing
Add OwnerSplitAddress nvarchar (255)

Update PortfolioProject..NashvilleHousing
Set OwnerSplitAddress =parsename(REPLACE(OwnerAddress,',','.'),3)



Alter Table PortfolioProject..NashvilleHousing
Add OwnerSplitCity nvarchar (255)

Update PortfolioProject..NashvilleHousing
Set OwnerSplitCity =parsename(REPLACE(OwnerAddress,',','.'),2)



Alter Table PortfolioProject..NashvilleHousing
Add OwnerSplitState nvarchar (255)

Update PortfolioProject..NashvilleHousing
Set OwnerSplitState =parsename(REPLACE(OwnerAddress,',','.'),1)




select * from PortfolioProject..NashvilleHousing



--Using SUBSTRING on to split the propertyaddress


select propertyaddress from PortfolioProject..NashvilleHousing


select SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) from PortfolioProject..NashvilleHousing

select SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(OwnerAddress)) from PortfolioProject..NashvilleHousing


Alter Table PortfolioProject..NashvilleHousing
Add PropertySplitAddressNew nvarchar (255)


Update PortfolioProject..NashvilleHousing
Set PropertySplitAddressNew = SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)


Alter Table PortfolioProject..NashvilleHousing
Add PropertySplitCityNew nvarchar (255)


Update PortfolioProject..NashvilleHousing
Set PropertySplitCityNew = SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(OwnerAddress))

select * from PortfolioProject..NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field
select Distinct(SoldAsVacant) ,count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2


select SoldAsVacant,
Case 
when SoldAsVacant = 'Y' Then 'Yes'
when SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
End
from PortfolioProject..NashvilleHousing


Update PortfolioProject..NashvilleHousing
Set SoldAsVacant=Case 
when SoldAsVacant = 'Y' Then 'Yes'
when SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
End

select Distinct(SoldAsVacant),count(SoldAsVacant) 
from PortfolioProject..NashvilleHousing
group by SoldAsVacant


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
--View the duplicates
With RowNumCTE as( 
select *,ROW_NUMBER() OVER(partition by parcelID ,
PropertyAddress,SalePrice,SaleDate,LegalReference order by uniqueID
) as row_num
from PortfolioProject..NashvilleHousing
)

select * from RowNumCTE
where row_num >1
order by PropertyAddress

--Delete the duplicate row_num>1

With RowNumCTE as( 
select *,ROW_NUMBER() OVER(partition by parcelID ,
PropertyAddress,SalePrice,SaleDate,LegalReference order by uniqueID
) as row_num
from PortfolioProject..NashvilleHousing
)

Delete from RowNumCTE
where row_num >1

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

select * from PortfolioProject..NashvilleHousing

Alter Table PortfolioProject..NashvilleHousing
Drop Column PropertySplitAddressNew,PropertySplitCityNew
