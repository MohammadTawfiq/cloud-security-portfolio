# Project 3: Azure Defender for Cloud : Compliance & Posture Management

## Day 1
- Created resource group `rg-azure-defender-compliance-demo`
- Deployed Ubuntu VM (`vm-defender-compliance-demo`) and storage account 
(`stdefendercompliancedemo`), intentionally left with default settings 
  (open SSH, public blob access, no disk encryption) so Microsoft Defender 
  for Cloud has real misconfigurations to detect
- Enabled Microsoft Defender for Cloud (Foundational CSPM, free tier)
- First Secure Score assessment kicked off, takes several hours, checking results tomorrow