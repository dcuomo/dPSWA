Configuration PSWA {
    Import-DscResource -ModuleName dPSWA

    PswaWebApplication PSWA2 {
        Ensure = 'Absent'
        WebApplicationName = 'pswa2'
        WebSiteName = 'PoSHWeb'
    }
}

PSWA -OutputPath c:\temp
Start-DscConfiguration -Path c:\temp -Verbose -Wait -Force