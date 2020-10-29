# Terraform state will be stored in S3
terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-8eec1e97ac602d3228bad33b61efeaae"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}

# Use AWS Terraform provideryes
provider "aws" {
  region = "eu-west-1"
}

# Create EC2 instance https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "default" {
  ami                    = var.ami
  count                  = var.instance_count
  vpc_security_group_ids = [aws_security_group.default.id]
  source_dest_check      = false
  instance_type          = var.instance_type

  tags = {
    Name = "terraform-default"
  }
}

# Create Security Group for EC2 - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "default" {
  name = "terraform-default-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
