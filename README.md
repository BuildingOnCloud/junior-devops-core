# Junior DevOps Core Infrastructure Pipeline

This repository contains the infrastructure-as-code (Terraform) and configuration management (Ansible) pipeline for deploying a public-facing Ubuntu web server on AWS.

## 🛠 Operations Log & Architecture Decisions

### 1. Networking & Module Cross-Referencing Fix
* **The Issue:** The EC2 instance resource block (`aws_instance.backend_server`) was originally trapped inside the `network` module and locked to a private subnet, preventing external configuration access. Meanwhile, the `compute` module was only generating local manifest tracking files.
* **The Fix:** Rather than introducing a messy module workaround, we updated `terraform/modules/network/main.tf` directly. We shifted the `subnet_id` allocation from `aws_subnet.private.id` to `aws_subnet.public.id` and enabled public IP addressing.
* **The Outputs:** Updated `terraform/modules/network/outputs.tf` to expose `instance_public_ip`, giving us immediate visibility into the machine's dynamic public endpoint upon recreation.

### 2. Infrastructure Deployment Execution
* Ran `terraform apply -auto-approve` inside the `dev` environment.
* Terraform successfully tore down the isolated private asset and provisioned a brand-new public virtual machine host with the live cloud footprint.

### 3. SSH Cryptographic Handshake & Key Management
* **The Issue:** Initial Ansible ad-hoc connection attempts failed with a `Host key verification failed` protective abort because the brand-new VM signature was completely missing from the local development laptop's registry.
* **The Fix:** Used `ssh-keygen -R [IP]` to verify the fingerprint cache was clear, and utilized the `ANSIBLE_HOST_KEY_CHECKING=False` session bypass flag to securely pull down and trust the new public cloud machine footprint.

### 4. Code Standards & Ansible Lint Compliance
* **The Issue:** The initial playbook draft triggered syntax warnings and errors in the editor's automated linter due to legacy formats.
* **The Fix:** Rewrote the playbook to adhere to modern enterprise production standards:
  * Replaced legacy truthy values (`yes`/`no`) with native YAML booleans (`true`/`false`).
  * Migrated bare module definitions to **FQCN** (Fully Qualified Collection Names) format (e.g., changing `apt:` to `ansible.builtin.apt:` and `service:` to `ansible.builtin.service:`).

### 5. Playbook Configuration Execution
* Executed the finalized configuration playbook against the managed node cluster.
* **Result:** `PLAY RECAP: ok=4 changed=2 unreachable=0 failed=0`. The managed instance successfully updated its internal package caches, installed the Nginx engine binaries, and initiated the live web service background daemon.

---

## 🚀 How to Run This Pipeline

### Prerequisites
* Ensure your local SSH key pair is available at `~/.ssh/junior-devops-admin-key.pub`.

### Step 1: Provision the Infrastructure
```bash
cd terraform/environments/dev
terraform init
terraform apply -auto-approve
