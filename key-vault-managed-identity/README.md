# Azure Key Vault and Managed Identity

## What this project is about

A lot of cloud security comes down to one simple question: how does a piece of software prove who it is without a password sitting somewhere in plain text. This project answers that question directly.

I built an Azure Key Vault and connected it to a VM using a Managed Identity, so the VM can pull secrets out of the vault without any credential ever being typed, stored, or hardcoded anywhere. This also closes a real gap from Project 3, where a disk encryption finding couldn't be fixed because it depended on a Key Vault that didn't exist yet. That vault now exists, and the fix is complete.

## What I built

- A resource group: `rg-keyvault-project4`
- A Key Vault: `kv-mtawfiq-p4`, using the Azure RBAC permission model, in India South Central
- A Linux VM: `vm-keyvault-project4` (Ubuntu 22.04), with a system-assigned Managed Identity enabled, SSH restricted to my own IP
- Two scoped RBAC role assignments on the vault
- A secret, stored and retrieved end to end using only the VM's identity
- Azure Disk Encryption, enabled on the VM using the vault

📸 `screenshots/01-keyvault-created.png`
📸 `screenshots/02-vm-managed-identity-on.png`

## Setting up least-privilege access

Switching the vault to the RBAC permission model means nobody gets access by default, not even the subscription owner. I confirmed this the hard way: my first attempt to create a secret failed with an RBAC permission error, because owning the subscription doesn't grant data-plane access to a vault's contents anymore.

I assigned two roles, both scoped to the vault itself rather than the resource group or subscription.

| Principal | Role | Scope | Why |
|---|---|---|---|
| Me (user) | Key Vault Secrets Officer | This vault only | Needed to create and manage secrets |
| VM's Managed Identity | Key Vault Secrets User | This vault only | Read-only. The VM only ever needs to read a secret |

Both assignments were deliberately scoped to the vault resource itself, not the resource group or subscription, so the access granted matches exactly what each principal actually needs and nothing more.

📸 `screenshots/03-rbac-role-assignments.png`

## Proving secure secret retrieval

I stored a test secret in the vault, `demo-db-password`, standing in for something like a database credential an application would normally need.

From inside the VM, I requested an Azure AD token directly from Azure's Instance Metadata Service, an internal-only endpoint reachable only from within the VM, which authenticates it using its Managed Identity. I then used that token to fetch the secret.

```bash
TOKEN=$(curl -s -H Metadata:true "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net" | grep -o '"access_token":"[^"]*' | sed 's/"access_token":"//')

curl -s -H "Authorization: Bearer $TOKEN" "https://kv-mtawfiq-p4.vault.azure.net/secrets/demo-db-password?api-version=7.4"
```

The VM retrieved the secret's value successfully. No username, password, or connection string was ever typed or stored anywhere in this process, only the VM's own Azure identity, requested and used automatically.

📸 `screenshots/04-secret-retrieval-success.png`

## Closing the Project 3 gap: disk encryption

This is where the project hit its real bottleneck. Enabling Azure Disk Encryption on the VM's original size, `Standard_B1s` with 1 GB of RAM, failed outright. The deployment only reported a generic "Conflict" error at first, which wasn't useful on its own. Digging into the Activity Log's Error details surfaced the actual reason:

Azure Disk Encryption for Linux has a real memory requirement that isn't obvious until you hit it. I stopped the VM, resized it to `Standard_B2ms` (2 vCPU, 8 GB RAM), started it back up, and retried the encryption setup. It completed successfully against `kv-mtawfiq-p4` on the second attempt.

📸 `screenshots/05-vm-resized-b2ms.png`

This closes the finding Project 3 had to leave open:

Before, from Project 3: `Azure disk encryption: Not enabled`
After, this project: `Azure disk encryption: Enabled`

📸 `screenshots/06-before-not-enabled.png`
📸 `screenshots/07-after-enabled.png`

## Summary

- Built a Key Vault using the RBAC permission model, and a VM with a system-assigned Managed Identity
- Set up least-privilege access, with scoped role assignments limited to the vault itself, for both my own account and the VM's identity
- Proved secure, credential-free secret retrieval end to end, from inside the VM, using only its Managed Identity
- Hit a real memory requirement enabling Azure Disk Encryption, diagnosed it through the Activity Log rather than guessing, resized the VM, and fixed it
- Closed the disk encryption finding deferred from Project 3, completing that dependency chain

## Lessons learned
- An RBAC-model Key Vault grants no implicit access to anyone, including the account owner. Every principal, including your own account, needs an explicit, scoped role assignment before it can touch a secret.
- Managed Identity removes the problem of needing a credential to get a credential. Proving it end to end, requesting a token and retrieving a secret from inside the VM with nothing hardcoded anywhere, made that concrete rather than theoretical.
- Some fixes depend on other infrastructure being built first. Project 3 couldn't close its disk encryption finding without a Key Vault; this project existed specifically to build that vault and finish the job.
- Azure Disk Encryption for Linux needs roughly 8 GB of RAM. A small VM size will fail with a generic deployment error that hides the real, specific reason, which only shows up in the Activity Log's Error details.