@echo off

SETLOCAL
SET input_variables_file=input_variables.txt

FOR /F "eol=# tokens=*" %%i IN (%input_variables_file%) DO SET %%i

echo Succesfully parsed variables from %input_variables_file%
echo Targeting Databases: %db_environment_creds%
echo Executing SQL Script: "%sql_script_path%"
echo Action to perform: "%action%"
echo Output Folder: "%output_folder%"

powershell -ExecutionPolicy Bypass -File ./_execute_RUN_instead.ps1 -sql_script_path "%sql_script_path%" -action "%action%" -output_folder "%output_folder%" -db_environment_creds "%db_environment_creds%"

ENDLOCAL

echo The entire script has finished.

PAUSE