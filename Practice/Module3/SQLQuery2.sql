DECLARE @SqlQuery nvarchar(MAX) 
SET @SqlQuery = 'SELECT * FROM '
--SET @SqlQuery = CONCAT(@SqlQuery, 'featherman.Customers')
--SET @SqlQuery += 'featherman.Customers'
EXECUTE sp_executeSQL @SqlQuery