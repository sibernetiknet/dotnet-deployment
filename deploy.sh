#Functions
PRINTMESSAGE(){
    echo "[*] $1"
}
LOGMESSAGE(){
    echo "[**] Log: $1"
}

SDKCHECK(){
    if command -v dotnet >/dev/null 2>&1; then
    printMessage "The .NET SDK is installed."
    else
    printMessage "The .NET SDK is not installed. Visit: https://dotnet.microsoft.com/en-us/download"
    exit
    fi
}



SDKCHECK



