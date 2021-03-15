--1. Tabele
CREATE TABLE PERSONS (
PERSON_ID INT GENERATED ALWAYS AS IDENTITY NOT NULL
, FIRSTNAME VARCHAR2(50)
, LASTNAME VARCHAR2(50)
, CONSTRAINT PERSONS_PK PRIMARY KEY
( PERSON_ID
)
ENABLE );
CREATE TABLE TRIPS (
TRIP_ID INT GENERATED ALWAYS AS IDENTITY NOT NULL
, NAME VARCHAR2(100)
, COUNTRY VARCHAR2(50)
, TRIP_DATE DATE
, NO_PLACES INT
, CONSTRAINT TRIPS_PK PRIMARY KEY
( TRIP_ID
)
ENABLE );
CREATE TABLE RESERVATIONS (
RESERVATION_ID INT GENERATED ALWAYS AS IDENTITY NOT NULL , TRIP_ID INT
, PERSON_ID INT
, STATUS CHAR(1)
, CONSTRAINT RESERVATIONS_PK PRIMARY KEY (
RESERVATION_ID )
ENABLE );
ALTER TABLE RESERVATIONS
ADD CONSTRAINT RESERVATIONS_FK1 FOREIGN KEY (
PERSON_ID )
REFERENCES PERSONS (
PERSON_ID )
ENABLE;
ALTER TABLE RESERVATIONS
ADD CONSTRAINT RESERVATIONS_FK2 FOREIGN KEY (
TRIP_ID )
REFERENCES TRIPS (
TRIP_ID )
ENABLE;
ALTER TABLE RESERVATIONS
ADD CONSTRAINT RESERVATIONS_CHK1 CHECK (status IN ('N','P','C'))
ENABLE;

-- 2. Wypełnienie danymi
INSERT INTO PERSONS
(FIRSTNAME, LASTNAME)
VALUES
('Dawid', 'Dobrik');

INSERT INTO TRIPS
(NAME, COUNTRY, TRIP_DATE, NO_PLACES)
VALUES
('Barcelona Marzeń', 'Hiszpania', TO_DATE('2021/08/21') , 4);

INSERT INTO RESERVATIONS
(TRIP_ID, PERSON_ID, STATUS)
VALUES
(26, 10, 'P');

-- 3. Widoki
-- a)
CREATE VIEW V_Reservations
AS SELECT T.COUNTRY, T.TRIP_DATE, T.NAME AS TRIP_NAME, P.FIRSTNAME, P.LASTNAME, R.RESERVATION_ID, R.STATUS
   FROM RESERVATIONS R
   INNER JOIN TRIPS T ON R.TRIP_ID = T.TRIP_ID
   INNER JOIN PERSONS P ON R.PERSON_ID = P.PERSON_ID;

-- b)
CREATE VIEW V_Trips
AS SELECT T.COUNTRY, T.TRIP_DATE, T.NAME AS TRIP_NAME, T.NO_PLACES, T.NO_PLACES - (SELECT COUNT(*)
                                                                                   FROM V_Reservations VR
                                                                                   WHERE VR.TRIP_NAME = T.NAME) AS NO_AVAILABLE_PLACES
   FROM TRIPS T;

-- c)
CREATE VIEW V_Trips
AS SELECT T.COUNTRY, T.TRIP_DATE, T.NAME AS TRIP_NAME, T.NO_PLACES, T.NO_PLACES - (SELECT COUNT(*)
                                                                                   FROM V_Reservations VR
                                                                                   WHERE VR.TRIP_NAME = T.NAME) AS NO_AVAILABLE_PLACES
   FROM TRIPS T;


-- 4. Tworzenie Procedur/Funkcji

-- a)

-- Row Type
CREATE OR REPLACE TYPE TRIP_PARTICIPANTS_ROW AS OBJECT (
    COUNTRY VARCHAR2(50),
    TRIP_DATE DATE,
    TRIP_NAME VARCHAR2(100),
    FIRSTNAME VARCHAR2(50),
    LASTNAME VARCHAR2(50),
    RESERVATION_ID INT,
    STATUS CHAR(1)
                                                       );

