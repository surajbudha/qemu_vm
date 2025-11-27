#!/bin/bash
# Install jenkins on linux systems
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
    echo "Installing Jenkins on Ubuntu/Debian"
    sudo apt update
    sudo apt -y install fontconfig openjdk-21-jre
    if [[ $(java -version; echo $?) -ne 0 ]]; then
        echo "Java installation failed. Exiting."
        exit 1
    fi
    if [[ ! -f /etc/apt/sources.list.d/jenkins.list ]]; then
        sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
        echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
        sudo apt update
    fi
    sudo apt -y install jenkins
    sudo systemctl daemon-reload
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    sudo systemctl status jenkins --no-pager
    echo "Jenkins installation completed on Ubuntu/Debian"

elif [[ "$os_family" == *"redhat"* || "$os_family" == *"centos"* || "$os_family" == *"fedora"* ]]
  then
    echo "Installing Jenkins on RedHat/CentOS/Fedora"
    ssudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo yum upgrade
    # Add required dependencies for the jenkins package
    sudo yum install fontconfig java-21-openjdk -y
    sudo yum install jenkins -y
    sudo systemctl daemon-reload
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    sudo systemctl status jenkins --no-pager
    echo "Jenkins installation completed on RedHat/CentOS/Fedora"
else
    echo "This script is intended for Ubuntu/Debian/Redhat systems only."
    exit 1
fi