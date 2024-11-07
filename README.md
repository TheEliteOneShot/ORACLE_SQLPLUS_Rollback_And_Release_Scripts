# ORACLE_SQLPLUS_Rollback_And_Release_Scripts
A very lightweight and clean script framework for releasing and rolling back scripts in an organized fashion. This script allows for easy releases and rollback's that can be executed on multiple databases at once. 

-This script will stop and rollback any DML changes.
-This script will stop on any DDL errors and in additional highlight which released packages contained compilation errors.

1. Install **SQLPLUS**.
2. Edit **input_variables.txt** with your preference.
3. Execute **DDL/DDL_CURRENT_ERRORS.sql** on the target databases so that the script can keep track of which new compilation errors are present after the script is finished.
4. Execute **run.bat** to execute either a ROLLBACK or a RELEASE in the respective ticket folder. The output will be in either the RELEASE or OUTPUT folder after the script has finished.
