DECLARE
    v_count                           NUMBER := 0;
    v_count_invalid_packages_before   NUMBER := 0;
    v_count_invalid_packages_after    NUMBER := 0;
BEGIN
    SELECT COUNT ( * ) AS invalid_packages_before
      INTO v_count_invalid_packages_before
      FROM dba_objects
     WHERE status <> 'VALID'
       AND object_type LIKE 'PACKAGE%'
       AND owner = 'SEVDBA';

    FOR r IN ( SELECT DISTINCT 'alter package ' || owner || '.' || object_name || ' compile package' AS code
                 FROM dba_objects
                WHERE status <> 'VALID'
                  AND object_type LIKE 'PACKAGE%'
                  AND owner = 'SEVDBA' ) LOOP
        v_count := v_count + 1;
        DBMS_OUTPUT.put_line ( r.code );

        BEGIN
            EXECUTE IMMEDIATE r.code;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.put_line ( 'INNER ERROR' );
                DBMS_OUTPUT.put_line ( SQLCODE );
                DBMS_OUTPUT.put_line ( SQLERRM );
        END;
    END LOOP;

    SELECT COUNT ( * ) AS invalid_packages_before
      INTO v_count_invalid_packages_after
      FROM dba_objects
     WHERE status <> 'VALID'
       AND object_type LIKE 'PACKAGE%'
       AND owner = 'SEVDBA';

    DBMS_OUTPUT.put_line ( 'Invalid Packages Before: ' || v_count_invalid_packages_before );
    DBMS_OUTPUT.put_line ( 'Packages Recompiled: ' || v_count );
    DBMS_OUTPUT.put_line ( 'Invalid Packages After: ' || v_count_invalid_packages_after );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line ( 'OUTER ERROR' );
        DBMS_OUTPUT.put_line ( SQLCODE );
        DBMS_OUTPUT.put_line ( SQLERRM );
        ROLLBACK;
END;
