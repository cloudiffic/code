<#
.SYNOPSIS
    Connects to Microsoft Graph via App Registration and reports users with 
    direct assigned Entra ID roles.
.DESCRIPTION
    Requires Microsoft.Graph.Authentication and Microsoft.Graph.Identity.Governance modules.
#>

# --- CONFIGURATION ---
$TenantId     = "YOUR_TENANT_ID"          # e.g., contoso.onmicrosoft.com
$ClientId     = "YOUR_CLIENT_ID"          # App Registration Application (client) ID
$ClientSecret = "YOUR_CLIENT_SECRET"      # App Registration Client Secret value

# Ensure required modules are installed
$requiredModules = @("Microsoft.Graph.Authentication", "Microsoft.Graph.Identity.Governance", "Microsoft.Graph.Users")
foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing required module: $module..." -ForegroundColor Cyan
        Install-Module -Name $module -Scope CurrentUser -Force -AllowClobber
    }
}

# --- AUTHENTICATION ---
Write-Host "Authenticating to Microsoft Graph using App Registration..." -ForegroundColor Cyan
try {
    Connect-MgGraph -TenantId $TenantId -ClientId $ClientId -ClientSecret (ConvertTo-SecureString $ClientSecret -AsPlainText -Force) -ErrorAction Stop
}
catch {
    Write-Error "Authentication failed: $_"
    exit
}

# --- FETCH DATA ---
Write-Host "Retrieving Entra ID role definitions and assignments..." -ForegroundColor Cyan

try {
    # Fetch all role definitions to map IDs to friendly role names
    $roleDefinitions = Get-MgRoleManagementDirectoryRoleDefinition -All
    $roleMap = @{}
    foreach ($role in $roleDefinitions) {
        $roleMap[$role.Id] = $role.DisplayName
    }

    # Fetch all directory role assignments
    $roleAssignments = Get-MgRoleManagementDirectoryRoleAssignment -All
}
catch {
    Write-Error "Failed to retrieve role assignment data from Microsoft Graph: $_"
    Disconnect-MgGraph | Out-Null
    exit
}

if (-not $roleAssignments) {
    Write-Host "No active role assignments found!" -ForegroundColor Yellow
    Disconnect-MgGraph | Out-Null
    exit
}

# --- PROCESS RESULTS ---
Write-Host "Processing user assignments..." -ForegroundColor Cyan
$report = foreach ($assignment in $roleAssignments) {
    # Check if the principal is a user (PrincipalType or trying to fetch as user)
    # We query the user object by ID to verify and get DisplayName/UPN
    try {
        $user = Get-MgUser -UserId $assignment.PrincipalId -Property "DisplayName,UserPrincipalName,OnPremisesSyncEnabled" -ErrorAction Stop
        # Determine if account is Cloud-Only or Synchronized from on-premises AD
        $accountType = if ($user.OnPremisesSyncEnabled -eq $true) { "Synchronized (Hybrid)" } else { "Cloud-Only" }
        
        # If successfully found, it's a user account with a direct assignment
        [PSCustomObject]@{
            "Display Name"   = $user.DisplayName
            "UPN"            = $user.UserPrincipalName
            "Assigned Role"  = $roleMap[$assignment.RoleDefinitionId]
            "Assignment ID"  = $assignment.Id
        }
    }
    catch {
        # If it throws an error, the principal is likely a Service Principal or Group, not a direct user account
        continue
    }
}

# --- OUTPUT DISPLAY & EXPORT ---
if ($report) {
    $report | Out-GridView -Title "Users with Direct Entra ID Roles"
    $csvPath = ".\DirectEntraRoleUsers_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
    $report | Export-Csv -Path $csvPath -NoTypeInformation
    Write-Host "Report successfully exported to: $(Resolve-Path $csvPath)" -ForegroundColor Green
} else {
    Write-Host "No users with direct role assignments found." -ForegroundColor Yellow
}

# --- DISCONNECT ---
Disconnect-MgGraph | Out-Null
Write-Host "Disconnected from Microsoft Graph." -ForegroundColor Cyan
