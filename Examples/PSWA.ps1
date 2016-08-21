Configuration SimplePSWA {

    Import-DSCResource -ModuleName xWebAdministration, PSDesiredStateConfiguration, dPSWA
    
    WindowsFeatureSet PowerShellWebAccess {
        Name   = 'WindowsPowerShellWebAccess','Web-Mgmt-Console'
        Ensure = 'Present'
    }

    #Custom WebSite Otherwise, section not needed
    xWebSite PSWA_Website{
        Name  = 'PoSHWeb'
        State = 'Started'
        Ensure = 'Present'
        PreloadEnabled = $true
        PhysicalPath = "$($env:SystemDrive)\inetpub\Tester"
        BindingInfo     = @(
            MSFT_xWebBindingInformation {
                Protocol = "HTTP"
                Port     = 8080
            }
        )
    }

    PswaWebApplication PSWA2 {
        Ensure = 'Present'
        WebApplicationName = 'pswa2'
        WebSiteName = 'PoSHWeb'
    }
}

SimplePSWA -OutputPath c:\temp
Start-DscConfiguration -Path c:\temp\ -Verbose -Wait -Force