@ECHO off
SET GamesDir=%cd%

:APPID
SET /P GID=Steam App ID:
IF %GID%=="" (
    ECHO ERROR: Please provide Steam App ID
    GOTO APPID
)

ECHO.
:GETNAME
rem wget -O gameinfo.json "https://api.steamcmd.net/v1/info/%GID%"

For /F "delims=" %%i in ('type gameinfo.json ^| jq -r ".data.\"740\".common.name"') DO SET "json=%%i"

ECHO %json%
ECHO.

:FOLDER
SET /P GLOC=Folder Name:
IF %GLOC%=="" (
    ECHO ERROR: Please provide game install directory
    GOTO APPID
)

SET INSTLOC=%GamesDir%\games\%GLOC%\
SET STEAMCMD=steamcmd.exe

ECHO.
ECHO Install Location: %INSTLOC%
ECHO.

IF NOT EXIST %INSTLOC% GOTO NOGAMEDIR

:START
IF NOT EXIST %STEAMCMD% GOTO NOSTEAM

:INSTALL
steamcmd +force_install_dir %INSTLOC% +login anonymous +app_update %GID% +validate +quit
ECHO.
REM ECHO SUCCESS: SteamCMD game installation has finished
REM ECHO.
GOTO EXIT
    
:NOGAMEDIR
ECHO WARNING: Game install directory not found 
ECHO.
SET /P X=If new install continue, otherwise cancel (1-continue, 2-cancel):
ECHO.
IF %X%==1 GOTO START
IF %X%==2 GOTO CANCELLED

:NOSTEAM
ECHO.
ECHO ERROR: Cannot find SteamCMD executable
ECHO.
pause
EXIT

:CANCELLED
ECHO.
ECHO CANCELLED: SteamCMD game installation has been cancelled
ECHO.
GOTO EXIT

:FAILED
ECHO.
ECHO FAILED: SteamCMD game installation has failed
ECHO.
GOTO EXIT

:RESTART
CLS
GOTO APPID

:EXIT
SET /P Y=Install another? (1-yes, 2-no):
IF %Y%==1 GOTO RESTART
IF %Y%==2 EXIT
