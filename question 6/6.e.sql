SELECT A.F_LAST, A.F_FIRST, B.BLDG_CODE, B.ROOM FROM FACULTY_VIEW AS A, LOCATION AS B
WHERE A.LOC_ID = B.LOC_ID;