#!/bin/bash

GC='\033[0;32m' #green color
RC='\033[0;31m' #red color
OC='\033[0;33m' #orange color
NC='\033[0m' #no color
IC='\033[0;37m' #input text
BC='\033[1m' #bold text
UC='\033[4m' #underline text

function successLog { echo -e "${GC}$1${NC}"; }
function warningLog { echo -e "${OC}$1${NC}"; }
function errorLog { echo -e "${RC}$1${NC}"; }
function inputLog { printf "${IC}$1${NC}"; }
function titleLog { echo -e "${BC}$1${NC}"; }
function sectionLog { echo -e "${UC}$1${NC}"; }
function log { echo -e "$1"; }

# INFO
clear
figlet NPM responder
titleLog "Welcome to NPM responder"
log "Version: $VERSION"

# INSTALLATION
sectionLog "\nPreparing installation"
# TODO: uncomment
#git clone https://github.com/Kiseloff/npm_responder-webui.git
if [ $? -eq 0 ]; then
  successLog "DONE."
else
  errorLog "PREPARATION FAILED!"
  exit 1
fi

# SETUP
sectionLog "\nApplication setup"

INTERACTIVE=${INTERACTIVE:-1}

DEFAULT_STACK_NAME=${STACK_NAME:-npmresponder}

DEFAULT_APP_WEBUI_PORT=${APP_WEBUI_PORT:-8080}
DEFAULT_APP_API_EXTERNAL_IP=${APP_API_EXTERNAL_IP:-}
DEFAULT_APP_API_PORT=${APP_API_PORT:-5001}

DEFAULT_APP_TELNETSRV_PORT=${APP_TELNETSRV_PORT:-8023}

DEFAULT_APP_USERNAME=${APP_USERNAME:-npmd}
DEFAULT_APP_SNMPv3_SECRET=${APP_SNMPv3_SECRET:-}
DEFAULT_APP_SSH_SECRET=${APP_SSH_SECRET:-}
DEFAULT_APP_COMMUNITY=${APP_COMMUNITY:-public}

interactiveSetup() {
  ## Enter stack name
  while true
  do
    inputLog "Enter stack name [$DEFAULT_STACK_NAME]: "
    read stack_name
    STACK=${stack_name:=$DEFAULT_STACK_NAME}
    docker stack ps $STACK &> /dev/null
    if [ $? -eq 0 ]; then
      warningLog "Stack name [$STACK] is already taken!"
    else
      break
    fi
  done

  ## Enter web-ui application port
  inputLog "Enter web-ui application port [$DEFAULT_APP_WEBUI_PORT]: "
  read app_webui_port
  WEBUI_PORT=${app_webui_port:=$DEFAULT_APP_WEBUI_PORT}

  ## Enter api server IP address
  inputLog "Enter api server IP address [$DEFAULT_APP_API_EXTERNAL_IP]: "
  read app_api_external_ip
  API_EXTERNAL_IP=${app_api_external_ip:=$DEFAULT_APP_API_EXTERNAL_IP}

  ## Enter api server port
  inputLog "Enter api server port [$DEFAULT_APP_API_PORT]: "
  read app_api_port
  API_PORT=${app_api_port:=$DEFAULT_APP_API_PORT}

  ## Enter telnet server port
  inputLog "Enter telnet server port [$DEFAULT_APP_TELNETSRV_PORT]: "
  read app_telnetsrv_port
  TELNETSRV_PORT=${app_telnetsrv_port:=$DEFAULT_APP_TELNETSRV_PORT}

  ## Enter SNMPv3/SSH username
  inputLog "Enter SNMPv3/SSH username [$DEFAULT_APP_USERNAME]: "
  read app_username
  USERNAME=${app_username:=$DEFAULT_APP_USERNAME}

  ## Enter SNMPv3 secret
  inputLog "Enter SNMPv3 secret [$DEFAULT_APP_SNMPv3_SECRET]: "
  read app_snmpv3_secret
  SNMPv3_SECRET=${app_snmpv3_secret:=$DEFAULT_APP_SNMPv3_SECRET}

  ## Enter SSH secret
  inputLog "Enter SSH secret [$DEFAULT_APP_SSH_SECRET]: "
  read app_ssh_secret
  SSH_SECRET=${app_ssh_secret:=$DEFAULT_APP_SSH_SECRET}

  ## Enter SNMPv2c community
  inputLog "Enter SNMPv2c community [$DEFAULT_APP_COMMUNITY]: "
  read app_community
  COMMUNITY=${app_community:=$DEFAULT_APP_COMMUNITY}

#  log "STACK: $STACK"
#  log "WEBUI_PORT: $WEBUI_PORT"
#  log "API_EXTERNAL_IP: $API_EXTERNAL_IP"
#  log "API_PORT: $API_PORT"
#  log "TELNETSRV_PORT: $TELNETSRV_PORT"
#  log "USERNAME: $USERNAME"
#  log "SNMPv3_SECRET: $SNMPv3_SECRET"
#  log "SSH_SECRET: $SSH_SECRET"
#  log "COMMUNITY: $COMMUNITY"
}

