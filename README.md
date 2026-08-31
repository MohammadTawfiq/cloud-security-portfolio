# cloud-security-portfolio

Hands-on projects documenting my transition into cloud security. Deploying real infrastructure, breaking it, and fixing it, with full write-ups of the process.

## About Me

Electronics & Communication Engineer background, currently building cloud security skills through Microsoft Azure training (AZ-500, AZ-104, Security Fundamentals) and self-directed, hands-on projects. This repo is where I apply that learning in real deployed environments.

## Projects

### 1. Securing an Azure VM with Network Security Groups
**Status: Complete**
Deployed an Azure VM and locked down inbound traffic to SSH-only from a trusted source, demonstrating least-privilege network access control. Verified access using Azure Bastion due to local ISP port restrictions.
[→ View project](https://github.com/MohammadTawfiq/cloud-security-portfolio/blob/main/nsg-vm-security)

### 2. OWASP Juice Shop: IDOR Vulnerability & Patch (A01:2021 Broken Access Control)
**Status: Complete**
Deployed a customized, intentionally vulnerable web app to Azure, built and exploited a real IDOR (Insecure Direct Object Reference) vulnerability as two separate users, then patched it with an ownership check and re-verified the fix. Full attack-and-defense documentation with screenshot evidence.
[→ View project](https://github.com/MohammadTawfiq/cloud-security-portfolio/blob/main/juice-shop-idor)

### 3. Azure Defender for Cloud: Compliance & Posture Management
**Status: Complete**
Deploying Microsoft Defender for Cloud against a live Azure environment, using Secure Score to identify real misconfigurations (open SSH access, default disk encryption, public blob storage access), then remediating them with Azure Policy and mapping the results against the CIS Microsoft Azure Foundations Benchmark. Before/after evidence documented throughout.
[→ View project](https://github.com/MohammadTawfiq/cloud-security-portfolio/blob/main/azure-defender-for-cloud-compliance)

### 4. Azure Key Vault and Managed Identity
**Status: Complete**
Built an Azure Key Vault with RBAC-based least-privilege access, then connected it to a VM using a system-assigned Managed Identity, proving secure, credential-free secret retrieval end to end. Also closes the disk encryption finding deferred from Project 3, resolving a real Azure Disk Encryption memory requirement along the way.
[→ View project](https://github.com/MohammadTawfiq/cloud-security-portfolio/blob/main/key-vault-managed-identity)

## Tools & Technologies

Azure, Microsoft Defender for Cloud, Azure Policy, Azure Key Vault, Managed Identity, RBAC, Docker, Git/GitHub, Node.js