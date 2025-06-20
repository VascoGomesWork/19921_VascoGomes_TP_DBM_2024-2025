# === Configuration ===
# Set your Renew base directory
$RENEW_DIR = "E:\Univerisidade_Stuff\Mestrado_IoT\1_Ano\2_Semestre\Desenvolvimento_Baseado_Modelos\renew4.1base"

# === Build the CLASSPATH from all JAR files ===
$jarFiles = Get-ChildItem -Path $RENEW_DIR -Recurse -Filter "*.jar" | Select-Object -ExpandProperty FullName
$CP = ".;" + ($jarFiles -join ";")

# Append existing CLASSPATH if set
if ($env:CLASSPATH) {
    $CP = "$env:CLASSPATH;$CP"
}

Write-Host "Using CLASSPATH: $CP"

# === Find javac ===
$JAVAC = "javac.exe"
if ($env:JAVA_HOME) {
    $javaPath = Join-Path $env:JAVA_HOME "bin\javac.exe"
    if (Test-Path $javaPath) {
        $JAVAC = $javaPath
    }
}

# === Compile passed Java files ===
if ($args.Count -eq 0) {
    Write-Error "No Java files specified to compile."
    exit 1
}

# Execute javac
& $JAVAC -classpath $CP @args
