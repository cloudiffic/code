$List = @()
$ServerFilter = "*"
$objOWA = Get-OWAVirtualDirectory | Where {$_.Server -like $ServerFilter}
$objOAB = Get-OABVirtualDirectory | Where {$_.Server -like $ServerFilter}
$objECP = Get-EcpVirtualDirectory | Where {$_.Server -like $ServerFilter}
$objEWS = Get-WebServicesVirtualDirectory | Where {$_.Server -like $ServerFilter}
$objASync = Get-ActiveSyncVirtualDirectory | Where {$_.Server -like $ServerFilter}
$objADiscover = Get-AutodiscoverVirtualDirectory | Where {$_.Server -like $ServerFilter}
 
foreach ($object in $objOWA)
{
    $obj = New-Object PSObject
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Identity -Value $object.Identity
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Name -Value $object.Name
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Server -Value $object.Server
    Add-Member -InputObject $obj -MemberType NoteProperty -Name RequireSSL -Value $object.RequireSSL
    Add-Member -InputObject $obj -MemberType NoteProperty -Name BasicAuthentication -Value $object.BasicAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name WindowsAuthentication -Value $object.WindowsAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name OAuthAuthentication -Value $object.OAuthAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name InternalUrl -Value $object.InternalUrl
    Add-Member -InputObject $obj -MemberType NoteProperty -Name ExternalUrl -Value $object.ExternalUrl
 
   $List +=$obj
}
 
foreach ($object in $objOAB)
{
    $obj = New-Object PSObject
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Identity -Value $object.Identity
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Name -Value $object.Name
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Server -Value $object.Server
    Add-Member -InputObject $obj -MemberType NoteProperty -Name RequireSSL -Value $object.RequireSSL
    Add-Member -InputObject $obj -MemberType NoteProperty -Name BasicAuthentication -Value $object.BasicAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name WindowsAuthentication -Value $object.WindowsAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name OAuthAuthentication -Value $object.OAuthAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name InternalUrl -Value $object.InternalUrl
    Add-Member -InputObject $obj -MemberType NoteProperty -Name ExternalUrl -Value $object.ExternalUrl
 
   $List +=$obj
}
 
foreach ($object in $objECP)
{
    $obj = New-Object PSObject
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Identity -Value $object.Identity
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Name -Value $object.Name
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Server -Value $object.Server
    Add-Member -InputObject $obj -MemberType NoteProperty -Name RequireSSL -Value $object.RequireSSL
    Add-Member -InputObject $obj -MemberType NoteProperty -Name BasicAuthentication -Value $object.BasicAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name WindowsAuthentication -Value $object.WindowsAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name OAuthAuthentication -Value $object.OAuthAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name InternalUrl -Value $object.InternalUrl
    Add-Member -InputObject $obj -MemberType NoteProperty -Name ExternalUrl -Value $object.ExternalUrl
 
   $List +=$obj
}
 
foreach ($object in $objEWS)
{
    $obj = New-Object PSObject
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Identity -Value $object.Identity
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Name -Value $object.Name
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Server -Value $object.Server
    Add-Member -InputObject $obj -MemberType NoteProperty -Name RequireSSL -Value $object.RequireSSL
    Add-Member -InputObject $obj -MemberType NoteProperty -Name BasicAuthentication -Value $object.BasicAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name WindowsAuthentication -Value $object.WindowsAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name OAuthAuthentication -Value $object.OAuthAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name InternalUrl -Value $object.InternalUrl
    Add-Member -InputObject $obj -MemberType NoteProperty -Name ExternalUrl -Value $object.ExternalUrl
 
   $List +=$obj
}
 
 
foreach ($object in $objASync)
{
    $obj = New-Object PSObject
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Identity -Value $object.Identity
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Name -Value $object.Name
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Server -Value $object.Server
    Add-Member -InputObject $obj -MemberType NoteProperty -Name RequireSSL -Value $object.RequireSSL
    Add-Member -InputObject $obj -MemberType NoteProperty -Name BasicAuthentication -Value $object.BasicAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name WindowsAuthentication -Value $object.WindowsAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name OAuthAuthentication -Value $object.OAuthAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name InternalUrl -Value $object.InternalUrl
    Add-Member -InputObject $obj -MemberType NoteProperty -Name ExternalUrl -Value $object.ExternalUrl
 
   $List +=$obj
}
 
foreach ($object in $objADiscover)
{
    $obj = New-Object PSObject
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Identity -Value $object.Identity
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Name -Value $object.Name
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Server -Value $object.Server
    Add-Member -InputObject $obj -MemberType NoteProperty -Name RequireSSL -Value $object.RequireSSL
    Add-Member -InputObject $obj -MemberType NoteProperty -Name BasicAuthentication -Value $object.BasicAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name WindowsAuthentication -Value $object.WindowsAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name OAuthAuthentication -Value $object.OAuthAuthentication
    Add-Member -InputObject $obj -MemberType NoteProperty -Name InternalUrl -Value $object.InternalUrl
    Add-Member -InputObject $obj -MemberType NoteProperty -Name ExternalUrl -Value $object.ExternalUrl
 
   $List +=$obj
}
 
