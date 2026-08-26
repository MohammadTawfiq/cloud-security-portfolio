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