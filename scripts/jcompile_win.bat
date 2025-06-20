@echo off
setlocal EnableDelayedExpansion

:: === Configuration ===
:: Set the path to your Renew installation
set "RENEW_DIR=E:\Univerisidade_Stuff\Mestrado_IoT\1_Ano\2_Semestre\Desenvolvimento_Baseado_Modelos\renew4.1base"

:: === Build CLASSPATH from all .jar files ===
set "CP=."

for /R "%RENEW_DIR%" %%f in (*.jar) do (
    set "CP=!CP!;%%f"
)

:: === Append existing CLASSPATH if set ===
if defined CLASSPATH (
    set "CP=%CLASSPATH%;!CP!"
)

echo Using CLASSPATH: !CP!

:: === Locate Java compiler ===
if defined JAVA_HOME (
    if exist "%JAVA_HOME%\bin\javac.exe" (
        set "JAVAC=%JAVA_HOME%\bin\javac.exe"
    ) else (
        set "JAVAC=javac"
    )
) else (
    set "JAVAC=javac"
)

:: === Compile with arguments passed to the script ===
%JAVAC% -classpath "!CP!" %*

endlocal
