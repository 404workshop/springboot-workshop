@echo off
setlocal

:: Check if mvn is available in PATH
where mvn >nul 2>&1
if %errorlevel% equ 0 (
    mvn %*
    exit /b %errorlevel%
)

echo [INFO] Apache Maven not found in PATH. Bootstrapping Maven via PowerShell...

set MAVEN_VERSION=3.9.6
set MAVEN_HOME_DIR=%USERPROFILE%\.m2\wrapper\dists\apache-maven-%MAVEN_VERSION%

if exist "%MAVEN_HOME_DIR%\bin\mvn.cmd" (
    "%MAVEN_HOME_DIR%\bin\mvn.cmd" %*
    exit /b %errorlevel%
)

echo [INFO] Downloading Apache Maven %MAVEN_VERSION% (this may take a few seconds)...
powershell -Command "$url = 'https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip'; $zip = \"$env:TEMP\maven.zip\"; $dest = \"$env:USERPROFILE\.m2\wrapper\dists\"; New-Item -ItemType Directory -Force -Path $dest | Out-Null; Invoke-WebRequest -Uri $url -OutFile $zip; Expand-Archive -Path $zip -DestinationPath $dest -Force; Remove-Item $zip"

if exist "%MAVEN_HOME_DIR%\bin\mvn.cmd" (
    "%MAVEN_HOME_DIR%\bin\mvn.cmd" %*
) else (
    echo [ERROR] Failed to bootstrap Maven. Please install Maven manually.
    exit /b 1
)
endlocal
