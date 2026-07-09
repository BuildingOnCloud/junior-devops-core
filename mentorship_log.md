# Mentorship Log - Junior DevOps Engineer Project

## Session 1: Infrastructure Architecture & Network Design Review
**Date:** July 6, 2026  
**Mentor:** [Senior DevOps Engineer Name / Mock Entry]  

### Architectural Questions Proposed:
1. For our reusable Terraform networking module, should we strictly isolate our database and compute instances within private subnets, using a public Bastion/Jump host structure, or is it acceptable to rely entirely on strict Security Group rules on a public subnet?
2. How should we structure our variable overrides in `variables.tf` to ensure the module remains highly reusable across staging and production environments without duplicating code?

### Mentor Feedback & Guidance:
* **Networking:** The mentor advised that strict network isolation is always preferred over relying purely on firewall rules on public subnets. We will design the module to provision explicit public and private subnets, placing the compute instances entirely in the private space.
* **Module Reusability:** The mentor suggested utilizing default values for common configurations (like CIDR blocks) but exposing environment tags and instance tiers as mandatory variables to enforce consistency.

### Action Items & Implementation Plan:
- [ ] Build a Terraform network module with 1 Public Subnet and 1 Private Subnet.
- [ ] Configure a security group that blocks direct internet access to the private subnet.
- [ ] Implement variables for `environment` (e.g., dev/prod) and `aws_region`.

## Entry: [Insert Current Date, e.g., 2026-07-09] - Infrastructure Provisioning & Configuration Success

### 🧱 What I Worked On
* Shifted the AWS EC2 instance deployment from an isolated private subnet to a public subnet within the Terraform network module to allow external configuration.
* Established an agentless configuration pipeline using Ansible to target the live AWS instance via SSH.
* Standardized an Ansible automation playbook to systematically update system caches, install Nginx, and enable the background daemon.

### 🛑 Challenges & Blocks Overcome
1. **Cross-Module Variable Access:** Avoided adding complex workarounds by refactoring the `network` module (`main.tf` and `outputs.tf`) directly to expose the instance's public IP.
2. **SSH Host Key Verification:** Fixed an Ansible `Host key verification failed` error caused by a missing cryptographic fingerprint on the host machine by managing the connection with `ANSIBLE_HOST_KEY_CHECKING=False`.
3. **Ansible Lint Warnings:** Cleaned up syntax errors highlighted by the code editor's linter. Converted legacy truthy strings (`yes`/`no`) to native YAML booleans (`true`/`false`) and refactored bare tasks to use **FQCN** (Fully Qualified Collection Names) like `ansible.builtin.apt`.

### 💡 Key Takeaways
* **Idempotency in Action:** Verified that Ansible playbooks can run repeatedly without breaking things—only changing files or states when the server deviates from our declared code blueprint.
* **Modern YAML Best Practices:** Learned why the industry requires FQCN to prevent collision bugs across large-scale multi-cloud Ansible collections.
