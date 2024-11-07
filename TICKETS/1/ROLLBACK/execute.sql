WHENEVER SQLERROR EXIT sql.sqlcode ROLLBACK;
WHENEVER OSERROR EXIT sql.sqlcode ROLLBACK;
SET AUTOCOMMIT OFF;
SET EXITCOMMIT OFF;
SET SQLBLANKLINES ON;
SET ECHO OFF;
SET FEEDBACK ON;
SET TERM OFF VERIFY OFF HEAD ON;
SET LINESIZE 200 PAGESIZE 9999;
SET LONG 4000000;
SET SERVEROUTPUT ON;

COLUMN v_date_yyyymmddss NEW_VAL date_yyyymmddss NOPRINT;
COLUMN v_db_name NEW_VAL db_name NOPRINT;
COLUMN v_schema_name NEW_VAL schema_name NOPRINT;

SELECT TO_CHAR ( SYSDATE,
                 'YYYYMMDDSS' ) v_date_yyyymmddss
  FROM DUAL;

SELECT SYS_CONTEXT ( 'userenv',
                     'db_name' ) v_db_name
  FROM DUAL;

SELECT SYS_CONTEXT ( 'userenv',
                     'current_schema' ) v_schema_name
  FROM DUAL;

--If you want to add all the output to a single file use the 'append' command
--SPOOL &1./execute.txt append

SPOOL &1./execute_&schema_name._&db_name._&date_yyyymmddss..txt;

-- Need to create this table if it isn't created in order to check for errors
TRUNCATE TABLE current_errors;

INSERT INTO current_errors ( obj_name,
                             attribute )
    SELECT DISTINCT name,
                    attribute
      FROM user_errors;

-- FILES TO EXECUTE BELOW

@@example.sql

-- FILES TO EXECUTE ABOVE

-- Check for new compilation errors

DECLARE
    v_new_error_count   NUMBER := 0;
BEGIN
    WITH
        cte_errors ( name,
                     attribute )
        AS
            (SELECT DISTINCT name,
                             attribute
               FROM user_errors
              WHERE name NOT IN ( SELECT obj_name
                                    FROM current_errors ))
    SELECT COUNT ( * )
      INTO v_new_error_count
      FROM cte_errors;

    IF v_new_error_count > 0 THEN
	
        ROLLBACK;
		DBMS_OUTPUT.PUT_LINE('The following objects have new errors: ');
		
        FOR r IN ( SELECT DISTINCT name AS obj_name,
                                   attribute AS attr
                     FROM user_errors
                    WHERE name NOT IN ( SELECT obj_name
                                          FROM current_errors ) )
		LOOP
            DBMS_OUTPUT.put_line ( 'OBJ_NAME: [' || r.obj_name || '] ATTRIBUTE: [' || r.attr || ']' );
        END LOOP;
		DBMS_OUTPUT.PUT_LINE('*******************************************');
        raise_application_error ( -20000,
                                  'NEW compilation errors for objects listed above!' );
    END IF;

    DBMS_OUTPUT.put_line ( 'NO new compilation errors.' );
	
END;
/

COMMIT;

SHOW ERROR;
EXIT;