-- Table Type
CREATE OR REPLACE TYPE TRIP_PARTICIPANTS_TABLE AS TABLE OF TRIP_PARTICIPANTS_ROW;

-- FUNCTION
CREATE OR REPLACE FUNCTION TRIP_PARTICIPANTS(
    SEARCHED_TRIP_ID INT
)
RETURN TRIP_PARTICIPANTS_TABLE
IS
    return_table TRIP_PARTICIPANTS_TABLE;
    BEGIN
        SELECT TRIP_PARTICIPANTS_ROW(VR.COUNTRY, VR.TRIP_DATE, TRIP_NAME, FIRSTNAME, LASTNAME, RESERVATION_ID, STATUS)
        BULK COLLECT INTO return_table
        FROM V_Reservations VR
        INNER JOIN TRIPS T ON VR.TRIP_NAME = T.NAME
        WHERE T.TRIP_ID = SEARCHED_TRIP_ID;
        RETURN return_table;
    END;
--

SELECT * FROM table(TRIP_PARTICIPANTS(21));

-- b)

-- FUNCTION
CREATE OR REPLACE FUNCTION PERSON_RESERVATIONS(
    SEARCHED_PERSON_ID INT
)
RETURN TRIP_PARTICIPANTS_TABLE
IS
    return_table TRIP_PARTICIPANTS_TABLE;
    BEGIN
        SELECT TRIP_PARTICIPANTS_ROW(VR.COUNTRY, VR.TRIP_DATE, TRIP_NAME, VR.FIRSTNAME, VR.LASTNAME, RESERVATION_ID, STATUS)
        BULK COLLECT INTO return_table
        FROM V_Reservations VR
        INNER JOIN PERSONS P ON P.FIRSTNAME = VR.FIRSTNAME AND P.LASTNAME = VR.LASTNAME
        WHERE P.PERSON_ID = SEARCHED_PERSON_ID;
        RETURN return_table;
    END;
--

SELECT * FROM table(PERSON_RESERVATIONS(1));

-- c)

-- Row Type
CREATE OR REPLACE TYPE AVAILABLE_TRIPS_ROW AS OBJECT (
    COUNTRY VARCHAR2(50),
    TRIP_DATE DATE,
    TRIP_NAME VARCHAR2(100),
    NO_AVAILABLE_PLACES INT

                                                       );

-- Table Type
CREATE OR REPLACE TYPE AVAILABLE_TRIPS_TABLE AS TABLE OF AVAILABLE_TRIPS_ROW;


-- FUNCTION
CREATE OR REPLACE FUNCTION AVAILABLE_TRIPS(
    SEARCHED_COUNTRY VARCHAR2,
    SEARCHED_DATE_FROM DATE,
    SEARCHED_DATE_TO DATE
)
RETURN AVAILABLE_TRIPS_TABLE
IS
    return_table AVAILABLE_TRIPS_TABLE;
    BEGIN
        SELECT AVAILABLE_TRIPS_ROW(COUNTRY, TRIP_DATE, TRIP_NAME, NO_AVAILABLE_PLACES)
        BULK COLLECT INTO return_table
        FROM V_TRIPS VT
        WHERE VT.COUNTRY = SEARCHED_COUNTRY AND (VT.TRIP_DATE BETWEEN SEARCHED_DATE_FROM AND SEARCHED_DATE_TO);
        RETURN return_table;
    END;
--

SELECT * FROM table(AVAILABLE_TRIPS('Hiszpania', TO_DATE('2021/08/15', 'YYYY/MM/DD'), TO_DATE('2021/08/29', 'YYYY/MM/DD ')) );

-- 5. Tworzenie procedur modyfikujacych dane

