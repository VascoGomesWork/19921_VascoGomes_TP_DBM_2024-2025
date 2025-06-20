@echo off
setlocal EnableDelayedExpansion

REM === 1. Set Renew Home ===
set "HOMERENEW=E:\Univerisidade_Stuff\Mestrado_IoT\1_Ano\2_Semestre\Desenvolvimento_Baseado_Modelos\renew4.1base"

REM Check if loader.jar exists
if not exist "%HOMERENEW%\de.renew.loader.jar" (
    echo Error: cannot find de.renew.loader.jar in %HOMERENEW%!
    exit /b 1
)

REM === 2. Define External Classes Directory ===
set "SCRIPT_DIR=%~dp0"
set "MY_EXTERNAL_CLASSES_DIR=%SCRIPT_DIR%.."
for %%I in ("%MY_EXTERNAL_CLASSES_DIR%") do set "MY_EXTERNAL_CLASSES_DIR=%%~fI"

echo MY_EXTERNAL_CLASSES_DIR set to: %MY_EXTERNAL_CLASSES_DIR%

REM === 3. Build CLASSPATH ===
set "CP=%HOMERENEW%;%HOMERENEW%\lib;%MY_EXTERNAL_CLASSES_DIR%"

REM Add all .jar files from HOMERENEW recursively
set "ADDITIONAL_JARS="
for /R "%HOMERENEW%" %%F in (*.jar) do (
    set "ADDITIONAL_JARS=!ADDITIONAL_JARS!;%%F"
)

set "CP=%CP%!ADDITIONAL_JARS!"

REM Strip leading semicolon if present
if "!CP:~0,1!"==";" set "CP=!CP:~1!"

echo CLASSPATH: !CP!

REM === 4. Find Java ===
set "JAVACMD=java"
if defined JAVA_HOME (
    if exist "%JAVA_HOME%\bin\java.exe" (
        set "JAVACMD=%JAVA_HOME%\bin\java.exe"
    )
)

REM Check Java command
where %JAVACMD% >nul 2>nul
if errorlevel 1 (
    echo Error: Java command not found.
    exit /b 1
)

REM === 5. Module Path ===
set "MODULE_PATH=%HOMERENEW%"
if exist "%HOMERENEW%\libs" (
    set "MODULE_PATH=%MODULE_PATH%;%HOMERENEW%\libs"
)
if /I not "%MY_EXTERNAL_CLASSES_DIR%"=="%HOMERENEW%" if /I not "%MY_EXTERNAL_CLASSES_DIR%"=="%HOMERENEW%\libs" (
    set "MODULE_PATH=%MODULE_PATH%;%MY_EXTERNAL_CLASSES_DIR%"
)

echo JAVA COMMAND: %JAVACMD%
echo MODULE_PATH: %MODULE_PATH%

REM === 6. Find .rnw files in parent directory ===
set "RNW_ARGS="
set "RNW_FOUND=0"
for %%F in ("%MY_EXTERNAL_CLASSES_DIR%\*.rnw") do (
    if exist "%%F" (
        set "RNW_ARGS=!RNW_ARGS! "%%F""
        set "RNW_FOUND=1"
    )
)

REM === 7. Launch Renew ===
set "JAVA_ARGS=-Xmx200M -Dde.renew.netPath=%MY_EXTERNAL_CLASSES_DIR% -classpath "%CP%" -p "%MODULE_PATH%" -m de.renew.loader/de.renew.plugin.PluginManager gui"

echo Executing:
echo %JAVACMD% %JAVA_ARGS% %RNW_ARGS% %*

%JAVACMD% %JAVA_ARGS% %RNW_ARGS% %*

if errorlevel 1 (
    echo Renew exited with an error.
    exit /b 1
) else (
    echo Renew ran successfully.
)

endlocal
