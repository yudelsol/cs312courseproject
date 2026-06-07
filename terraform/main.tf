terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-sg"
  description = "Allow SSH and Minecraft traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Minecraft"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "minecraft-sg"
  }
}

resource "aws_instance" "minecraft" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "minecraft-server"
  }
}

resource "aws_eip" "minecraft_ip" {
  domain = "vpc"

  tags = {
    Name = "minecraft-eip"
  }
}

resource "aws_eip_association" "minecraft_eip_assoc" {
  instance_id   = aws_instance.minecraft.id
  allocation_id = aws_eip.minecraft_ip.id
}
