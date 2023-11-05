provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}

resource "aws_instance" "example" {
  ami           = "ami-05c13eab67c5d8861"  # Replace with the AMI ID of your choice
  instance_type = "t2.micro"              # You can choose a different instance type

  tags = {
    Name = "ExampleInstance"
  }
}
