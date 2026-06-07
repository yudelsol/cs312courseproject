variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI ID"
}

variable "instance_type" {
  default = "t3.small"
}

variable "key_name" {
  description = "AWS key pair name"
}
