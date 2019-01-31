#!/bin/bash

Color_Off="$(printf '\033[0m')" #returns to "normal"
BBlue="$(printf '\e[1;36m')" #set green
BGreen="$(printf '\e[1;32m')" #set green
BRed="$(printf '\033[0;31m')" #set red

pInfo() {
  echo "${BBlue}$1${Color_Off}"
}

pError() {
  echo "${BRed}$1${Color_Off}"
}

pSuccess() {
  echo "${BGreen}$1${Color_Off}"
}

devDeploy() {
  apex deploy $1 --alias dev
}

qaDeploy() {
  apex deploy $1 --env qa --alias qa
  devDeploy $1
}

prodDeploy() {
  apex deploy $1 --env prod --alias prod
  qaDeploy $1
} 

pInfo ">> getting env"
env=$1

pInfo ">> getting function NAME from path"
FUNCTION_NAME=${PWD##*/}
#setting default env if env is empty
if [ -z "$env" ]; then
  env="dev"
fi

pInfo ">> unlink global package lambda-local"
sudo npm unlink lambda-local

pInfo ">> validating params"
if [ -z "$FUNCTION_NAME" ]; then
  pError " ***Function Name is required **"  
  exit 1;
else 
  pInfo ">> Wait a moment we are deploying $FUNCTION_NAME function in $env environment..."
  cd ../../
  case "$env" in
    "dev") devDeploy $FUNCTION_NAME
    ;;
    "qa") qaDeploy $FUNCTION_NAME
    ;;
    "prod") prodDeploy $FUNCTION_NAME
    ;;
  esac
fi