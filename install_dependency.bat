@echo off
setlocal EnableDelayedExpansion

rem ───────────────────────────────────────────────
rem Configuration
set "GROUP_ID=com.mit.mis"
set "VERSION=1.0"
set "PACKAGING=jar"

set "PROJECT_DIR=%~dp0"
set "LIB_DIR=%PROJECT_DIR%src\main\resources\lib"
set "OUTPUT_DEP_FILE=%PROJECT_DIR%dependencies.xml"

rem ───────────────────────────────────────────────
rem Clear the old output file and write header
echo ^<dependencies^> > "!OUTPUT_DEP_FILE!"

rem ───────────────────────────────────────────────
rem through each jar file and call subroutine
for %%F in ("%LIB_DIR%\*.jar") do (
    call :processJar "%%~fF"
)

rem Close dependencies tag
echo ^</dependencies^> >> "!OUTPUT_DEP_FILE!"
echo Done! Dependencies written to: !OUTPUT_DEP_FILE!
pause
exit /b

rem ───────────────────────────────────────────────
rem Subroutine to process each JAR
:processJar
set "FILE=%~1"
set "ARTIFACT_NAME=%~n1"

rem Install to local Maven repo
call mvn install:install-file ^
    -Dfile="%FILE%" ^
    -DgroupId=%GROUP_ID% ^
    -DartifactId=%ARTIFACT_NAME% ^
    -Dversion=%VERSION% ^
    -Dpackaging=%PACKAGING%

rem Append to output file
>> "%OUTPUT_DEP_FILE%" echo     ^<dependency^>
>> "%OUTPUT_DEP_FILE%" echo         ^<groupId^>^%GROUP_ID%^</groupId^>
>> "%OUTPUT_DEP_FILE%" echo         ^<artifactId^>^%ARTIFACT_NAME%^</artifactId^>
>> "%OUTPUT_DEP_FILE%" echo         ^<version^>^%VERSION%^</version^>
>> "%OUTPUT_DEP_FILE%" echo     ^</dependency^>
exit /b