nonInteractiveSetup() {
  ## Stack name
  inputLog "Stack name: $DEFAULT_STACK_NAME"
  STACK=$DEFAULT_STACK_NAME
  docker stack ps $STACK &> /dev/null
  if [ $? -eq 0 ]; then
    warningLog "\nStack name [$STACK] is already taken!"
    errorLog "SETUP FAILED!"
    exit 1
  fi

  ## web-ui application port
  inputLog "\nWeb-ui application port: $DEFAULT_APP_WEBUI_PORT "
  WEBUI_PORT=$DEFAULT_APP_WEBUI_PORT

  ## api server IP address
  inputLog "\nApi server IP address: $DEFAULT_APP_API_EXTERNAL_IP "
  API_EXTERNAL_IP=$DEFAULT_APP_API_EXTERNAL_IP

  ## api server port
  inputLog "\nApi server port: $DEFAULT_APP_API_PORT "
  API_PORT=$DEFAULT_APP_API_PORT

  ## telnet server port
  inputLog "\nTelnet server port: $DEFAULT_APP_TELNETSRV_PORT "
  TELNETSRV_PORT=$DEFAULT_APP_TELNETSRV_PORT

  ## SNMPv3/SSH username
  inputLog "\nSNMPv3/SSH username: $DEFAULT_APP_USERNAME "
  USERNAME=$DEFAULT_APP_USERNAME

  ## SNMPv3 secret
  inputLog "\nSNMPv3 secret: $DEFAULT_APP_SNMPv3_SECRET "
  SNMPv3_SECRET=$DEFAULT_APP_SNMPv3_SECRET

  ## SSH secret
  inputLog "\nSSH secret: $DEFAULT_APP_SSH_SECRET "
  SSH_SECRET=$DEFAULT_APP_SSH_SECRET

  ## SNMPv2c community
  inputLog "\nSNMPv2c community: $DEFAULT_APP_COMMUNITY \n"
  COMMUNITY=$DEFAULT_APP_COMMUNITY

}


if [ $INTERACTIVE -eq 1 ]; then
  interactiveSetup
else
  nonInteractiveSetup
fi


COMPOSE_FILE="npm_responder-webui/docker-compose.yml"
max_attempts=20

#TODO: delete '' in sed. It's used in MAC OSX version sed
sed -i '' 's/${APP_WEBUI_PORT}/'"$WEBUI_PORT"'/g' $COMPOSE_FILE
sed -i '' 's/${APP_API_EXTERNAL_IP}/'"$API_EXTERNAL_IP"'/g' $COMPOSE_FILE
sed -i '' 's/${APP_API_PORT}/'"$API_PORT"'/g' $COMPOSE_FILE
sed -i '' 's/${APP_TELNETSRV_PORT}/'"$TELNETSRV_PORT"'/g' $COMPOSE_FILE
sed -i '' 's/${APP_API_USERNAME}/'"$USERNAME"'/g' $COMPOSE_FILE
sed -i '' 's/${APP_API_SNMPv3_SECRET}/'"$SNMPv3_SECRET"'/g' $COMPOSE_FILE
sed -i '' 's/${APP_API_SSH_SECRET}/'"$SSH_SECRET"'/g' $COMPOSE_FILE
sed -i '' 's/${APP_API_COMMUNITY}/'"$COMMUNITY"'/g' $COMPOSE_FILE

successLog "DONE."

## DEPLOYMENT
#sectionLog "\nApplication deployment"
#docker stack deploy -c $COMPOSE_FILE $STACK
#if [ $? -eq 0 ]; then
#  successLog "DONE."
#else
#  errorLog "DEPLOYMENT FAILED!"
#  exit 1
#fi