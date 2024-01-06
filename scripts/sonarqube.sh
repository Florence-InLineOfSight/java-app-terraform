#!/bin/bash

# If via user_data, will run as root so no "sudo" needed

#SONARQUBE INSTALLATION MANUAL/SCRIPT

##Prerequisites (T2-Medium EC2)
sudo hostnamectl set-hostname SonarQube
sudo apt update
sudo apt install default-jdk -y
sudo apt install wget git unzip vim -y

##Download and extract SonarQube directory
cd /opt
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.2.46101.zip
sudo unzip sonarqube-8.9.2.46101.zip
sudo rm -rf sonarqube-8.9.2.46101.zip
sudo mv sonarqube-8.9.2.46101 sonarqube

##Create sonar user and assign permissions/ownership
sudo useradd -d /opt/sonarqube -s /bin/bash -U sonar
sudo echo "sonar ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/sonar
sudo chown -R sonar: /opt/sonarqube


## Configure sonarqube to run as a service: create a sonarqube.service file and add some content to it.
output_file="/etc/systemd/system/sonarqube.service"

# Redirect configuration block to output file
sudo tee "$output_file" << EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
User=sonar
Environment="JAVA_HOME=/usr/lib/jvm/default-java"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
Restart=always
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF


##Start sonarqube
sudo systemctl daemon-reload	#Reload daemon after service configurations
sudo systemctl enable sonarqube	#Enable sonarqube to start upon boot
sudo systemctl start sonarqube
# sudo systemctl status sonarqube