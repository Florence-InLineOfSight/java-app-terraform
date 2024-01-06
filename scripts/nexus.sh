#!/bin/bash

# If via user_data, will run as root so no "sudo" needed

# Prerequisites
sudo hostnamectl set-hostname nexus
sudo apt update -y
sudo apt install openjdk-17-jre -y
sudo apt-get install openjdk-8-jdk -y
sudo apt install vim wget git -y

# Download nexus tar file, check official website for latest/preferred version
cd /opt
sudo wget https://download.sonatype.com/nexus/3/nexus-3.58.1-02-unix.tar.gz

# Extract nexus and sonatype work
sudo tar -xvzf nexus-3.58.1-02-unix.tar.gz
sudo rm -rf nexus-3.58.1-02-unix.tar.gz		# Delete after extraction
sudo mv /opt/nexus-3.58.1-02/ /opt/nexus  # Rename folder to nexus

# Set nexus user to run nexus
sudo echo 'run_as_user="nexus"' > /opt/nexus/bin/nexus.rc

# Create nexus user and assign sudo privilege
sudo useradd -d /opt/nexus -s /bin/bash -U nexus
sudo echo "nexus ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nexus

# Change ownership
sudo chown -R nexus:nexus /opt/nexus/
sudo chown -R nexus:nexus /opt/sonatype-work/


## Configure nexus to run as a service: create a nexus.service file and add some content to it.
output_file="/etc/systemd/system/nexus.service"

# Redirect configuration block to output file
sudo tee "$output_file" << EOF
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-failure
RestartSec=2
StartLimitInterval=60

[Install]
WantedBy=multi-user.target
EOF


# Run nexus
sudo systemctl daemon-reload
sudo systemctl start nexus
sudo systemctl enable nexus	# Enable nexus to start when server starts running