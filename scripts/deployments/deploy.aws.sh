#!/bin/bash

# $1 = aws_access_key_id
# $2 = aws_secret_access_key
# $3 = region
install_aws_cli() {
    echo "Install aws cli"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install

    echo "Configure aws cli"
    aws configure set aws_access_key_id $1
    aws configure set aws_secret_access_key $2
    aws configure set default.region $3
}

# $1 = region
# $2 = cluster-name
configure_cluster() {
    echo "Connect to k8s cluster"
    aws eks --region $1 update-kubeconfig --name $2
}

# $1 = aws_access_key_id
# $2 = aws_secret_access_key
# $3 = region
# $4 = cluster-name
execute() {
    install_aws_cli $1 $2 $3
    configure_cluster $3 $4
    kubectl get svc
}

execute $1 $2 $3 $4
