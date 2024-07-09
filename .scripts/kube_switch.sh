#!/usr/bin/env bash

# Switch between Kubernetes enviroments
aws --profile $1 eks update-kubeconfig --region eu-central-1 --name IO-$1
aws --profile $1 sts get-caller-identity
