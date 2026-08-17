-- PROGRAM 3: ALTER STUDENT TABLE

USE CollegeDB;

-- Add Email VARCHAR(30)


-- Add PhoneNumber


-- Display modified table structure
USE CollegeDB;

ALTER TABLE Student
ADD Email VARCHAR(30);

ALTER TABLE Student
ADD PhoneNumber INT;

DESCRIBE Student;