-- a)
CREATE OR REPLACE PROCEDURE ADD_RESERVATION(
    add_trip_id IN INT, add_person_id IN INT
) AS
    s_trip_date DATE;
    no_available INT;
    s_reservation_id INT;
    BEGIN
        SELECT TRIP_DATE INTO s_trip_date FROM TRIPS T WHERE T.TRIP_ID = add_trip_id;

        SELECT NO_AVAILABLE_PLACES
        INTO no_available
        FROM V_Trips VT
        INNER JOIN TRIPS T2 on VT.TRIP_NAME = T2.NAME
        WHERE T2.TRIP_ID = add_trip_id;

        IF s_trip_date > trunc(sysdate)  AND no_available > 0 THEN
                INSERT INTO RESERVATIONS(TRIP_ID, PERSON_ID, STATUS) VALUES (add_trip_id, add_person_id, 'N');

                SELECT MAX(RESERVATION_ID)
                INTO s_reservation_id
                FROM RESERVATIONS;

                INSERT INTO RESERVATION_LOG(RESERVATION_ID, CHANGE_DATE, STATUS) VALUES(s_reservation_id, trunc(sysdate)
                , 'N');
        END IF;
    END;


--

declare
	ADD_TRIP_ID NUMBER := 24;
	ADD_PERSON_ID NUMBER := 9;
begin
	ADD_RESERVATION(
		ADD_TRIP_ID => ADD_TRIP_ID,
		ADD_PERSON_ID => ADD_PERSON_ID
	);
end;


-- b)
CREATE OR REPLACE PROCEDURE MODIFY_RESERVATION_STATUS(
    modify_reservation_id IN INT, modify_status IN CHAR
) AS
    no_available INT;
    s_trip_id INT;
    current_status CHAR;
    BEGIN
        SELECT TRIP_ID
        INTO s_trip_id
        FROM RESERVATIONS
        WHERE RESERVATION_ID = modify_reservation_id;

        SELECT NO_AVAILABLE_PLACES
        INTO no_available
        FROM V_Trips VT
        INNER JOIN TRIPS T2 on VT.TRIP_NAME = T2.NAME
        WHERE T2.TRIP_ID = s_trip_id;

        SELECT STATUS
        INTO current_status
        FROM RESERVATIONS
        WHERE RESERVATION_ID = modify_reservation_id;

        IF no_available > 0 OR current_status != 'C' THEN
            UPDATE RESERVATIONS
            SET STATUS = modify_status
            WHERE RESERVATION_ID = modify_reservation_id;
            INSERT INTO RESERVATION_LOG(RESERVATION_ID, CHANGE_DATE, STATUS) VALUES(modify_reservation_id, trunc(sysdate)
            , modify_status);
        end if;
    END;


declare
	MODIFY_RESERVATION_ID NUMBER := 1;
	MODIFY_STATUS CHAR(1) := 'C';
begin
	MODIFY_RESERVATION_STATUS(
		MODIFY_RESERVATION_ID => MODIFY_RESERVATION_ID,
		MODIFY_STATUS => MODIFY_STATUS
	);
end;

-- c)

CREATE OR REPLACE PROCEDURE MODIFY_NUMBER_PLACES(
    s_trip_id IN INT, new_no_places IN INT
) AS
    no_reserved INT;
    BEGIN
        SELECT T2.NO_PLACES - VT.NO_AVAILABLE_PLACES
        INTO no_reserved
        FROM V_Trips VT
        INNER JOIN TRIPS T2 on VT.TRIP_NAME = T2.NAME
        WHERE T2.TRIP_ID = s_trip_id;

        IF new_no_places >= no_reserved THEN
            UPDATE TRIPS
            SET NO_PLACES = new_no_places
            WHERE TRIP_ID = s_trip_id;
        end if;
    END;

declare
	S_TRIP_ID NUMBER := 25;
	NEW_NO_PLACES NUMBER := 10;
begin
	MODIFY_NUMBER_PLACES(
		S_TRIP_ID => S_TRIP_ID,
		NEW_NO_PLACES => NEW_NO_PLACES
	);
end;

-- 6

CREATE TABLE RESERVATION_LOG (
  ID INT GENERATED ALWAYS AS IDENTITY NOT NULL,
  RESERVATION_ID INT,
  CHANGE_DATE DATE,
  STATUS CHAR(1),
  CONSTRAINT RESERVATION_LOG_PK PRIMARY KEY
    (
     ID
    )
ENABLE );

-- 7 Zmiana struktury bazy

--nowa kolumna
ALTER TABLE TRIPS
ADD NO_AVAILABLE_PLACES INT;

