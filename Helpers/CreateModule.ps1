$ModulePath   = 'C:\Program Files\WindowsPowerShell\Modules'
$ModuleName   = 'dPSWA'
$ResourceName = 'PswaWebApplication'

New-xDSCResource -Name $ResourceName -Path $ModulePath -ModuleName $ModuleName -Property $(
    New-xDSCResourceProperty -Name Ensure  -Type String -Attribute Key -ValidateSet 'Present','Absent'
    
    New-xDSCResourceProperty -Name WebApplicationName -Type String -Attribute Write
    New-xDSCResourceProperty -Name WebSiteName        -Type String -Attribute Write

    #Note Requires alternative option - ie. Being able to custom set certificate
    #New-xDSCResourceProperty -Name TestCertificate -Type Boolean -Attribute Write
)

New-ModuleManifest -Path "$ModulePath\$ModuleName\$ModuleName.psd1" `
    -Guid (New-Guid).Guid `
    -ModuleVersion 1.0    `
    -Description 'Allows for the removal of a windows role or feature from the online image'

#Copy-Item -Path "$ModulePath\$ModuleName" -Destination 'C:\Program Files\WindowsPowerShell\DSCService\Modules' -Recurse
