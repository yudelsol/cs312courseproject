#!/bin/bash

IP=$(terraform -chdir=terraform output -raw minecraft_ip)

echo "[minecraft]" > ansible/inventory.ini
echo "$IP ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/minecraftKey.pem" >> ansible/inventory.ini

echo "Inventory updated with IP: $IP"
