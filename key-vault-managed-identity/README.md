# Project 4: Azure Key Vault + Managed Identity

## Overview

This project builds an Azure Key Vault and connects it to a VM using a
System-Assigned Managed Identity — so the VM can retrieve secrets from
the vault without any password, key, or credential ever being hardcoded
into a script or config file.

It also closes a loop from **Project 3** (Microsoft Defender for Cloud
compliance): that project flagged a disk encryption finding on the VM
that couldn't be fixed at the time because Azure Disk Encryption
requires a Key Vault to store its encryption keys, and no vault existed
yet. This project builds that vault and will use it to properly enable
disk encryption.

## Why this matters

Hardcoded secrets (passwords, API keys, connection strings sitting in
code or config files) are one of the most common real-world causes of
breaches — anyone who can read the code can read the secret. Key Vault
removes that risk by keeping secrets in one centrally managed, access
controlled, and logged location. Managed Identity removes the matching
problem on the other side: instead of the VM needing its *own*
hardcoded credential to prove who it is to Key Vault, Azure issues and
manages that identity automatically.

Together, this is the standard pattern for identity-based access
instead of embedded credentials — a core building block of Zero Trust
architecture in the cloud.

## What's being built

- [ ] Azure Key Vault (RBAC-based access model)
- [ ] New Azure VM with a System-Assigned Managed Identity enabled
- [ ] Least-privilege RBAC role assignment (`Key Vault Secrets User`)
      scoped to the VM's identity only
- [ ] A secret stored in the vault and retrieved from the VM using the
      Managed Identity — no credentials typed or stored anywhere
- [ ] Azure Disk Encryption enabled on the VM using this Key Vault,
      closing the Project 3 finding
- [ ] Screenshots and before/after documentation
- [ ] Lessons learned

## Status

🚧 **In progress.** Resource group and initial resources are being set
up. This README will be updated as each piece above is completed, with
screenshots and explanations added inline.

## Resources used

| Resource | Name |
|---|---|
| Resource Group | `rg-keyvault-project4` |
| Key Vault | `kv-mtawfiq-p4` |
| VM | `vm-keyvault-project4` |

---
*Part of the [cloud-security-portfolio](../) — see the root README for
the full project list.*