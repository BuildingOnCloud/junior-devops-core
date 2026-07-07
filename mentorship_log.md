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
