@echo off
REM  - - CLEANUP - -
set PROGCOMPLETE=
:cleanup_do
2>nul del jsplist.lsi>nul
2>nul del patch.bat>nul
if "%PROGCOMPLETE%"=="YES" goto EndOfProgram
cls
REM  - - END CLEANUP - -
set hLine=********************************************************************************
set prg=
set prg2=
set process_priority=2
echo.
echo %hLine%
echo         @JSPLOC-Appender: Utility to append JSP Location to JSP Content
echo %hLine%
echo.
echo|set /p=Scanning recursively for JSP Files, please wait 
:showprogress
if not "%prg%"==".........." goto proceednow
goto endproceed
:proceednow
echo|set /p=.
for /l %%n in (1,1,%process_priority%) do echo.|pause>nul
set prg=%prg%.
goto showprogress
:endproceed
echo  [ Completed ]
echo.
2>nul dir/b/s/a *.jsp>jsplist.lsi
if %errorlevel% equ 1 goto nofiles
echo|set /p=Generating Patch Script ...
for /l %%n in (1,1,%process_priority%) do echo.|pause>nul
echo  [ Completed ]
echo.
echo|set /p=Updating JSP Files, please wait 
echo @echo off>patch.bat
echo 2^>nul 1^>nul find /C "@JSPLOC" %%1>>patch.bat
echo if ^%%errorlevel^%% equ 1 goto not_patched>>patch.bat
echo goto done>>patch.bat
echo :not_patched>>patch.bat
echo echo ^^^<!-- @JSPLOC: %%1 --^^^>^>^>%%1>>patch.bat
echo goto done>>patch.bat
echo :done>>patch.bat
:showprogress2
if not "%prg2%"=="....." goto proceednow2
goto endproceed2
:proceednow2
for /l %%n in (1,1,%process_priority%) do echo.|pause>nul
echo|set /p=.
set prg2=%prg2%.
goto showprogress2
:endproceed2
for /F "delims=" %%i in (jsplist.lsi) do call patch.bat "%%i"
echo  [ Completed ]
goto success_completed
:nofiles
echo No JSP files were found with recursive search.
:success_completed
set PROGCOMPLETE=YES
goto cleanup_do
:EndOfProgram
echo.
echo.
echo  [--- Hit any key to exit this tool ---]
pause>nul
:mainexit
cls