provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}


resource "aws_instance" "web_server" {
  ami           = "ami-0fc5d935ebf8bc3bc"  # Update with your desired AMI
  instance_type = "t2.micro"  # Update with your desired instance type
  vpc_security_group_ids = [
    aws_security_group.My_Monday_Task.id,
    # Add more security group IDs if needed
  ]

  user_data = <<-EOF
    #!/bin/bash
    # Switch to the root user
    sudo su -

    # Update the package manager with automatic "yes" responses
    yes | apt update

    # Install expect with automatic "yes" responses
    yes | apt-get install -y expect

    # Download XAMPP installer
    wget https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/8.1.17/xampp-linux-x64-8.1.17-0-installer.run

    # Make the installer executable
    chmod +x xampp-linux-x64-8.1.17-0-installer.run

    yes | ./xampp-linux-x64-8.1.17-0-installer.run

    # Install netstat
    yes | apt-get install -y net-tools

    # Update the XAMPP configuration to allow access
    sed -i 's/local/all granted/' /opt/lampp/etc/extra/httpd-xampp.conf

    # Restart XAMPP
    /opt/lampp/lampp restart

    # Change to the XAMPP htdocs directory
    cd /opt/lampp/htdocs

    # Clone a Git repository (replace URL with your repository)
    git clone https://github.com/Pavan0445/TaskforMonday.git
    EOF

  tags = {
    Name = "XAMPP-EC2"
  }
}

resource "aws_security_group" "My_Monday_Task" {
  name        = "http-https-ssh-sg"
  description = "Allow HTTP, HTTPS, and SSH traffic"
}

resource "aws_security_group_rule" "http_ingress1" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Allow HTTP from anywhere (not recommended for production)
  security_group_id = aws_security_group.My_Monday_Task.id
}

resource "aws_security_group_rule" "https_ingress1" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Allow HTTPS from anywhere (not recommended for production)
  security_group_id = aws_security_group.My_Monday_Task.id
}

resource "aws_security_group_rule" "ssh_ingress1" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Allow SSH from anywhere (not recommended for production)
  security_group_id = aws_security_group.My_Monday_Task.id
}

resource "aws_security_group_rule" "all_egress1" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # Allow all outbound traffic
  cidr_blocks       = ["0.0.0.0/0"] # Allow all outbound traffic
  security_group_id = aws_security_group.My_Monday_Task.id
}
