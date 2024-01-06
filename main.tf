provider "aws" {
  region = "us-east-1"
}

# CREATE EC2-INSTANCES
# jenkins
resource "aws_instance" "jenkins" {
  ami = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.medium"
  key_name = "java-app-key"
  security_groups = ["launch-wizard-2"]
  # vpc_security_group_ids = [vpc-095e3d7080afd7633]
  user_data = file("scripts/jenkins.sh")

  tags = {
    Name = "Jenkins-T"
  }
}

# java-agent
resource "aws_instance" "java_agent" {
  ami = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.small"
  key_name = "java-app-key"
  security_groups = ["launch-wizard-9"]

  user_data = file("scripts/agent.sh")

  tags = {
    Name = "Java agent -T"
  }
}

# Sonarqube
resource "aws_instance" "sonarqube" {
  ami = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.small"
  key_name = "java-app-key"
  security_groups = ["launch-wizard-8"]

  user_data = file("scripts/sonarqube.sh")

  tags = {
    Name = "Sonarqube-T"
  }
}

# nexus
resource "aws_instance" "nexus" {
  ami = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.medium"
  key_name = "java-app-key"
  security_groups = ["launch-wizard-3"]

  user_data = file("scripts/nexus.sh")

  tags = {
    Name = "Nexus-T"
  }
}


###### Create a specific key pair for all instances ######
# Create key pair resource (as shown on AWS)
resource "aws_key_pair" "java_app_key" {
  key_name   = "java-app-key"
  public_key = tls_private_key.java_app_tls_key.public_key_openssh
}

# Generate RSA key pair
resource "tls_private_key" "java_app_tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096  # 512 bytes = 256 to 512 chars
}

# Get private key
resource "local_file" "java_app_private_key" {
  filename = "creds/java-app-private-key.pem"
  content = tls_private_key.java_app_tls_key.private_key_pem
  # file_permission = "0600"
}


# How prevent destruction of resources (instances) when changing attributes
# Create security groups for each instance (Since each instance has its own required ports)
# Create a vpc and subnet(s)
# Seperate project into different .tf files
# Overview of important terraform concepts and files