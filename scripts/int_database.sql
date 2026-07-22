/*
================================================================
Create Database and Schemas
================================================================
Script Purpose:
  This script creates a new database named 'DataWarehouse' after checking if it already exists.
  If the database exists, it is dropped and recreated. Additionally, the script sets up 3 schemas
  within the database: 'Bronze', 'silver', 'gold'

WARNING
  Running this script will drop the entire 'DataWarehouse' database if it exists.
  All data in the database will be permanently deleted. Proceed with caution
  and ensure you have proper backups before running this script
*/

Use master;
Go

-- Drop and recreate 'DataWarehouse' database
IF EXISTS (Select 1 from sys.databases where name = 'DataWarehouse')
begin
  alter database Datawarehouse set single_user with rollback immediate;
  drop database DataWarehouse;
end;
go

-- Create the 'DataWarehouse' database
create database DataWarehouse;
go

Use DataWarehouse;
go

-- create schemas
create schema bronze;
go

create schema silver;
go

create schema gold;
go
