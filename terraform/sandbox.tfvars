# Global Information
region                  = "us-east-1"

# VPC
# <-- VPC Subnet(s) -->
vpc_range               = "10.2.0.0/16"

# <-- Public Subnet(s) -->
public_subnet_1a        = "10.2.16.0/24"
public_subnet_1b        = "10.2.32.0/24"

# <-- Private Subnet(s) -->
private_subnet_1a       = "10.2.116.0/24"
private_subnet_1b       = "10.2.132.0/24"

# Optional Setting(s)
# < -- Jumphost Configuration -->
jumphost_sshkey         = "key"
jumphost_instancetype   = "t3.micro"
jumphost_ami            = "ami-033b95fb8079dc481"

# < -- AWX Instance(s) Configuration -->
awx1a_sshkey         = "key"
awx1a_instancetype   = "t3.micro"
awx1a_ami            = "ami-033b95fb8079dc481"

awx1b_sshkey         = "key"
awx1b_instancetype   = "t3.micro"
awx1b_ami            = "ami-033b95fb8079dc481"