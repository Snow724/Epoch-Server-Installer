:Author: Snow
@echo off
COLOR 9f
TYPE Bin\Info\intro.txt
::================================================================================================================================================================
Set inifile=Configuration.ini
FOR /F "delims== tokens=2* usebackq" %%i in (`type %inifile% ^| find "VR="`) do (set VR=%%i) 
FOR /F "delims== tokens=2* usebackq" %%i in (`type %inifile% ^| find "A2OA="`) do (set A2OA=%%i) 
FOR /F "delims== tokens=2* usebackq" %%i in (`type %inifile% ^| find "hive="`) do (set hive=%%i) 
FOR /F "delims== tokens=2* usebackq" %%i in (`type %inifile% ^| find "settings="`) do (set settings=%%i) 
FOR /F "delims== tokens=2* usebackq" %%i in (`type %inifile% ^| find "exename="`) do (set exename=%%i) 
FOR /F "delims== tokens=2* usebackq" %%i in (`type %inifile% ^| find "bec="`) do (set bec=%%i) 
::===============================================================================================================================================================================================
::----------------- ADVANCED SETTINGS DO NOT TOUCH UNLESS YOU KNOW WHAT YOU ARE DOING ----------------------------------------
::set hive=#DayzServ.epoch.1_hive
::set settings=#DayzServ.epoch.1_settings
::set exename=Server_Epoch.1.exe
::set bec=F:\BEC_Epoch.1
::===============================================================================================================================================================================================
:: ---------------------------------------------------------- DO NOT TOUCH ANYTHING BELLOW THIS LINE OR YOU WILL BREAK THIS FILE -----------------------------
::===============================================================================================================================================================================================
Title DayZ Epoch Server Installer
:: Check if already ran > Clear up old
if exist "Dump\Check.AGS" (
rmdir /s /q "Dump\"
)
:: Retrieve,unpackage and prepare files for setup process________________________________________________________________________
Echo Before we begin please take the time to read the instructions
SET /P README=  Read the readme? (yes or no)

if /i {%README%}=={yes} (
start "" "README.txt" /MIN
)
<nul set /p "=If you have read the README.txt please press any key to continue with the setup"
pause >nul

echo Type one of the following ___________________________________________
echo +++++++++++++++
echo Fresh 
echo Update
echo +++++++++++++++

echo fresh will download all the files and update will only do the server setup
echo __________________________________________________________________________
SET /P OPTION=  Fresh install or Updating/adding new server?

if /i {%OPTION%}=={Fresh} (
	 echo ============================================================
	 echo Beginning download of %VR% Epoch Server Files and BEC in & timeout 3
	:: Downloading Files
	WGET --no-check-certificate -P Dump/ https://s3.amazonaws.com/dayzepoch/DayZ_Epoch_Server_%VR%_Release.7z 
	WGET --no-check-certificate -P Dump/ http://www.ibattle.org/Downloads/Bec.zip 
	 echo ============================================================
	 echo Finished Downloading %VR% Epoch Server Files and BEC & Timeout 3
	 :: Check if has already been run
	copy "Bin\Check.AGS" "Dump\Check.AGS"
	 echo ============================================================
	 echo Beginning extraction of %VR% Epoch Server Files and BEC in & timeout 3
	:: Extracting Files 
	  for /R "Dump" %%I in ("*.7z") do (
	  "Bin\7-zip\7za.exe" x -y -o"%%~dpnI" "%%~fI" 
	)
	    for /R "Dump" %%I in ("*.zip") do (
	  "Bin\7-zip\7za.exe" x -y -o"%%~dpnI" "%%~fI" 
	)
	 echo ============================================================
	 echo Finished Extracting %VR% Epoch Server Files & Timeout 3

	 echo ============================================================
	 echo Cleaning up files ..... ..... ..... & timeout 2
	:: Clean up files 
	REN "Dump\DayZ_Epoch_Server_%VR%_Release" "%VR%_ServerFiles"
	DEL "Dump\DayZ_Epoch_Server_%VR%_Release.7z" 
	DEL "Dump\Bec.zip" 
)
::===============================================================================================================================================================================================
:: Setup process________________________________________________________________________
echo Beginning setup process.... & timeout 3
echo Creating Directories
:: Making Directories and creating needed files
echo ==========================================================

mkdir "%A2OA%\%hive%"
mkdir "%A2OA%\%settings%"
mkdir "%bec%"
::
mkdir "%A2OA%\%settings%\old_bay\mission"
mkdir "%A2OA%\%settings%\old_bay\server"
mkdir "%A2OA%\%settings%\old_bay\config"
mkdir "%A2OA%\%settings%\old_bay\AH_Logs"
::
mkdir "%A2OA%\%settings%\new_bay\server"
mkdir "%A2OA%\%settings%\new_bay\mission"
mkdir "%A2OA%\%settings%\new_bay\config"
::
mkdir "%A2OA%\%settings%\hives"
mkdir "%A2OA%\%settings%\hives2"
::
mkdir "%A2OA%\EXE"
copy  "%A2OA%\arma2oaserver.exe" "%A2OA%\EXE\%exename%"
echo ==========================================================

