#!/bin/sh

if ! test "$1"; then
    echo "Usage: $0 user@addr ..."
    exit 1
fi

key=$(cat ~/.ssh/id_rsa.pub)

reset="\e[0m"
red="\e[0;31m"
green="\e[0;32m"

for host in $@
do
    echo "***************[${host}]******************"
    ssh -o PasswordAuthentication=no $host "ls>/dev/null" 2>/dev/null
    if [[ $? == 0 ]]; then
        printf "${green}already exists...${reset}\n"
        continue
    fi
    ssh $host "chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys && echo $key >> ~/.ssh/authorized_keys"
    if [[ $? != 0 ]]; then
        echo "error..."
        exit 1
    fi
    ssh -o PasswordAuthentication=no $host "ls>/dev/null" 2>/dev/null
    if [[ $? != 0 ]]; then
        printf "${red}failed...${reset}\n"
    else
        printf "${green}success...${reset}\n"
    fi
done
