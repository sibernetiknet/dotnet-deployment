#Path variables
HOME_DIRECTORY=~

#Functions
PRINTMESSAGE(){
    echo -e "\n [*] $1 \n"
}
LOGMESSAGE(){
    echo -e "\n [**] Log: $1 \n"
}

SDKCHECK(){
    if command -v dotnet >/dev/null 2>&1; then
    PRINTMESSAGE "The .NET SDK is installed."
    else
    PRINTMESSAGE "The .NET SDK is not installed. Visit: https://dotnet.microsoft.com/en-us/download"
    exit
    fi
}

#.NET SDK Control
SDKCHECK

#Read project path
while true; do
  read -p "Enter the project full path of the folder: " PROJECT_PATH

  if [ -d "$PROJECT_PATH" ]; then
    LOGMESSAGE "Folder exist."
    break
  else
    PRINTMESSAGE "Folder does not exist: $PROJECT_PATH"
  fi
done

#Read project publis path
while true; do
  read -p "Enter the full path folder to save the project to be published: " PROJECT_PUBLISH_PATH

  if [ -d "$PROJECT_PUBLISH_PATH" ]; then
    LOGMESSAGE "Folder exist."
    break
  else
    PRINTMESSAGE "Folder does not exist: $PROJECT_PUBLISH_PATH"
  fi
done










