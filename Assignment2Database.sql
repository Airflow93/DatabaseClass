/*
*  INFO2120
*  Assignment 2 Database Schema
*  Jay Lok, William Smith, Daniel Faulkner
*/

/* delete eventually already existing tables;
 * ignore the errors if you execute this script the first time
 * Drops the schema and all objects inside of schema as well
 */
BEGIN TRANSACTION;
   DROP TABLE IF EXISTS public.CarModel CASCADE;
   DROP TABLE IF EXISTS public.Car CASCADE;
   DROP TABLE IF EXISTS public.CarBay CASCADE;
   DROP TABLE IF EXISTS public.Booking CASCADE;
   DROP TABLE IF EXISTS public.Member CASCADE;
   DROP TABLE IF EXISTS public.MembershipPlan CASCADE;
   DROP TABLE IF EXISTS public.PaymentMethod CASCADE;
   DROP TABLE IF EXISTS public.BankAccount CASCADE;
   DROP TABLE IF EXISTS public.Paypal CASCADE;
   DROP TABLE IF EXISTS public.CreditCard CASCADE;
   DROP SCHEMA IF EXISTS CarShareDB CASCADE;  
COMMIT;

-- This creates the schema and initiates all transactions at once until COMMIT;
BEGIN TRANSACTION;

CREATE SCHEMA CarShareDB;

-- Searches user path then public then schema
SET search_path = '$user', public, CarShareDB;

CREATE TYPE transmission AS ENUM (
'Manual',
'Fully Automatic'
'Semi-Automatic'
'Continuously Variable'
);

--REMEMBER TO DO DOMAIN CONSTRAINT ON THE VALUES OF THESE KIDS
--ALSO MAKE SURE TO DO COMPOSITE TYPING CUZ YA A BEAST
CREATE TYPE pos AS (
latitude DECIMAL,
longtitude DECIMAL
)

CREATE TABLE CarShareDB.CarModel (
make VARCHAR(20),
model VARCHAR(20),
category VARCHAR(20) NOT NULL,
capacity SMALLINT,
PRIMARY KEY(make, model)
);

--By registration number does it mean the numbers on the form or the license plate?
CREATE TABLE CarShareDB.Car (
regno SMALLINT,
name VARCHAR(20) NOT NULL UNIQUE,
year SMALLINT, -- Use smallint since date takes in day values
transmission -- enums here since only a few types
make VARCHAR(20) NOT NULL,
model VARCHAR(20) NOT NULL,
carBayName VARCHAR(20) NOT NULL,
PRIMARY KEY (regno),
FOREIGN KEY (make, model) REFERENCES CarModel(make, model),
FOREIGN KEY (carBayName) REFERENCES CarBay(name)
);

CREATE TABLE CarShareDB.CarBay (
name VARCHAR(20),
address VARCHAR(100) NOT NULL UNIQUE, --Can't have two carbays in the same address, it would just be one
description TEXT,
pos, --Composite attribute value
regno SMALLINT NOT NULL,
PRIMARY KEY(name),
FOREIGN KEY (regno) REFERENCES Car(regno)
);

CREATE TABLE CarShareDB.Booking (
startTimeDate DATE,
startTimeHour INTEGER, --date time type
duration, --Interval
regno SMALLINT NOT NULL,
email VARCHAR(254) NOT NULL,
whenBooked TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (startTimeDate, startTimeHour),
FOREIGN KEY (email) REFERENCES Member (email)
FOREIGN KEY (regno) REFERENCES Car (regno)
);

CREATE TABLE CarShareDB.Member (
email VARCHAR(254),
password VARCHAR(20) NOT NULL, -- Check max / minimum length
nickname VARCHAR(20) NOT NULL UNIQUE,
memberTitle VARCHAR(10) NOT NULL, --mr., mrs., ms etc
familyName VARCHAR(50) NOT NULL,
givenName VarChar(50) NOT NULL, 
licenseNR VARCHAR() NOT NULL UNIQUE, --australian license length?
licenseExpiry() NOT NULL,
address VARCHAR(50) NOT NULL,
birthdate DATE NOT NULL,
since TIMESTAMP NOT NULL,
memberShipPlanTitle VARCHAR(50) NOT NULL,
carBayName VARCHAR(20) NOT NULL,
PRIMARY KEY (email),
FOREIGN KEY (carBayName) REFERENCES CarBay(name),
FOREIGN KEY (memberShipPlanTitle) REFERENCES Membership_Plan(title)
);

