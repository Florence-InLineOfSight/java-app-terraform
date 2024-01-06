#!/bin/bash

# If via user_data, will run as root so no "sudo" needed

#DOCKER INSTALLATION ON UBUNTU
#https://docs.docker.com/engine/install/ubuntu/

#Requirements
##At least 64 bit operating system with at least 2 GB recommended RAM, with necessary storage based on 
##size of images and containers to be created.


#Prerequisites
##Uninstall conflicting unofficial packages for Docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

##Setup apt repository
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg -y
sudo hostnamectl set-hostname Java-agent

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo systemctl enable docker

##Add ubuntu (or any preferred user) to docker group to grant docker privileges
sudo usermod -aG docker ubuntu

##Reboot instance to effect change