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

SSHCONNECTIONTEST(){
    ssh -q -o ConnectTimeout=10 $REMOTE_USER@$REMOTE_HOST exit
    return $?
}

PUBLISHPROJECT(){
    cd $PROJECT_PATH
    dotnet clean
    dotnet build
    dotnet publish --configuration Release --output $PROJECT_PUBLISH_PATH .
}

TRANSFER(){
    if [ "$USE_IIS" != "${USE_IIS#[Yy]}" ]; then
        ssh $REMOTE_USER@$REMOTE_HOST 'iisreset /stop'
        PRINTMESSAGE "IIS stopped."
        else
            LOGMESSAGE "ISS not using."
    fi

    scp -r $PROJECT_PUBLISH_PATH/* --exclude=wwwroot --exclude=.DS_Store $REMOTE_USER@$REMOTE_HOST:$REMOTE_PROJECT_PATH

    if [ "$USE_IIS" != "${USE_IIS#[Yy]}"  ]; then
        ssh $REMOTE_USER@$REMOTE_HOST 'iisreset /start'
        PRINTMESSAGE "IIS started."
        else
        LOGMESSAGE "ISS not using."
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

#Read project publish path
while true; do
  read -p "Enter the full path folder to save the project to be published: " PROJECT_PUBLISH_PATH

  if [ -d "$PROJECT_PUBLISH_PATH" ]; then
    LOGMESSAGE "Folder exist."
    break
  else
    PRINTMESSAGE "Folder does not exist: $PROJECT_PUBLISH_PATH"
  fi
done

#Read remote user and host
while true; do
  read -p "Enter remote user : " REMOTE_USER
  read -p "Enter remote host : " REMOTE_HOST

  SSHCONNECTIONTEST

  if [ $? -eq 0 ]; then
    PRINTMESSAGE "SSH Connection created."
    break
  else
    PRINTMESSAGE "Connection failed. Please enter remote desktop information."
  fi
done

#Read IIS information
while true; do
  read -p "Do you want to restart the IIS service? (y/n) : " USE_IIS

    case $USE_IIS in 
        [yY] ) break;;
        [nN] ) break;;
        * ) PRINTMESSAGE "Invalid response. Try again please."
    esac

done

#Read remote desktop website folder
while true; do
  read -p "Enter remote desktop website folder path : " REMOTE_PROJECT_PATH

    if ssh $REMOTE_USER@$REMOTE_HOST "powershell -Command "Test-Path -Path ''$REMOTE_PROJECT_PATH''"" | grep 'True'
        then
        PRINTMESSAGE "Remote project folder path exist."
        break;
        else
        PRINTMESSAGE "Remote project folder path not found. Please enter again."
    fi
done

# File transfer operations
PRINTMESSAGE "File transfer operation begins. Please wait."

PUBLISHPROJECT
TRANSFER

PRINTMESSAGE "File transfer operation finished. Please check your website."





















