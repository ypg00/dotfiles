#!/usr/bin/env bash

aws eks update-kubeconfig --region eu-central-1 --profile $1 --name "v3-$1"
aws sts get-caller-identity --profile $1

echo "------------------------------- Workflows -------------------------------"
kubectl get workflows -A
# kubectl get workflows -A -o jsonpath='{range .items[?(@.status.phase=="Running")]}{.metadata.namespace}{"\t"}{.metadata.name}{"\t"}{.status.phase}{"\n"}{end}'
echo ""
kubectl config view | rg current
echo "-------------------------------------------------------------------------"
