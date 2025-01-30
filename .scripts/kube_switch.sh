#!/usr/bin/env bash

# Switch between Kubernetes enviroments
aws eks update-kubeconfig --region eu-central-1 --name 1-31-$1 --profile $1
aws --profile $1 sts get-caller-identity
kubectl get workflows -A -o jsonpath='{range .items[?(@.status.phase=="Running")]}{.metadata.namespace}{"\t"}{.metadata.name}{"\t"}{.status.phase}{"\n"}{end}'