-- widoki

CREATE VIEW V_Reservations2
AS SELECT T.COUNTRY, T.TRIP_DATE, T.NAME AS TRIP_NAME, P.FIRSTNAME, P.LASTNAME, R.RESERVATION_ID, R.STATUS
   FROM RESERVATIONS R
   INNER JOIN TRIPS T ON R.TRIP_ID = T.TRIP_ID
   INNER JOIN PERSONS P ON R.PERSON_ID = P.PERSON_ID;

-- b)
CREATE VIEW V_Trips2
AS SELECT T.COUNTRY, T.TRIP_DATE, T.NAME AS TRIP_NAME, T.NO_PLACES, T.NO_AVAILABLE_PLACES
   FROM TRIPS T;


-- przelicz dostępne miejsca
CREATE OR REPLACE PROCEDURE CALCULATE_AVAILABLE_PLACES(
    s_trip_id INT
)
AS
    s_no_avaliable_places INT;
    BEGIN
        SELECT T.NO_PLACES - COUNT(*)
        INTO s_no_avaliable_places
        FROM V_Reservations2 VR
        INNER JOIN TRIPS T ON T.NAME = VR.TRIP_NAME
        WHERE T.TRIP_ID = s_trip_id;

        UPDATE TRIPS
            SET TRIPS.NO_AVAILABLE_PLACES = s_no_avaliable_places
        WHERE TRIP_ID = s_trip_id;
    END;

-- procedury
CREATE OR REPLACE PROCEDURE ADD_RESERVATION2(
    add_trip_id IN INT, add_person_id IN INT
) AS
    s_trip_date DATE;
    no_available INT;
    s_reservation_id INT;
    BEGIN
        SELECT TRIP_DATE INTO s_trip_date FROM TRIPS T WHERE T.TRIP_ID = add_trip_id;

        SELECT NO_AVAILABLE_PLACES
        INTO no_available
        FROM TRIPS;

        IF s_trip_date > trunc(sysdate)  AND no_available > 0 THEN
                INSERT INTO RESERVATIONS(TRIP_ID, PERSON_ID, STATUS) VALUES (add_trip_id, add_person_id, 'N');

                SELECT MAX(RESERVATION_ID)
                INTO s_reservation_id
                FROM RESERVATIONS;

                INSERT INTO RESERVATION_LOG(RESERVATION_ID, CHANGE_DATE, STATUS) VALUES(s_reservation_id, trunc(sysdate)
                , 'N');

                CALCULATE_AVAILABLE_PLACES(add_trip_id);
        END IF;
    END;


CREATE OR REPLACE PROCEDURE MODIFY_RESERVATION_STATUS2(
    modify_reservation_id IN INT, modify_status IN CHAR
) AS
    s_no_available INT;
    s_trip_id INT;
    current_status CHAR;
    BEGIN
        SELECT TRIP_ID
        INTO s_trip_id
        FROM RESERVATIONS
        WHERE RESERVATION_ID = modify_reservation_id;

        SELECT NO_AVAILABLE_PLACES
        INTO s_no_available
        FROM V_Trips VT
        INNER JOIN TRIPS T2 on VT.TRIP_NAME = T2.NAME
        WHERE T2.TRIP_ID = s_trip_id;

        SELECT STATUS
        INTO current_status
        FROM RESERVATIONS
        WHERE RESERVATION_ID = modify_reservation_id;

        IF s_no_available > 0 OR current_status != 'C' THEN
            UPDATE RESERVATIONS
            SET STATUS = modify_status
            WHERE RESERVATION_ID = modify_reservation_id;
            INSERT INTO RESERVATION_LOG(RESERVATION_ID, CHANGE_DATE, STATUS) VALUES(modify_reservation_id, trunc(sysdate)
            , modify_status);
            CALCULATE_AVAILABLE_PLACES(s_trip_id);
        end if;
    END;

