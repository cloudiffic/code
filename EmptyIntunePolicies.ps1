<#
.SYNOPSIS
    Finds Microsoft Intune configuration policies that are unassigned or assigned exclusively to empty groups.
.DESCRIPTION
    Connects to Microsoft Graph, retrieves Settings Catalog policies and classic Device Configuration profiles,
    checks their assignments, verifies member counts for target groups, and exports findings to a CSV file.
#>

# 1. Connect to Microsoft Graph with required scopes
$RequiredScopes = @(
    "DeviceManagementConfiguration.Read.All",
    "Group.Read.All",
    "Directory.Read.All"
)

Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes $RequiredScopes

$results = @()

# --- PART 1: Modern Configuration Policies (Settings Catalog & Templates) ---
Write-Host "Fetching modern Configuration Policies..." -ForegroundColor Cyan
$configPolicies = Get-MgDeviceManagementConfigurationPolicy -All -ErrorAction SilentlyContinue

foreach ($policy in $configPolicies) {
    $policyId   = $policy.Id
    $policyName = $policy.Name
    $policyType = "Settings Catalog / Configuration Policy"

    $assignments = Get-MgDeviceManagementConfigurationPolicyAssignment -DeviceManagementConfigurationPolicyId $policyId -ErrorAction SilentlyContinue

    if (-not $assignments -or $assignments.Count -eq 0) {
        $results += [PSCustomObject]@{
            PolicyName = $policyName
            PolicyId   = $policyId
            PolicyType = $policyType
            Status     = "Unassigned"
            Details    = "No assignments configured"
        }
        continue
    }

    $emptyGroupFound     = $false
    $hasActiveAssignment = $false
    $emptyGroupNames     = @()

    foreach ($assignment in $assignments) {
        $target  = $assignment.Target
        $groupId = $null

        if ($target -and $target.AdditionalProperties.ContainsKey('groupId')) {
            $groupId = $target.AdditionalProperties['groupId']
        } elseif ($target -and $target.GroupId) {
            $groupId = $target.GroupId
        }

        if ($groupId) {
            $members = Get-MgGroupMember -GroupId $groupId -All -ErrorAction SilentlyContinue
            if (-not $members -or $members.Count -eq 0) {
                $emptyGroupFound = $true
                $groupObj = Get-MgGroup -GroupId $groupId -ErrorAction SilentlyContinue
                $groupName = if ($groupObj) { $groupObj.DisplayName } else { $groupId }
                $emptyGroupNames += $groupName
            } else {
                $hasActiveAssignment = $true
            }
        } else {
            # Dynamic or built-in targets (e.g., All Users, All Devices)
            $hasActiveAssignment = $true
        }
    }

    if (-not $hasActiveAssignment -and $emptyGroupFound) {
        $results += [PSCustomObject]@{
            PolicyName = $policyName
            PolicyId   = $policyId
            PolicyType = $policyType
            Status     = "Assigned to Empty Group(s)"
            Details    = "Empty groups: $($emptyGroupNames -join ', ')"
        }
    }
}


# --- PART 2: Classic Device Configuration Profiles ---
Write-Host "Fetching classic Device Configuration Profiles..." -ForegroundColor Cyan
$deviceConfigs = Get-MgDeviceManagementDeviceConfiguration -All -ErrorAction SilentlyContinue

foreach ($policy in $deviceConfigs) {
    $policyId   = $policy.Id
    $policyName = $policy.DisplayName
    $policyType = "Classic Device Configuration"

    $assignments = Get-MgDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $policyId -ErrorAction SilentlyContinue

    if (-not $assignments -or $assignments.Count -eq 0) {
        $results += [PSCustomObject]@{
            PolicyName = $policyName
            PolicyId   = $policyId
            PolicyType = $policyType
            Status     = "Unassigned"
            Details    = "No assignments configured"
        }
        continue
    }

    $emptyGroupFound     = $false
    $hasActiveAssignment = $false
    $emptyGroupNames     = @()

    foreach ($assignment in $assignments) {
        $target  = $assignment.Target
        $groupId = $null

        if ($target -and $target.AdditionalProperties.ContainsKey('groupId')) {
            $groupId = $target.AdditionalProperties['groupId']
        } elseif ($target -and $target.GroupId) {
            $groupId = $target.GroupId
        }

        if ($groupId) {
            $members = Get-MgGroupMember -GroupId $groupId -All -ErrorAction SilentlyContinue
            if (-not $members -or $members.Count -eq 0) {
                $emptyGroupFound = $true
                $groupObj = Get-MgGroup -GroupId $groupId -ErrorAction SilentlyContinue
                $groupName = if ($groupObj) { $groupObj.DisplayName } else { $groupId }
                $emptyGroupNames += $groupName
            } else {
                $hasActiveAssignment = $true
            }
        } else {
            $hasActiveAssignment = $true
        }
    }

    if (-not $hasActiveAssignment -and $emptyGroupFound) {
        $results += [PSCustomObject]@{
            PolicyName = $policyName
            PolicyId   = $policyId
            PolicyType = $policyType
            Status     = "Assigned to Empty Group(s)"
            Details    = "Empty groups: $($emptyGroupNames -join ', ')"
        }
    }
}

# 3. Export results to CSV
$outputPath = ".\IntuneUnassignedOrEmptyGroupPolicies.csv"
$results | Export-Csv -Path $outputPath -NoTypeInformation
Write-Host "Report successfully generated and saved to: $(Resolve-Path $outputPath)" -ForegroundColor Green
