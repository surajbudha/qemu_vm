#!/bin/bash
# Install terraform on linux systems
# Authors: Suraj Budha Thoki
# Date: 2024-06-10
# Version: 1.0

set -e
os_family="unknown"

# Determine OS family
if [[ -f /etc/os-release ]]
  then
  echo "test"
  os_family=$(cat /etc/os-release | grep ^NAME | cut -d '"' -f2 | tr '[:upper:]' '[:lower:]')
elif [[ -f /etc/redhat-release ]]
  then
  os_family="redhat"
fi

echo "$os_family"

if [[ "$os_family" == *"ubuntu"* || "$os_family" == *"debian"* ]]
  then
    echo "Installing terraform on Ubuntu/Debian"
    sudo apt-get update
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update
    sudo apt-get install -y terraform
    terraform -help
    echo "Terraform installation completed on Ubuntu/Debian"

elif [[ "$os_family" == *"redhat"* || "$os_family" == *"centos"* || "$os_family" == *"fedora"* ]]
  then
    echo "Installing terraform on RedHat/CentOS/Fedora"
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    sudo yum -y install terraform
    terraform -help
    echo "Terraform installation completed on RedHat/CentOS/Fedora"
else
    echo "This script is intended for Ubuntu/Debian/Redhat systems only."
    exit 1
fi