--
-- Create Database: University
--

--CREATE DATABASE University2;
--USE University2;


--
-- Table structure for table 'Staff'
--

CREATE TABLE Staff (
  StaffNo int NOT NULL IDENTITY(1,1),
  StaffFirstName varchar(255) NOT NULL,
  StaffLastName varchar(255) NOT NULL,
  StaffRegion varchar(255) NOT NULL,
  PRIMARY KEY (StaffNo)
);


--
-- Table structure for table 'Student'
--

CREATE TABLE Student (
  StudentID int NOT NULL IDENTITY(1,1),
  StudentFirstName varchar(255) NOT NULL,
  StudentLastName varchar(255) NOT NULL,
  RegisteredDate datetime NOT NULL,
  StudentRegion varchar(255) NOT NULL,
  StaffNo int NOT NULL,
  CONSTRAINT fk1_staff_no FOREIGN KEY (StaffNo) REFERENCES Staff (StaffNo),
  PRIMARY KEY (StudentID)
);


--
-- Table structure for table 'Course'
--

CREATE TABLE Course (
  CourseCode int NOT NULL IDENTITY(1,1),
  Title varchar(255) NOT NULL,
  Credit int NOT NULL CONSTRAINT check_credit CHECK (Credit=15 OR Credit=30),
  Quota int NOT NULL,
  StaffNo int NOT NULL,
  CONSTRAINT fk2_staff_no FOREIGN KEY (StaffNo) REFERENCES Staff (StaffNo),
  PRIMARY KEY (CourseCode)
);


--
-- Table structure for table 'Enrollment'
--

CREATE TABLE Enrollment (
  StudentID int NOT NULL,
  CourseCode int NOT NULL,
  EnrolledDate datetime NOT NULL,
  FinalGrade int,
  CONSTRAINT fk1_student_id FOREIGN KEY (StudentID) REFERENCES Student (StudentID),
  CONSTRAINT fk1_course_code FOREIGN KEY (CourseCode) REFERENCES Course (CourseCode),
  PRIMARY KEY (StudentID, CourseCode)
);


--
-- Table structure for table 'Assignment'
--

CREATE TABLE Assignment (
  StudentID int NOT NULL,
  CourseCode int NOT NULL,
  AssignmentNo int NOT NULL,
  Grade int NOT NULL CONSTRAINT check_grade CHECK (Grade BETWEEN 0 AND 100),
  CONSTRAINT fk_student_course FOREIGN KEY (StudentID, CourseCode) REFERENCES Enrollment (StudentID, CourseCode),
  PRIMARY KEY (StudentID, CourseCode, AssignmentNo)
);

