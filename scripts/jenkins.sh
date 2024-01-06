#!/bin/bash

# If via user_data, will run as root so no "sudo" needed

# JENKINS INSTALLTION SCRIPT (UBUNTU...)

# Installing Prerequisites
sudo apt update -y
sudo apt install openjdk-17-jre -y
sudo apt install vim wget git -y
sudo hostnamectl set-hostname jenkins

# Adding jenkins libraries and keys, and installing jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y

# Give jenkins user sudo rights
sudo echo "jenkins ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins