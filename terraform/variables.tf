variable "name" {
  type        = string
  description = "Name prefix"
  default     = "sandbox"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "default_tags" {
  type = map(string)
  default = {
    Project = "awsauth"
    Managed = "terraform"
    Owner   = "you"
  }
}
