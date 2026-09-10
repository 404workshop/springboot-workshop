@echo off
setlocal
set ERROR_CODE=0

set MAVEN_CMD_LINE_ARGS=%*

if "%JAVA_HOME%" == "" goto findJava
set JAVA_EXE="%JAVA_HOME%\bin\java.exe"
if exist %JAVA_EXE% goto execute
:findJava
set JAVA_EXE=java

:execute
%JAVA_EXE% -jar "%~dp0.mvn\wrapper\maven-wrapper.jar" %MAVEN_CMD_LINE_ARGS%
if %ERRORLEVEL% neq 0 set ERROR_CODE=1

exit /b %ERROR_CODE%
