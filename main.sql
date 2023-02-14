-- First part:

CREATE TABLE Departments
(
	Name varchar(20) NOT NULL,
	ID char(5) PRIMARY KEY,
	Budget numeric(12,2),
	Category varchar(15) Check (Category in 
	('Engineering' , 'Science'))

);


CREATE TABLE Teachers
(
	FirstName varchar(20) NOT NULL,
	LastName varchar(30) NOT NULL,
	ID char(7),
	BirthYear int,
	DepartmentID char(5),
	Salary numeric(7,2) Default 10000.00,
	PRIMARY KEY (ID), 
	FOREIGN KEY (DepartmentID) REFERENCES Departments(ID)
);


CREATE TABLE Students
(
	FirstName varchar(20) NOT NULL,
	LastName varchar(30) NOT NULL, 
	StudentNumber char(7) PRIMARY KEY,
	BirthYear int,
	DepartmentID char(5),
	AdvisorID char(7), 
	FOREIGN KEY (DepartmentID) REFERENCES Departments(ID),
	FOREIGN KEY (AdvisorID) REFERENCES Teachers(ID)

);


ALTER TABLE Students
	ADD NumberOfPassedCourse int

CREATE TABLE Courses
(
	ID char(7) PRIMARY KEY,
	Title varchar(20) NOT NULL,
	Credits int,
	DepartmentID char(5),
	FOREIGN KEY (DepartmentID) REFERENCES Departments(ID) 
);


CREATE TABLE Available_Courses(
	CourseID char(7),
	Semester varchar(15) check (Semester in 
	('fall','spring')),
	Year int,
	ID char(7) PRIMARY KEY,
	TeacherID char(7),
	FOREIGN KEY(CourseID) REFERENCES Courses(ID),
	FOREIGN KEY(TeacherID) REFERENCES Teachers(ID),

);


CREATE TABLE Taken_Courses
(
	StudentID char(7),
	CourseID char(7),
	Semester varchar(15) Check (Semester in 
	('Fall','Spring')),
	
	Year int,

	Grade numeric(5,2) NOT NULL Default 00.00,

	FOREIGN KEY (StudentID) REFERENCES Students(StudentNumber) ,
	FOREIGN KEY (CourseID) REFERENCES Courses(ID)
 
);


CREATE TABLE Prerequisites
(
	CourseID char(7),
	PrereqID char(7),

	FOREIGN KEY (CourseID) REFERENCES Courses(ID),
	FOREIGN KEY (PrereqID) REFERENCES Courses(ID)
 
);

INSERT INTO DepartMents (Name,ID,Budget) VALUES ('Computer engineering', 'CE',2000.00);
INSERT INTO DepartMents (Name,ID,Budget) VALUES ('Elec engineering', 'EE',3000.00);

INSERT INTO Teachers (FirstName,LastName,ID,BirthYear,DepartmentID) VALUES ('Arsalan', 'Yavari', '123', 20, 'CE');
INSERT INTO Teachers (FirstName,LastName,ID,BirthYear,DepartmentID) VALUES ('Adrian', 'Yavari', '321', 20, 'EE');

INSERT INTO Students(FirstName,LastName,StudentNumber,BirthYear,DepartmentID,AdvisorID) VALUES ('alaki','palaki','9999',18,'CE','123');
INSERT INTO Students(FirstName,LastName,StudentNumber,BirthYear,DepartmentID,AdvisorID) VALUES ('kharaki','paraki','8888',18,'CE','321');
INSERT INTO Students(FirstName,LastName,StudentNumber,BirthYear,DepartmentID,AdvisorID) VALUES ('Skyler','Adriano','123',18,'CE','123');

INSERT INTO Courses(ID,Title,Credits ,DepartmentID) Values ('123','DB',3,'CE');
INSERT INTO Courses(ID,Title,Credits ,DepartmentID) Values ('124','CloudComputing',3,'CE');

INSERT INTO Available_Courses (CourseID,Semester,Year,ID,TeacherID) Values ('123','Fall',2023,'1','123');
INSERT INTO Available_Courses (CourseID,Semester,Year,ID,TeacherID) Values ('124','Spring',2000,'2','321');

INSERT INTO Taken_Courses(StudentID,CourseID,Semester,Year,Grade) VALUES ('9999','123','Fall',2023,80.00);
INSERT INTO Taken_Courses(StudentID,CourseID,Semester,Year,Grade) VALUES ('8888','124','Spring',2000,100.00);


--------------------------------------------------------------------------------

-- Second part:

SELECT DepartMents.Name, DepartMents.ID ,DepartMents.Budget , DepartMents.Category 
From Students INNER JOIN DepartMents ON (Students.DepartmentID = DepartMents.ID)  
WHERE Students.StudentNumber = '123' ;


UPDATE Taken_Courses SET Grade = Grade+1; 
SELECT Taken_Courses.Grade+1 from Taken_Courses;


SELECT FirstName,LastName,StudentNumber 
FROM Students inner join Taken_Courses on (Students.StudentNumber=Taken_Courses.StudentID) 
WHERE (Taken_Courses.CourseID<>'db');
