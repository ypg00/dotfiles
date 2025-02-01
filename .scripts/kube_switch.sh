#!/usr/bin/env bash

# Switch between Kubernetes enviroments
aws eks update-kubeconfig --region eu-central-1 --profile $2 --name "$1-$2"
aws sts get-caller-identity --profile $2

echo "---------- Workflows ----------"
kubectl get workflows -A -o jsonpath='{range .items[?(@.status.phase=="Running")]}{.metadata.namespace}{"\t"}{.metadata.name}{"\t"}{.status.phase}{"\n"}{end}'
echo "---------- cronWorkflows ----------"
kubectl get cronWorkflows -A -o jsonpath='{range .items[?(@.status.phase=="Running")]}{.metadata.namespace}{"\t"}{.metadata.name}{"\t"}{.status.phase}{"\n"}{end}'
