# Minecraft Server Infrastructure as Code (Terraform + Ansible)

## Overview

This project automates the deployment of a Minecraft server on AWS using Infrastructure as Code (IaC). It provisions infrastructure using **Terraform** and configures the server using **Ansible**, resulting in a fully repeatable deployment pipeline.

---

## Tooling & Versions

The following tools are required to run this project:

### Infrastructure Tools

* **Terraform**: ≥ 1.5+
* **Ansible**: ≥ 2.10+

### Local Environment

* Linux / WSL2 (recommended for Windows users)
* OpenSSH client
* Git

---

## Pipeline Overview

The infrastructure is deployed in four automated stages:

### 1. Infrastructure Provisioning (Terraform)

* Creates AWS EC2 instance
* Creates security group (SSH + Minecraft port 25565)
* Allocates Elastic IP
* Outputs public IP address

### 2. Dynamic Inventory Generation

* Terraform output is extracted
* EC2 IP is injected into Ansible `inventory.ini`

### 3. Configuration Management (Ansible)

* Connects to EC2 via SSH with Ansible
* Installs Java
* Deploys Minecraft server dependencies
* Configures systemd service

### 4. Service Startup

* Minecraft server is started as a system service
* Automatically restarts on failure or reboot

---

## Repository Structure

```text id="repo1"
minecraft-server-iac/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│
├── ansible/
│   ├── minecraft.yml
│   ├── inventory.ini
│
├── scripts/
│   ├── deploy.sh
│   ├── update_inventory.sh
│
└── README.md
```

---

## Full Deployment Guide

### Prerequisites

Before running anything:

1. Install AWS CLI and configure credentials:

```bash id="aws1"
aws configure
```

2. Ensure Terraform is installed:

```bash id="tf1"
terraform -version
```

3. Ensure Ansible is installed:

```bash id="an1"
ansible --version
```

4. Ensure SSH key exists:

* AWS EC2 key pair must be created (e.g., `minecraftKey`)
* `.pem` file downloaded locally
* Permissions set:

```bash id="ssh1"
chmod 400 minecraftKey.pem
```

---

## Manual Step-by-Step Deployment

### Step 1 — Provision Infrastructure

```bash id="step1"
cd terraform
terraform init
terraform apply -auto-approve
```

---

### Step 2 — Update Ansible Inventory

```bash id="step2"
cd ..
./scripts/update_inventory.sh
```

This pulls the EC2 IP from Terraform output and updates:

```text id="inv1"
ansible/inventory.ini
```

---

### Step 3 — Configure Server with Ansible

```bash id="step3"
cd ansible
ansible-playbook -i inventory.ini minecraft.yml
```

---

## Accessing the Minecraft Server

After deployment, Terraform outputs the public IP:

```text id="ip1"
minecraft_public_ip = x.x.x.x
```

Connect using:

```text id="mc1"
x.x.x.x:25565
```

---

## Windows User Instructions

If running on Windows:

### Recommended setup:

* Use **WSL2 (Ubuntu)**
* Install tools inside WSL:

  * Terraform
  * Ansible
  * AWS CLI

### SSH key location example:

```text id="win1"
C:\Users\<user>\Downloads\minecraftKey.pem
```

Inside WSL:

```bash id="win2"
cp /mnt/c/Users/<user>/Downloads/minecraftKey.pem ~/
chmod 400 minecraftKey.pem
```

## Cleanup

Destroy all resources:

```bash id="clean1"
cd terraform
terraform destroy -auto-approve
```

---

## Resources & References

* Terraform AWS Provider:
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs

* Ansible Documentation:
  https://docs.ansible.com/

* AWS EC2 Documentation:
  https://docs.aws.amazon.com/ec2/

* Minecraft Server Setup Reference:
  https://www.minecraft.net/en-us/download/server

