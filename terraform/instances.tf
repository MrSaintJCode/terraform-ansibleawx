locals {
    jumphost_name = "${terraform.workspace}-jumphost"
}

# <-- Jumphost(s) -->
resource "aws_instance" "ec2_jumphost" {
    ami                     = var.jumphost_ami
    instance_type           = var.jumphost_instancetype
    key_name                = var.jumphost_sshkey
    subnet_id               = aws_subnet.workspace_public_subnet_1a.id
    vpc_security_group_ids  = [aws_security_group.jumphost_sg.id]

    tags = {
      "Name"         = local.jumphost_name
      "Env"          = "${terraform.workspace}"
      "Project"      = "${terraform.workspace}"
      "DeployedWith" = "terraform"
    }
}

resource "aws_eip" "jumphost" {
    instance    = aws_instance.ec2jumphost.id
    vpc         = true
}

# <-- Ansible AWX -->
resource "aws_instance" "ec2_awx1a" {
    ami                     = var.awx_ami
    instance_type           = var.awx_instancetype
    key_name                = var.awx_sshkey
    subnet_id               = aws_subnet.workspace_private_subnet_1a.id
    vpc_security_group_ids  = [aws_security_group.awx_sg.id]

    tags = {
      "Name"         = "${terraform.workspace}-awx1a"
      "Env"          = "${terraform.workspace}"
      "Project"      = "${terraform.workspace}"
      "DeployedWith" = "terraform"
    }
}

resource "aws_instance" "ec2_awx1b" {
    ami                     = var.awx_ami
    instance_type           = var.awx_instancetype
    key_name                = var.awx_sshkey
    subnet_id               = aws_subnet.workspace_private_subnet_1b.id
    vpc_security_group_ids  = [aws_security_group.awx_sg.id]

    user_data               = file("scripts/install_awx.sh")

    provisioner "ansible_configuration" {
        source      = "conf/myapp.conf"
        destination = "/etc/myapp.conf"
    }
    tags = {
      "Name"         = "${terraform.workspace}-awx1b"
      "Env"          = "${terraform.workspace}"
      "Project"      = "${terraform.workspace}"
      "DeployedWith" = "terraform"
    }
}