# Global Information
variable "region" {
  type    = string
  default = "us-east-1"
}

# VPC
# <-- VPC Subnet(s) -->
variable "vpc_range" {
  description = "Create a vpc with a specified CIDR (10.2.0.0/16)"
  type        = string
}

# <-- Public Subnet(s) -->
variable "public_subnet_1a" {
  description = "Create a public subnet in zone 1a with a specified CIDR (10.2.16.0/24)"
  type        = string
}

variable "public_subnet_1b" {
  description = "Create a public subnet in zone 1b with a specified CIDR (10.2.32.0/24)"
  type        = string
}

# <-- Private Subnet(s) -->
variable "private_subnet_1a" {
  description = "Create a private subnet in zone 1a with a specified CIDR (10.2.116.0/24)"
  type        = string
}

variable "private_subnet_1b" {
  description = "Create a private subnet in zone 1b with a specified CIDR (10.2.132.0/24)"
  type        = string
}

# Optional Settings
# <-- Jumphost Instance -->
variable "jumphost_sshkey" {
  description = "SSH Key to use for the Jumphost"
  type        = string
}

variable "jumphost_instancetype" {
  description = "The instance type for the Jumphost (t3.micro)"
  type        = string  
}

variable "jumphost_sshport" {
  description = "Choose an SSH port for the Jumphost (22)"
  type        = number
  default     = 22
}

variable "jumphost_ami" {
  description = "Choose an AMI for the Jumphost (Amazon Linux 2 AMI)"
  type        = string
  default     = "ami-033b95fb8079dc481" 
}

# <-- Ansible AWX Instance -->
variable "awx_sshkey" {
  description = "SSH Key to use for the awx1b"
  type        = string
}

variable "awx_instancetype" {
  description = "The instance type for the awx1b (t3.micro)"
  type        = string
}

variable "awx_ami" {
  description = "Choose an AMI for the awx1a (Amazon Linux 2 AMI)"
  type        = string
  default     = "ami-033b95fb8079dc481" 
}