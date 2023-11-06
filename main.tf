provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}


resource "aws_instance" "web_server" {
  ami           = "ami-0fc5d935ebf8bc3bc"  # Update with your desired AMI
  instance_type = "t2.micro"  # Update with your desired instance type
  key_name      = "taskformonday"
  vpc_security_group_ids = [
    aws_security_group.My_Monday_Task.id,
    # Add more security group IDs if needed
  ]


  tags = {
    Name = "XAMPP-EC2"
  }
}

resource "aws_security_group" "My_Monday_Task" {
  name        = "http-https-ssh-sg12"
  description = "Allow HTTP, HTTPS, and SSH traffic"
}

resource "aws_security_group_rule" "http_ingress2" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Allow HTTP from anywhere (not recommended for production)
  security_group_id = aws_security_group.My_Monday_Task.id
}

resource "aws_security_group_rule" "https_ingress2" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Allow HTTPS from anywhere (not recommended for production)
  security_group_id = aws_security_group.My_Monday_Task.id
}

resource "aws_security_group_rule" "ssh_ingress2" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Allow SSH from anywhere (not recommended for production)
  security_group_id = aws_security_group.My_Monday_Task.id
}

resource "aws_security_group_rule" "all_egress2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # Allow all outbound traffic
  cidr_blocks       = ["0.0.0.0/0"] # Allow all outbound traffic
  security_group_id = aws_security_group.My_Monday_Task.id
}