CREATE OR REPLACE PROCEDURE MODIFY_NUMBER_PLACES2(
    s_trip_id IN INT, new_no_places IN INT
) AS
    no_reserved INT;
    BEGIN
        SELECT T2.NO_PLACES - VT.NO_AVAILABLE_PLACES
        INTO no_reserved
        FROM V_Trips VT
        INNER JOIN TRIPS T2 on VT.TRIP_NAME = T2.NAME
        WHERE T2.TRIP_ID = s_trip_id;

        IF new_no_places >= no_reserved THEN
            UPDATE TRIPS
            SET NO_PLACES = new_no_places
            WHERE TRIP_ID = s_trip_id;
            CALCULATE_AVAILABLE_PLACES(s_trip_id);
        end if;
    END;

-- 8 Zmiana strategii zapisywania
-- Triggery do poprawki 14.03.2021

CREATE OR REPLACE TRIGGER ADDING_RESERVATION
    AFTER INSERT
    ON RESERVATIONS
    REFERENCING NEW AS newROW
    FOR EACH ROW
BEGIN
   INSERT INTO RESERVATION_LOG(RESERVATION_ID, CHANGE_DATE, STATUS)
   VALUES(newROW.RESERVATION_ID, trunc(SYSDATE), newROW.STATUS);
END;

declare
	ADD_TRIP_ID NUMBER := 21;
	ADD_PERSON_ID NUMBER := 10;
begin
	ADD_RESERVATION(
		ADD_TRIP_ID => ADD_TRIP_ID,
		ADD_PERSON_ID => ADD_PERSON_ID
	);
end;

CREATE OR REPLACE TRIGGER MODIFY_RESERVATION
    AFTER UPDATE OF STATUS
    ON RESERVATIONS
    REFERENCING NEW AS newROW
    FOR EACH ROW
BEGIN
   INSERT INTO RESERVATION_LOG(RESERVATION_ID, CHANGE_DATE, STATUS)
   VALUES(newROW.RESERVATION_ID, trunc(SYSDATE), newROW.STATUS);
END;


CREATE OR REPLACE  TRIGGER PROHIBIT_DELETION
BEFORE DELETE ON RESERVATIONS
BEGIN
    raise_application_error(-20001,'Reservations cant be deleted');
END;

-- procedury

CREATE OR REPLACE PROCEDURE ADD_RESERVATION3(
    add_trip_id IN INT, add_person_id IN INT
) AS
    s_trip_date DATE;
    no_available INT;
    s_reservation_id INT;
    BEGIN
        SELECT TRIP_DATE INTO s_trip_date FROM TRIPS T WHERE T.TRIP_ID = add_trip_id;

        SELECT NO_AVAILABLE_PLACES
        INTO no_available
        FROM TRIPS T
        WHERE T.TRIP_ID = add_trip_id;

        IF s_trip_date > trunc(sysdate)  AND no_available > 0 THEN
                INSERT INTO RESERVATIONS(TRIP_ID, PERSON_ID, STATUS) VALUES (add_trip_id, add_person_id, 'N');
        END IF;
    END;


--

-- b)
CREATE OR REPLACE PROCEDURE MODIFY_RESERVATION_STATUS3(
    modify_reservation_id IN INT, modify_status IN CHAR
) AS
    no_available INT;
    s_trip_id INT;
    current_status CHAR;
    BEGIN
        SELECT TRIP_ID
        INTO s_trip_id
        FROM RESERVATIONS
        WHERE RESERVATION_ID = modify_reservation_id;

        SELECT NO_AVAILABLE_PLACES
        INTO no_available
        FROM Trips T
        WHERE T.TRIP_ID = s_trip_id;

        SELECT STATUS
        INTO current_status
        FROM RESERVATIONS
        WHERE RESERVATION_ID = modify_reservation_id;

        IF no_available > 0 OR current_status != 'C' THEN
            UPDATE RESERVATIONS
            SET STATUS = modify_status
            WHERE RESERVATION_ID = modify_reservation_id;
        end if;
    END;

-- c)

CREATE OR REPLACE PROCEDURE MODIFY_NUMBER_PLACES3(
    s_trip_id IN INT, new_no_places IN INT
) AS
    no_reserved INT;
    BEGIN
        SELECT T.NO_PLACES - T.NO_AVAILABLE_PLACES
        INTO no_reserved
        FROM Trips T
        WHERE T.TRIP_ID = s_trip_id;

        IF new_no_places >= no_reserved THEN
            UPDATE TRIPS
            SET NO_PLACES = new_no_places
            WHERE TRIP_ID = s_trip_id;
        end if;
    END;