$List | Export-Csv VirtualDirectory.csv
 
Get-EMailAddressPolicy | Select Name,Guid,Priority,AdminDisplayName,Enabled,IncludedRecipients,RecipientContainer,RecipientFilter,RecipientFilterApplied,RecipientFilterType,EnabledPrimarySMTPAddressTemplate,@{n="EnabledEmailAddressTemplates";E={$_.EnabledEmailAddressTemplates -join "/"}},@{n="ConditionalCustomAttribute1";E={$_.ConditionalCustomAttribute1 -join "/"}},@{n="ConditionalCustomAttribute10"; E={$_.ConditionalCustomAttribute10 -join "/"}},@{n="ConditionalCustomAttribute11"; E={$_.ConditionalCustomAttribute11 -join "/"}},@{n="ConditionalCustomAttribute12"; E={$_.ConditionalCustomAttribute12 -join "/"}},@{n="ConditionalCustomAttribute13"; E={$_.ConditionalCustomAttribute13 -join "/"}},@{n="ConditionalCustomAttribute14"; E={$_.ConditionalCustomAttribute14 -join "/"}},@{n="ConditionalCustomAttribute15"; E={$_.ConditionalCustomAttribute15 -join "/"}},@{n="ConditionalCustomAttribute2"; E={$_.ConditionalCustomAttribute2 -join "/"}},@{n="ConditionalCustomAttribute3"; E={$_.ConditionalCustomAttribute3 -join "/"}},@{n="ConditionalCustomAttribute4"; E={$_.ConditionalCustomAttribute4 -join "/"}},@{n="ConditionalCustomAttribute5"; E={$_.ConditionalCustomAttribute5 -join "/"}},@{n="ConditionalCustomAttribute6"; E={$_.ConditionalCustomAttribute6 -join "/"}},@{n="ConditionalCustomAttribute7"; E={$_.ConditionalCustomAttribute7 -join "/"}},@{n="ConditionalCustomAttribute8"; E={$_.ConditionalCustomAttribute8 -join "/"}},@{n="ConditionalCustomAttribute9"; E={$_.ConditionalCustomAttribute9 -join "/"}} | Export-Csv Get-EmailAddressPolicy.csv -NoTypeInformation
 
