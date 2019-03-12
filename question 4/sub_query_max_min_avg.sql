SELECT A.C_SEC_ID, A.SUM_MAX_ENROLLMENTS, B.AVERAGE_CURRENT_ENROLLMENT, 
B.MAX_CURRENT_ENROLLMENT, B.MIN_CURRENT_ENROLLMENT
FROM (SELECT E.C_SEC_ID, SUM(CS.MAX_ENRL) AS SUM_MAX_ENROLLMENTS
	FROM ENROLLMENT E
		LEFT JOIN COURSE_SECTION CS
    		ON E.C_SEC_ID = CS.C_SEC_ID
			GROUP BY C_SEC_ID
	) AS A, 
(SELECT AVG(CURRENT_ENROLLMENT_COUNT) AVERAGE_CURRENT_ENROLLMENT, 
	MAX(CURRENT_ENROLLMENT_COUNT) MAX_CURRENT_ENROLLMENT, MIN(CURRENT_ENROLLMENT_COUNT) MIN_CURRENT_ENROLLMENT
		FROM (SELECT E.C_SEC_ID, COUNT(S_ID) AS CURRENT_ENROLLMENT_COUNT
			FROM ENROLLMENT E
				LEFT JOIN COURSE_SECTION CS
    				ON E.C_SEC_ID = CS.C_SEC_ID
				LEFT JOIN COURSE C
    				ON CS.COURSE_ID = C.COURSE_ID
				LEFT JOIN TERM T
    				ON CS.TERM_ID = T.TERM_ID
				WHERE TERM_DESC = 'Summer 2008'
					GROUP BY  E.C_SEC_ID
		) AS INTERNAL
) AS B