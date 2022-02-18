#! /bin/bash
echo "[+] Updating/Upgrading Instance"
sudo yum update -y && sudo yum upgrade -y

echo "[+] Installing Docker"
sudo yum install docker -y

echo "[+] Setting Permissions for Docker"
sudo usermod -aG docker ec2-user

echo "[+] Installing Ansible AWX Dependencies"
sudo yum groupinstall "Development Tools" -y
sudo amazon-linux-extras install ansible2 -y

echo "[+] Fetching Ansible AWX 17.1.0"
wget https://github.com/ansible/awx/archive/refs/tags/17.1.0.zip  -O awx.zip
unzip awx.zip

echo "[+] Setting Permissions for Folders"
sudo chown ec2-user:ec2-user -R awx-17.1.0
sudo chmod 777 -R awx-17.1.0
cd awx-17.1.0/installer/

echo "[+] Installing Python Dependencies"
pip3 install docker docker-compose requests