Get-MailContact -resultsize unlimited | Select Identity,Name,DisplayName,Alias,RecipientTypeDetails,RecipientType,PrimarySmtpAddress,ExternalEmailAddress,@{n="emailAddresses";E= {$_.EmailAddresses -join "\"}},LegacyExchangeDN,OrganizationalUnit,ServerName,Database,@{n="ExtensionCustomAttribute1";E={$_.ExtensionCustomAttribute1 -join "\"}},@{n="ExtensionCustomAttribute2";E={$_.ExtensionCustomAttribute2 -join "\"}},@{n="ExtensionCustomAttribute3";E={$_.ExtensionCustomAttribute3 -join "\"}},@{n="ExtensionCustomAttribute4";E={$_.ExtensionCustomAttribute4 -join "\"}},@{n="ExtensionCustomAttribute5";E={$_.ExtensionCustomAttribute5 -join "\"}},@{n="CustomAttribute1";E={$_.CustomAttribute1 -join "\"}},@{n="CustomAttribute10";E={$_.CustomAttribute10 -join "\"}},@{n="CustomAttribute11";E={$_.CustomAttribute11 -join "\"}},@{n="CustomAttribute12";E={$_.CustomAttribute12 -join "\"}},@{n="CustomAttribute13";E={$_.CustomAttribute13 -join "\"}},@{n="CustomAttribute14";E={$_.CustomAttribute14 -join "\"}},@{n="CustomAttribute15";E={$_.CustomAttribute15 -join "\"}},@{n="CustomAttribute2";E={$_.CustomAttribute2 -join "\"}},@{n="CustomAttribute3";E={$_.CustomAttribute3 -join "\"}},@{n="CustomAttribute4";E={$_.CustomAttribute4 -join "\"}},@{n="CustomAttribute5";E={$_.CustomAttribute5 -join "\"}},@{n="CustomAttribute6";E={$_.CustomAttribute6 -join "\"}},@{n="CustomAttribute7";E={$_.CustomAttribute7 -join "\"}},@{n="CustomAttribute8";E={$_.CustomAttribute8 -join "\"}},@{n="CustomAttribute9";E={$_.CustomAttribute9 -join "\"}} | Export-Csv Get-MailContact.csv -NoTypeInformation
 
Get-ReceiveConnector | Select Name,Identity,fqdn,Comment,ConnectionTimeOut,@{n="Bindings";E={$_.Bindings -join "\"}},DomainSecuredEnabled,MaxInboundConnection,MaxInboundConnectionPerSource,MaxInboundConnectionPercentagePerSource,MaxRecipientsPerMessage,@{n="RemoteIPRanges";E={$_.RemoteIPRanges -join "/"}},RequireEHLODomain,RequireTLS,EnableAuthGSSAPI | Export-Csv Get-ReceiveConnector.csv -NoTypeInformation

Get-SendConnector | Select Name,Identity,fqdn,Comment,Port,@{n="AddressSpaces";E={$_.AddressSpaces -join "\"}},ConnectionInactivityTimeOut,DNSRoutingEnabled,DomainSecureEnabled,ForceHELO,IgnoreSTARTTLS,IsScopedConnector,IsSmtpConnector,ProtocolLoggingLevel,RequireOorg,RequireTLS,SmartHostAuthMechanism,@{n="SmartHosts";E={$_.SmartHosts -join "\"}},SmtpMaxMessagesPerConnection,SourceIPAddress,@{n="SourceTransportServers";E={$_.SourceTransportServers -join "\"}},UseExternalDNSServersEnabled | Export-Csv Get-SendConnector.csv -NoTypeInformation
 
Get-ActiveSyncMailboxPolicy | Export-Csv Get-ActiveSyncMailboxPolicy.csv -NoTypeinformation

Get-RetentionPolicyTag | Select Name,Type,Action,AgeLimitForRetention,RetentionAction | Export-Csv Get-RetentionPolicyTags.csv -NoTypeInformation

Get-RetentionPolicy | Select Name,@{n="retentionPolicyTagLinks";E={$_.RetentionPolicyTagLinks -join "/"}} | Export-Csv Get-RetentionPolicy.csv -NoTypeInformation
 
Get-AcceptedDomain | Select DomainName,DomainType,Default | Export-Csv Get-DomainName.csv -NoTypeInformation

Get-EmailAddressPolicy | Select Name,Guid,Priority,AdminDisplayName,Enabled,IncludedRecipients,RecipientContainer,RecipientFilter,RecipientFilterApplied,RecipientFilterType,EnabledPrimarySMTPAddressTemplate,@{n="EnabledEmailAddressTemplates";E={$_.EnabledEmailAddressTemplates -join "/"}},@{n="ConditionalCustomAttribute1";E={$_.ConditionalCustomAttribute1 -join "/"}},@{n="ConditionalCustomAttribute10"; E={$_.ConditionalCustomAttribute10 -join "/"}},@{n="ConditionalCustomAttribute11"; E={$_.ConditionalCustomAttribute11 -join "/"}},@{n="ConditionalCustomAttribute12"; E={$_.ConditionalCustomAttribute12 -join "/"}},@{n="ConditionalCustomAttribute13"; E={$_.ConditionalCustomAttribute13 -join"/"}},@{n="ConditionalCustomAttribute14"; E={$_.ConditionalCustomAttribute14 -join "/"}},@{n="ConditionalCustomAttribute15"; E={$_.ConditionalCustomAttribute15 -join "/"}},@{n="ConditionalCustomAttribute2"; E={$_.ConditionalCustomAttribute2 -join "/"}},@{n="ConditionalCustomAttribute3"; E={$_.ConditionalCustomAttribute3 -join "/"}},@{n="ConditionalCustomAttribute4"; E={$_.ConditionalCustomAttribute4 -join "/"}},@{n="ConditionalCustomAttribute5"; E={$_.ConditionalCustomAttribute5 -join "/"}},@{n="ConditionalCustomAttribute6"; E={$_.ConditionalCustomAttribute6 -join "/"}},@{n="ConditionalCustomAttribute7"; E={$_.ConditionalCustomAttribute7 -join "/"}},@{n="ConditionalCustomAttribute8"; E={$_.ConditionalCustomAttribute8 -join "/"}},@{n="ConditionalCustomAttribute9"; E={$_.ConditionalCustomAttribute9 -join "/"}} | Export-Csv Get-EmailAddressPolicy.csv
 
Get-ExchangeServer | Select Identity,Name,Domain,Edition,AdminDisplayVersion,ExchangeLegacyDN,fqdn,ServerRole,Site | Export-Csv Get-ExchangeServer.csv -NoTypeInformation

Get-ExchangeCertificate | Select-Object Services, HasPrivateKey, IsSelfSigned, Issuer, PublicKeySize, NotAfter, @{Expression={$_.CertificateDomains};Label="CertDomain";} | Export-Csv Get-ExchangeCertificate.csv

Get-ClientAccessServer | Select-Object Name,Fqdn,AutoDiscoverServiceInternalUri, OutlookAnywhereEnabled | Export-Csv Get-ClientAccessServer -NoTypeInformation

$MBX = Get-MailboxServer
foreach ($server in $mbx) {
Get-MailboxServer | Get-LogonStatistics | Select UserName,Clientersion,LastAccessTime,ServerName | Export-Csv OutlookVersion.csv
}


Get-OrganizationRelationship | Export-Clixml OrganizationRelationships.xml
Get-OrganizationConfig | Export-Clixml OrganizationConfig.xml
Get-SharingPolicy | Export-Clixml SharingPolicies.xml
$Domain = $Domain = Get-AcceptedDomain | Where-Object {$_.Default -Like "True"}
Get-FederationInformation -DomainName $Domain.Name | Export-Csv FederationInformation.xml


