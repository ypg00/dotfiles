#!/bin/bash

awsconfigpath=~/.aws/config

# Make sure arg is passed
if [ $# -eq 0 ]; then
    echo "Usage: $0 <env>"
    exit 1
fi

env_name=$1

# Read config file and extract variables for the specified environment
while read -r line || [[ -n "$line" ]]; do
    if [[ $line == \[$env_name\]* ]]; then
        while read -r line || [[ -n "$line" ]]; do
            if [[ $line == *=* ]]; then
                key=$(echo "$line" | cut -d '=' -f 1)
                value=$(echo "$line" | cut -d '=' -f 2-)
                export_key=$(echo "$key" | tr '[:lower:]' '[:upper:]' | sed 's/\./_/g')
                export "$export_key"="$value"
            fi
        done
    fi
done < "$awsconfigpath"