:: Begin file transfer and setup of files
:: Setup Hive
ROBOCOPY  /S "Dump\%VR%_ServerFiles\@DayZ_Epoch_Server\addons" "%A2OA%\%hive%\addons"
copy "Dump\%VR%_ServerFiles\@DayZ_Epoch_Server\HiveExt.dll" "%A2OA%\%hive%" 

::Setup Battleeye
ROBOCOPY  /S "Dump\%VR%_ServerFiles\Battleye" "%A2OA%\%settings%\Battleye"

:: BEC Setup
	ROBOCOPY  /S "Dump\BEC" "%bec%" 
:: Loose ends
mkdir "%A2OA%\Launchers"

:: Setup Mission,Settings and Keys
Echo Chernarus
Echo Napf
Echo Lingor
Echo Taviana
Echo Namalsk
echo .
SET /P ANSWER=  Which map would you like to run?


if /i {%ANSWER%}=={chernarus} (
	ROBOCOPY  /S "Dump\%VR%_ServerFiles\MPMissions\DayZ_Epoch_11.Chernarus" "%A2OA%\MPMissions\DayZ_Epoch_11.Chernarus"
	ROBOCOPY  /S "Dump\%VR%_ServerFiles\Config-Examples\instance_11_Chernarus" "%A2OA%\%settings%"
	copy "Bin\Launchers\Epoch_Chernarus.bat" "%A2OA%\Launchers\Epoch_Chernarus.bat"
	REN "%bec%\Bec.exe" "Bec_Chernarus.exe"
)

if /i {%ANSWER%}=={napf} (
	ROBOCOPY  /S "Dump\%VR%_ServerFiles\MPMissions\DayZ_Epoch_24.Napf" "%A2OA%\MPMissions\DayZ_Epoch_24.Napf"
	ROBOCOPY  /S "Dump\%VR%_ServerFiles\Config-Examples\instance_24_Napf" "%A2OA%\%settings%"
	copy "Bin\Launchers\Epoch_Napf.bat" "%A2OA%\Launchers\Epoch_Napf.bat"
	REN "%bec%\Bec.exe" "Bec_Napf.exe"

)

if /i {%ANSWER%}=={lingor} (
	ROBOCOPY  /S "Dump\%VR%_ServerFiles\MPMissions\DayZ_Epoch_7.Lingor" "%A2OA%\MPMissions\DayZ_Epoch_7.Lingor"
	ROBOCOPY  /S "Dump\%VR%_ServerFiles\Config-Examples\instance_7_Lingor" "%A2OA%\%settings%"
	ROBOCOPY  /S "Dump\%VR%_ServerFiles\Keys\External Keys (use as needed)\Lingor" "%A2OA%\Keys"
	copy "Bin\Launchers\Epoch_Lingor.bat" "%A2OA%\Launchers\Epoch_Lingor.bat"
	REN "%bec%\Bec.exe" "Bec_lingor.exe"

)

if /i {%ANSWER%}=={taviana} (
	ROBOCOPY  /S "Dump\%VR%_ServerFiles\MPMissions\DayZ_Epoch_13.Tavi" "%A2OA%\MPMissions\DayZ_Epoch_13.Tavi"
	ROBOCOPY  /S "Dump\%VR%_ServerFiles\Config-Examples\instance_13_tavi" "%A2OA%\%settings%"
	ROBOCOPY  /S "Dump\%VR%_ServerFiles\Keys\External Keys (use as needed)\Taviana" "%A2OA%\Keys"
	copy "Bin\Launchers\Epoch_Taviana.bat" "%A2OA%\Launchers\Epoch_Taviana.bat"

	REN "%bec%\Bec.exe" "Bec_Taviana.exe"

)

if /i {%ANSWER%}=={namalsk} (
	ROBOCOPY  /S "Dump\%VR%_ServerFiles\MPMissions\DayZ_Epoch_15.namalsk" "%A2OA%\MPMissions\DayZ_Epoch_15.namalsk"
	ROBOCOPY  /S "Dump\%VR%_ServerFiles\Config-Examples\instance_15_namalsk" "%A2OA%\%settings%"
	ROBOCOPY  /S "Dump\%VR%_ServerFiles\Keys\External Keys (use as needed)\Namalsk" "%A2OA%\Keys"
	copy "Bin\Launchers\Epoch_Namalsk.bat" "%A2OA%\Launchers\Epoch_Namalsk.bat"

	REN "%bec%\Bec.exe" "Bec_Namalsk.exe"

)
:: Copy Epoch Key
copy "Dump\%VR%_ServerFiles\Keys\dayz_epoch1051.bikey" "%A2OA%\Keys"
:: Finalize Settings , copy basic.cfg
copy "Bin\basic.cfg" "%A2OA%\%settings%"
:: Copy exterior files
copy "Dump\%VR%_ServerFiles\DatabaseMySql.dll" "%A2OA%"
copy "Dump\%VR%_ServerFiles\DatabasePostgre.dll" "%A2OA%"
copy "Dump\%VR%_ServerFiles\tbb.dll" "%A2OA%"
copy "Dump\%VR%_ServerFiles\tbbmalloc.dll" "%A2OA%"

Echo ******************************************************************************
Echo The your setup has been complete , now you need your database setup and apache
Echo ******************************************************************************


SET /P ANSWER=  Would you like us to install that for you?  (yes or no)

if /i {%ANSWER%}=={yes} (
Bin\xamp\XampSetup
)
exit
