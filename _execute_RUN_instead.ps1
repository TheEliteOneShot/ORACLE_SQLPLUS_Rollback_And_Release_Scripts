param (
[Parameter(Mandatory=$true)][string]$sql_script_path,
[Parameter(Mandatory=$true)][string]$action,
[Parameter(Mandatory=$true)][string]$output_folder,
[Parameter(Mandatory=$true)][string]$db_environment_creds
)

#Variables
$array_db_environment_creds = $db_environment_creds.split(",")
$current_datetime = (get-date -format yyyyMMdd_HHmmss)
$start_time = $(get-date)
$command = "@`"" + $sql_script_path + "/" + $action + "/execute.sql" + "`""
$output_folder = $sql_script_path + "/" + $action + $output_folder

#Create the folder
[void](New-Item -Path ($output_folder) -Name $current_datetime -ItemType "directory")

#Start the transcript
[void](Start-Transcript -path $output_folder/$current_datetime/ps_output_$(get-date -format yyyyMMdd_HHmmss).txt -append)

Write-Host STARTED at [$start_time]
Write-Host Beginning execution of $command on all targeted environments
Write-Host Targeting these database environments: [$db_environment_creds]

for ($i = 0; $i -lt $array_db_environment_creds.Length; $i++) {

Write-Host Now executing the SQL script on environment: $array_db_environment_creds[$i]

#Execute SQL plus command
& sqlplus.exe $array_db_environment_creds[$i] $command $output_folder/$current_datetime

}

$elapsed_time = $(get-date) - $start_time

Write-Host ENDED at $(get-date)
Write-Host The SQL script has completed executing on all of the environments. Time Elapsed: [$elapsed_time.TotalSeconds]
Write-Host Output Folder: "$output_folder/$current_datetime"

#Stop the transcript
[void](Stop-Transcript)