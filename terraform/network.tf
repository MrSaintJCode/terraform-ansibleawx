# <-- VPC Subnet(s) -->
resource "aws_vpc" "workspace_vpc" {
  cidr_block           = var.vpc_range
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name"         = "${terraform.workspace}-vpc"
    "Env"          = "${terraform.workspace}"
    "Project"      = "${terraform.workspace}"
    "DeployedWith" = "terraform"
  }
}

# <-- Public Subnets -->
# Public Subnet - 1a
resource "aws_subnet" "workspace_public_subnet_1a" {
  vpc_id                  = aws_vpc.workspace_vpc.id
  cidr_block              = var.public_subnet_1a
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    "Name"         = "${terraform.workspace}-public_1a"
    "Env"          = "${terraform.workspace}"
    "Project"      = "${terraform.workspace}"
    "DeployedWith" = "terraform"
  }
}

# Public Subnet - 1b
resource "aws_subnet" "workspace_public_subnet_1b" {
  vpc_id                  = aws_vpc.workspace_vpc.id
  cidr_block              = var.public_subnet_1b
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    "Name"         = "${terraform.workspace}-public_1b"
    "Env"          = "${terraform.workspace}"
    "Project"      = "${terraform.workspace}"
    "DeployedWith" = "terraform"
  }
}

# <-- Private Subnets -->
# Private Subnet - 1a
resource "aws_subnet" "workspace_private_subnet_1a" {
  vpc_id            = aws_vpc.workspace_vpc.id
  cidr_block        = var.private_subnet_1a
  availability_zone = "us-east-1a"
  #map_public_ip_on_launch = false
  tags = {
    "Name"         = "${terraform.workspace}-priv_sub_1a"
    "Env"          = "${terraform.workspace}"
    "Project"      = "${terraform.workspace}"
    "DeployedWith" = "terraform"
  }
}

# Private Subnet - 1b
resource "aws_subnet" "workspace_private_subnet_1b" {
  vpc_id            = aws_vpc.workspace_vpc.id
  cidr_block        = var.private_subnet_1b
  availability_zone = "us-east-1b"
  #map_public_ip_on_launch = false
  tags = {
    "Name"         = "${terraform.workspace}-priv_sub_1b"
    "Env"          = "${terraform.workspace}"
    "Project"      = "${terraform.workspace}"
    "DeployedWith" = "terraform"
  }
}

# <-- Internet Gateway(s) -->
# workspace_vpc
resource "aws_internet_gateway" "workspace_gateway" {
  vpc_id = aws_vpc.workspace_vpc.id
  tags = {
    "Name"         = "${terraform.workspace}-gateway"
    "Env"          = "${terraform.workspace}"
    "Project"      = "${terraform.workspace}"
    "DeployedWith" = "terraform"
  }
}

# <-- Elastic IP(s) --> 
# Elastic IP - 1a
resource "aws_eip" "workspace_eip_nat_1a" {
  vpc = true
}

# Elastic IP - 1b
resource "aws_eip" "workspace_eip_nat_1b" {
  vpc = true
}

# <-- Nat(s) -->
# NAT - 1a
resource "aws_nat_gateway" "workspace_nat_gateway_1a" {
  allocation_id = aws_eip.workspace_eip_nat_1a.id
  subnet_id     = aws_subnet.workspace_public_subnet_1a.id
  tags = {
    "Name"         = "${terraform.workspace}-nat_1a"
    "Env"          = "${terraform.workspace}"
    "Project"      = "${terraform.workspace}"
    "DeployedWith" = "terraform"
  }
}

# NAT - 1b
resource "aws_nat_gateway" "workspace_nat_gateway_1b" {
  allocation_id = aws_eip.workspace_eip_nat_1b.id
  subnet_id     = aws_subnet.workspace_public_subnet_1b.id
  tags = {
    "Name"         = "${terraform.workspace}-nat_1b"
    "Env"          = "${terraform.workspace}"
    "Project"      = "${terraform.workspace}"
    "DeployedWith" = "terraform"
  }
}

# <-- Route Table(s) -->
# |CREATE| Public Subnet Route Table 
resource "aws_route_table" "workspace_public_route_table" {
  vpc_id = aws_vpc.workspace_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.workspace_gateway.id
  }

  tags = {
    "Name"         = "${terraform.workspace}-public_rt"
    "Env"          = "${terraform.workspace}"
    "Project"      = "${terraform.workspace}"
    "DeployedWith" = "terraform"
  }
}

# |CREATE| Private Route - 1a
resource "aws_route_table" "workspace_nat_route_table_1a" {
  vpc_id = aws_vpc.workspace_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.workspace_nat_gateway_1a.id
  }
  tags = {
    "Name"         = "${terraform.workspace}-private_rt_1a"
    "Env"          = "${terraform.workspace}"
    "Project"      = "${terraform.workspace}"
    "DeployedWith" = "terraform"
  }
}

# |CREATE| Private Route - 1b
resource "aws_route_table" "workspace_nat_route_table_1b" {
  vpc_id = aws_vpc.workspace_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.workspace_nat_gateway_1b.id
  }
  tags = {
    "Name"         = "${terraform.workspace}-private_rt_1b"
    "Env"          = "${terraform.workspace}"
    "Project"      = "${terraform.workspace}"
    "DeployedWith" = "terraform"
  }
}

# <-- Subnet Association -->
# |ASSOCIATE| Public Route - 1a
resource "aws_route_table_association" "workspace_rt_pub_1a" {
  subnet_id      = aws_subnet.workspace_public_subnet_1a.id
  route_table_id = aws_route_table.workspace_public_route_table.id
}

# |ASSOCIATE| Public Route - 1b
resource "aws_route_table_association" "workspace_rt_pub_1b" {
  subnet_id      = aws_subnet.workspace_public_subnet_1b.id
  route_table_id = aws_route_table.workspace_public_route_table.id
}

# |ASSOCIATE| Private Route - 1a
resource "aws_route_table_association" "workspace_rt_priv_1a" {
  subnet_id      = aws_subnet.workspace_private_subnet_1a.id
  route_table_id = aws_route_table.workspace_nat_route_table_1a.id
}

# |ASSOCIATE| Private Route - 1b
resource "aws_route_table_association" "workspace_rt_priv_1b" {
  subnet_id      = aws_subnet.workspace_private_subnet_1b.id
  route_table_id = aws_route_table.workspace_nat_route_table_1b.id
}