USE AdventureWorks2019;


-- 1. Find the unique job titles in the company

SELECT DISTINCT(JobTitle)
FROM HumanResources.Employee

-- 2. Find first name, last name phone number and phone number type for all people

SELECT Person.FirstName, Person.LastName, Phone.PhoneNumber, PhoneNumberType.Name PhoneNumberType
FROM Person.Person Person
LEFT JOIN Person.PersonPhone Phone
ON Person.BusinessEntityID = Phone.BusinessEntityID
LEFT JOIN Person.PhoneNumberType PhoneNumberType
ON Phone.PhoneNumberTypeID = PhoneNumberType.PhoneNumberTypeID

-- 3. Find first name, last name, city, state and country

SELECT Person.FirstName, Person.LastName, Address.City, StateProvince.Name, CountryRegion.Name
FROM Person.Person Person
LEFT JOIN Person.BusinessEntityAddress BusinessEntityAddress
ON Person.BusinessEntityID = BusinessEntityAddress.BusinessEntityID
LEFT JOIN Person.Address Address
ON BusinessEntityAddress.AddressID = Address.AddressID
LEFT JOIN Person.StateProvince StateProvince
ON Address.StateProvinceID = StateProvince.StateProvinceID
LEFT JOIN Person.CountryRegion CountryRegion 
ON StateProvince.CountryRegionCode = CountryRegion.CountryRegionCode

-- 4. Find amount of people per country, ordered descending by the amount

SELECT CountryRegion.Name, COUNT(*) AmountOfPeople
FROM Person.Person Person
LEFT JOIN Person.BusinessEntityAddress BusinessEntityAddress
ON Person.BusinessEntityID = BusinessEntityAddress.BusinessEntityID
LEFT JOIN Person.Address Address
ON BusinessEntityAddress.AddressID = Address.AddressID
LEFT JOIN Person.StateProvince StateProvince
ON Address.StateProvinceID = StateProvince.StateProvinceID
LEFT JOIN Person.CountryRegion CountryRegion 
ON StateProvince.CountryRegionCode = CountryRegion.CountryRegionCode
GROUP BY CountryRegion.Name
ORDER BY AmountOfPeople DESC

-- 5. Find the first name, last name and the job title of all employees

SELECT Person.FirstName, Person.LastName, Employee.JobTitle
FROM Person.Person Person
LEFT JOIN HumanResources.Employee Employee
ON Person.BusinessEntityID = Employee.BusinessEntityID
WHERE Person.PersonType != 'IN'

-- 6. Employee first name, last name and his current department

SELECT Person.FirstName, Person.LastName, Department.Name
FROM Person.Person Person
LEFT JOIN HumanResources.Employee Employee
ON Person.BusinessEntityID = Employee.BusinessEntityID
LEFT JOIN HumanResources.EmployeeDepartmentHistory EmployeeDepartmentHistory
ON Person.BusinessEntityID = EmployeeDepartmentHistory.BusinessEntityID
LEFT JOIN HumanResources.Department Department
ON EmployeeDepartmentHistory.DepartmentID = Department.DepartmentID
WHERE Person.PersonType != 'IN' AND Employee.CurrentFlag = 1

-- 7. Number of currently hired people per department

SELECT Department.Name, COUNT(*) CurrentlyHired
FROM Person.Person Person
LEFT JOIN HumanResources.Employee Employee
ON Person.BusinessEntityID = Employee.BusinessEntityID
LEFT JOIN HumanResources.EmployeeDepartmentHistory EmployeeDepartmentHistory
ON Person.BusinessEntityID = EmployeeDepartmentHistory.BusinessEntityID
LEFT JOIN HumanResources.Department Department
ON EmployeeDepartmentHistory.DepartmentID = Department.DepartmentID
WHERE Person.PersonType != 'IN' AND Employee.CurrentFlag = 1
GROUP BY Department.Name

-- 8. Find people (first name, last name) that were hired in more than one department

SELECT Person.FirstName, Person.LastName
FROM HumanResources.Employee Employee
LEFT JOIN Person.Person Person
ON Employee.BusinessEntityID = Person.BusinessEntityID
LEFT JOIN HumanResources.EmployeeDepartmentHistory EmployeeDepartmentHistory
ON Employee.BusinessEntityID = EmployeeDepartmentHistory.BusinessEntityID
GROUP BY Person.FirstName, Person.LastName
HAVING COUNT(DISTINCT EmployeeDepartmentHistory.DepartmentID) > 1;

-- 9. Employee first name, last name and the current hourly salary

SELECT Person.BusinessEntityID, Person.FirstName, Person.LastName, EmployeePayHistory.Rate, EmployeePayHistory.ModifiedDate
FROM HumanResources.Employee Employee
LEFT JOIN Person.Person Person
ON Employee.BusinessEntityID = Person.BusinessEntityID
LEFT JOIN HumanResources.EmployeePayHistory EmployeePayHistory
ON Employee.BusinessEntityID = EmployeePayHistory.BusinessEntityID
WHERE Person.PersonType != 'IN' AND Employee.CurrentFlag = 1 
		AND EmployeePayHistory.ModifiedDate = (SELECT MAX(EmployeePayHistory2.ModifiedDate) 
												FROM HumanResources.EmployeePayHistory EmployeePayHistory2 
												WHERE Person.BusinessEntityID = EmployeePayHistory2.BusinessEntityID)

-- 10. Find employees that have above average vacation hours

SELECT Person.FirstName, Person.LastName, Employee.VacationHours
FROM HumanResources.Employee Employee
LEFT JOIN Person.Person Person
ON Employee.BusinessEntityID = Person.BusinessEntityID
WHERE Person.PersonType != 'IN' 
	AND Employee.CurrentFlag = 1 
	AND Employee.VacationHours > (SELECT AVG(Employee2.VacationHours) FROM HumanResources.Employee Employee2)