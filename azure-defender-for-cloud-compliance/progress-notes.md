# Project 3: Azure Defender for Cloud : Compliance & Posture Management

## Day 1
- Created resource group `rg-azure-defender-compliance-demo`
- Deployed Ubuntu VM (`vm-defender-compliance-demo`, Standard_B1s) with 
  intentional misconfigurations: SSH (port 22) open to any source 
  (see `01-nsg-open-ssh-port22.png`), default disk encryption using 
  platform-managed keys instead of customer-managed 
  (see `02-vm-disk-default-encryption.png`)
- Created storage account `stdefendercompliancedemo` with Blob anonymous 
  access enabled (see `03-storage-blob-anonymous-access-enabled.png`)
- Confirmed Microsoft Defender for Cloud's Foundational CSPM plan is enabled 
  (Free tier, Full monitoring coverage)
- First Secure Score assessment now running in background, checking results 
  tomorrow
  - Captured resource architecture diagram showing VM, NSG, storage account, 
  disk, vnet, and public IP relationships (see `04-resource-architecture-diagram.png`)

  ## Day 2

- Captured resource architecture diagram from Resource Visualizer showing 
  VM, NSG, storage account, disk, vnet, and public IP relationships 
  (see `04-resource-architecture-diagram.png`)
- Checked Microsoft Defender for Cloud Secure Score : initial assessment 
  still in progress at first check (100% shown, but 13 recommendations 
  "Not evaluated", not a real result yet) (see `05-secure-score-initial-not-evaluated.png`)
- Rechecked a few hours later: Secure Score updated to 11%, 3 of 3 resources 
  flagged unhealthy, confirming the assessment engine is actively evaluating 
  the environment
- Reviewed the Recommendations list and identified the 3 real findings 
  matching this project's intentional misconfigurations:
  1. **Management ports should be closed on your virtual machines**:  
     flags the open SSH (port 22) rule on `vm-defender-compliance-demo` 
     (see `06-finding-management-ports.png`)
  2. **Linux virtual machines should enable Azure Disk Encryption or 
     EncryptionAtHost** : flags default disk encryption on 
     `vm-defender-compliance-demo` (see `07-finding-disk-encryption.png`)
  3. **Storage accounts should restrict network access using virtual 
     network rules** : flags public network access on 
     `stdefendercompliancedemo` (see `08-finding-storage-network-access.png`)
- Note: Defender for Cloud's "Risk level" (Critical/High/Medium/Low) column 
  requires the paid Defender CSPM plan, Foundational CSPM (free tier) still 
  provides full Secure Score evaluation and named recommendations, which is 
  what this project relies on
- Next: remediate all 3 findings using Azure Policy assignments (not 
  Defender's built-in Quick Fix), to match the project's compliance-framework 
  documentation goal