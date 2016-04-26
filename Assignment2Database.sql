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
capacity SMALLINT CHECK(capacity BETWEEN 1 AND 8),
PRIMARY KEY(make, model)
);

--By registration number does it mean the numbers on the form or the license plate?
CREATE TABLE CarShareDB.Car (
regno CHAR(6),
name VARCHAR(20) NOT NULL UNIQUE,
year SMALLINT, -- Use smallint since date takes in day values
transmission -- enums here since only a few types
make VARCHAR(20) NOT NULL,
model VARCHAR(20) NOT NULL,
carBayName VARCHAR(50) NOT NULL,
PRIMARY KEY (regno),
FOREIGN KEY (make, model) REFERENCES CarModel(make, model),
FOREIGN KEY (carBayName) REFERENCES CarBay(name)
);




CREATE TABLE CarShareDB.CarBay (
name VARCHAR(50),
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
INSERT INTO CarModel VALUES('Nissan','Pulsar','Sedan',5);
INSERT INTO CarModel VALUES('Toyota','Corolla','Hatch',5);
INSERT INTO CarModel VALUES('Bac','Mono','Sports',1);
INSERT INTO CarModel VALUES('Chrysler','Sebring','Sedan',5);

-- INSERT INTO CarModel VALUES('Nissan','Maxima',NULL,5); -- Violate NOT NULL CONSTRAINT
-- INSERT INTO CarModel VALUES('Toyota','Corolla','Hatch',0); -- Violate MIN boundary for capacity
-- INSERT INTO CarModel VALUES('Bac','Mono','Sports',9); -- Violate MAX boundary for capacity
-- INSERT INTO CarModel VALUES('Chrysler','Sebring','Sedan',5);

--Car
INSERT INTO Car VALUES('CPG71D','DaPuffness',2005,'Fully Automatic','Nissan','Pulsar','Sydney Uni Footbridge');
INSERT INTO Car VALUES('PG4ET1','Wizzbang',2015,'Manual','Toyota','Corolla','Spencer Street Carpark');
INSERT INTO Car VALUES('SKYBLU','NotACar',2009,'Fully Automatic','Bac','Mono','Parramatta Westfield');
INSERT INTO Car VALUES('BTE016','SuperCar',1990,'Fully Automatic','Chrysler','Sebring','Sydney Uni Library');

-- Incorrect Input
-- INSERT INTO Car VALUES('CPG71D','DaPuffness',2005,'Fully Automatic',NULL,'Pulsar','Sydney Uni Footbridge'); NULL Make
-- INSERT INTO Car VALUES('PG4ET1','Wizzbang',2015,'Manual','Toyota','NULL','Spencer Street Carpark'); NULL Model
-- INSERT INTO Car VALUES('SKYBL$','NotACar',2009,'Fully Automatic','Bac','Mono','Parramatta Westfield Hey I'm too long to actually work'); Out of bounds input
-- INSERT INTO Car VALUES('BTE01667','SuperCar',1990,'Fully Automatic','Chrysler','Sebring','Sydney Uni Library'); Regno input out of bounds

--CarBay
INSERT INTO CarBay VALUES('Sydney Uni Footbridge','34 fake street Sydney Uni','Parking spot 3 at Sydney Uni','-33.889,151.185','CPG71D');
INSERT INTO CarBay VALUES('Spencer Street Carpark','10 Street Street Puffmead','Parking spot 10 at Puffmead Station','-34.850457,159.185385','PG4ET1');
INSERT INTO CarBay VALUES('Parramatta Westfield','155 Parramatta Westfield','Parking spot 102 at Parramatta Westfield','-180.0,180.0','SKYBLU');
INSERT INTO CarBay VALUES('Sydney Uni Library','857 Fake Street Sydney Uni','Parking spot 41 at Sydney Uni','-33.34,151.56','BTE016');


--Booking
INSERT INTO Booking VALUES('12/04/2016','04:00 PM','03:00','CPG71D','boxcutting@gmail.com','2016-03-19 10:23:54+02');
INSERT INTO Booking VALUES('12/03/2016','09:00 AM','08:00','PG4ET1','myemail@gmail.com','2016-02-03 13:23:54+02');
INSERT INTO Booking VALUES('21/04/2016','08:00 AM','12:00','SKYBLU','skyblu@gmail.com','2016-04-10 10:44:30+02');
INSERT INTO Booking VALUES('18/05/2016','11:00 AM','6:00','BTE016','bte016@gmail.com','2016-05-10 09:21:30+02');

-- INSERT INTO Booking VALUES('12/04/2016','04:00 PM','3:30','CPG71D','boxcutting@gmail.com','2016-03-19 10:23:54+02'); Duration must be rounded to hour
-- INSERT INTO Booking VALUES('12/04/2016','04:00 PM','8:00','PG4ET1','myemail@gmail.com','2016-02-03 13:23:54+02'); Same booking date
-- INSERT INTO Booking VALUES('21/04/2016','08:00 AM','12:00','SKYBLU',NULL,'2016-04-10 10:44:30+02'); NULL email
-- INSERT INTO Booking VALUES('18/05/2016','11:00 AM','6:00','NULL,'bte016@gmail.com','2016-05-10 09:21:30+02'); No Regno

--Member
INSERT INTO Member VALUES('boxcutting@gmail.com','safepassword','Dapuffness','Mr','Smith','William','412XYZ1','123 Not fake street Moorepark','01/01/1993','2014-03-19 10:23:54+02','Concession','Sydney Uni Footbridge');
INSERT INTO Member VALUES('myemail@gmail.com','password1','WillsPass','Miss','Mack','Smack','552ZA2','44 Apple Street Sutherland','01/04/1994','2015-04-28 11:00:33+02','Adult','Spencer Street Carpark');
INSERT INTO Member VALUES('skyblu@gmail.com','password2','OtherPass','Ms','Georges','George','A41S2451','12 New Street Parramatta','03/11/1980','2015-11-11 11:00:33+02','Corporate','Parramatta Westfield');
INSERT INTO Member VALUES('bte016@gmail.com','password3','lastpass','Mr','Kate','Michael','24145XA','94 New Chatswood Drive Chatswood','16/10/1940','2014-12-12 10:00:33+02','Senior','Sydney Uni Library');


--Phone Numbers
INSERT INTO PhoneNumbers VALUES('boxcutting@gmail.com','0431182921');
INSERT INTO PhoneNumbers VALUES('myemail@gmail.com','0424605999');
INSERT INTO PhoneNumbers VALUES('skyblu@gmail.com','0445523984');
INSERT INTO PhoneNumbers VALUES('bte016@gmail.com','0452331924');


--Membership Plan
INSERT INTO MembershipPlan VALUES('Concession','30.00','5.00','2.00','45','1','150');
INSERT INTO MembershipPlan VALUES('Adult','50.00','7.00','3.00','65','2','150');
INSERT INTO MembershipPlan VALUES('Corporate','45.00','6.00','2.00','55','1.5','250');
INSERT INTO MembershipPlan VALUES('Senior','30.00','4.00','2.00','45','1','150');

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
