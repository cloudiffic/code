#import the ActiveDirectory Module

Import-Module ActiveDirectory


$AllADUsers = Get-ADUser -Filter * -Properties *

$AllADUsers |
Select-Object @{Label = "First Name";Expression = {$_.GivenName}},
@{Label = "Last Name";Expression = {$_.Surname}},
@{Label = "Display Name";Expression = {$_.DisplayName}},
@{Label = "SAMAccountName";Expression = {$_.sAMAccountName}},
@{Label = "UserPrincipalName";Expression = {$_.UserPrincipalName}},
@{Label = "OrganizationalUnit";Expression = {$_.CanonicalName}},
@{Label = "EmailAddress";Expression = {$_.EmailAddress}},
@{Label = "Full address";Expression = {$_.StreetAddress}},
@{Label = "City";Expression = {$_.City}},
@{Label = "State";Expression = {$_.st}},
@{Label = "Post Code";Expression = {$_.PostalCode}},
@{Label = "Country/Region";Expression = {if (($_.Country -eq 'GB')  ) {'United Kingdom'} Else {''}}},
@{Label = "Job Title";Expression = {$_.Title}},
@{Label = "Company";Expression = {$_.Company}},
@{Label = "Description";Expression = {$_.Description}},
@{Label = "Department";Expression = {$_.Department}},
@{Label = "Office";Expression = {$_.OfficeName}},
@{Label = "Phone";Expression = {$_.telephoneNumber}},
@{Label = "Email";Expression = {$_.Mail}},
@{Label = "Manager";Expression = {%{(Get-AdUser $_.Manager -Properties DisplayName).DisplayName}}},
@{Label = "Account Status";Expression = {if (($_.Enabled -eq 'TRUE')  ) {'Enabled'} Else {'Disabled'}}}, # the 'if statement# replaces $_.Enabled
@{Label = "Last Logon Date";Expression = {$_.lastlogondate}} | 

#Export CSV report

Export-Csv -Path .\ADUsers.csv
