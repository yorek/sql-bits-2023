-- Data stored in relational format, as usual
select * from dbo.users;
select * from dbo.user_addresses;
select * from dbo.user_phones;
go

-- Turn relational data into a JSON document
select 
	u.firstName,
	u.lastName,
	u.isAlive,
	u.age,
	[address].streetAddress,
	[address].city,
	[address].[state],
	[address].postalCode,
    json_query((select [type], [number] from dbo.user_phones up where up.user_id = u.id for json auto)) as phones
from 
	dbo.users u 
inner join 
	dbo.user_addresses as [address] on u.id = [address].[user_id] 
for 
	json auto
go

-- Data has been saved as JSON documents
select * from dbo.users_json;
go

-- Get name from the first document
declare @json varchar(max)
select top (1) @json = json_data from dbo.users_json where id = 1
select @json;
select json_value(@json, '$.firstName')	
go

-- Get JSON data 
declare @json varchar(max)
select top (1) @json = json_data from dbo.users_json where id = 2
select @json;
select json_query(@json, '$.children')	
go

-- Extract JSON data as Key-Value pairs
declare @json varchar(max)
select top (1) @json = json_data from dbo.users_json where id = 2
select @json;
select * from openjson(@json, '$.children')	
go

-- Extract JSON data as a table
declare @json varchar(max)
select top (1) @json = json_data from dbo.users_json where id = 2
select @json;
select * from openjson(@json) with
    (
        FirstName nvarchar(50) '$.firstName',
        LastName nvarchar(50) '$.lastName',
        Age int '$.age',
        [State] nvarchar(50) '$.address.state'
    ) as t
go

-- Use CROSS APPLY to extract data from
-- all rows containing JSON document (note that document with id=3 contains 2 users, not only 1)
select
    j.id as document_id,
    t.*
from
    dbo.users_json as j
cross apply
    openjson(j.json_data) with
    (
        FirstName nvarchar(50) '$.firstName',
        LastName nvarchar(50) '$.lastName',
        Age int '$.age',
        [State] nvarchar(50) '$.address.state'
    ) as t