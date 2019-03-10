LOAD DATA LOCAL INFILE '/Users/gdiaz/gil-workspace/db-modeling-design-final-project/enrollment.csv' 
INTO TABLE ENROLLMENT
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 2 LINES
(S_ID,C_SEC_ID,@GRADE)
SET GRADE = NULLIF(@GRADE,'');

SELECT * FROM ENROLLMENT;