#!/bin/bash

install_gcloud() {
    wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-310.0.0-linux-x86_64.tar.gz
    tar -xzf google-cloud-sdk-310.0.0-linux-x86_64.tar.gz
    ./google-cloud-sdk/install.sh
}

configure_cluster() {
    mkdir -p /etc/deploy
    echo $1 | base64 -d > /etc/deploy/sa.json
    ./google-cloud-sdk/bin/gcloud auth activate-service-account --key-file /etc/deploy/sa.json --project=$2
    ./google-cloud-sdk/bin/gcloud components install kubectl
    ./google-cloud-sdk/bin/gcloud config set project $2
    ./google-cloud-sdk/bin/gcloud container clusters get-credentials $3 --zone $4
}

# $1 - gke_service_account_creds_base_64
# $2 - gke_project
# $3 - gke_cluster_name
# $4 - gke_zone
execute() {
    install_gcloud
    configure_cluster $1 $2 $3 $4
    kubectl get svc
}

execute $1 $2 $3 $4