-- 9

CREATE OR REPLACE TRIGGER ADDING_RESERVATION_PLACES
    AFTER INSERT
    ON RESERVATIONS
    REFERENCING NEW AS newROW
BEGIN
   UPDATE TRIPS
       SET TRIPS.NO_AVAILABLE_PLACES = TRIPS.NO_AVAILABLE_PLACES - 1
    WHERE TRIPS.TRIP_ID = newROW.TRIP_ID;
   INSERT INTO RESERVATION_LOG(RESERVATION_ID, CHANGE_DATE, STATUS) VALUES(newROW.RESERVATION_ID, trunc(sysdate)
            , newROW.STATUS);
END;

CREATE OR REPLACE TRIGGER CHANGE_STATUS
    AFTER INSERT
    ON RESERVATIONS
    REFERENCING NEW AS newROW
BEGIN
   INSERT INTO RESERVATION_LOG(RESERVATION_ID, CHANGE_DATE, STATUS) VALUES(newROW.RESERVATION_ID, trunc(sysdate)
            , newROW.STATUS);
END;


CREATE OR REPLACE TRIGGER UPDATE_AVAILABLE
    AFTER UPDATE OF NO_PLACES
    ON TRIPS
BEGIN
   UPDATE TRIPS
       SET TRIPS.NO_AVAILABLE_PLACES = TRIPS.NO_AVAILABLE_PLACES + NEW.NO_PLACES - OLD.NO_PLACES
    WHERE TRIPS.TRIP_ID = NEW.TRIP_ID;
END;

-- procedury

CREATE OR REPLACE PROCEDURE ADD_RESERVATION4(
    add_trip_id IN INT, add_person_id IN INT
) AS
    s_trip_date DATE;
    no_available INT;
    s_reservation_id INT;
    BEGIN
        SELECT TRIP_DATE INTO s_trip_date FROM TRIPS T WHERE T.TRIP_ID = add_trip_id;

        SELECT NO_AVAILABLE_PLACES
        INTO no_available
        FROM TRIPS T
        WHERE T.TRIP_ID = add_trip_id;

        IF s_trip_date > trunc(sysdate)  AND no_available > 0 THEN
                INSERT INTO RESERVATIONS(TRIP_ID, PERSON_ID, STATUS) VALUES (add_trip_id, add_person_id, 'N');
        END IF;
    END;


--

-- b)
CREATE OR REPLACE PROCEDURE MODIFY_RESERVATION_STATUS4(
    modify_reservation_id IN INT, modify_status IN CHAR
) AS
    no_available INT;
    s_trip_id INT;
    current_status CHAR;
    BEGIN
        SELECT TRIP_ID
        INTO s_trip_id
        FROM RESERVATIONS
        WHERE RESERVATION_ID = modify_reservation_id;

        SELECT NO_AVAILABLE_PLACES
        INTO no_available
        FROM Trips T
        WHERE T.TRIP_ID = s_trip_id;

        SELECT STATUS
        INTO current_status
        FROM RESERVATIONS
        WHERE RESERVATION_ID = modify_reservation_id;

        IF no_available > 0 OR current_status != 'C' THEN
            UPDATE RESERVATIONS
            SET STATUS = modify_status
            WHERE RESERVATION_ID = modify_reservation_id;
        end if;
    END;

-- c)

CREATE OR REPLACE PROCEDURE MODIFY_NUMBER_PLACES4(
    s_trip_id IN INT, new_no_places IN INT
) AS
    no_reserved INT;
    BEGIN
        SELECT T.NO_PLACES - T.NO_AVAILABLE_PLACES
        INTO no_reserved
        FROM Trips T
        WHERE T.TRIP_ID = s_trip_id;

        IF new_no_places >= no_reserved THEN
            UPDATE TRIPS
            SET NO_PLACES = new_no_places
            WHERE TRIP_ID = s_trip_id;
        end if;
    END;


