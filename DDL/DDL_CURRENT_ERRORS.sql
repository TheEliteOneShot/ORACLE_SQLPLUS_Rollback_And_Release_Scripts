-- This table holds the all of the current compilation errors owned by that schema. 
--It's compared with the errors again after the script runs to write the output log any new compilation errors.

CREATE TABLE "SEVDBA".current_errors
(
    id           NUMBER
                    GENERATED ALWAYS AS IDENTITY
(
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9999999999999999999999999999
    CACHE 20
    CYCLE
    ORDER
    KEEP
    ),
    obj_name     VARCHAR2 ( 4000 ),
    attribute    VARCHAR2 ( 4000 )
);


ALTER TABLE "SEVDBA".current_errors
    ADD ( CONSTRAINT current_errors_pk PRIMARY KEY ( id ) ENABLE VALIDATE );