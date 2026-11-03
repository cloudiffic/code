<#
.SYNOPSIS
    Exports all Intune Device Configuration Policies along with Included and Excluded Groups.
.DESCRIPTION
    Uses Microsoft Graph SDK to retrieve all device configuration profiles, expands their assignment 
    targets, resolves Group Names from Entra ID, and exports the baseline to CSV.
#>

[CmdletBinding()]
param(
    [string]$ExportPath = ".\Intune_DeviceConfiguration_Policies_Export.csv"
)

Write-Host "Fetching Device Configuration Policies from Microsoft Graph..." -ForegroundColor Cyans

# Retrieve all device configuration profiles
$policies = Get-MgDeviceManagementDeviceConfiguration -All -ExpandProperty "assignments"

$results = [System.Collections.Generic.List[PSObject]]::new()

foreach ($policy in $policies) {
    # Check if policy has any assignments
    if ($null -eq $policy.Assignments -or $policy.Assignments.Count -eq 0) {
        $results.Add([PSCustomObject]@{
            PolicyId          = $policy.Id
            PolicyName        = $policy.DisplayName
            PlatformType      = $policy.OdataType.Replace('#microsoft.graph.', '')
            LastModified      = $policy.LastModifiedDateTime
            AssignmentType    = "Unassigned"
            TargetGroupId     = "N/A"
            TargetGroupName   = "N/A"
            ExclusionStatus   = "Unassigned"
            Description       = $policy.Description
        })
        continue
    }

    # Iterate through each assignment block
    foreach ($assignment in $policy.Assignments) {
        $target = $assignment.Target
        
        $assignmentType = "Unknown"
        $groupId        = "N/A"
        $groupName      = "N/A"
        $exclusionStatus = "Included"

        switch ($target.OdataType) {
            "#microsoft.graph.groupAssignmentTarget" {
                $assignmentType  = "Group Assignment"
                $groupId         = $target.GroupId
                $exclusionStatus = "Included"
            }
            "#microsoft.graph.exclusionGroupAssignmentTarget" {
                $assignmentType  = "Group Exclusion"
                $groupId         = $target.GroupId
                $exclusionStatus = "Excluded"
            }
            "#microsoft.graph.allDevicesAssignmentTarget" {
                $assignmentType  = "All Devices"
                $groupName      = "All Devices"
                $exclusionStatus = "Included"
            }
            "#microsoft.graph.allLicensedUsersAssignmentTarget" {
                $assignmentType  = "All Users"
                $groupName      = "All Users"
                $exclusionStatus = "Included"
            }
            Default {
                $assignmentType = $target.OdataType.Replace('#microsoft.graph.', '')
            }
        }

        # Resolve Group Name from Entra ID if a Group ID is present
        if ($groupId -ne "N/A" -and [string]::IsNullOrEmpty($groupId) -eq $false) {
            try {
                $group = Get-MgGroup -GroupId $groupId -ErrorAction SilentlyContinue
                if ($group) {
                    $groupName = $group.DisplayName
                } else {
                    $groupName = "Unknown/Deleted Group"
                }
            } catch {
                $groupName = "Error Resolving Group"
            }
        }

        $results.Add([PSCustomObject]@{
            PolicyId          = $policy.Id
            PolicyName        = $policy.DisplayName
            PlatformType      = $policy.OdataType.Replace('#microsoft.graph.', '')
            LastModified      = $policy.LastModifiedDateTime
            AssignmentType    = $assignmentType
            TargetGroupId     = $groupId
            TargetGroupName   = $groupName
            ExclusionStatus   = $exclusionStatus
            Description       = $policy.Description
        })
    }
}

# Export to CSV
$results | Export-Csv -Path $ExportPath -NoTypeInformation -Encoding UTF8
Write-Host "Successfully exported $($results.Count) assignment records to: $ExportPath" -ForegroundColor Green

# Display Summary Table in Console
$results | Format-Table -Property PolicyName, AssignmentType, TargetGroupName, ExclusionStatus -AutoSize
