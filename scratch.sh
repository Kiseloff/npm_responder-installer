INTERACTIVE=${INTERACTIVE:-1}

DEFAULT_STACK_NAME=${STACK_NAME:-npmresponder}

DEFAULT_APP_WEBUI_PORT=${APP_WEBUI_PORT:-8080}
DEFAULT_APP_API_EXTERNAL_IP=${APP_API_EXTERNAL_IP:-}
DEFAULT_APP_API_PORT=${APP_API_PORT:-5001}

DEFAULT_APP_API_USERNAME=${APP_API_USERNAME:-}
DEFAULT_APP_API_SNMPv3_SECRET=${APP_API_SNMPv3_SECRET:-}
DEFAULT_APP_API_SSH_SECRET=${APP_API_SSH_SECRET:-}
DEFAULT_APP_API_COMMUNITY=${APP_API_COMMUNITY:-public}

DEFAULT_APP_TELNETSRV_PORT=${APP_TELNETSRV_PORT:-8023}


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
  read app_port
  WEBUI_PORT=${app_port:=$DEFAULT_APP_WEBUI_PORT}


}