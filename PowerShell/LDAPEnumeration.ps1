# Store the domain object in the $domainObj variable
$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()

# Store the PdcRoleOwner name to the $PDC variable
$PDC = $domainObj.PdcRoleOwner.Name

# Store the Distinguished Name variable into the $DN variable
$DN = ([adsi]'').distinguishedName

# Build the LDAP string
$LDAP = "LDAP://$PDC/$DN"
$LDAP

# Store the Directory Entry in the $direntry variable
$direntry = New-Object System.DirectoryServices.DirectoryEntry($LDAP)

# Search from the top of the Domain
$dirsearcher = New-Object System.DirectoryServices.DirectorySearcher($direntry)

# Using samAccountType attribute to filter normal user accounts
$dirsearcher.filter="samAccountType=805306368"
# $dirsearcher.filter="name=jeffadmin"
# $dirsearcher.filter="objectclass=group"

$result = $dirsearcher.FindAll()

Foreach($obj in $result)
{
    Foreach($prop in $obj.Properties)
    {
        $prop
    }

    Write-Host "-------------------------------"
}
