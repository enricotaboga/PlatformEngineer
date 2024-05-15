#!/bin/bash

terraform apply -target module.aws_eks -target module.aws_kms -target module.aws_vpc -target null_resource.update_kubeconfig -var-file terraform.tfvars -auto-approve

sleep 30

terraform apply -var-file terraform.tfvars -auto-approve
