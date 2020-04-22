variable "instance_count" {
  default = 1
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ID" {
  default = "terraform-demo"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "availability_zone" {
  default = "us-east-1a"
}