SELECT S_FIRST, S_LAST
FROM STUDENT S
WHERE S_CLASS = (
    SELECT S_CLASS
    FROM STUDENT S
    WHERE S_FIRST = 'Jorge'
    AND S_LAST = 'Perez'
);