CREATE TABLE CarShareDB.PhoneNumbers (
email VARCHAR(254),
phoneNumber INTEGER NOT NULL, -- Phone numbers are 10 digits right? Theres no point in this table call if theres no phone number so number needs to be set not null
PRIMARY KEY(email, phoneNumber),
FOREIGN KEY (email, phoneNumber) REFERENCES Member
);

CREATE TABLE CarShareDB.MembershipPlan (
title VARCHAR(50),
monthly_fee NUMERIC,
hourly_rate NUMERIC,
km_rate NUMERIC,
daily_rate NUMERIC,
daily_km_rate NUMERIC,
daily_km_included NUMERIC,
PRIMARY KEY (title)
);

CREATE TABLE CarShareDB.PaymentMethod (
num INTEGER, --Can also use serial which is auto incrementing, however declaring unique in this case suffices
email VARCHAR(254),
PRIMARY KEY(num, email)
);

CREATE TABLE CarShareDB.BankAccount (
paymentNumber INTEGER,
paymentEmail VARCHAR(254),
name VARCHAR(50),
account NUMERIC,
bsb NUMERIC,
PRIMARY KEY(paymentNumber,paymentEmail)
FOREIGN KEY(paymentNumber, paymentEmail) REFERENCES PaymentMethod(num, email)
);

CREATE TABLE CarShareDB.Paypal (
paymentNumber INTEGER,
paymentEmail VARCHAR(254),
payPalEmail VARCHAR(254),
PRIMARY KEY(paymentNumber,paymentEmail),
);

CREATE TABLE CarShareDB.CreditCard (
cardNumber BIGINT,
paymentNumber INTEGER, 
paymentEmail VARCHAR(254),
expires DATE, --Credit cards usually only have the months and date
name VARCHAR(50),
brand VARCHAR(50), --By brand do you mean visa etc or the company such as westpac
PRIMARY KEY(paymentNumber,paymentEmail)
FOREIGN KEY(paymentNumber, paymentEmail) REFERENCES PaymentMethod(num, email)
);

/*
 *Inserting Example Data into the tables
*/
--CarModel
INSERT INTO CarModel VALUES();
INSERT INTO CarModel VALUES();
INSERT INTO CarModel VALUES();
INSERT INTO CarModel VALUES();

--Car
INSERT INTO Car VALUES();
INSERT INTO Car VALUES();
INSERT INTO Car VALUES();
INSERT INTO Car VALUES();

--CarBay
INSERT INTO CarBay VALUES();
INSERT INTO CarBay VALUES();
INSERT INTO CarBay VALUES();
INSERT INTO CarBay VALUES();

--Booking
INSERT INTO Booking VALUES();
INSERT INTO Booking VALUES();
INSERT INTO Booking VALUES();
INSERT INTO Booking VALUES();

--Member
INSERT INTO Member VALUES();
INSERT INTO Member VALUES();
INSERT INTO Member VALUES();
INSERT INTO Member VALUES();

--Phone Numbers
INSERT INTO PhoneNumbers VALUES();
INSERT INTO PhoneNumbers VALUES();
INSERT INTO PhoneNumbers VALUES();
INSERT INTO PhoneNumbers VALUES();

--Membership Plan
INSERT INTO MembershipPlan VALUES();
INSERT INTO MembershipPlan VALUES();
INSERT INTO MembershipPlan VALUES();
INSERT INTO MembershipPlan VALUES();

--Payment Method
INSERT INTO PaymentMethod VALUES();
INSERT INTO PaymentMethod VALUES();
INSERT INTO PaymentMethod VALUES();
INSERT INTO PaymentMethod VALUES();

--Bank Account
INSERT INTO BankAccount VALUES();
INSERT INTO BankAccount VALUES();
INSERT INTO BankAccount VALUES();
INSERT INTO BankAccount VALUES();

--Paypal
INSERT INTO Paypal VALUES();
INSERT INTO Paypal VALUES();
INSERT INTO Paypal VALUES();
INSERT INTO Paypal VALUES();

--Creditcard
INSERT INTO CreditCard VALUES();
INSERT INTO CreditCard VALUES();
INSERT INTO CreditCard VALUES();
INSERT INTO CreditCard VALUES();
COMMIT;