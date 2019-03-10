# Database Modeling And Design Final Project
<!-- TOC -->
- [Database Modeling And Design Final Project](#database-modeling-and-design-final-project)
- [Lipscomb Database](#lipscomb-database)
    - [Question 1: Defining The Database](#question-1-defining-the-database)
        - [Create database code](#create-database-code)
        - [Primary and Foreign Key's Table](#primary-and-foreign-keys-table)
        - [Foreign Key's Deletes and Updates](#foreign-keys-deletes-and-updates)
        - [Variable Attributes](#variable-attributes)
    - [Question 2: Populating The Database](#question-2-populating-the-database)
        - [Importing Course Data](#importing-course-data)
        - [Importing Location Data](#importing-location-data)
        - [Importing Faculty Data](#importing-faculty-data)
        - [Importing Student Data](#importing-student-data)
        - [Importing Term Data](#importing-term-data)
        - [Importing Course Section Data](#importing-course-section-data)
<!-- /TOC -->

## Lipscomb Database
### Question 1: Defining The Database
#### Create database code
```sql
CREATE DATABASE IF NOT EXISTS LIPSCOMB;

USE LIPSCOMB;


/* ---------- LISPCOMB DB ---------- */


/*---------- COURSE TABLE ----------
pk: COURSE_ID | Unique identifier for the COURSE table.
                COURSE_SEC table will use COURSE_ID
                as fk.
fk: none
ric:
    on update: none
    on delete: none
*/
CREATE TABLE `COURSE` (
    `COURSE_ID` INTEGER PRIMARY KEY AUTO_INCREMENT,
    `COURSE_NO` VARCHAR(10) NOT NULL,
    `COURSE_NAME` VARCHAR(50) NOT NULL,
    `CREDITS` TINYINT NOT NULL
);


/*---------- LOCATION TABLE ----------
pk: LOC_ID | Unique identifier for LOCATION table.
             FACULTY and COURSE_SEC tables will 
             use LOC_ID as fk.
fk: none
ric:
    on update: none
    on delete: none
*/
CREATE TABLE `LOCATION` (
    `LOC_ID` INTEGER PRIMARY KEY AUTO_INCREMENT,
    `BLDG_CODE` VARCHAR(10) NOT NULL,
    `ROOM` VARCHAR(5) NOT NULL,
    `CAPACITY` INTEGER NOT NULL
);


/*---------- FACULTY TABLE ----------
pk: F_ID | Unique identifier for FACULTY table.
           STUDENT will use F_ID as fk.
fk: LOC_ID, F_SUPER
ric:
    on update: cascade | will update the student table and course_section table.
    on delete: restrict | delete is restricted for location table since
                         LOC_ID is assigned to faculty members as fk.
                         F_SUPER links back to F_ID.
*/
CREATE TABLE `FACULTY` (
    `F_ID` INTEGER PRIMARY KEY AUTO_INCREMENT,
    `F_LAST` VARCHAR(50) NOT NULL,
    `F_FIRST` VARCHAR(50) NOT NULL,
    `F_MI` VARCHAR(1),
    `F_PHONE` VARCHAR(15),
    `F_RANK` VARCHAR(30) NOT NULL,
    `F_SUPER` INTEGER,
    `F_PIN` VARCHAR(10) NOT NULL,
    `LOC_ID` INTEGER,
    FOREIGN KEY (`LOC_ID`)
        REFERENCES LOCATION (`LOC_ID`)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT
);


/*---------- STUDENT TABLE ----------
pk: S_ID
fk: F_ID
ric:
    on update: cascade  | will update the faculty table and enrollment table.
    on delete: restrict | delete is restricted to the FACULTY table since 
                         F_ID is a fk in STUDENT table.
*/
CREATE TABLE `STUDENT` (
    `S_ID` INTEGER PRIMARY KEY AUTO_INCREMENT,
    `S_LAST` VARCHAR(50) NOT NULL,
    `S_FIRST` VARCHAR(50) NOT NULL,
    `S_MI` VARCHAR(1) NOT NULL,
    `S_ADDRESS` VARCHAR(75) NOT NULL,
    `S_CITY` VARCHAR(50) NOT NULL,
    `S_STATE` VARCHAR(2) NOT NULL,
    `S_ZIP` VARCHAR(5) NOT NULL,
    `S_PHONE` VARCHAR(15) NOT NULL,
    `S_CLASS` VARCHAR(5) NOT NULL,
    `S_DOB` DATE NOT NULL,
    `S_PIN` VARCHAR(4) NOT NULL,
    `DATE_ENROLLED` DATE,
    `F_ID` INTEGER,
    FOREIGN KEY (`F_ID`)
        REFERENCES FACULTY (`F_ID`)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT
);


/*---------- TERM TABLE ----------
pk: TERM_ID
fk: none
ric:
    on update: none
    on delete: none
*/
CREATE TABLE `TERM` (
    `TERM_ID` INTEGER PRIMARY KEY AUTO_INCREMENT,
    `TERM_DESC` VARCHAR(20) NOT NULL,
    `STATUS` VARCHAR(6) NOT NULL,
    `START_DATE` DATE NOT NULL
);


/*---------- COURSE_SECTION TABLE ----------
pk: C_SEC_ID
fk: COURSE_ID, TERM_ID, F_ID, LOC_ID
ric:
    on update: cascade   | update will update the enrollment table.
    on delete: no action | delete has no action on tables COURSE,
                           TERM, FACULTY and LOCATION. Each
                           section depend on all 4 fk.
*/
CREATE TABLE `COURSE_SECTION` (
    `C_SEC_ID` INTEGER PRIMARY KEY AUTO_INCREMENT,
    `COURSE_ID` INTEGER NOT NULL,
    `TERM_ID` INTEGER NOT NULL,
    `SEC_NUM` INTEGER NOT NULL,
    `F_ID` INTEGER NOT NULL,
    `MTG_DAYS` VARCHAR(7) NOT NULL,
    `START_TIME` TIME NOT NULL,
    `END_TIME` TIME NOT NULL,
    `LOC_ID` INTEGER,
    `MAX_ENRL` INTEGER,
    FOREIGN KEY (`COURSE_ID`)
        REFERENCES COURSE (`COURSE_ID`)
        ON UPDATE CASCADE 
        ON DELETE NO ACTION,
    FOREIGN KEY (`TERM_ID`)
        REFERENCES TERM (`TERM_ID`)
        ON UPDATE CASCADE 
        ON DELETE NO ACTION,
    FOREIGN KEY (`F_ID`)
        REFERENCES FACULTY (`F_ID`)
        ON UPDATE CASCADE 
        ON DELETE NO ACTION,
    FOREIGN KEY (`LOC_ID`)
        REFERENCES LOCATION (`LOC_ID`)
        ON UPDATE CASCADE 
        ON DELETE NO ACTION
);


/*---------- ENROLLMENT TABLE ----------
pk: enr_id
fk: s_id, c_sec_id
ric:
    on update: cascade                | will update the faculty table and enrollment table.
    on delete: restrict and no action | delete is restricted on COURSE_SECTION table
                                        and no action on STUDENT table.
*/
CREATE TABLE `ENROLLMENT` (
    `ENR_ID` INTEGER PRIMARY KEY AUTO_INCREMENT,
    `S_ID` INTEGER NOT NULL,
    `C_SEC_ID` INTEGER NOT NULL,
    `GRADE` VARCHAR(5) DEFAULT NULL,
    FOREIGN KEY (`S_ID`)
        REFERENCES STUDENT (`S_ID`)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    FOREIGN KEY (`C_SEC_ID`)
        REFERENCES COURSE_SECTION (`C_SEC_ID`)
        ON UPDATE CASCADE 
        ON DELETE RESTRICT
);
```

#### Primary and Foreign Key's Table

Table|Primary Key|Foreign Key
---|---|---
LOCATION|LOC_ID|None
STUDENT|S\_ID|F\_ID => Reference to FACULTY (F_ID)
FACULTY|F\_ID|F\_SUPER => Reference to FACULTY (F_\_ID)
TERM|TERM_ID|None
COURSE|COURSE_ID|None
COURSE\_SECTION|C\_SEC_ID\_ID|COURSE\_ID => Reference to COURSE (COURSE\_ID), TERM\_ID => Reference to TERM (TERM\_ID), F\_ID => Reference to FACULTY (F\_ID), LOC\_ID => Reference to LOCATION (LOC\_ID)
ENROLLMENT|ENR\_ID|S\_ID => Reference to STUDENT (S\_ID), C\_SEC\_ID => Reference to COURSE\_SECTION (C\_SEC_ID)

#### Foreign Key's Deletes and Updates

Table|Foreign Key|Justification Description
---|---|---
Student|F_ID|Restricted delete, cascade update on Faculty when delete on Student table.
Faculty|LOC_ID|Restricted delete, cascade update on Location when delete on Faculty table.
Course Section|COURSE\_ID, TERM\_ID, F\_ID, LOC\_ID|No action delete, cascade update on Course, Term, Faculty, and Location tables.
Enrollment|S\_ID, C\_SEC\_ID|No Action delete, cascade update on Student table and restrict delete, cascade update on Course Section table.

#### Variable Attributes
> Some variables where recommended to be `string` typed and got changed something else. For instance, `START_DATE` in the `TERM` table was a `string` typed and got changed to `date` data typed. The `ENROLLMENT` table got added a unique primary key named `ENR_ID`. Also, in the `FACULTY` table, the `F_SUPER` field got converted to a foreign key that references to the primary key in the same table which is `F_ID` after inserting the data. This is done to find who is the supervisor of specific faculty member.

### Question 2: Populating The Database

> The original files containing the data were in `.doc` file. That data was transferred to `.csv` files by copy and pasting each table to a text editor (VSCode). After creating `.csv` files and the database, the `.csv` files were loaded into the database.

#### Importing Course Data

```sql
LOAD DATA LOCAL INFILE '/Users/gdiaz/gil-workspace/db-modeling-design-final-project/course.csv' 
INTO TABLE COURSE
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 2 LINES
(COURSE_ID,COURSE_NO,COURSE_NAME,CREDITS);

SELECT * FROM COURSE;
```
COURSE_ID|COURSE_NO|COURSE_NAME|CREDITS
----|----|----|----
1|IT 101|Intro. to Info. Tech.|3
2|IS 301|Systems Analysis|3
3|IT 240|Intro. to Database Systems|3
4|CS 120|Intro. To Programming in C++|3
5|IT 451|Web-Based Systems|3

#### Importing Location Data

```sql
LOAD DATA LOCAL INFILE '/Users/gdiaz/gil-workspace/db-modeling-design-final-project/location.csv' 
INTO TABLE LOCATION
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 2 LINES
(LOC_ID,BLDG_CODE,ROOM,CAPACITY);

SELECT * FROM LOCATION;
```
LOC_ID|BLDG_CODE|ROOM|CAPACITY
----|----|----|----
1|CR|101|150
2|CR|202|40
3|CR|103|35
4|CR|105|35
5|BUS|105|42
6|BUS|404|35
7|BUS|421|35
8|BUS|211|55
9|BUS|424|1
10|BUS|402|1
11|BUS|433|1
12|LIB|217|2
13|LIB|222|1

#### Importing Faculty Data

```sql
LOAD DATA LOCAL INFILE '/Users/gdiaz/gil-workspace/db-modeling-design-final-project/faculty.csv' 
INTO TABLE FACULTY
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 2 LINES
(F_ID,F_LAST,F_FIRST,F_MI,LOC_ID,F_PHONE,F_RANK,@F_SUPER,F_PIN)
SET F_SUPER = IF(@F_SUPER = '',NULL, @F_SUPER);

ALTER TABLE FACULTY
ADD FOREIGN KEY (F_SUPER)
REFERENCES FACULTY(F_ID);

SELECT * FROM FACULTY;
```
F_ID|F_LAST|F_FIRST|F_MI|F_PHONE|F_RANK|F_SUPER|F_PIN|LOC_ID
----|----|----|----|----|----|----|----|----
1|Marx|Teresa|J|3251234567|Associate|4|6339|9
2|Zhulin|Mark|M|3252345678|Full|NULL|1121|10
3|Langley|Colin|A|3253456789|Assistant|4|9871|12
4|Brown|Jonnel|D|3254567890|Full|NULL|8297|11
5|Sealy|James|L|3255678901|Associate|2|6089|13

#### Importing Student Data

```sql
LOAD DATA LOCAL INFILE '/Users/gdiaz/gil-workspace/db-modeling-design-final-project/student.csv' 
INTO TABLE STUDENT
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 2 LINES
(S_ID, S_LAST, S_FIRST, S_MI, S_ADDRESS, S_CITY, S_STATE, S_ZIP, S_PHONE, S_CLASS, @S_DOB, S_PIN, F_ID, @DATE_ENROLLED)
SET S_DOB = STR_TO_DATE(@S_DOB, '%m/%d/%y'),
DATE_ENROLLED = STR_TO_DATE(@DATE_ENROLLED, '%m/%d/%y');

SELECT * FROM STUDENT;
```

S_ID|S_LAST|S_FIRST|S_MI|S_ADDRESS|S_CITY|S_STATE|S_ZIP|S_PHONE|S_CLASS|S_DOB|S_PIN|F_ID|DATE_ENROLLED
----|----|----|----|----|----|----|----|----|----|----|----|----|----
1|Jones|Tammy|R|1817 Eagleridge Circle|Houston|TX|77027|3250987654|SR|1986-07-14|8891|2003-06-03|1
2|Perez|Jorge|C|951 Rainbow Drive|Abilene|TX|79901|3258765432|SR|1986-08-19|1230|2002-01-10|1
3|Marsh|John|A|1275 W Main St|Dallas|TX|78012|3257654321|JR|1983-10-10|1613|2003-08-24|1
4|Smith|Mike||428 EN 16 Street|Abilene|TX|79902|3256543210|SO|1987-09-24|1841|2004-08-23|2
5|Johnson|Lisa|M|764 College Drive|Abilene|TX|79901|3255432109|SO|1987-11-20|4420|2005-01-08|4
6|Nguyen|Ni|M|688 4thStreet|Ft Worth|TX|78767|3254321098|FR|1988-12-04|9188|2006-08-22|3

#### Importing Term Data

```sql
LOAD DATA LOCAL INFILE '/Users/gdiaz/gil-workspace/db-modeling-design-final-project/term.csv' 
INTO TABLE TERM
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 2 LINES
(TERM_ID,TERM_DESC,STATUS,@START_DATE)
SET START_DATE = STR_TO_DATE(@START_DATE, '%d-%b-%y');

SELECT * FROM TERM;
```

TERM_ID|TERM_DESC|STATUS|START_DATE
----|----|----|----
1|Fall 2006|CLOSED|2007-08-28
2|Spring 2007|CLOSED|2008-01-09
3|Summer 2007|CLOSED|2006-05-15
4|Fall 2007|CLOSED|2007-08-28
5|Spring 2008|OPEN|2008-01-08
6|Summer 2008|OPEN|2008-05-07

#### Importing Course Section Data

```sql
LOAD DATA LOCAL INFILE '/Users/gdiaz/gil-workspace/db-modeling-design-final-project/course_section.csv' 
INTO TABLE COURSE_SECTION
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 2 ROWS
(C_SEC_ID,COURSE_ID,TERM_ID,SEC_NUM,F_ID,MTG_DAYS,@START_TIME,@END_TIME,LOC_ID,MAX_ENRL)
SET START_TIME = TIME_FORMAT(
		CAST(
			CONCAT(CASE WHEN RIGHT(@START_TIME,2) = 'PM' 
				THEN
					HOUR(@START_TIME) + 12 
				ELSE 
					HOUR(@START_TIME) END, ':',
					MINUTE(@START_TIME)) AS CHAR CHARACTER SET utf8), '%T'),
	END_TIME = TIME_FORMAT(
		CAST(
			CONCAT(CASE WHEN RIGHT(@END_TIME,2) = 'PM'
				THEN
					HOUR(@END_TIME) + 12 
				ELSE HOUR(@END_TIME) END, ':',
					MINUTE(@END_TIME)) AS CHAR CHARACTER SET utf8), '%T');
SELECT * FROM COURSE_SECTION;
```

C_SEC_ID|COURSE_ID|TERM_ID|SEC_NUM|F_ID|MTG_DAYS|START_TIME|END_TIME|LOC_ID|MAX_ENRL
----|----|----|----|----|----|----|----|----|----
1|1|4|1|2|MWF|10:00:00|10:50:00|1|140
2|1|4|2|3|TR|09:30:00|10:45:00|7|35
3|1|4|3|3|MWF|08:00:00|08:50:00|2|35
4|2|4|1|4|TR|11:00:00|12:15:00|6|35
5|2|5|2|4|TR|14:00:00|15:15:00|6|35
6|3|5|1|1|MWF|09:00:00|09:50:00|5|30
7|3|5|2|1|MWF|10:00:00|10:50:00|5|30
8|4|5|1|5|TR|08:00:00|09:15:00|3|35
9|5|5|1|2|MWF|14:00:00|14:50:00|5|35
10|5|5|2|2|MWF|15:00:00|15:50:00|5|35
11|1|6|1|1|MTWRF|08:00:00|09:30:00|1|50
12|2|6|1|2|MTWRF|08:00:00|09:30:00|6|35
13|3|6|1|3|MTWRF|08:00:00|09:30:00|5|35
