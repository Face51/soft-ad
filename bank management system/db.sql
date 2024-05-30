CREATE DATABASE bankdb;

-- Use the created database
USE bankdb;

-- Create the accounts table
CREATE TABLE accounts (
    accNo VARCHAR(14) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    accType CHAR(1) NOT NULL,
    deposit DECIMAL(10, 2) NOT NULL
);