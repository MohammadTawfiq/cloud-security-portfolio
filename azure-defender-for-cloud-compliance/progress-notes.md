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
- First Secure Score assessment kicked off, checking results tomorrow

## Day 2
- Captured resource architecture diagram from Resource Visualizer showing 
  VM, NSG, storage account, disk, vnet, and public IP relationships 
  (see `04-resource-architecture-diagram.png`)
- Checked Microsoft Defender for Cloud Secure Scor , initial assessment 
  still in progress at first check (100% shown, but 13 recommendations 
  "Not evaluated," not a real result yet) (see `05-secure-score-initial-not-evaluated.png`)
- Rechecked a few hours later: Secure Score updated to 11%, 3 of 3 resources 
  flagged unhealthy, confirming the assessment engine is actively evaluating 
  the environment
- Reviewed the Recommendations list and identified the 3 real findings 
  matching this project's intentional misconfigurations:
  1. **Management ports should be closed on your virtual machines** — 
     flags the open SSH (port 22) rule on `vm-defender-compliance-demo` 
     (see `06-finding-management-ports.png`)
  2. **Linux virtual machines should enable Azure Disk Encryption or 
     EncryptionAtHost** — flags default disk encryption on 
     `vm-defender-compliance-demo` (see `07-finding-disk-encryption.png`)
  3. **Storage accounts should restrict network access using virtual 
     network rules** — flags public network access on 
     `stdefendercompliancedemo` (see `08-finding-storage-network-access.png`)
- Note: Defender for Cloud's "Risk level" (Critical/High/Medium/Low) column 
  requires the paid Defender CSPM plan, Foundational CSPM (free tier) still 
  provides full Secure Score evaluation and named recommendations, which is 
  what this project relies on
- Created 3 Azure Policy assignments (built-in definitions, AuditIfNotExists 
  effect, scoped to `rg-azure-defender-compliance-demo`), one per finding
- Checked Azure Policy compliance for each assigned policy (before remediation):
  1. **Management ports should be closed on your virtual machines** : 
     Non-compliant, 0% (0 of 1), `vm-defender-compliance-demo` flagged for 
     its open SSH (port 22) rule (see `09-policy-compliance-management-ports-before.png`)
  2. **Linux virtual machines should enable Azure Disk Encryption or 
     EncryptionAtHost** : Non-compliant, 0% (0 of 1). Compliance reason: 
     `GCExtensionIdentityMissing` , this policy relies on Azure Machine 
     Configuration (Guest Configuration), which requires an agent/managed 
     identity on the VM that wasn't set up as part of this project's scope. 
     The result correctly reflects "encryption not confirmed" rather than a 
     fully verified in-OS scan (see `10-policy-compliance-disk-encryption-before.png`)
  3. **Storage accounts should restrict network access using virtual 
     network rules** : Non-compliant, 0% (0 of 1), `stdefendercompliancedemo` 
     flagged for allowing public network access from all networks 
     (see `11-policy-compliance-storage-network-before.png`)
- All 3 policies confirmed working correctly and independently reproduce 
  the same findings as Secure Score, solid before-state evidence
- Next: remediate all 3 (tighten NSG rule, address disk encryption, restrict 
  storage network access), then re-check policy compliance for the after-state

  -- Remediated Finding 1 (open SSH): updated NSG rule to restrict source from 
  "Any" to a specific IP address (see `12-nsg-ssh-restricted-after.png`)
- Remediated Finding 3 (storage public network access): changed storage 
  account's public network access from "Enabled from all networks" to 
  "Enabled from selected networks," added the project's existing virtual 
  network (`vnet-indiasouthcentral-1`) and own IP address as allowed sources 
  (see `13-storage-network-restricted-after.png`)
- Verified resource access settings (virtual network endpoint status: 
  Enabled, IPv4 address listed, exceptions reviewed) confirming the 
  restriction was correctly applied at the resource level 
  (see `14-storage-network-resource-access-settings.png`)
- Note: Azure Policy compliance for both findings is backed by Microsoft 
  Defender for Cloud security assessments (`Microsoft.Security/assessments`), 
  which refresh on Defender's own recommendation cycle, this can lag actual 
  configuration changes by several hours, sometimes up to 24. The policy 
  dashboard may continue to show "Non-compliant" for a while even though the 
  underlying resource configuration is already fixed. Verified both fixes 
  directly at the resource level rather than waiting on the policy dashboard 
  to catch up.