Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class Advapi32 {
        [DllImport("advapi32.dll", SetLastError = true)]
        public static extern IntPtr OpenSCManager(string machineName, string databaseName, uint desiredAccess);

        [DllImport("advapi32.dll", SetLastError = true)]
        public static extern IntPtr OpenService(IntPtr scManager, string serviceName, uint desiredAccess);

        [DllImport("advapi32.dll", SetLastError = true)]
        public static extern bool CloseServiceHandle(IntPtr hSCObject);
    }
"@

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

$dirsearcher.filter="objectclass=computer"

$result = $dirsearcher.FindAll()

$serviceName = "LanmanServer" # You can change the service name as needed

foreach ($obj in $result) {
    foreach($prop in $obj.Properties)
    {
        $computerName = $prop.cn
    
        $scManagerHandle = [Advapi32]::OpenSCManager($computerName, 'ServicesActive', 0xF003F) # SC_MANAGER_CONNECT
    
        if ($scManagerHandle -ne 0) {
            $serviceHandle = [Advapi32]::OpenService($scManagerHandle, $serviceName, 0xF003F) # SERVICE_QUERY_STATUS
      
            if ($serviceHandle -ne 0) {
                Write-Host "User has administrative permissions on $computerName"
            }
            else {
                Write-Host "User does not have administrative permissions on $computerName"
            }
      
            [Advapi32]::CloseServiceHandle($serviceHandle)
            [Advapi32]::CloseServiceHandle($scManagerHandle)
        }
        else {
            Write-Host "Failed to connect to Service Control Manager on $computerName"
        }
    }
}
